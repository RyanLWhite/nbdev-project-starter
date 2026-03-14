#!/usr/bin/env python3
"""Generate and validate project structure diagram.

Usage:
    python scripts/project_map.py update  # Update embedded diagrams
    python scripts/project_map.py check   # Check if diagrams are up-to-date
"""

import argparse
import sys
from fnmatch import fnmatch
from pathlib import Path
from typing import Dict, List

import yaml


def load_config(config_path: Path) -> dict:
    """Load configuration from YAML file."""
    with open(config_path) as f:
        return yaml.safe_load(f)


def should_ignore(path: Path, ignore_patterns: List[str], root: Path) -> bool:
    """Check if path matches any ignore pattern."""
    rel_path = str(path.relative_to(root))
    name = path.name

    for pattern in ignore_patterns:
        if fnmatch(name, pattern) or fnmatch(rel_path, pattern):
            return True
    return False


def collect_structure(root: Path, ignore_patterns: List[str], max_depth: int) -> Dict[str, List[Path]]:
    """Collect directory structure up to max_depth."""
    structure = {}

    def scan_dir(path: Path, depth: int):
        if depth > max_depth:
            return

        items = []
        try:
            for item in sorted(path.iterdir(), key=lambda x: (not x.is_dir(), x.name)):
                if should_ignore(item, ignore_patterns, root):
                    continue
                items.append(item)
                if item.is_dir() and depth < max_depth:
                    scan_dir(item, depth + 1)
        except PermissionError:
            pass

        structure[str(path.relative_to(root)) if path != root else "."] = items

    scan_dir(root, 0)
    return structure


def generate_tree(root: Path, structure: Dict[str, List[Path]], descriptions: Dict[str, str]) -> str:
    """Generate ASCII tree representation."""
    lines = [f"{root.name}/"]

    def add_items(parent_path: str, prefix: str):
        items = structure.get(parent_path, [])

        for i, item in enumerate(items):
            is_last = i == len(items) - 1
            item_rel = str(item.relative_to(root))

            connector = "└── " if is_last else "├── "
            extension = "    " if is_last else "│   "

            lookup_key = item_rel + "/" if item.is_dir() else item_rel
            desc = descriptions.get(lookup_key, "")
            comment = f"  # {desc}" if desc else ""

            display_name = item.name + "/" if item.is_dir() else item.name
            has_children = item.is_dir() and item_rel in structure and structure[item_rel]

            if item.is_dir():
                lines.append(f"{prefix}{connector}{display_name:<30}{comment}")
                if has_children:
                    add_items(item_rel, prefix + extension)
                else:
                    lines.append(f"{prefix}{extension}└── ...")
            else:
                lines.append(f"{prefix}{connector}{display_name:<30}{comment}")

    add_items(".", "")
    return "\n".join(lines)


def embed_diagram(file_path: Path, diagram: str, start_marker: str, end_marker: str) -> bool:
    """Embed diagram between markers in file. Returns True if changed."""
    content = file_path.read_text()

    if start_marker not in content or end_marker not in content:
        print(f"Warning: Markers not found in {file_path}", file=sys.stderr)
        return False

    start_idx = content.index(start_marker) + len(start_marker)
    end_idx = content.index(end_marker)

    new_content = content[:start_idx] + "\n```\n" + diagram + "\n```\n" + content[end_idx:]

    if new_content != content:
        file_path.write_text(new_content)
        return True
    return False


def check_diagram(file_path: Path, diagram: str, start_marker: str, end_marker: str) -> bool:
    """Check if embedded diagram matches. Returns True if matches."""
    content = file_path.read_text()

    if start_marker not in content or end_marker not in content:
        print(f"Error: Markers not found in {file_path}", file=sys.stderr)
        return False

    start_idx = content.index(start_marker) + len(start_marker)
    end_idx = content.index(end_marker)

    expected = "\n```\n" + diagram + "\n```\n"
    actual = content[start_idx:end_idx]

    return expected == actual


def main():
    parser = argparse.ArgumentParser(description="Generate and validate project structure diagram")
    parser.add_argument("mode", choices=["update", "check"], help="Operation mode")
    args = parser.parse_args()

    script_dir = Path(__file__).parent
    root = script_dir.parent

    config_path = root / "project-structure.yml"
    if not config_path.exists():
        print(f"Error: Config file not found: {config_path}", file=sys.stderr)
        sys.exit(1)

    config = load_config(config_path)
    ignore_patterns = config.get("ignore", [])
    max_depth = config.get("max_depth", 2)
    descriptions = config.get("descriptions", {})
    embed_targets = config.get("embed_in", [])

    structure = collect_structure(root, ignore_patterns, max_depth)
    diagram = generate_tree(root, structure, descriptions)

    start_marker = "<!-- PROJECT-STRUCTURE-START -->"
    end_marker = "<!-- PROJECT-STRUCTURE-END -->"

    success = True

    if args.mode == "update":
        for target in embed_targets:
            target_path = root / target
            if not target_path.exists():
                print(f"Warning: Embed target not found: {target}", file=sys.stderr)
                continue

            changed = embed_diagram(target_path, diagram, start_marker, end_marker)
            if changed:
                print(f"Updated: {target}")
            else:
                print(f"No change: {target}")

    elif args.mode == "check":
        for target in embed_targets:
            target_path = root / target
            if not target_path.exists():
                print(f"Error: Embed target not found: {target}", file=sys.stderr)
                success = False
                continue

            matches = check_diagram(target_path, diagram, start_marker, end_marker)
            if matches:
                print(f"✓ {target}")
            else:
                print(f"✗ {target} - diagram is out of date", file=sys.stderr)
                print(f"\nExpected diagram:\n{diagram}\n", file=sys.stderr)
                success = False

        if not success:
            print("\nRun 'python scripts/project_map.py update' to fix", file=sys.stderr)
            sys.exit(1)

    if success:
        print("✓ All checks passed" if args.mode == "check" else "✓ Update complete")


if __name__ == "__main__":
    main()
