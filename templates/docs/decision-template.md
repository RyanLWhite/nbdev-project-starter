# nbdev Decisions for [Project Name]

**Created:** [date]
**Purpose:** Document how this project uses nbdev — what we export, how we organize notebooks, and why.

---

## Context

<!-- Describe your project type and how it relates to nbdev:
     - Is this a reusable library? A data pipeline? An application?
     - What makes your use case different from the typical nbdev tutorial project?
     - Why is nbdev a good fit despite those differences? -->

---

## Decisions

### 1. Notebook Organization

**Decision:** [How you'll number and group notebooks]

**Rationale:** [Why this organization makes sense for your project]

**Structure:**
```
nbs/
├── 00_core.ipynb          # Core utilities
├── 01_[module].ipynb      # ...
├── index.ipynb            # Project overview
```

### 2. What to Export vs. Keep Notebook-Only

**Decision:** Export functions that are:
1. Reused across multiple notebooks
2. Well-tested and stable
3. Conceptually complete (do one thing well)

**Don't export:**
- One-off exploration code
- Ad-hoc data inspection
- Debugging cells
- Prototype versions (until they stabilize)

### 3. Testing Strategy

**Decision:** [Your approach to testing]

<!-- Options to consider:
     - Inline assertions after function definitions
     - Example-based tests (demonstrate usage while validating)
     - Data validation tests (check integrity of outputs)
     - fastcore.test functions (test_eq, test_fail, etc.)
     - Skipping notebooks that require external data: skip_exec: true -->

### 4. Documentation Strategy

**Decision:** [Generate docs? Keep private? Use Quarto features?]

<!-- Even private projects benefit from generated docs:
     - Serves as a decision log for future-you
     - Documents the "why" behind decisions
     - Shows example inputs/outputs
     - No extra work (generated from notebooks) -->

### 5. Data and Configuration

**Decision:** [How you handle data paths, config, secrets]

<!-- Common patterns:
     - Constants in 00_core.ipynb for paths
     - Data stored outside repo, referenced via paths
     - Environment variables for secrets
     - .gitignore for data directories -->

### 6. Git Workflow

**Decision:** Use nbdev's git hooks. Commit both notebooks and exported .py files.

**`.gitignore` should exclude:**
- `_docs/`
- `_proc/`
- `.ipynb_checkpoints/`
- `__pycache__/`
- `venv/`
- [project-specific exclusions: data directories, etc.]

---

## References

- [nbdev Best Practices](https://nbdev.fast.ai/tutorials/best_practices.html)
- [nbdev Walkthrough](https://nbdev.fast.ai/tutorials/tutorial.html)
- [fastai Style Guide](https://docs.fast.ai/dev/style.html)
- [Forum: Exploratory notebooks best practice](https://forums.fast.ai/t/nbdev-best-practice-for-exploratory-notebooks/98205)
