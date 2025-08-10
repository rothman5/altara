from ctypes import LittleEndianStructure, c_uint8, c_uint16, sizeof
from enum import IntEnum, auto
from typing import ClassVar, Optional

from app.protocols import DeviceMessage, DeviceProtocol


class ExHeader(LittleEndianStructure):
    _pack_ = 1
    _fields_ = [
        ("u8_sof", c_uint8),
        ("u8_src", c_uint8),
        ("u8_dst", c_uint8),
        ("u8_rw", c_uint8),
        ("u16_cmd", c_uint16),
        ("u16_len", c_uint16),
    ]


class ExStartOfFrame(IntEnum):
    REQ = 0xAB
    RSP = 0xBA


class ExAction(IntEnum):
    READ = 0x00
    WRITE = 0x01


class ExAddress(IntEnum):
    PC_HOST = auto()
    BOARD_1 = auto()
    BOARD_2 = auto()


class ExCommand(IntEnum):
    R_HW_INFO = auto()
    R_FW_INFO = auto()
    R_SYS_REG = auto()
    R_SYS_DIAG = auto()
    RW_SYS_CFG = auto()
    RW_SYS_TIME = auto()


class ExMessage(DeviceMessage):
    pld_len: ClassVar[int] = 2048

    def __init__(
        self,
        src: ExAddress,
        dst: ExAddress,
        cmd: ExCommand,
        dir: ExAction,
        pld: bytes = b"",
    ) -> None:
        self.sof = ExStartOfFrame.REQ
        self.src = src
        self.dst = dst
        self.cmd = cmd
        self.dir = dir
        self.pld = pld

    def to_bytes(self) -> bytes:
        hdr = ExHeader()
        hdr.u8_sof = self.sof
        hdr.u8_src = self.src.value
        hdr.u8_dst = self.dst.value
        hdr.u8_rw = self.dir.value
        hdr.u16_len = sizeof(ExHeader) + len(self.pld) + sizeof(c_uint16)
        hdr.u16_cmd = self.cmd.value

        hdr_pld = bytes(hdr) + self.pld
        checksum = self.checksum(hdr_pld)
        return hdr_pld + checksum.to_bytes(2, "little")


class ExProtocol(DeviceProtocol):
    def decode(self) -> Optional[bytes]:
        if len(self._cache) < sizeof(ExHeader):
            return None

        hdr_bytes = self._cache[: sizeof(ExHeader)]
        if not hdr_bytes:
            return None

        hdr = ExHeader.from_buffer_copy(hdr_bytes)
        if hdr.u8_sof != ExStartOfFrame.RSP:
            self._cache = self._cache[1:]
            return None

        try:
            src = ExAddress(hdr.u8_src)
            dst = ExAddress(hdr.u8_dst)
            cmd = ExCommand(hdr.u16_cmd)
            act = ExAction(hdr.u8_rw)
        except ValueError:
            self._cache = self._cache[1:]
            return None

        if dst != ExAddress.PC_HOST:
            self._cache = self._cache[1:]
            return None

        if len(self._cache) < hdr.u16_len:
            return None

        msg_bytes = self._cache[: hdr.u16_len]
        recv_chksum = int.from_bytes(msg_bytes[-sizeof(c_uint16) :], "little")
        calc_chksum = ExMessage.checksum(msg_bytes[: -sizeof(c_uint16)])
        if recv_chksum != calc_chksum:
            self._cache = self._cache[1:]
            return None

        pld = msg_bytes[sizeof(ExHeader) : -sizeof(c_uint16)]
        msg = ExMessage(src, dst, cmd, act, pld)
        self._cache = self._cache[hdr.u16_len :]
        return msg.to_bytes()
