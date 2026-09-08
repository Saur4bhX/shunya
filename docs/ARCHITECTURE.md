# Shunya Architecture

## Purpose

Shunya is a structured layer on top of a supported Arch Linux installation.

The architecture separates universal Shunya behavior from hardware-specific adaptation.

## Conceptual Architecture

                    SHUNYA
                      │
          ┌───────────┴───────────┐
          │                       │
        CORE                  HARDWARE
          │                       │
     Hyprland                  GPU
     Quickshell                Display
     Theme                     Audio
     Launcher                  Network
     Notifications             Battery
     Keybindings               Touchpad
     Applications              Bluetooth
          │                       │
          └───────────┬───────────┘
                      │
                  INSTALLER
                      │
                      ▼
                 SHUNYA SYSTEM

## Layers

### Core

Core contains behavior intended to be common across supported Shunya systems.

Examples include:

- Desktop environment configuration
- Window management
- Shell/UI configuration
- Theme system
- Launcher
- Notifications
- Keybindings
- Standard application configuration

Core should not contain assumptions about one specific laptop.

### Hardware

Hardware contains detection and adaptation logic for machine-specific characteristics.

Hardware categories include:

- GPU
- Display
- Audio
- Network
- Bluetooth
- Battery and power
- Touchpad and input
- External displays

Hardware logic should adapt the system without unnecessarily duplicating the Core.

### Installer

The Installer is responsible for turning a supported Arch installation into a Shunya system.

Its eventual responsibilities include:

- Preflight checks
- Hardware detection
- Package installation
- Configuration deployment
- Machine-specific handling
- Error handling
- Logging
- Validation
- Recovery/rollback expectations

The full installer is not implemented at this stage.

### Machine-Local Configuration

Machine-local configuration contains values that should not become universal Shunya defaults.

Examples may include:

- Device-specific overrides
- Local hardware choices
- User-specific paths
- Local preferences that are intentionally outside the universal Core

Machine-local configuration must remain clearly separated from the reusable Shunya configuration.

## Layer Interaction

The intended flow is:

    Supported Arch
          │
          ▼
      Installer
          │
          ├──────► Hardware Detection
          │              │
          │              ▼
          │        Hardware Adapters
          │
          ▼
         Core
          │
          ▼
    Shunya System

Hardware detection informs hardware adapters.

Hardware adapters provide the necessary machine-specific behavior.

Core provides the common Shunya experience.

The Installer coordinates deployment and validation.

## Architecture Rules

1. Core must remain hardware-agnostic where practical.
2. Hardware-specific behavior belongs in the Hardware layer.
3. Machine-local values must not silently become universal defaults.
4. The Installer should coordinate layers rather than duplicate their logic.
5. Dependencies should be introduced deliberately.
6. Configuration ownership must remain clear.
7. Significant system changes should be explicit and recoverable.
8. The architecture must remain understandable on a fresh clone.
9. The reference laptop must not define universal Shunya assumptions.
10. Avoid abstractions that do not provide meaningful value.

## Current Boundary

At the Foundation stage, the architecture is being defined before substantial implementation.

Desktop configuration, hardware adapters, and the full installer are intentionally deferred until the Core Skeleton is established.
