# nbdev Project Starter

Automated setup for nbdev projects following fastai conventions.

One script creates a fully configured project: GitHub repo, virtual environment, nbdev + JupyterLab, Cursor rules, contributing guides, notebook style guide, git hooks — ready to open JupyterLab and start writing.

## What You Get

A new project with:

- **GitHub repository** created and connected
- **Virtual environment** with nbdev, JupyterLab, Quarto installed
- **`pyproject.toml`** fully configured (PEP 621, nbdev3 style)
- **Cursor rules** for nbdev workflow (notebooks as source of truth, export directives, autoreload guidance)
- **`CONTRIBUTING.md`** with complete nbdev development workflow
- **`GETTING-STARTED.md`** quick-reference checklist
- **`docs/notebook-style-guide.md`** with explore → export → demo pattern
- **`docs/autoreload-best-practices.md`** for module reloading
- **`docs/fastai-info-map.md`** curated learning resources
- **`docs/decision-template.md`** for documenting project-specific nbdev decisions
- **Git hooks** installed for clean notebook diffs
- **Initial commit** pushed to GitHub

## Prerequisites

- Python 3.10+
- [GitHub CLI](https://cli.github.com/) (`gh`) — installed and authenticated (`gh auth login`)
- Git configured

## Quick Start

```bash
# Clone this starter repo (once)
git clone https://github.com/YourUsername/nbdev-project-starter.git

# Run the script
./nbdev-project-starter/create-project.sh
```

The script will prompt you for:
- Project name (e.g., `my-analysis`)
- One-line description
- Keywords, visibility (public/private), license
- Parent directory (default: `~/Code`)

Then it does everything else automatically.

## Configuration

Save personal defaults in `~/.nbdev-starter.conf` to skip repeated prompts:

```bash
GITHUB_USERNAME="YourGitHubUsername"
AUTHOR_NAME="Your Name"
AUTHOR_EMAIL="you@users.noreply.github.com"
DEFAULT_LICENSE="Apache-2.0"
DEFAULT_PYTHON_VERSION=">=3.10"
DEFAULT_PARENT_DIR="$HOME/Code"
```

## What the Script Does

1. Checks prerequisites (git, gh, python3)
2. Prompts for project details
3. Creates GitHub repository via `gh`
4. Clones locally, creates virtual environment
5. Installs JupyterLab, nbdev, Quarto
6. Runs `nbdev-new` to scaffold the project
7. Generates `pyproject.toml` from your inputs
8. Copies Cursor rules (with module name substituted)
9. Copies CONTRIBUTING.md, GETTING-STARTED.md, docs (with project details substituted)
10. Installs git hooks (`nbdev-install-hooks`)
11. Installs package in editable mode (`pip install -e '.[dev]'`)
12. Runs `nbdev-prepare`
13. Commits and pushes initial setup

## After Setup

```bash
cd ~/Code/my-project
source venv/bin/activate
jupyter lab
```

**Daily workflow:**
1. Edit notebooks in `nbs/`
2. `nbdev-prepare` before committing
3. `git add . && git commit -m "..." && git push`

**Enable GitHub Pages** (after first CI pass):
Settings → Pages → select `gh-pages` branch

## Conventions Baked In

These conventions are encoded in the Cursor rules, style guide, and contributing docs:

| Convention | Source |
|---|---|
| Notebooks are source of truth; never edit `.py` files | Cursor rule, CONTRIBUTING.md |
| `#\| export`, `#\| hide`, `#\| default_exp` directives | Cursor rule |
| `nbdev-prepare` before every commit | CONTRIBUTING.md |
| Explore → Export → Demo notebook pattern | Cursor rule, style guide |
| Google-style docstrings | Style guide |
| Autoreload in consumer notebooks only | Cursor rule, autoreload doc |
| Descriptive `snake_case`, `UPPER_CASE` constants | Style guide |
| Explicit imports (no `import *`) | Style guide |
| `fastcore.test` for inline testing | CONTRIBUTING.md |

## Manual Setup

If you prefer to set up manually (or the script doesn't fit your situation), see [SETUP-GUIDE.md](SETUP-GUIDE.md) for a complete step-by-step reference.

## Project Structure

```
nbdev-project-starter/
├── create-project.sh              # Main automation script
├── README.md                      # This file
├── SETUP-GUIDE.md                 # Manual setup reference
└── templates/                     # Files copied into new projects
    ├── cursor-rules/
    │   ├── nbdev-workflow.mdc     # Always-on nbdev workflow rules
    │   └── notebook-conventions.mdc  # Notebook-scoped style rules
    ├── CONTRIBUTING.md            # Development workflow guide
    ├── GETTING-STARTED.md         # Quick-reference checklist
    ├── nbdev.yml                  # Quarto configuration
    └── docs/
        ├── notebook-style-guide.md       # Notebook conventions
        ├── autoreload-best-practices.md  # Module reloading guidance
        ├── fastai-info-map.md            # Curated learning resources
        └── decision-template.md          # Template for project decisions
```

## Customization

### Changing template content

Edit files in `templates/` directly. Placeholders use `{{VARIABLE}}` syntax:
- `{{PROJECT_NAME}}` — e.g., `my-project`
- `{{MODULE_NAME}}` — e.g., `my_project`
- `{{GITHUB_USERNAME}}` — e.g., `YourUsername`
- `{{AUTHOR_NAME}}`, `{{AUTHOR_EMAIL}}`, `{{DESCRIPTION}}`

### Adding new templates

Add files to `templates/` and update the "Copy templates" section in `create-project.sh` to include them.

## Resources

- [nbdev Documentation](https://nbdev.fast.ai/)
- [nbdev Tutorial](https://nbdev.fast.ai/tutorials/tutorial.html)
- [nbdev Best Practices](https://nbdev.fast.ai/tutorials/best_practices.html)
- [fastai Style Guide](https://docs.fast.ai/dev/style.html)
- [fastai CONTRIBUTING](https://github.com/fastai/fastai/blob/main/CONTRIBUTING.md)
