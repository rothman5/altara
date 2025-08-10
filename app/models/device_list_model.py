"""
Module:
    Device List Model

Author:
    Rasheed Othman

Created:
    2025-08-09

Description:
    This module defines the DeviceListModel class, which is responsible for managing a list of device view models.
"""

from typing import Dict, Optional, Union

from PySide6.QtCore import (
    QAbstractListModel,
    QByteArray,
    QModelIndex,
    QObject,
    QPersistentModelIndex,
    Qt,
    Slot,
)
from PySide6.QtSerialPort import QSerialPortInfo

from app.models import DeviceModel
from app.protocols import ExProtocol
from app.tools.logger import Log
from app.view_models import DeviceViewModel, ExViewModel

ModelIndex = Union[QModelIndex, QPersistentModelIndex]
ModelData = Union[str, int, bool, DeviceViewModel]


DEVICE_VIEW_MODEL_MAP = {
    (0x1234, 0x5678): (ExProtocol, ExViewModel),
}


class DeviceListModel(QAbstractListModel):
    """
    Represents a list model for QML that holds and manages `DeviceViewModel` instances.
    It provides roles for accessing device properties such as `name`, `port`, and `baud`.
    """

    NameRole = Qt.ItemDataRole.UserRole + 1
    PortRole = Qt.ItemDataRole.UserRole + 2
    BaudRole = Qt.ItemDataRole.UserRole + 3
    ConnRole = Qt.ItemDataRole.UserRole + 4
    DeviceRole = Qt.ItemDataRole.UserRole + 5

    def __init__(self, parent: Optional[QObject] = None) -> None:
        super().__init__(parent)
        self._log = Log()
        self._devices: list[DeviceViewModel] = []

    def rowCount(self, parent: ModelIndex = QModelIndex()) -> int:
        """
        Get the number of rows in the model.

        Args:
            parent (ModelIndex, optional): The parent index. Defaults to QModelIndex().

        Returns:
            int: The number of rows in the model.
        """
        return len(self._devices)

    def roleNames(self) -> Dict[int, QByteArray]:
        """
        Get the role names for the model.

        Returns:
            Dict[int, QByteArray]: A dictionary mapping role IDs to their names.
        """
        return {
            self.NameRole: QByteArray(b"name"),
            self.PortRole: QByteArray(b"port"),
            self.BaudRole: QByteArray(b"baud"),
            self.ConnRole: QByteArray(b"connected"),
            self.DeviceRole: QByteArray(b"device"),
        }

    def data(self, index: ModelIndex, role: int = Qt.ItemDataRole.DisplayRole) -> Optional[ModelData]:
        """
        Get the data for a specific index and role.

        Args:
            index (ModelIndex): The model index for the item.
            role (int, optional): The role for the item. Defaults to Qt.ItemDataRole.DisplayRole.

        Returns:
            Optional[ModelData]: The data for the specified index and role, or None if not found.
        """
        if not index.isValid() or not (0 <= index.row() < len(self._devices)):
            return None
        device = self._devices[index.row()]
        if role == self.NameRole or (role == Qt.ItemDataRole.DisplayRole):
            return device.get_name()
        elif role == self.PortRole:
            return device.get_port()
        elif role == self.BaudRole:
            return device.get_baud()
        elif role == self.ConnRole:
            return device.get_status()
        elif role == self.DeviceRole:
            return device
        return None

    @Slot(str, str, int, result=bool)
    def add_device(self, name: str, port: str, baud: int) -> bool:
        """
        Add a new device to the model.

        Args:
            name (str): The name of the device.
            port (str): The port of the device.
            baud (int): The baud rate of the device.

        Returns:
            bool: True if the device was added successfully, False otherwise.
        """
        if (port == "No devices available") or any(d.name == name or d.port == port for d in self._devices):
            return False

        self.beginInsertRows(QModelIndex(), len(self._devices), len(self._devices))

        device = DeviceModel(name, port, baud)
        info = QSerialPortInfo(device.serial)
        vid, pid = info.vendorIdentifier(), info.productIdentifier()
        models = DEVICE_VIEW_MODEL_MAP.get((vid, pid), None)
        if not models:
            # If no matching models are found, use the default classes
            protocol_cls = ExProtocol
            view_model_cls = ExViewModel
        else:
            protocol_cls = models[0]
            view_model_cls = models[1]

        device.protocol = protocol_cls()
        model = view_model_cls(device)

        self._devices.append(model)
        self.endInsertRows()
        self._log.debug(f"Added device: {name} on port {port} with baud {baud}")
        return True

    @Slot(int, result=bool)
    def remove_device(self, index: int) -> bool:
        """
        Remove a device from the model.

        Args:
            index (int): The index of the device to remove.

        Returns:
            bool: True if the device was removed successfully, False otherwise.
        """
        if not (0 <= index < len(self._devices)):
            return False
        self.beginRemoveRows(QModelIndex(), index, index)
        model = self._devices.pop(index)
        model.close()
        model.deleteLater()
        self.endRemoveRows()
        self._log.debug(f"Removed device at index {index}: {model.get_name()}")
        return True

    @Slot(int, result=DeviceModel)
    def get_device(self, index: int) -> Optional[DeviceViewModel]:
        """
        Get the device at the specified index.

        Args:
            index (int): The index of the device.

        Returns:
            Optional[DeviceViewModel]: The device at the specified index, or None if not found.
        """
        if not (0 <= index < len(self._devices)):
            return None
        return self._devices[index]

    @Slot(DeviceViewModel, result=int)
    def get_index(self, model: DeviceViewModel) -> int:
        """
        Get the index of the specified device model.

        Args:
            model (DeviceViewModel): The device model to find.

        Returns:
            int: The index of the device model, or -1 if not found.
        """
        try:
            return self._devices.index(model)
        except ValueError:
            return -1

    @Slot(int, str, str, int, result=bool)
    def edit_device(self, index: int, name: str, port: str, baud: int) -> bool:
        """
        Edit an existing device in the model.

        Args:
            index (int): The index of the device to edit.
            name (str): The new name of the device.
            port (str): The new port of the device.
            baud (int): The new baud rate of the device.

        Returns:
            bool: True if the device was edited successfully, False otherwise.
        """
        if not (0 <= index < len(self._devices)):
            return False
        device = self._devices[index]
        device.set_name(name)
        device.set_port(port)
        device.set_baud(baud)
        self._log.debug(f"Edited device at index {index}: {name} on port {port} with baud {baud}")
        return True

    def get_devices(self) -> list[DeviceViewModel]:
        """
        Get a list of all devices in the model.

        Returns:
            list[DeviceViewModel]: A list of all device view models.
        """
        return self._devices
