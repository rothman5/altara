ENV ?= .venv
LOG ?= debug.log
QML ?= app/views/App.qml
TESTS ?= tests

ifeq ($(OS), Windows_NT)
    PYTHON := $(ENV)/Scripts/python.exe
	PYCLEAN := $(ENV)/Scripts/pyclean.exe
	PYQML := $(ENV)/Scripts/pyside6-qml.exe
else
	PYTHON := $(ENV)/bin/python
	PYCLEAN := $(ENV)/bin/pyclean
	PYQML := $(ENV)/bin/pyside6-qml.exe
endif

.PHONY: all clean clean_py clean_logs qml

all: clean run

run:
	$(PYTHON) -m app.main

qml:
	$(PYQML) $(QML)

clean: clean_py clean_logs

clean_py:
	$(PYCLEAN) .

clean_logs:
	@if [ -f "$(LOG)" ]; then \
		rm -f $(LOG); \
		echo "Log file $(LOG) removed."; \
	fi

tests: test_models test_tools test_view_models test_views

test_models:
	$(PYTHON) -m $(TESTS).test_models

test_tools:
	$(PYTHON) -m $(TESTS).test_tools

test_view_models:
	$(PYTHON) -m $(TESTS).test_view_models

test_views:
	$(PYTHON) -m $(TESTS).test_views
