# Altara

Automated logging, telemetry, and real-time analysis.

## Brief

A Qt serial communication application utilizing the model, view, view-model design pattern.
Altara is designed as a foundation for communication between serial devices.
The system can be expanded to support the specific applications of each type of available device.
However, the underlying system that manages the multi-threading and scheduling of events remains the same for each device.
Each custom device implementation is based off an abstract device class model that defines the common expected behaviour of every device.
The user can then expand their implementation to include custom signals and properties.

## Setup

See the `Makefile` to automate project navigation.
It provides rules for the following functionality:
* Creating a virtual environment
* Installing application dependencies
* Running the application
* Removing the virtual environment
* Cleaning the application working directory
* Compiling new application executables

## Releases

This project adheres to [Semantic Versioning](http://semver.org/).

|**Version** |**Date**    |**Details**         |**Sources**           |**Executables**  |
|:----------:|:----------:|:------------------:|:--------------------:|:---------------:|
