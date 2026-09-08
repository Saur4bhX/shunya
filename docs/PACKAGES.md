# Shunya Package Manifest Model

## Purpose

Package manifests declare software intentionally required by Shunya.

They are inputs to future installation and validation logic.

## Manifests

### Official Arch Packages

    packages/pacman.txt

Contains packages available from supported official Arch repositories.

### AUR Packages

    packages/aur.txt

Contains approved packages obtained from the Arch User Repository.

AUR usage follows the rules defined in `docs/PACKAGE_POLICY.md`.

## Format

Each manifest contains one package name per line.

Example:

    package-name

Blank lines are allowed.

Comments begin with `#`.

Example:

    # Required for a specific capability
    package-name

Package names must be valid package identifiers.

## Ordering

Packages should be kept in a stable, predictable order.

Where practical, maintain alphabetical ordering.

## Duplicates

Duplicate package names are not permitted.

Validation should report duplicates rather than silently hiding them.

## Separation

A package must appear in only the manifest appropriate to its source.

A package must not be placed in `aur.txt` merely because it is convenient
when an adequate official Arch package exists.

## Minimalism

A package is added only when there is a demonstrated Shunya requirement.

Do not populate manifests with anticipated or optional software.

Optional functionality should not automatically become a required dependency.

## Dependency Ownership

Packages installed as dependencies of explicitly declared packages do not
need to be duplicated in the manifest unless Shunya directly requires and
manages them.

The package manager remains responsible for dependency resolution.

## Validation

Future package tooling should validate:

- Manifest syntax
- Empty or malformed entries
- Duplicate packages
- Package source separation
- Unnecessary or obsolete entries where practical

## Installation

Future installer logic should:

1. Read the manifests.
2. Validate them.
3. Resolve package availability.
4. Install only declared requirements and their necessary dependencies.
5. Report failures clearly.

The manifests themselves must not contain shell commands.

## Updates

Changes to package manifests are intentional project changes and should be
committed to Git.

Significant package additions or removals should have a clear reason.

## AUR Risk

AUR packages are community-maintained and require additional review.

Shunya must not assume that an AUR package is equivalent in trust or
maintenance to an official Arch package.

## Current State

The manifests intentionally contain no large package collection.

Packages will be added when implementation requires them.

## Principle

> Declare what Shunya needs; let the package manager resolve how it gets
> there.
