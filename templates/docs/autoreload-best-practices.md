# Module Reloading in nbdev: Best Practices

## The Problem

When developing with nbdev, you export notebook cells to Python modules using `nbdev-export`. However, Jupyter's Python kernel caches compiled bytecode (`.pyc` files) in `__pycache__/` directories and keeps modules loaded in memory. This means changes you make and export don't take effect until you restart the kernel.

### Symptoms
- Code changes don't appear after running `nbdev-export`
- Functions behave like old versions even after editing
- Silent failures (e.g., file operations appear successful but files aren't actually created)
- Need to manually delete `__pycache__` and restart kernel repeatedly

## The Solution: Use `%autoreload`

This is the **standard nbdev/fastai practice** for consumer notebooks:

```python
%load_ext autoreload
%autoreload 2
```

### What It Does
- **`%autoreload 2`**: Automatically reloads all modules before executing each code cell
- Eliminates the need to restart the kernel after `nbdev-export`
- Standard IPython extension, widely used in the nbdev/fastai ecosystem

### When to Use It

**Use autoreload in notebooks that import your library modules:**
- Orchestrator notebooks that import and run pipeline steps
- Development/testing notebooks
- Exploratory notebooks that import from your library

**Do NOT use autoreload in library notebooks:**
- Notebooks that primarily *define* exported code (e.g., `00_core.ipynb`)
- These notebooks define functions — they don't import them from other modules
- Adding autoreload here is harmless but unnecessary

This follows Jeremy Howard's published guidance: enable `%autoreload 2` in notebooks that are *consumers* of your package, not in notebooks that merely define/export code.

## Alternative: Manual Cache Clearing

If autoreload isn't working or you need a completely fresh start:

```bash
# Delete cache files
rm -rf your_module/__pycache__

# Then restart the Jupyter kernel
```

Autoreload makes this largely unnecessary in practice.

## References

- [IPython autoreload extension](https://ipython.readthedocs.io/en/stable/config/extensions/autoreload.html)
- [nbdev Best Practices](https://nbdev.fast.ai/tutorials/best_practices.html)
- [fastai Style Guide](https://docs.fast.ai/dev/style.html)

## Key Takeaway

**Use `%autoreload 2` in consumer/orchestrator notebooks.** This is the standard nbdev/fastai practice and prevents the subtle, frustrating bugs caused by stale module caches.
