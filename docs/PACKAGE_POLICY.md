# Shunya Package Policy

## Purpose

Shunya should use the smallest practical set of software required to provide
its intended functionality.

Every significant dependency must have a clear reason to exist.

## Package Sources

### Official Arch repositories

Preferred by default.

Use official Arch packages when they provide the required functionality
adequately.

### AUR

AUR packages are allowed only when there is a clear technical requirement
and no suitable official Arch package is available.

AUR dependencies must be reviewed before adoption.

## Package Evaluation

Before adding a significant package, answer:

1. What does Shunya need it for?
2. Is the functionality actually required?
3. Is there a suitable official Arch package?
4. If not, why is an AUR package justified?
5. What dependencies does it introduce?
6. Can the dependency be removed or replaced later?
7. Does it conflict with Shunya's minimalism or FOSS-first principles?

## FOSS Preference

Shunya prefers Free and Open Source Software.

Non-FOSS software may be used when there is a justified technical or practical
requirement, but it should not be added merely for convenience.

## Package Manifests

Packages will eventually be declared through:

- `packages/pacman.txt` — official Arch packages
- `packages/aur.txt` — AUR packages

These files are declarative manifests, not arbitrary installation scripts.

They should contain only packages intentionally required by Shunya.

## No Premature Dependencies

Foundation development must not install the eventual desktop stack merely
because it is planned.

Packages are added when their implementation stage requires them.

## Removal and Replacement

A package should be removed when:

- Its functionality is no longer required.
- A simpler dependency-free solution replaces it.
- A better-supported alternative is adopted.
- Its maintenance or compatibility cost becomes unjustified.

Changes to significant dependencies should be documented in Git history.

## Principle

> If Shunya cannot clearly explain why it needs a dependency, Shunya does not
> need that dependency yet.
