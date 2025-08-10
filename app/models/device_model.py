"""
Module:
    Device Model

Author:
    Rasheed Othman

Created:
    2025-08-09

Description:
    This module defines the `DeviceModel` class, which represents a communication channel with a specific device.
    The `DeviceModel` class is responsible for managing the serial port connection and the communication protocol.
"""

from typing import Optional

from PySide6.QtCore import QObject, Signal
from PySide6.QtSerialPort import QSerialPort

from app.protocols import DeviceProtocol


class DeviceModel(QObject):
    """
    Each instance of `DeviceModel` represents a communication channel with a specific device.
    Each device model is associated with a specific protocol for communication.
    The communication protocol is determined based on the vendor and product identifiers for the device.
    The device model can also configure the underlying serial port.
    """

    response_decoded = Signal(bytes)

    def __init__(
        self,
        name: str,
        portname: str,
        baudrate: int,
        *,
        protocol: Optional[DeviceProtocol] = None,
        parent: Optional[QObject] = None,
        databits: QSerialPort.DataBits = QSerialPort.DataBits.Data8,
        parity: QSerialPort.Parity = QSerialPort.Parity.NoParity,
        stopbits: QSerialPort.StopBits = QSerialPort.StopBits.OneStop,
        flowcontrol: QSerialPort.FlowControl = QSerialPort.FlowControl.NoFlowControl,
    ) -> None:
        super().__init__()
        self._name = name
        self._protocol = protocol
        self._serial = QSerialPort(parent)
        self._serial.setPortName(portname)
        self._serial.setBaudRate(baudrate)
        self._serial.setDataBits(databits)
        self._serial.setParity(parity)
        self._serial.setStopBits(stopbits)
        self._serial.setFlowControl(flowcontrol)
        self._serial.readyRead.connect(self._receive_available_cb)

    @property
    def name(self) -> str:
        """
        Get the name of the device model.

        Returns:
            str: The name of the device model.
        """
        return self._name

    @name.setter
    def name(self, value: str) -> None:
        """
        Set the name of the device model.

        Args:
            value (str): The new name of the device model.
        """
        self._name = value

    @property
    def port(self) -> str:
        """
        Get the port name of the device model.

        Returns:
            str: The port name of the device model.
        """
        return self._serial.portName()

    @port.setter
    def port(self, value: str) -> None:
        """
        Set the port name of the device model.

        Args:
            value (str): The new port name of the device model.
        """
        self._serial.setPortName(value)

    @property
    def baud(self) -> int:
        """
        Get the baud rate of the device model.

        Returns:
            int: The baud rate of the device model.
        """
        return self._serial.baudRate()

    @baud.setter
    def baud(self, value: int) -> None:
        """
        Set the baud rate of the device model.

        Args:
            value (int): The new baud rate of the device model.
        """
        self._serial.setBaudRate(value)

    @property
    def connected(self) -> bool:
        """
        Check if the device model is connected.

        Returns:
            bool: True if the device model is connected, False otherwise.
        """
        return self._serial.isOpen()

    @property
    def serial(self) -> QSerialPort:
        """
        Get the serial port associated with the device model.

        Returns:
            QSerialPort: The serial port associated with the device model.
        """
        return self._serial

    @property
    def protocol(self) -> Optional[DeviceProtocol]:
        """
        Get the communication protocol associated with the device model.

        Returns:
            Optional[DeviceProtocol]: The communication protocol associated with the device model, or None if not set.
        """
        return self._protocol

    @protocol.setter
    def protocol(self, value: Optional[DeviceProtocol]) -> None:
        """
        Set the communication protocol for the device model.

        Args:
            value (Optional[DeviceProtocol]): The new communication protocol for the device model.
        """
        self._protocol = value

    def open(self) -> bool:
        """
        Open the serial port associated with the device model.

        Returns:
            bool: True if the serial port was opened successfully, False otherwise.
        """
        if not self._serial.isOpen():
            status = self._serial.open(QSerialPort.OpenModeFlag.ReadWrite)
            return status
        return True

    def close(self) -> None:
        """
        Close the serial port associated with the device model.
        """
        if self._serial.isOpen():
            self._serial.close()

    def toggle(self) -> None:
        """
        Toggle the state of the serial port associated with the device model.
        """
        if self._serial.isOpen():
            self._serial.close()
        else:
            self._serial.open(QSerialPort.OpenModeFlag.ReadWrite)

    def transmit(self, data: bytes) -> int:
        """
        Transmit data over the serial port.

        Args:
            data (bytes): The data to transmit.

        Returns:
            int: The number of bytes written to the serial port.
        """
        if self._serial.isOpen():
            return self._serial.write(data)
        return -1

    def receive(self) -> bytes:
        """
        Receive data from the serial port.

        Returns:
            bytes: The data received from the serial port.
        """
        if self._serial.isOpen():
            return self._serial.readAll().data()
        return b""

    def _receive_available_cb(self) -> None:
        """
        Callback function to handle available data for reception.
        The immediate new data is fed to the communication protocol,
        then is continuously polled to decode all available messages.
        """
        if not self._protocol:
            return
        self._protocol.feed(self.receive())
        while True:
            decoded = self._protocol.decode()
            if not decoded:
                break
            self.response_decoded.emit(decoded)
