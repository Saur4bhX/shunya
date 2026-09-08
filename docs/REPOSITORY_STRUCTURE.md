# Shunya Repository Structure

## Purpose

This document defines the organization and ownership rules for the Shunya repository.

## Directories

- `bin/` — user-facing Shunya commands.
- `config/` — universal desktop and application configuration.
- `hardware/` — hardware detection and hardware-specific adapters.
- `installer/` — installation, update, diagnosis, reset, and detection logic.
- `packages/` — package manifests.
- `themes/` — Shunya themes and visual assets.
- `scripts/` — internal helper scripts.
- `machine/` — machine-local configuration and overrides.
- `docs/` — project documentation.

## Naming Conventions

- Use lowercase names for directories and files.
- Use hyphens for multi-word filenames where appropriate.
- Use descriptive names.
- Shell scripts should use `.sh` when they are standalone scripts.
- User-facing commands belong in `bin/`.
- Documentation uses Markdown (`.md`).

## Configuration Ownership

### Universal Configuration

Universal Shunya configuration belongs under:

    config/

It must not depend on one specific machine unless the dependency is explicitly abstracted.

### Hardware Configuration

Hardware-specific detection and adapters belong under:

    hardware/

Hardware logic should expose capabilities or adaptations to the Core rather than embedding hardware assumptions throughout the project.

### Machine-Local Configuration

Machine-specific settings belong under:

    machine/

Examples may include:

- Machine-specific display settings
- Hardware-specific overrides
- Local preferences that cannot reasonably be universal

Machine-local configuration must not silently become part of the universal configuration.

## Empty Directories

Directories may intentionally remain empty during development.

A directory should not be populated merely because it exists.

Implementation should be added only when there is a defined requirement for it.

## General Rule

Every file should have a clear owner and purpose.

Avoid duplicated configuration and unnecessary abstraction.
