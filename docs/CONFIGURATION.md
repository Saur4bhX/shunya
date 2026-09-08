# Shunya Configuration Model

## Purpose

Shunya configuration is divided into portable configuration and
machine-specific configuration.

The model must keep the Core reproducible while allowing hardware and
machine-specific differences where necessary.

## Configuration Layers

### Core Defaults

Portable configuration shared by supported Shunya systems.

Location:

    config/

Core defaults must not contain assumptions about a particular machine.

### Hardware Configuration

Hardware-dependent behavior belongs to:

    hardware/

Hardware configuration should adapt the system to detected capabilities.

### Machine-local Configuration

Machine-specific overrides belong to:

    machine/

Examples:

- Host-specific settings
- Hardware quirks
- Local overrides
- Installation-specific state

Machine-local configuration must not silently become part of portable Core
configuration.

## Precedence

When multiple configuration layers provide the same setting, the intended
precedence is:

    Core defaults
        ↓
    Hardware adaptation
        ↓
    Machine-local override

A more specific layer may override a less specific layer when explicitly
supported.

## Ownership

Each configuration value should have a clear owner.

Before adding a setting, determine whether it belongs to:

- Core
- Hardware
- Machine-local

Avoid duplicate definitions across layers.

## Deployment

Future deployment logic should:

1. Read the appropriate configuration.
2. Resolve applicable hardware and machine overrides.
3. Validate the resulting configuration.
4. Deploy it to the required system/user location.
5. Report failures clearly.

Deployment must be deterministic and safe to repeat.

## User Configuration

Shunya must distinguish between:

- Shunya-managed configuration
- User-owned configuration
- Machine-local configuration

Shunya must not silently overwrite unrelated user configuration.

## Secrets

Secrets and sensitive credentials must never be committed to the repository.

Machine-local or ignored storage may be used where necessary.

## Reproducibility

A fresh Shunya installation should be able to reproduce the portable Core
configuration from the repository.

Machine-local differences must be explicit exceptions.

## Future Configuration Format

The exact configuration formats will be selected when implementation requires
them.

No configuration format should be introduced merely for the sake of having
one.

## Validation

Future configuration tooling should detect:

- Missing required configuration
- Invalid values
- Conflicting overrides
- Unsupported settings
- Machine-specific configuration accidentally placed in Core

## Reset

The future `shunya reset` command must operate only on configuration that
Shunya explicitly owns.

It must not claim to restore arbitrary system state.

## Principle

> Portable configuration is the default; machine-specific configuration is
> the exception.
