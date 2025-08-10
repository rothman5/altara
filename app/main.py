"""
Module:
    Main

Author:
    Rasheed Othman

Created:
    2025-08-09

Description:
    This module serves as the entry point for the application, initializing the Qt application and loading the QML interface.
"""

import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from app.models import DeviceListModel, PortListModel
from app.tools.logger import Log
from app.tools.paths import QML_PATH


def main() -> int:
    """
    Main entry point for the application.

    Returns:
        int: The exit code of the application.
    """
    log = Log()

    if not QML_PATH.exists():
        log.error(f"QML path does not exist: {QML_PATH}")
        return -1

    app = QGuiApplication(sys.argv)
    eng = QQmlApplicationEngine()

    device_list_model = DeviceListModel(app)
    eng.rootContext().setContextProperty("deviceListModel", device_list_model)

    port_list_model = PortListModel(device_list_model, app)
    eng.rootContext().setContextProperty("portListModel", port_list_model)

    eng.load(QML_PATH)
    if not eng.rootObjects():
        log.error(f"Failed to load QML: {QML_PATH}")
        return -1

    return app.exec()


if __name__ == "__main__":
    sys.exit(main())
