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
- **Export to Python** — notebooks export to Python modules via `#|export` directive
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
nbdev-prepare
```

This does four things:
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

```
{{PROJECT_NAME}}/
├── nbs/                    # Notebooks (source of truth)
│   ├── index.ipynb        # Project overview → becomes README.md
│   ├── 00_core.ipynb      # Core utilities
│   └── ...                # Other notebooks
├── {{MODULE_NAME}}/       # Exported Python modules (auto-generated)
│   ├── core.py           # From 00_core.ipynb
│   └── ...
├── docs/                  # Documentation and guides
└── scripts/               # Automation scripts (if any)
```

## Notebook Conventions

### Export Directive

Mark cells to be exported to Python modules:

```python
#|export
def my_function():
    """This will be exported to the Python module."""
    return "Hello"
```

### Hide Exploratory Code

Hide cells that shouldn't appear in docs:

```python
#|hide
print("Debug info")
```

### Test Inline

Use assertions to test your code:

```python
#|export
def add(a, b):
    return a + b

# Test (this cell doesn't get exported)
assert add(2, 3) == 5
from fastcore.test import test_eq
test_eq(add(10, 20), 30)
```

### Document as You Code

Add markdown cells explaining what your code does. These become documentation!

For the full notebook style guide, see [docs/notebook-style-guide.md](docs/notebook-style-guide.md).

## Common Tasks

| Task | Command |
|------|---------|
| Export notebooks to .py | `nbdev-export` |
| Run all tests | `nbdev-test` |
| Clean notebook metadata | `nbdev-clean` |
| Preview documentation | `nbdev-preview` |
| Full prepare (before commit) | `nbdev-prepare` |

## Troubleshooting

### "ModuleNotFoundError: {{MODULE_NAME}}"

```bash
pip install -e '.[dev]'
```

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
nbdev-prepare
```

## Resources

- [nbdev Documentation](https://nbdev.fast.ai/)
- [nbdev Tutorial](https://nbdev.fast.ai/tutorials/tutorial.html)
- [nbdev Best Practices](https://nbdev.fast.ai/tutorials/best_practices.html)
- [fastai Style Guide](https://docs.fast.ai/dev/style.html)
- [Notebook Style Guide](docs/notebook-style-guide.md)
