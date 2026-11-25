---
name: release-version
description: Bump project version, sync dependencies, commit, and tag a release. Use when user wants to create a new release, bump version, cut a new version, or prepare a release.
---

# Release Version

## Quick start

Use [semantic versioning](https://semver.org/).

1. Determine bump type from user request or changes since last tag
2. Update `version` in `pyproject.toml`
3. Run `uv sync --all-extras --dev`
4. Commit and tag

## Workflows

### Create a new release

- [ ] Determine version bump type:
  - **Patch** (X.Y.Z+1): Bug fixes, minor improvements
  - **Minor** (X.Y+1.0): New features, backwards compatible
  - **Major** (X+1.0.0): Breaking changes
- [ ] If user didn't specify bump type, inspect changes: `git log <last-tag>..HEAD --oneline`
- [ ] Read current version from `pyproject.toml` `[project]` table
- [ ] Compute new version and confirm with user
- [ ] If the release changes the Python version (`requires-python`), update dependent tool config in the same release commit — e.g. ruff `target-version` in `pyproject.toml` (observed 2026-11-25: stale `py312` after a 3.15 bump)
- [ ] Update `version = "X.Y.Z"` in `pyproject.toml`
- [ ] Run `uv sync --all-extras --dev` to sync lockfile (in network-restricted environments, `uv sync --locked --offline` from a warm cache is a valid fallback — a pure version bump needs no registry access, observed 2026-11-25)
- [ ] Stage and commit: `git add pyproject.toml uv.lock && git commit -m "Next version X.Y.Z"`
- [ ] Create tag: `git tag vX.Y.Z`
- [ ] Inform user that commit + tag are ready (do NOT push unless asked)

### Version calculation rules

- Patch: increment Z (e.g. 0.4.3 -> 0.4.4)
- Minor: increment Y, reset Z to 0 (e.g. 0.4.3 -> 0.5.0)
- Major: increment X, reset Y and Z to 0 (e.g. 0.4.3 -> 1.0.0)
