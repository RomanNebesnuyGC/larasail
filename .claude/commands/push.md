Commit all staged and unstaged changes, then push to master with correct semantic version bump tag.

## Rules

Versioning is automatic via GitHub Actions on every push to master. The bump type is controlled by a tag in the commit message:

- **patch** (default, `2.0.0 → 2.0.1`): no tag needed — just a regular commit message
- **minor** (`2.0.1 → 2.1.0`): include `[minor]` in the commit message
- **major** (`2.1.0 → 3.0.0`): include `[major]` in the commit message

## How to decide the bump type

- Bug fixes, small improvements, docs → **patch** (default)
- New commands, new flags, new features that don't break existing behavior → **minor** — add `[minor]`
- Breaking changes to defaults, removed commands, incompatible behavior changes → **major** — add `[major]`

## Steps

1. Run `git status` and `git diff` to see what changed
2. If the working tree is clean (nothing to commit):
   - Run `git tag --points-at HEAD` to check if the current commit already has a tag
   - If it has no tag, run `git tag -a vX.Y.Z HEAD -m "vX.Y.Z"` using the next patch version from `.larasail/VERSION`, then `git push origin vX.Y.Z`
   - If it already has a tag, report "Nothing to push, already tagged" and stop
3. If there are changes:
   - Decide the bump type based on the nature of the changes
   - Stage relevant files
   - Write a clear commit message — append `[minor]` or `[major]` if needed (nothing for patch)
   - Commit and push to master
