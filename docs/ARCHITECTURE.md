# Shunya Architecture

## Purpose

Shunya is organized into four primary boundaries:

- Core
- Hardware
- Installer
- Machine-local

The architecture separates portable Shunya behavior from hardware-specific
adaptation and machine-specific state.

## Core

Core contains the portable Shunya experience and behavior.

Examples:

- Desktop configuration
- Window manager configuration
- Shell/UI configuration
- Launcher
- Notifications
- Keybindings
- Theme definitions
- Application defaults

Core must not contain assumptions about one specific laptop or hardware model.

## Hardware

Hardware contains adapters and detection logic for physical hardware.

Examples:

- GPU
- Display
- Audio
- Network
- Bluetooth
- Battery/power
- Touchpad/input
- External displays

Hardware logic should expose what the system needs without making the Core
dependent on a particular machine.

## Installer

Installer is responsible for transforming a supported Arch Linux system into
a Shunya system.

Responsibilities include:

- Preflight checks
- Hardware detection
- Package installation
- Configuration deployment
- Machine-specific handling
- Logging
- Error handling
- Backup/recovery
- Post-install validation

The installer must not become the owner of Core configuration.

## Machine-local

Machine-local contains information that belongs only to one physical
installation.

Examples:

- Machine-specific overrides
- Local hardware quirks
- Host-specific configuration
- Local state that must not be committed as portable Shunya configuration

Machine-local data must not define the general Shunya architecture.

## Dependency Direction

The intended relationship is:

    SHUNYA
      |
      +-- Core
      |
      +-- Hardware
      |
      +-- Installer
      |
      +-- Machine-local

Core should remain portable.

Hardware adapts physical systems to Shunya requirements.

Installer coordinates deployment.

Machine-local provides controlled exceptions where necessary.

## Separation Principle

When a requirement can be implemented universally, it belongs in Core.

When behavior depends on hardware capabilities, it belongs in Hardware.

When behavior concerns installation or deployment, it belongs in Installer.

When behavior exists only because of one particular machine, it belongs in
Machine-local.

Machine-specific behavior must not silently leak into Core.

## Conceptual Flow

    Portable Shunya
          |
      +---+---+
      |       |
     Core   Hardware
      |       |
      +---+---+
          |
       Installer
          |
          v
    Shunya System

## Architectural Rule

Prefer the simplest portable solution.

Introduce hardware-specific or machine-specific logic only when there is a
clear technical reason.

Shunya should remain understandable, reproducible, and recoverable.
