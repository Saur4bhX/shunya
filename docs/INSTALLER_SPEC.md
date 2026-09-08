# Shunya Installer Specification

## Purpose

The Shunya installer converts a supported Arch Linux installation into a
Shunya system in a controlled, reproducible, and recoverable manner.

This document defines the installer contract. It does not implement the
installer.

## Supported Starting State

The initial installer target is:

- Arch Linux
- Existing bootable system
- Working network connection
- Functional package manager
- User with required administrative privileges

The installer must verify prerequisites before making system changes.

## Preflight

Before modifying the system, the installer should check:

- Operating system
- Architecture
- Network availability
- Package manager availability
- Administrative privileges
- Required filesystem access
- Existing Shunya installation state
- Available disk space where relevant

Preflight failures must stop installation before destructive changes occur.

## Hardware Detection

The installer should detect relevant hardware capabilities, including:

- GPU
- Display
- Audio
- Network
- Bluetooth
- Battery/power
- Touchpad/input
- External display capability

Detection results should influence adapters and package selection, not alter
the portable Core architecture.

## Package Installation

The installer installs packages from Shunya's declarative package manifests.

It must:

- Prefer official Arch repositories
- Handle approved AUR dependencies according to project policy
- Avoid unnecessary packages
- Report installation failures clearly

## Configuration Deployment

The installer deploys Shunya configuration to the appropriate system/user
locations.

Configuration deployment should be:

- Deterministic
- Repeatable
- Explicit
- Safe to re-run

Existing user configuration must not be silently destroyed.

## Machine-Specific Handling

Machine-specific configuration belongs to the Machine-local boundary.

The installer may detect and configure machine-specific requirements, but
those requirements must not silently become part of portable Core
configuration.

## Idempotency

Running the installer again on an already configured Shunya system should
not unnecessarily duplicate, corrupt, or conflict with existing configuration.

The installer should detect current state and make only required changes.

## Error Handling

Failures must:

- Stop the affected operation safely
- Produce a useful error message
- Return a non-zero exit status
- Avoid leaving the system in an unknown state where reasonably possible

The installer must never silently ignore significant failures.

## Logging

Installation actions should be logged sufficiently to diagnose failures.

Logs should identify:

- Major operations
- Package operations
- Configuration deployment
- Hardware detection
- Errors

Sensitive information must not be unnecessarily written to logs.

## Backup and Recovery

Before significant system modifications, the installer should provide or
perform an appropriate recovery checkpoint.

The recovery design must be documented before destructive installation
operations are implemented.

The installer must not claim rollback capability that it cannot actually
provide.

## Post-Install Validation

After installation, the installer should verify:

- Required packages are installed
- Required configuration exists
- Expected services/configuration are functional
- Hardware-specific requirements were handled
- Shunya reports a valid version/state

Validation failures must be clearly reported.

## Update

The future `shunya update` operation should:

- Update Shunya-managed components
- Preserve machine-local configuration
- Avoid unnecessary changes
- Validate the resulting state

## Reset

The future `shunya reset` operation must clearly define what is reversible
before implementation.

It must not imply that arbitrary system state can always be restored.

## Safety Principles

The installer must:

- Explain significant changes
- Avoid destructive operations without justification
- Never silently overwrite unrelated user data
- Prefer reversible operations
- Fail clearly rather than guessing
- Keep machine-specific logic isolated
- Remain as simple as practical

## Future CLI

The intended interface is:

    shunya install
    shunya update
    shunya doctor
    shunya reset
    shunya version

The exact CLI contract will be defined separately during Core Skeleton.

## Implementation Boundary

This specification does not authorize implementation of the full installer.

Installer implementation begins only after the Foundation and Core Skeleton
requirements are established.

## Disclaimer

Shunya is a hobby/experimental project. Installation may modify system
configuration, install software, and change services on an Arch Linux system.

Users should review changes and maintain appropriate backups.

Hardware compatibility is not guaranteed.
