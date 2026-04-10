# python-package-template

A Nix-first Python package template with:

- `pytest` test support
- `mypy` type checking
- `ruff` linting
- source and wheel package checks

## Rename the placeholders

Run this once after creating from the template:

```bash
nix run .#rename
```

It renames:

- distribution name: `python-package-template`
- import package: `python_package`

## Quick start

```bash
nix develop
pytest
mypy src tests
ruff check src tests
pyproject-build --no-isolation --sdist --wheel
```

## Nix checks

```bash
nix flake check
```

This runs package build checks, linting, type checking, and distribution validation (`twine check`).
