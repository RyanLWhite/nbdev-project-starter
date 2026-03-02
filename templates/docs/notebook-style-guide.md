# Notebook Style Guide

> Conventions for writing nbdev notebooks in this project

## Overview

Notebooks serve three purposes:
1. **Documentation** — explaining concepts and approaches
2. **Implementation** — containing the actual source code (with `#| export`)
3. **Testing** — demonstrating and validating functionality

## Notebook Structure

### 1. Header Cell (Markdown)

```markdown
# Module Name

> Brief one-line description of what this module does

Additional context about the module's purpose, key features, or important notes.
```

### 2. Module Declaration

```python
#| default_exp module_name
```

This tells nbdev which module to export to (e.g., `{{MODULE_NAME}}.module_name`).

### 3. Imports

```python
#| hide
from nbdev.showdoc import *
```

Then export block:

```python
#| export
from pathlib import Path
import pandas as pd
# ... other imports
```

### 4. Implementation Sections

Each major section follows a consistent pattern:

```
## Section Title

Brief description of what this section accomplishes.

### 🔍 Explore: [What we're exploring]
[Exploration cells that inspect data, test ideas, build understanding]

### 🔍 Explore: [Build the function_name()]
[Final exploration before implementation]

[#| export function definition]

### ✅ Demo: [What we're testing]
[Demo cells that test the function]
```

## Cell Types and Labels

Each function will have multiple cell types dedicated to it, so that this section of the notebook is a little R&D laboratory for the function.

### Exploration Cells: `### 🔍 Explore:`

**Purpose**: Inspect data, test ideas, and build understanding before implementing

**When to use**:
- Examining raw data structure
- Testing an approach or API
- Understanding edge cases
- Building up logic incrementally
- Experimenting with different approaches

**Characteristics**:
- Come *before* the functionality they support
- May contain temporary/experimental code
- Focus on investigation and learning
- No `#| export` directive

**Examples**:
```markdown
### 🔍 Explore: Understand the input format

### 🔍 Explore: Test the parsing approach

### 🔍 Explore: Build the process_data() function
```

The "Build the..." variant indicates we're about to define the exported function.

### Demo Cells: `### ✅ Demo:`

**Purpose**: Test and validate exported functions

**When to use**:
- Testing a newly defined function
- Showing example usage
- Validating edge cases
- Demonstrating filters or parameters

**Characteristics**:
- Come *after* the function definition
- Call the exported function(s)
- Show expected output
- May include assertions or comparisons
- No `#| export` directive

**Examples**:
```markdown
### ✅ Demo: Test process_data()

### ✅ Demo: Test with edge cases

### ✅ Demo: Visual demonstration of output
```

### Export Cells: `#| export`

**Purpose**: Define production code that will be exported to the module

**Characteristics**:
- Include `#| export` directive at the top
- Contain complete, production-ready functions
- Include comprehensive docstrings
- Follow the exploration cells that led to them
- Come before the demo cells that test them

## Section Organization Pattern

Follow this pattern for each feature/function:

```
## N. Feature Name

Brief description

### 🔍 Explore: Understand the problem
[Investigation cell(s)]

### 🔍 Explore: Test the approach
[More investigation cells as needed]

### 🔍 Explore: Build the function_name()
[Final exploration showing the logic]

[#| export function definition with full docstring]

### ✅ Demo: Test function_name()
[Basic test]

### ✅ Demo: Test with edge cases
[Additional tests as needed]
```

## Docstring Style

Use Google-style docstrings with clear sections:

```python
def function_name(arg1, arg2, optional_arg=None):
    """
    Brief one-line description.

    Longer description with more context, explaining what the function does,
    why it exists, and any important notes about its behavior.

    Args:
        arg1: Description of arg1
        arg2: Description of arg2
        optional_arg: Description of optional_arg (default: None)

    Returns:
        Description of what's returned

    Raises:
        ValueError: When this specific error occurs

    Note:
        Important notes, caveats, or usage guidance
    """
```

## Code Style

### Imports
- Group imports: standard library, third-party, local
- Use explicit imports (not `import *`)
- Import only what you need

### Configuration
- Extract magic values to constants (e.g., `MAX_RETRIES = 3`)
- Put reusable helpers in `core.ipynb` when used across multiple notebooks
- Use helper functions for recurring patterns

### Variable Naming
- Use descriptive names: `processed_items` not `pi`
- Use `snake_case` for functions and variables
- Use `UPPER_CASE` for constants

### General
- Comments explain *why*, not *what*
- Keep functions focused — one function, one job
- Use `pathlib.Path` for file paths
- Use f-strings for formatting

## Testing in Notebooks

### Demonstration Tests
- Use exploration cells to understand edge cases
- Use demo cells to validate the exported function
- Show both successful cases and filtered results
- Include visual output (DataFrames, printed values)

### Inline Assertions

```python
result = my_function(sample_input)
assert len(result) > 0, "Expected non-empty result"

from fastcore.test import test_eq
test_eq(my_function(2, 3), 5)
```

## Summary Cell

End with a summary markdown cell:

```markdown
## Summary and Next Steps

### Completed
- Feature 1
- Feature 2

### Remaining
- Next feature

### Next Steps
Brief description of what comes next.
```

## Markdown Headers

- `#` — notebook title (once)
- `##` — major sections (numbered: "1. Feature Name")
- `###` — cell labels (🔍 Explore: / ✅ Demo:)
- `####` — sub-sections within exploration (use sparingly)

## Anti-Patterns to Avoid

- **Don't** use generic comments like "# Test function" → **Do** use labeled headers: "### ✅ Demo: Test process_data()"
- **Don't** mix exploration and production code in one cell → **Do** separate exploration cells from `#| export` cells
- **Don't** leave magic strings scattered through code → **Do** extract to constants
- **Don't** create new notebooks/modules without considering cohesion → **Do** group related functionality in the same module

## Relationship to fastai Style Guide

This guide complements the [fastai coding style guide](https://docs.fast.ai/dev/style.html). Shared principles:

- **Brevity facilitates reasoning** — keep concepts on one screen when possible
- **Expository programming** — notebooks support experimentation and explanation
- **Comments explain WHY not WHAT** — clear code over verbose comments
- **One line = one idea** — compact layouts for conceptually related code

What we adopt from fastai:
- ~160 character line width
- Horizontal alignment for similar operations
- Modern Python features (comprehensions, f-strings, pathlib)
- Vertical space economy for related code

## References

- [fastai Coding Style Guide](https://docs.fast.ai/dev/style.html)
- [nbdev Documentation](https://nbdev.fast.ai/)
- [nbdev Best Practices](https://nbdev.fast.ai/tutorials/best_practices.html)
- [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html) — docstring format reference
