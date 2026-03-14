"""Update project structure diagram, then run nbdev-prepare."""

import sys
from pathlib import Path
from subprocess import run

from fastcore.script import call_parse


@call_parse
def main():
    "Update project structure diagram, then run nbdev-prepare."
    root = Path(__file__).parent.parent
    run([sys.executable, str(root / "scripts" / "project_map.py"), "update"], check=True)
    run(["nbdev-prepare"], check=True)
