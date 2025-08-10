import threading
from typing import Any, ClassVar, TypeVar

SingletonType = TypeVar("SingletonType", bound="Singleton")


class Singleton(type):
    _lock: ClassVar[threading.Lock] = threading.Lock()
    _instances: ClassVar[dict[type[Any], Any]] = {}

    def __call__(cls: type[SingletonType], *args, **kwargs) -> SingletonType:
        """
        Create or return the singleton instance of the class.
        If the instance does not exist, it is created; otherwise, the existing instance is returned.
        A thread lock is used to ensure thread safety when creating the instance.
        Check-lock-check pattern is used to avoid unnecessary locking after the instance is created.
        We accept that the first call to __call__ may be slow due to the lock acquisition,
        but subsequent calls will be fast as they return the already created instance without locking.

        Args:
            cls (type[T]): The class to create or return the instance of.
            *args: Positional arguments to pass to the class constructor.
            **kwargs: Keyword arguments to pass to the class constructor.

        Returns:
            T: The singleton instance of the class.
        Raises:
            TypeError: If the class does not support instantiation with the provided arguments.

        Usage:
            class MySingleton(metaclass=Singleton):
                pass

            instance1 = MySingleton()
            instance2 = MySingleton()
            assert instance1 is instance2  # Both variables point to the same instance.
        """
        if cls not in cls._instances:
            with cls._lock:
                if cls not in cls._instances:
                    cls._instances[cls] = super().__call__(*args, **kwargs)
        return cls._instances[cls]
