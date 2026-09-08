# Shunya Backup and Recovery

## Purpose

Shunya development must remain recoverable. Important work must not exist only as uncommitted local changes.

## Development Workflow

Meaningful change
→ Test
→ Commit
→ Push to GitHub
→ Periodic local backup
→ Milestone tag

## Rules

- Commit after meaningful changes.
- Push regularly, preferably after each development session.
- Create Git tags for completed milestones.
- Create a local backup before risky system changes.
- Maintain periodic local snapshots.
- Periodically verify that the repository can be restored.
- Never rely on an uncommitted working tree as the only copy of important work.

## Recovery Sources

Shunya should be recoverable from:

1. The GitHub repository.
2. Local Git history.
3. Local project archives/snapshots.

## Restoration

A fresh copy can be restored by cloning the GitHub repository:

    git clone <repository-url>

The restored repository should be checked with:

    git status
    git log --oneline --decorate

## Local Backups

Local backups should be stored outside the active project directory.

A backup should contain the Git repository history and project files.

Before risky development or system changes:

1. Ensure important work is committed.
2. Push the commit to GitHub.
3. Create a local project archive.
4. Perform the risky operation only after the checkpoint exists.

## Verification

Backups should periodically be tested by restoring or inspecting them rather than assuming they work.

## Principle

Recoverability is a requirement of Shunya development, not an optional convenience.
