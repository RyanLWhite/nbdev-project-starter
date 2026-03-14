# Notebook Style Guide

> Show, don't tell — every function gets a little R&D laboratory

This project uses [nbdev](https://nbdev.fast.ai/), where notebooks are the single source of truth for code, docs, and tests. Our conventions follow the [nbdev best practices](https://nbdev.fast.ai/tutorials/best_practices.html) with one key structural addition: every exported function is developed through a fixed sequence of sections.

## The Function Section Pattern

Each exported function gets its own H2 section. Within that section, four subsections appear in order:

```
## `function_name`

### Explore

### Define

### Examples

### Tests
```

This is the heart of the style guide. Everything else supports it.

### Explore

The spin-up section. Build understanding before writing the function.

- Inspect inputs, data shapes, edge cases
- Try out APIs, libraries, approaches
- Prototype logic incrementally in short cells
- No `#| export` — this is scratch work that becomes documentation

Explore cells answer the question: *what do I need to know before I can write this function?*

### Define

The exported function definition. One cell, one function.

```python
#| export
def function_name(
    text:str,        # The input text to process
    normalize:bool=True  # Apply Unicode normalization?
) -> str:            # The processed text
    "Process `text` for downstream use."
    ...
```

Key conventions for the definition:

- **Short docstring** — a single line is usually enough. Elaborate in Examples, not here.
- **Docments** — document parameters with inline comments directly on the signature. nbdev renders these into a clean parameter table automatically. No Args/Returns/Raises sections needed.
- **Type annotations** — use them on every parameter and the return value.

### Examples

Everything that would normally live in a docstring goes here instead — as executable cells with real outputs. This is the biggest advantage of developing in notebooks: instead of pasting code into plaintext, you run it.

- Start with basic usage, then cover each parameter
- Show real inputs and outputs
- Include plots, tables, printed output — whatever makes the behavior clear
- Use markdown cells between code cells to explain non-obvious behavior
- Reference related functions with backtick-doclinks (e.g., `` `other_function` ``)

### Tests

Validate the function with inline assertions. Every code cell in nbdev runs as a test, so assertions here are real CI checks.

```python
from fastcore.test import test_eq, test_fail

test_eq(function_name("hello"), "hello")
test_eq(function_name("café", normalize=True), "café")
```

- Use `test_eq` for equality checks — it prints both sides on failure
- Use `test_fail` to document error cases with real failing code
- Use plain `assert` when `test_eq` doesn't fit
- Keep each cell focused on one aspect of behavior

## Notebook-Level Structure

### Title and Subtitle

Every notebook starts with an H1 title and a blockquote subtitle:

```markdown
# Module Name

> One-line description of what this module does
```

### Module Declaration

```python
#| default_exp module_name
```

### Imports

Hidden imports first, then exported imports:

```python
#| hide
from nbdev.showdoc import *
```

```python
#| export
from pathlib import Path
import numpy as np
```

### Function Sections

The body of the notebook is a sequence of function sections following the Explore → Define → Examples → Tests pattern described above.

### Closing

End with `nbdev_export()` if needed, and optionally a brief summary of what the module provides.

## Docstring and Parameter Style

Follow the [docments](https://fastcore.fast.ai/docments.html) convention. Parameters are documented with inline comments on the signature itself:

```python
#| export
def draw_n(
    n:int,             # Number of cards to draw
    replace:bool=True  # Draw with replacement?
) -> list:             # List of cards
    "Draw `n` cards."
    ...
```

This single-line docstring plus inline docments is all you need. nbdev generates the parameter table for docs automatically. Put the detailed explanations in the Examples section where you can actually *run* them.

## What to Export

Export functions that are reused across notebooks, well-tested, and conceptually complete. Do **not** export one-off exploration, ad-hoc inspection, debugging cells, or prototypes.

## Testing Philosophy

Every code cell runs as a test during `nbdev_test`. Use this to your advantage:

- **Examples are tests.** Add assertions to your example cells when it doesn't hurt readability.
- **Error cases are tests.** Use `test_fail` instead of prose descriptions of what raises.
- **The Tests section is for focused validation** — edge cases, boundary conditions, type checking — that doesn't belong in the narrative flow of Examples.

## Directives Quick Reference

| Directive | Effect |
|-----------|--------|
| `#\| default_exp module_name` | Declares the target module |
| `#\| export` | Exports the cell to the module |
| `#\| hide` | Runs the cell but hides it from docs |
| `#\| eval: false` | Skips execution during `nbdev_test` |
| No directive | Appears in docs, not exported |

## References

- [nbdev Best Practices](https://nbdev.fast.ai/tutorials/best_practices.html) — the annotated `numpy.all` example is the gold standard
- [fastcore.docments](https://fastcore.fast.ai/docments.html) — parameter documentation style
- [fastcore.test](https://fastcore.fast.ai/test.html) — `test_eq`, `test_fail`, and friends
- [fastai Coding Style](https://docs.fast.ai/dev/style.html) — brevity, horizontal alignment, expository programming
