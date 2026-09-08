# Shunya Core Stack

## Purpose

The Shunya Core Stack defines the minimum portable software foundation
required to provide the Shunya desktop experience.

The Core Stack must remain independent of any specific laptop, GPU,
display, audio device, or other hardware.

Packages are not installed merely because they are listed here.
A package enters the package manifests only when its implementation
stage requires it and its dependency justification has been reviewed.

## Initial Core Stack

### Hyprland

**Role:** Wayland compositor and window management.

Hyprland provides:

- Window management
- Workspaces
- Wayland session foundation
- Core compositor behavior

Hyprland is part of the initial Shunya Core because a Wayland compositor
is required to provide the desktop environment.

### Quickshell

**Role:** Desktop shell and interactive UI framework.

Quickshell provides the framework for Shunya's:

- Panels
- Widgets
- Desktop UI
- Interactive shell components

Quickshell is part of the initial Core because Shunya intends to provide
a controlled desktop shell rather than relying on an unrelated pre-built
desktop environment.

### Kitty

**Role:** Primary terminal emulator.

Kitty provides the terminal interface used by the Shunya desktop.

Kitty is part of the initial Core because a usable desktop installation
requires a terminal application and Shunya intends to provide a defined
default terminal.

## Planned Core Functionality

The following are Core responsibilities but are not automatically
additional package dependencies at this stage:

- Launcher
- Notifications
- Lock/session behavior
- Keybindings
- Theme system
- Application defaults

Each will be evaluated during its implementation stage.

A planned feature must not become a package dependency until the
required implementation and dependency have been justified.

## Core Boundaries

Core contains portable desktop behavior and defaults.

Core must not contain:

- Machine-specific hardware assumptions
- Laptop-model-specific configuration
- GPU-specific configuration
- Host-specific paths or state
- Installation logic
- Hardware detection logic

Hardware adaptation belongs under `hardware/`.

System deployment belongs under `installer/`.

Machine-specific exceptions belong under `machine/`.

## Dependency Policy

Every significant Core dependency must be evaluated according to
`docs/PACKAGE_POLICY.md`.

The evaluation must establish:

1. Why Shunya requires the dependency.
2. Whether the functionality is actually required.
3. Whether an appropriate official Arch package exists.
4. What dependencies the package introduces.
5. Whether the dependency can be removed or replaced later.
6. Whether it remains consistent with Shunya's minimalism and FOSS-first
   principles.

The existence of a package in this document does not by itself authorize
installation.

## Initial Stack Decision

The initial Shunya Core Stack is:

    Hyprland
        |
        +-- Quickshell
        |
        +-- Kitty

These components form the initial functional foundation.

Additional software will be evaluated individually rather than added as
a desktop bundle.

## Design Principle

The Core Stack should remain:

- Minimal
- Portable
- Reproducible
- Hardware-independent
- FOSS-first where technically appropriate
- Understandable
- Recoverable

Shunya should add software only when the required functionality cannot
reasonably be provided by the existing Core or a simpler solution.
