#!/usr/bin/env python3

from __future__ import annotations

import argparse
import pathlib
import re
import shutil
import sys


OLD_DIST_NAME = "python-package-template"
OLD_IMPORT_NAME = "python_package"
SKIP_DIRS = {".git", ".direnv", ".ipython", "result", "dist", "build"}
SKIP_FILES = {"scripts/rename-project.py"}


def validate_dist_name(name: str) -> None:
    if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9._-]*", name):
        raise ValueError(
            f"Invalid distribution name '{name}'. Use letters, numbers, '.', '_' or '-'."
        )


def validate_import_name(name: str) -> None:
    if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", name):
        raise ValueError(
            f"Invalid import package name '{name}'. Use a valid Python identifier."
        )


def iter_files(root: pathlib.Path) -> list[pathlib.Path]:
    files: list[pathlib.Path] = []
    for path in root.rglob("*"):
        if not path.is_file():
            continue
        rel = path.relative_to(root)
        if any(part in SKIP_DIRS for part in rel.parts):
            continue
        if rel.as_posix() in SKIP_FILES:
            continue
        files.append(path)
    return files


def replace_in_text_files(root: pathlib.Path, old: str, new: str) -> None:
    for file_path in iter_files(root):
        content = file_path.read_text(encoding="utf-8")
        updated = content.replace(old, new)
        if updated != content:
            file_path.write_text(updated, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Rename template placeholders for distribution and import package names."
    )
    parser.add_argument("dist_name", nargs="?", help="New project distribution name (e.g. my-lib)")
    parser.add_argument(
        "import_name",
        nargs="?",
        help="New import package name (e.g. my_lib). Defaults to dist_name with '-' and '.' replaced by '_'.",
    )
    args = parser.parse_args()

    dist_name = args.dist_name
    if not dist_name:
        dist_name = input("Enter project distribution name (e.g. my-lib): ").strip()

    if not dist_name:
        print("Error: distribution name cannot be empty.", file=sys.stderr)
        return 1

    import_name = args.import_name
    if not import_name:
        default_import = dist_name.replace("-", "_").replace(".", "_")
        typed = input(f"Enter import package name [{default_import}]: ").strip()
        import_name = typed or default_import

    try:
        validate_dist_name(dist_name)
        validate_import_name(import_name)
    except ValueError as err:
        print(f"Error: {err}", file=sys.stderr)
        return 1

    if dist_name == OLD_DIST_NAME and import_name == OLD_IMPORT_NAME:
        print("Nothing to do: names already match template defaults.")
        return 0

    root = pathlib.Path(__file__).resolve().parents[1]

    old_pkg_dir = root / "src" / OLD_IMPORT_NAME
    new_pkg_dir = root / "src" / import_name

    if not old_pkg_dir.exists() and not new_pkg_dir.exists():
        print(
            f"Error: expected package directory '{old_pkg_dir.relative_to(root)}'.",
            file=sys.stderr,
        )
        return 1

    if old_pkg_dir.exists() and new_pkg_dir.exists() and old_pkg_dir != new_pkg_dir:
        print(f"Error: target package directory '{new_pkg_dir.relative_to(root)}' already exists.", file=sys.stderr)
        return 1

    replace_in_text_files(root, OLD_DIST_NAME, dist_name)
    replace_in_text_files(root, OLD_IMPORT_NAME, import_name)

    if old_pkg_dir.exists() and old_pkg_dir != new_pkg_dir:
        shutil.move(str(old_pkg_dir), str(new_pkg_dir))

    remaining = []
    for file_path in iter_files(root):
        text = file_path.read_text(encoding="utf-8")
        if OLD_DIST_NAME in text or OLD_IMPORT_NAME in text:
            remaining.append(file_path.relative_to(root).as_posix())

    if remaining:
        print("Warning: some template placeholders remain:", file=sys.stderr)
        for path in remaining:
            print(f"  {path}", file=sys.stderr)
        return 1

    print(f"Renamed distribution: {OLD_DIST_NAME} -> {dist_name}")
    print(f"Renamed import package: {OLD_IMPORT_NAME} -> {import_name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
