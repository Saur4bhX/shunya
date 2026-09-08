# Shunya CLI Contract

## Purpose

`shunya` is the primary command-line interface for managing a Shunya system.

The CLI must remain predictable, explicit, and safe.

## Invocation

The executable is:

    bin/shunya

It must determine the Shunya repository root from its own location and must
not depend on the user's current working directory.

## Commands

### `shunya help`

Displays available commands and usage information.

### `shunya version`

Displays the version stored in the repository's `VERSION` file.

### `shunya install`

Installs Shunya.

Status: planned, not implemented.

### `shunya update`

Updates Shunya-managed components.

Status: planned, not implemented.

### `shunya doctor`

Checks the Shunya installation and reports detected problems.

Status: planned, not implemented.

### `shunya reset`

Resets Shunya-managed configuration according to the future reset contract.

Status: planned, not implemented.

## Options

    shunya --help
    shunya -h

Display help.

    shunya --version
    shunya -v

Display the Shunya version.

## Exit Status

The CLI must use:

    0

for successful operations.

A non-zero status indicates failure.

Invalid or unknown commands must return a non-zero status.

## Error Handling

Errors must:

- Be written to stderr.
- Clearly identify the problem.
- Avoid silently ignoring failures.
- Avoid destructive actions unless explicitly requested.

## Working Directory

CLI behavior must be independent of the current working directory.

For example:

    cd /tmp
    ~/shunya/bin/shunya version

must work correctly.

## Logging

Future commands may provide structured or human-readable operational output.

Logging must not expose sensitive information unnecessarily.

## Safety

Commands that modify the system must:

- Clearly identify significant actions.
- Fail safely where practical.
- Avoid silently overwriting unrelated user data.
- Return a meaningful non-zero status on failure.

## Compatibility

The CLI is a public project interface.

Breaking changes should be documented and reflected in versioning.

## Implementation Rule

The CLI should remain small.

Command-specific functionality should be implemented in appropriate project
components rather than turning `bin/shunya` into one large script.

## Current Status

Implemented:

- `help`
- `version`
- basic command validation
- repository-root resolution

Planned:

- `install`
- `update`
- `doctor`
- `reset`
