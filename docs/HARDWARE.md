# Shunya Hardware Strategy

## Purpose

Shunya is hardware-aware, but its Core must remain portable.

Hardware-specific behavior belongs behind a defined Hardware boundary.

## Hardware Categories

Shunya may need to account for:

- GPU
- Display
- Audio
- Network
- Bluetooth
- Battery and power
- Touchpad and input
- External displays

Hardware support should be capability-based rather than tied unnecessarily to
one laptop model.

## Portable Core vs Hardware Adapter

### Portable Core

The Core defines what Shunya wants.

Examples:

- A graphical session
- Audio output
- Network connectivity
- Brightness control
- Power management
- External display support

### Hardware Layer

The Hardware layer determines how those capabilities are provided on a
particular system.

Examples:

- GPU-specific requirements
- Display-specific behavior
- Laptop-specific power behavior
- Touchpad-specific quirks
- Hardware driver requirements

The Core must not contain machine-specific workarounds.

## Detection

Hardware detection should identify relevant capabilities and hardware where
necessary.

Detection should be:

- Explicit
- Reproducible
- Non-destructive
- Easy to diagnose

Detection results should be available to the components that need them.

## Hardware Support Priority

Initial hardware support should prioritize common and well-supported Linux
hardware.

Unsupported or unusual hardware should fail clearly rather than being
silently misconfigured.

## Machine-Specific Overrides

Some hardware may require local exceptions.

Such exceptions belong in:

    machine/

They must not silently modify the portable Core.

Machine-specific configuration should be:

- Explicit
- Minimal
- Documented where significant
- Easy to remove

## External Displays

External display handling is considered a first-class hardware concern.

Shunya should eventually account for:

- Detection
- Resolution
- Refresh rate
- Connection/disconnection
- Multi-display layouts

Display configuration must remain separate from general Core configuration
where hardware-specific behavior is involved.

## GPU

GPU handling must account for different hardware families without assuming
the reference development laptop is representative of all systems.

GPU-specific packages or configuration belong in the Hardware boundary.

## Audio

Audio support should use the Linux audio stack appropriate to the supported
system.

Shunya should configure user-facing behavior without unnecessarily coupling
the Core to one hardware device.

## Network and Bluetooth

Network and Bluetooth are hardware/system capabilities.

Shunya should avoid embedding assumptions about a particular adapter or
interface name.

## Battery and Power

Laptop power behavior belongs to the Hardware boundary where it depends on
hardware capabilities.

Portable defaults should remain possible where supported.

## Touchpad and Input

Input configuration should distinguish portable defaults from device-specific
quirks.

Hardware-specific workarounds belong outside the portable Core.

## Failure Principle

If hardware cannot be detected or supported reliably:

1. Report the problem clearly.
2. Avoid destructive changes.
3. Preserve the portable configuration.
4. Allow diagnosis or manual intervention.

Shunya must not guess hardware configuration when the consequences could be
significant.

## Development Rule

The development laptop is a reference machine, not the definition of Shunya.

Every hardware-specific implementation should be evaluated against the
question:

> Is this a general Shunya requirement, or merely a requirement of this
> particular machine?

## Principle

> Shunya adapts to hardware; hardware does not define Shunya.
