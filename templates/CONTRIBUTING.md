# Contributing to {{PROJECT_NAME}}

> **This is the SOURCE OF TRUTH for development workflow.**
> Other files ([GETTING-STARTED.md](GETTING-STARTED.md), [README.md](README.md)) reference this document.

This project follows the **nbdev workflow** and **fastai practices** for development.

## Quick Start

### First Time Setup

```bash
# 1. Clone the repository
git clone https://github.com/{{GITHUB_USERNAME}}/{{PROJECT_NAME}}.git
cd {{PROJECT_NAME}}

# 2. Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate  # Do this every time you work on the project

# 3. Install in development mode
pip install -e '.[dev]'

# 4. Install git hooks for clean notebooks
nbdev-install-hooks

# 5. Start JupyterLab
jupyter lab
```

### Every Work Session

**Always activate the virtual environment first:**

```bash
cd /path/to/{{PROJECT_NAME}}
source venv/bin/activate  # You'll see (venv) in your prompt
```

## Development Philosophy

This project strictly follows the **nbdev way** and **fastai practices**:

- **Notebooks are source of truth** — all code lives in `nbs/` notebooks, not `.py` files
- **Tests are in notebooks** — every code cell is a test unless marked otherwise
- **Documentation is in notebooks** — notebooks generate both code and docs
- **Export to Python** — notebooks export to Python modules via `#| export` directive
- **Autoreload** — consumer/orchestrator notebooks use `%autoreload 2`

**Key principle:** Edit notebooks, never edit the exported `.py` files directly!

## The nbdev Workflow

### 1. Make Changes in Notebooks

Edit notebooks in `nbs/` directory using JupyterLab:

```bash
jupyter lab
```

### 2. Before Committing

**Always run:**

```bash
dev-prepare
```

This updates the project structure diagram, then runs `nbdev-prepare` which:
1. **Export** — converts notebooks to Python modules
2. **Test** — runs all code cells as tests
3. **Clean** — strips notebook metadata
4. **README** — updates README.md from index.ipynb

### 3. Commit and Push

```bash
git add .
git commit -m "Description of changes"
git push
```

GitHub Actions will automatically run tests, build documentation, and deploy to GitHub Pages.

## Project Structure

<!-- PROJECT-STRUCTURE-START -->
```
{{PROJECT_NAME}}/
├── .github/
│   └── workflows/                      # CI/CD
│       ├── deploy.yaml
│       └── test.yaml
├── {{MODULE_NAME}}/                    # Exported Python modules (auto-generated)
│   ├── __init__.py
│   ├── _modidx.py
│   └── core.py
├── docs/                               # Documentation and guides
│   ├── autoreload-best-practices.md
│   ├── decision-template.md
│   ├── fastai-info-map.md
│   └── notebook-style-guide.md
├── nbs/                                # Notebooks (source of truth)
│   ├── 00_core.ipynb                   # Core utilities
│   ├── _quarto.yml
│   ├── index.ipynb                     # Project overview → becomes README.md
│   ├── nbdev.yml
│   └── styles.css
├── scripts/
│   ├── __init__.py
│   ├── prepare.py
│   └── project_map.py
├── .gitattributes
├── .gitconfig
├── .gitignore
├── CONTRIBUTING.md                     # Development workflow (source of truth)
├── GETTING-STARTED.md
├── LICENSE
├── MANIFEST.in
├── README.md                           # Auto-generated from nbs/index.ipynb
├── project-structure.yml
└── pyproject.toml                      # Project config and dependencies
```
<!-- PROJECT-STRUCTURE-END -->

## Notebook Conventions

The key directives: `#| export` (send to module), `#| hide` (run but hide from docs), `#| default_exp module_name` (declare target module). Cells with no directive appear in docs but aren't exported — use these for examples and tests.

Each function has its own section in the notebook marked by a level 2 header (`## \`function_name\``). The section serves as a self-contained R&D laboratory for that function — all the context needed to understand, modify, and validate it lives together. The function section follows the **Explore → Define → Examples → Tests** pattern:

- **Explore** — inspect data, test approaches, build understanding
- **Define** — the `#| export` cell with short docstring and docments-style parameters
- **Examples** — executable cells that show behavior (replaces verbose docstrings)
- **Tests** — inline assertions with `test_eq`, `test_fail`, and `assert`

For the full style guide, see [docs/notebook-style-guide.md](docs/notebook-style-guide.md).

## Common Tasks

| Task | Command |
|------|---------|
| Full prepare (before commit) | `dev-prepare` |
| Export notebooks to .py | `nbdev-export` |
| Run all tests | `nbdev-test` |
| Clean notebook metadata | `nbdev-clean` |
| Build documentation | `nbdev-docs` |
| Preview documentation | `nbdev-preview` |
| Update structure diagram only | `python scripts/project_map.py update` |
| Check structure diagram is current | `python scripts/project_map.py check` |

## Troubleshooting

### "ModuleNotFoundError: {{MODULE_NAME}}"

Most common cause — package not installed in editable mode:
```bash
pip install -e '.[dev]'
```

If that doesn't help, the module directory name may not match `pyproject.toml`. Verify the directory `{{MODULE_NAME}}/` exists and matches the `lib_name` / `lib_path` in `pyproject.toml`.

### "command not found: nbdev-*"

```bash
source venv/bin/activate
```

### Git Hooks Not Working

```bash
nbdev-install-hooks
```

### Tests Failing Locally

```bash
nbdev-test
```

### README Changes Not Showing Up

**Never edit `README.md` directly.** Edit `nbs/index.ipynb` instead, then run:

```bash
dev-prepare
```

## Resources

- [nbdev Documentation](https://nbdev.fast.ai/)
- [nbdev Tutorial](https://nbdev.fast.ai/tutorials/tutorial.html)
- [nbdev Best Practices](https://nbdev.fast.ai/tutorials/best_practices.html)
- [fastai Style Guide](https://docs.fast.ai/dev/style.html)
- [Notebook Style Guide](docs/notebook-style-guide.md)
