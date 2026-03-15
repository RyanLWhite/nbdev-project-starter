#!/usr/bin/env python3
"""Validate starter consistency checks."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ALLOWED_PLACEHOLDERS = {
    "PROJECT_NAME",
    "MODULE_NAME",
    "GITHUB_USERNAME",
    "AUTHOR_NAME",
    "AUTHOR_EMAIL",
    "DESCRIPTION",
}


def fail(msg: str) -> None:
    print(f"ERROR: {msg}", file=sys.stderr)


def check_placeholders() -> int:
    errors = 0
    pattern = re.compile(r"\{\{([A-Z_]+)\}\}")
    for path in (ROOT / "templates").rglob("*"):
        if not path.is_file():
            continue
        if path.suffix not in {".md", ".mdc", ".yml", ".yaml", ".sh"}:
            continue
        text = path.read_text(encoding="utf-8")
        for match in pattern.findall(text):
            if match not in ALLOWED_PLACEHOLDERS:
                fail(f"{path.relative_to(ROOT)} uses unknown placeholder '{{{{{match}}}}}'")
                errors += 1
    return errors


def check_ci_pin() -> int:
    path = ROOT / "templates" / "github-workflows" / "test.yaml"
    text = path.read_text(encoding="utf-8")
    if not re.search(r"answerdotai/workflows/nbdev3-ci@[0-9a-f]{40}", text):
        fail(f"{path.relative_to(ROOT)} must pin nbdev3-ci to a commit SHA")
        return 1
    return 0


def check_dev_deps() -> int:
    path = ROOT / "create-project.sh"
    text = path.read_text(encoding="utf-8")
    required = {"jupyterlab", "jupyterlab-quarto", "nbdev", "pyyaml"}
    missing = [pkg for pkg in sorted(required) if f'"{pkg}"' not in text]
    if missing:
        fail(f"{path.relative_to(ROOT)} missing dev dependencies in generated pyproject: {', '.join(missing)}")
        return 1
    return 0


def check_known_links() -> int:
    path = ROOT / "templates" / "docs" / "fastai-info-map.md"
    text = path.read_text(encoding="utf-8")
    if re.search(r"tutorial\.htm(?!l)", text):
        fail(f"{path.relative_to(ROOT)} contains stale tutorial.htm link")
        return 1
    return 0


def main() -> int:
    errors = 0
    errors += check_placeholders()
    errors += check_ci_pin()
    errors += check_dev_deps()
    errors += check_known_links()
    if errors:
        print(f"\nStarter validation failed with {errors} error(s).", file=sys.stderr)
        return 1
    print("Starter validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
