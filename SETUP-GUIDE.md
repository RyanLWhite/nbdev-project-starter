# nbdev Project Setup Guide (Manual)

> **This is the manual reference.** For automated setup, use `create-project.sh` instead.

Complete reference for setting up a new nbdev project from scratch, following fastai practices.

**Note:** This guide covers nbdev infrastructure only (venv, tools, `nbdev-new`, `pyproject.toml`, hooks). `create-project.sh` additionally installs Cursor rules, CONTRIBUTING.md, GETTING-STARTED.md, notebook style guide, autoreload docs, and Quarto config. If you follow this manual guide, copy those files from the `templates/` directory afterward, or see the [What the Script Does](README.md#what-the-script-does) section in the README for the full list.

---

## Prerequisites

### Step 1: Create and Activate Virtual Environment

```bash
cd /path/to/your/project
python3 -m venv venv
source venv/bin/activate
```

### Step 2: Install Core Tools

```bash
pip install --upgrade pip
pip install jupyterlab
pip install nbdev
nbdev-install-quarto
pip install jupyterlab-quarto
```

**Critical:** All tools must be installed in the same Python environment.

---

## Initial Setup

### Step 1: Create GitHub Repository

1. Go to https://github.com/new (or use `gh repo create`)
2. Create repo with your desired name (e.g., `my-project`)
3. **Don't** initialize with README, .gitignore, or license if you have a local repo

### Step 2: Connect Local Repo to GitHub

```bash
git remote add origin https://github.com/YourUsername/your-repo.git
git branch -M main
git push -u origin main
```

### Step 3: Initialize nbdev

```bash
nbdev-new --user YourGitHubUsername --author "Your Name"
```

**What this creates:**
- `nbs/` directory with starter notebooks (`index.ipynb`, `00_core.ipynb`)
- `pyproject.toml` configuration file
- `.github/workflows/` for CI/CD
- Python module directory (e.g., `your_project/`)
- Config files (`.gitattributes`, `MANIFEST.in`)

---

## Configuring pyproject.toml

After running `nbdev-new`, review and update `pyproject.toml`:

### Build System

```toml
[build-system]
requires = ["setuptools>=64"]
build-backend = "setuptools.build_meta"
```

Leave as-is.

### Project Metadata

```toml
[project]
name = "my-project"              # pip install name (hyphens)
dynamic = ["version"]            # Leave as-is
description = "What it does"     # Update this
readme = "README.md"             # Leave as-is
requires-python = ">=3.10"       # Adjust if needed
license = {text = "Apache-2.0"}  # Your choice
authors = [{name = "Your Name", email = "you@example.com"}]
keywords = ["nbdev"]             # Add relevant keywords
```

### Project URLs

```toml
[project.urls]
Repository = "https://github.com/YourUsername/your-repo"
Documentation = "https://YourUsername.github.io/your-repo/"
```

### Entry Points and Setuptools

```toml
[project.entry-points.nbdev]
your_module = "your_module._modidx:d"

[tool.setuptools.dynamic]
version = {attr = "your_module.__version__"}

[tool.setuptools.packages.find]
include = ["your_module"]
```

Replace `your_module` with your actual Python module name (underscores, not hyphens).

### nbdev Configuration

```toml
[tool.nbdev]
lib_name = "your_module"
lib_path = "your_module"
doc_path = "_docs"
```

---

## Installing Git Hooks

```bash
nbdev-install-hooks
```

This:
- Strips notebook metadata before commits (cleaner diffs)
- Ensures notebooks and exported .py files stay in sync
- Makes merge conflicts human-readable
- Automatically trusts notebooks in the repo

---

## Naming Conventions

| Type | Format | Example | Used For |
|------|--------|---------|----------|
| **Repo name** | hyphens OK | `my-project` | GitHub URL, folder name |
| **Package name** | hyphens | `my-project` | `pip install` |
| **Module name** | underscores | `my_project` | `import my_project` |

Keep the same base name for all three: `my-project` (repo) → `my-project` (package) → `my_project` (module).

---

## Daily Workflow

### Starting a Work Session

```bash
cd /path/to/your-project
source venv/bin/activate
jupyter lab
```

### Core Commands

| Command | What It Does |
|---------|-------------|
| `nbdev-export` | Export notebooks to .py modules |
| `nbdev-test` | Run all notebook cells as tests |
| `nbdev-clean` | Clean notebook metadata |
| `nbdev-docs` | Build documentation site |
| `nbdev-preview` | Preview docs locally |
| `nbdev-prepare` | Export + test + clean + README |
| `dev-prepare` | Update structure diagram + `nbdev-prepare` (recommended before commits when starter templates are installed) |

### Typical Cycle

1. Edit notebooks in JupyterLab
2. `dev-prepare` (or `nbdev-prepare` if project does not include starter scripts)
3. `git add . && git commit -m "..." && git push`

---

## GitHub Pages Setup

After your first successful CI run:

1. Go to repo Settings → Pages
2. Under "Source", select branch: **`gh-pages`**
3. Save
4. Visit `https://YourUsername.github.io/your-repo/`

---

## Common Issues

### "ModuleNotFoundError: your_module"

Module directory name doesn't match `pyproject.toml`. Rename the directory to match.

### "Detected unstripped out notebooks"

```bash
nbdev-clean
git add nbs/
git commit -m "Clean notebook metadata"
```

Prevention: install git hooks with `nbdev-install-hooks`.

### "Could not infer user from git"

Pass explicitly: `nbdev-new --user YourUsername --author "Your Name"`

### "command not found: nbdev-new"

nbdev commands use **hyphens**, not underscores:
- `nbdev-new` (correct)
- `nbdev_new` (wrong)

---

## First-Time Checklist

- [ ] Create virtual environment and activate
- [ ] Install: pip (upgrade), jupyterlab, nbdev, quarto, jupyterlab-quarto
- [ ] Create GitHub repo
- [ ] Connect local repo to GitHub remote
- [ ] Run `nbdev-new --user YourUsername --author "Your Name"`
- [ ] Review and update `pyproject.toml`
- [ ] Verify module directory name matches `pyproject.toml`
- [ ] Run `nbdev-install-hooks`
- [ ] Run `pip install -e '.[dev]'`
- [ ] Run `dev-prepare` (or `nbdev-prepare` if unavailable)
- [ ] Commit and push initial setup
- [ ] Wait for CI to pass
- [ ] Enable GitHub Pages (Settings → Pages → gh-pages branch)

---

## Resources

- [nbdev Documentation](https://nbdev.fast.ai/)
- [nbdev Tutorial](https://nbdev.fast.ai/tutorials/tutorial.html)
- [nbdev Best Practices](https://nbdev.fast.ai/tutorials/best_practices.html)
- [fastai Style Guide](https://docs.fast.ai/dev/style.html)

---

**Note:** This guide follows nbdev3 conventions — `pyproject.toml` (not `settings.ini`), hyphenated CLI commands, and PEP 621 metadata.
