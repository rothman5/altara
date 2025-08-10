"""
Module:
    Device Protocol

Author:
    Rasheed Othman

Created:
    2025-08-09

Description:
    This module defines abstract base classes for device messages and protocols.
    It provides a structure for encoding and decoding messages to and from byte representations.
"""

from abc import ABC, abstractmethod
from typing import Optional


class DeviceMessage(ABC):
    """
    Abstract base class providing the expected behaviour of device messages.
    This allows users to create custom device messages based on formatted byte frames.
    The expectation is that the `to_bytes` method will be implemented to convert the message to a byte representation.
    """

    @abstractmethod
    def to_bytes(self) -> bytes:
        """
        Convert the device message to a byte representation.

        Returns:
            bytes: The byte representation of the device message.
        """
        ...

    @staticmethod
    def checksum(data: bytes) -> int:
        """
        Calculate the checksum of the given data.

        Args:
            data (bytes): The data to calculate the checksum for.

        Returns:
            int: The checksum of the given data as a 16-bit integer.
        """
        return sum(data) & 0xFFFF


class DeviceProtocol(ABC):
    """
    Abstract base class for device communication protocols.
    This allows users to create a custom message decoder based on formatted byte frames.
    The expectation is that the `decode` method will be implemented to convert the byte
    representation back into a device message (`DeviceMessage`).
    """

    def __init__(self) -> None:
        self._cache = bytearray()

    def feed(self, data: bytes) -> None:
        """
        Feed incoming data to the protocol for processing.

        Args:
            data (bytes): The incoming data to process.
        """
        self._cache.extend(data)

    def clear(self) -> None:
        """
        Clear the protocol's internal cache.
        """
        self._cache.clear()

    @abstractmethod
    def decode(self) -> Optional[bytes]:
        """
        Attempt to decode a device message from the internal cache.

        Returns:
            Optional[bytes]: The decoded device message, or None if decoding failed.
        """
        ...
