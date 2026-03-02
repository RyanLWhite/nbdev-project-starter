# Getting Started with {{PROJECT_NAME}}

Quick reference for developers.

## Checklist

- [ ] Read [README.md](README.md) — understand what this project does
- [ ] Read [CONTRIBUTING.md](CONTRIBUTING.md) — learn the nbdev workflow
- [ ] Set up development environment (below)

## Quick Setup

**Full details:** See [CONTRIBUTING.md](CONTRIBUTING.md#first-time-setup)

```bash
git clone https://github.com/{{GITHUB_USERNAME}}/{{PROJECT_NAME}}.git
cd {{PROJECT_NAME}}
python3 -m venv venv
source venv/bin/activate
pip install -e '.[dev]'
nbdev-install-hooks
```

## Daily Workflow

**Full details:** See [CONTRIBUTING.md](CONTRIBUTING.md#the-nbdev-workflow)

```bash
source venv/bin/activate  # Every time!
jupyter lab               # Edit notebooks
nbdev-prepare            # Before committing
git add . && git commit -m "..." && git push
```

## Key Resources

| Document | Purpose |
|----------|---------|
| [GETTING-STARTED.md](GETTING-STARTED.md) | Quick checklist (this file) |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Development workflow (source of truth) |
| [README.md](README.md) | Project overview |
| [docs/notebook-style-guide.md](docs/notebook-style-guide.md) | Notebook conventions |
| [docs/autoreload-best-practices.md](docs/autoreload-best-practices.md) | Module reloading guidance |

## Reminders

1. **Always activate venv first:** `source venv/bin/activate`
2. **Never edit `.py` files** — edit notebooks instead
3. **Never edit README.md** — edit `nbs/index.ipynb` instead
4. **Run `nbdev-prepare` before every commit**

## Common Issues

| Problem | Quick Fix |
|---------|-----------|
| `command not found: nbdev-*` | `source venv/bin/activate` |
| `ModuleNotFoundError` | `pip install -e '.[dev]'` |
| Tests failing | `nbdev-test` to see errors |
| README not updating | Edit `nbs/index.ipynb`, not README.md |

## Learn More

- [CONTRIBUTING.md](CONTRIBUTING.md) — full workflow guide
- [nbdev docs](https://nbdev.fast.ai/)
- [fastai style guide](https://docs.fast.ai/dev/style.html)
