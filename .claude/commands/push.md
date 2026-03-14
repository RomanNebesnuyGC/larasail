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
2. Decide the bump type based on the nature of the changes
3. Stage relevant files
4. Write a clear commit message — append `[minor]` or `[major]` if needed (nothing for patch)
5. Commit and push to master
