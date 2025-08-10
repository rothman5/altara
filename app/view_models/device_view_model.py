"""
Module:
    Device View Model

Author:
    Rasheed Othman

Created:
    2025-08-09

Description:
    This module defines the `DeviceViewModel` class, which serves as a bridge between the `DeviceModel` and the view.
    It exposes device properties as QML properties, handles device control actions, and emits signals for various events.
"""

from PySide6.QtCore import Property, QObject, Signal, Slot
from PySide6.QtSerialPort import QSerialPort

from app.models import DeviceModel


class DeviceViewModel(QObject):
    """
    Abstract base class representing a view model for a device (`DeviceModel`).
    It allows QML to access and bind to device properties, and to invoke operations for managing the device.
    Separates the view logic from the model logic.
    It also exposes callbacks for transmission completion, reception, and errors, which should be implemented by subclasses.
    """

    tx_event = Signal(int)
    rx_event = Signal(bytes)
    error_event = Signal(str)
    name_change_event = Signal(str)
    port_change_event = Signal(str)
    baud_change_event = Signal(int)
    conn_change_event = Signal(bool)

    def __init__(self, model: DeviceModel) -> None:
        super().__init__()
        self._model = model
        self._model.serial.bytesWritten.connect(self.transmit_complete_cb)
        self._model.response_decoded.connect(self.receive_complete_cb)
        self._model.serial.errorOccurred.connect(self.error_occurred_cb)

    @Slot()
    def toggle(self) -> None:
        """
        Toggle the connection state of the device and emit the connection change event.
        """
        self._model.toggle()
        self.conn_change_event.emit(self._model.connected)

    @Slot()
    def open(self) -> None:
        """
        Open the connection to the device and emit the connection change event.
        """
        self._model.open()
        self.conn_change_event.emit(self._model.connected)

    @Slot()
    def close(self) -> None:
        """
        Close the connection to the device and emit the connection change event.
        """
        self._model.close()
        self.conn_change_event.emit(self._model.connected)

    def get_name(self) -> str:
        """
        Get the name of the device.
        """
        return self._model.name

    def set_name(self, name: str) -> None:
        """
        Set the name of the device.

        Args:
            name (str): The new name of the device.
        """
        self._model.name = name
        self.name_change_event.emit(name)

    def get_port(self) -> str:
        """
        Get the port of the device.
        """
        return self._model.port

    def set_port(self, port: str) -> None:
        """
        Set the port of the device.

        Args:
            port (str): The new port of the device.
        """
        self._model.port = port
        self.port_change_event.emit(port)

    def get_baud(self) -> int:
        """
        Get the baud rate of the device.
        """
        return self._model.baud

    def set_baud(self, baud: int) -> None:
        """
        Set the baud rate of the device.

        Args:
            baud (int): The new baud rate of the device.
        """
        self._model.baud = baud
        self.baud_change_event.emit(baud)

    def get_status(self) -> bool:
        """
        Get the connection status of the device.
        """
        return self._model.connected

    """
    These are properties for QML binding.
    This allows QML to immediately react to changes in the device model
    without having to poll for updates.
    """
    name = Property(str, get_name, set_name, notify=name_change_event)
    port = Property(str, get_port, set_port, notify=port_change_event)
    baud = Property(int, get_baud, set_baud, notify=baud_change_event)
    conn = Property(bool, get_status, notify=conn_change_event)

    def transmit_complete_cb(self, n: int) -> None:
        """
        Callback for when transmission is complete.

        Args:
            n (int): The number of bytes transmitted.
        """
        self.tx_event.emit(n)

    def receive_complete_cb(self, data: bytes) -> None:
        """
        Callback for when reception is complete.

        Args:
            data (bytes): The received data.

        Raises:
            NotImplementedError: This method should be implemented in a subclass.
        """
        self.rx_event.emit(data)

    def error_occurred_cb(self, error: QSerialPort.SerialPortError) -> None:
        """
        Callback for when an error occurs.

        Args:
            error (QSerialPort.SerialPortError): The error that occurred.
        """
        self.error_event.emit(self._model.serial.errorString())
