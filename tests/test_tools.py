import threading
import time
import unittest
from typing import Any

from app.tools.singleton import Singleton


class DummySingleton1(metaclass=Singleton):
    def __init__(self, value: int = 0) -> None:
        time.sleep(0.01)
        self.value = value


class DummySingleton2(metaclass=Singleton):
    def __init__(self, value: int = 0) -> None:
        time.sleep(0.01)
        self.value = value


class DummySingleton3(metaclass=Singleton):
    pass


class DummySingleton4(metaclass=Singleton):
    pass


class TestSingleton(unittest.TestCase):
    def test_singleton_instance(self) -> None:
        a = DummySingleton1(10)
        b = DummySingleton1(20)

        err = "Singleton instances should be the same."
        self.assertIs(a, b, err)

        err = "Singleton should retain the first value set."
        self.assertEqual(a.value, 10, err)
        self.assertEqual(b.value, 10, err)

    def test_singleton_thread_safety(self) -> None:
        lock = threading.Lock()
        instances: dict[type[Any], set[Any]] = {
            DummySingleton3: set(),
            DummySingleton4: set(),
        }

        def __new(cls: type[Any]) -> None:
            inst = cls()
            with lock:
                instances[cls].add(inst)

        nthreads = 100
        threads: list[threading.Thread] = []
        for _ in range(nthreads):
            t1 = threading.Thread(target=__new, args=(DummySingleton3,))
            t2 = threading.Thread(target=__new, args=(DummySingleton4,))
            threads.append(t1)
            threads.append(t2)

        for thread in threads:
            thread.start()

        for thread in threads:
            thread.join()

        for cls, cls_instances in instances.items():
            err = f"{cls.__name__} should only have one instance."
            self.assertEqual(len(cls_instances), 1, err)


if __name__ == "__main__":
    unittest.main()
