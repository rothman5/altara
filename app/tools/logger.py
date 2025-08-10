import logging
import sys
from enum import StrEnum
from logging import FileHandler, Filter, Formatter, LogRecord, StreamHandler

from app.tools.paths import LOG_PATH
from app.tools.singleton import Singleton


class ANSIColor(StrEnum):
    WHITE = "\033[97m"
    GRAY = "\x1b[38;5;248m"
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    RESET = "\033[0m"
    BOLD = "\033[1m"


class _ANSIFormatter(Formatter):
    _colors = {
        logging.DEBUG: ANSIColor.GRAY + ANSIColor.BOLD,
        logging.INFO: ANSIColor.GREEN + ANSIColor.BOLD,
        logging.WARNING: ANSIColor.YELLOW + ANSIColor.BOLD,
        logging.ERROR: ANSIColor.RED + ANSIColor.BOLD,
        logging.CRITICAL: ANSIColor.RED + ANSIColor.BOLD,
    }

    def format(self, record: LogRecord) -> str:
        r = logging.makeLogRecord(record.__dict__)
        c = self._colors.get(r.levelno, ANSIColor.RESET)

        module = f"{ANSIColor.GRAY}{r.module}{ANSIColor.RESET}"
        lineno = f"{ANSIColor.GRAY}{r.lineno:<4d}{ANSIColor.RESET}"
        r.module = f"{module}:{lineno}"
        r.levelname = f"{c}{r.levelname:5.5s}{ANSIColor.RESET}"
        r.threadName = f"{ANSIColor.GRAY}{r.threadName:10.10s}{ANSIColor.RESET}"

        return super().format(r)


class _LogLevelFilter(Filter):
    _level_map = {"WARNING": "WARN", "CRITICAL": "CRIT"}

    def filter(self, record: LogRecord) -> bool:
        if record.levelname in self._level_map:
            record.levelname = self._level_map[record.levelname]
        return True


class Log(metaclass=Singleton):
    DATE_FMT = "%Y-%m-%d %H:%M:%S"
    FILE_FMT = "[%(asctime)s on %(threadName)-10s @ %(module)s:%(lineno)-4d] %(levelname)5.5s: %(message)s"
    TEXT_FMT = "[%(asctime)s on %(threadName)s @ %(module)s] %(levelname)s: %(message)s"

    def __init__(self) -> None:
        if hasattr(self, "_initialized"):
            return

        self._initialized = True
        self._name = "root"
        self._file = LOG_PATH

        self._log = logging.getLogger(name=self._name)
        self._log.setLevel(level=logging.DEBUG)

        self._add_file_handler()
        self._add_stream_handler()

    def info(self, msg: str, *args, **kwargs) -> None:
        self._log.info(msg, *args, **kwargs)

    def warn(self, msg: str, *args, **kwargs) -> None:
        self._log.warning(msg, *args, **kwargs)

    def error(self, msg: str, *args, **kwargs) -> None:
        self._log.error(msg, *args, **kwargs)

    def critical(self, msg: str, *args, **kwargs) -> None:
        self._log.critical(msg, *args, **kwargs)

    def debug(self, msg: str, *args, **kwargs) -> None:
        self._log.debug(msg, *args, **kwargs)

    def exception(self, msg: str, *args, **kwargs) -> None:
        self._log.exception(msg, *args, **kwargs)

    def _add_file_handler(self) -> None:
        self._file.touch(exist_ok=True)

        formatter = Formatter(fmt=self.FILE_FMT, datefmt=self.DATE_FMT)
        self._file_handler = FileHandler(self._file, mode="a", encoding="utf-8")

        self._file_handler.setLevel(level=logging.DEBUG)
        self._file_handler.addFilter(filter=_LogLevelFilter())
        self._file_handler.setFormatter(fmt=formatter)

        self._log.addHandler(hdlr=self._file_handler)

    def _add_stream_handler(self) -> None:
        formatter = _ANSIFormatter(fmt=self.TEXT_FMT, datefmt=self.DATE_FMT)
        self._stream_handler = StreamHandler(stream=sys.stdout)

        self._stream_handler.setLevel(level=logging.DEBUG)
        self._stream_handler.addFilter(filter=_LogLevelFilter())
        self._stream_handler.setFormatter(fmt=formatter)

        self._log.addHandler(hdlr=self._stream_handler)
