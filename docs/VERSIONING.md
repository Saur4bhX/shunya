# Shunya Versioning

## Version Format

Shunya uses Semantic Versioning:

    MAJOR.MINOR.PATCH

Example:

    0.1.0

During the experimental `0.x` phase, the project may introduce breaking
changes between minor versions.

## Version Meaning

### MAJOR

A major release may contain breaking changes to established interfaces,
configuration, or system behavior.

### MINOR

A minor release adds functionality or makes significant changes while
remaining within the project's compatibility expectations.

During `0.x`, minor releases may contain breaking changes.

### PATCH

A patch release contains bug fixes, corrections, documentation improvements,
or other changes that should not alter established behavior.

## Development Status

Shunya begins in the `0.x` series.

Version `1.0.0` represents the point at which the project considers its core
interfaces and architecture sufficiently stable for a first stable release.

## Milestone Tags

Important project milestones are tagged in Git.

Examples:

    step0
    foundation
    core-skeleton

Milestone tags identify verified project states and are not necessarily
release versions.

## Breaking Changes

Breaking changes must be:

- Deliberate
- Documented
- Recorded in Git history
- Reflected in relevant documentation

Changes affecting the CLI, configuration model, package manifests, or
installer behavior should be treated as potentially breaking.

## Configuration Migrations

When a configuration format changes incompatibly, Shunya should provide a
clear migration path where practical.

If automatic migration is unsafe or unreliable, Shunya should fail clearly
and explain the required manual action.

## Release History

Significant releases and architectural milestones should be recorded in
Git tags and project documentation.

## Version Source

The repository's `VERSION` file is the authoritative project version during
the early development phase.

The version reported by the future `shunya version` command must correspond
to this project version.

## Principle

> A version should communicate a meaningful state of the project, not merely
> the passage of time.
