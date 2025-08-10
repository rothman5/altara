"""
Module:
    Port List Model

Author:
    Rasheed Othman

Created:
    2025-08-09

Description:
    This module defines the PortListModel class, which is responsible for managing a list of available serial ports.
    It periodically refreshes the list of ports to ensure it reflects the current state of the system.
"""

from typing import Dict, Optional, Union

from PySide6.QtCore import (
    QAbstractListModel,
    QByteArray,
    QModelIndex,
    QObject,
    QPersistentModelIndex,
    Qt,
    QTimer,
    Slot,
)
from PySide6.QtSerialPort import QSerialPort, QSerialPortInfo

from app.models import DeviceListModel, DeviceModel

ModelIndex = Union[QModelIndex, QPersistentModelIndex]
ModelData = Union[str, int, bool, DeviceModel]


class PortListModel(QAbstractListModel):
    """
    Represents a list model for QML that holds available serial ports.
    It excludes ports that are already in use by and device in the provided `DeviceListModel`.
    The model also supports automatic refreshing of the port list using a `QTimer`.
    """

    PortRole = Qt.ItemDataRole.UserRole + 1
    DescRole = Qt.ItemDataRole.UserRole + 2

    _refresh_rate_ms = 3_000

    def __init__(self, models: DeviceListModel, parent: Optional[QObject] = None) -> None:
        super().__init__(parent)
        self._models = models
        self._ports: list[QSerialPortInfo] = self._filter_ports()
        self._timer = QTimer(self)
        self._timer.timeout.connect(self.refresh)
        self._placeholder = QSerialPortInfo(QSerialPort("No devices available"))

    def rowCount(self, parent: ModelIndex = QModelIndex()) -> int:
        """
        Get the number of rows in the model.

        Args:
            parent (ModelIndex, optional): The parent index. Defaults to QModelIndex().

        Returns:
            int: The number of rows in the model.
        """
        return len(self._ports)

    def roleNames(self) -> Dict[int, QByteArray]:
        """
        Get the role names for the model.

        Returns:
            Dict[int, QByteArray]: A dictionary mapping role IDs to their names.
        """
        return {self.PortRole: QByteArray(b"port"), self.DescRole: QByteArray(b"description")}

    def data(self, index: ModelIndex, role: int = Qt.ItemDataRole.DisplayRole) -> Optional[ModelData]:
        """
        Get the data for a specific index and role.

        Args:
            index (ModelIndex): The model index.
            role (int, optional): The data role. Defaults to Qt.ItemDataRole.DisplayRole.

        Returns:
            Optional[ModelData]: The data for the specified index and role.
        """
        if (
            (len(self._ports) == 1)
            and (self._ports[0] == self._placeholder)
            and ((role == self.PortRole) or (role == Qt.ItemDataRole.DisplayRole))
        ):
            return "No devices available"
        if not index.isValid() or not (0 <= index.row() < len(self._ports)):
            return None
        port = self._ports[index.row()]
        if (role == self.PortRole) or (role == Qt.ItemDataRole.DisplayRole):
            return port.portName()
        elif role == self.DescRole:
            desc = port.description()
            return f"{port.portName()} - {desc}" if desc else port.portName()
        return None

    @Slot()
    @Slot(bool)
    def refresh(self, repeat: bool = False) -> None:
        """
        Refresh the list of available serial ports.

        Args:
            repeat (bool, optional): Whether to repeat the refresh operation. Defaults to False.
        """
        available = self._filter_ports()
        changed = any(p1.portName() != p2.portName() for p1, p2 in zip(available, self._ports))
        if changed or (len(available) != len(self._ports)):
            self.beginResetModel()
            self._ports = available or [self._placeholder]
            self.endResetModel()
        if repeat:
            self.start_refresh()

    @Slot()
    def start_refresh(self) -> None:
        """
        Start the periodic refresh of the port list.
        """
        self._timer.start(self._refresh_rate_ms)

    @Slot()
    def stop_refresh(self) -> None:
        """
        Stop the periodic refresh of the port list.
        """
        self._timer.stop()

    @Slot(result=list)
    def available(self) -> list[str]:
        """
        Get a list of available serial port names.

        Returns:
            list[str]: A list of available serial port names.
        """
        available = [port.portName() for port in self._ports]
        if len(available) == 1 and available[0] == "":
            available = ["No devices available"]
        return available

    @Slot(str, result=int)
    def indexOf(self, port: str) -> int:
        """
        Get the index of a specific port.

        Args:
            port (str): The name of the port.

        Returns:
            int: The index of the port, or -1 if not found.
        """
        for i, p in enumerate(self._ports):
            if p.portName() == port:
                return i
        return -1

    def _filter_ports(self) -> list[QSerialPortInfo]:
        """
        Get a list of filtered serial ports.

        Returns:
            list[QSerialPortInfo]: A list of filtered serial ports.
        """
        consumed = [model.get_port() for model in self._models.get_devices()]
        available = [port for port in QSerialPortInfo.availablePorts() if port.portName() not in consumed]
        return available
