# fastai / nbdev Information Map

A curated "protege path" for doing nbdev the way Jeremy Howard tends to do it: start with the canonical nbdev workflow docs, then layer in the fastai style/engineering norms, then copy real repos/templates, and finally mine the forum threads where the sharp edges and "why this way?" explanations live.

---

## 1) The core canon (read these first, in order)

### A. nbdev docs (your primary reference)

* **nbdev home + Getting Started** — what nbdev is, how projects are structured, and the baseline commands you'll run constantly (export, test, docs, etc.). ([nbdev][1])
* **End-to-End Walkthrough** — the "from zero to published package" path; great for aligning your repo layout, notebook naming, exports, docs build, and release flow. ([nbdev][2])
* **Notebook Best Practices** — the opinionated "how to notebook" rules that make nbdev actually feel good (narrative + tests + refactors + clean diffs). ([nbdev][3])
* **Pre-commit hooks** — how nbdev expects you to prevent dirty/unexported notebooks from ever landing in git history. ([nbdev][4])

**When you'll reach for these docs**

* "What's the blessed workflow?" → Walkthrough
* "How should I structure notebooks / prose / tests?" → Best Practices
* "How do I keep git diffs clean?" → Pre-commit + Best Practices

---

## 2) "How Jeremy's teams write Python" (style + contribution norms)

### A. fastai style guide (official docs)

* **fastai Style Guide (docs)** — the higher-level "what good looks like" for readability and expressiveness. ([fastai][5])

### B. fastai contributing workflow (practical norms)

* **fastai CONTRIBUTING** — concrete repo hygiene expectations (including nbdev hooks) and how they want changes prepared. ([GitHub][6])
* **How to contribute to fastai (forum wiki)** — a more narrative "here's how we do open source development" guide. ([fast.ai Course Forums][7])

### C. "Style guide now available" (historical but culturally useful)

* **Forum post: fastai style guide (Part 1)** — older, but helpful for understanding the *taste* behind fastai code, not just the rules. ([fast.ai Course Forums][8])

**What to extract from these**

* Naming conventions, readability bias, "simple > clever" heuristics
* PR hygiene habits: hooks, tests, doc updates, minimal diffs

---

## 3) Templates + editor tooling (copy the scaffolding)

### A. The "do it like fastai does it" starting point

* **nbdev_template** — repo skeleton (configs, layout, CI patterns). If you're trying to replicate the house style, this is the fastest route.

### B. Editor workflow support

* **nbdev-vscode** — improves the nbdev workflow in Visual Studio Code (helpful if you split time between notebooks and an editor).

---

## 4) Jeremy's "why nbdev" essay (the mental model)

* **"nbdev + Quarto: A new secret weapon for productivity"** — the philosophical + practical pitch: why notebooks, why this workflow, how it changes iteration speed and quality.

(If you want to be a *protege*, don't just learn the commands — internalize the argument for the workflow.)

---

## 5) Video walkthroughs (watch someone do the workflow end-to-end)

* **nbdev tutorial (YouTube)** — "from scratch" project build; great for seeing the cadence: write → test in-notebook → export → docs → clean. ([YouTube][9])
* **nbdev tutorial: zero to published project in ~90 minutes (YouTube)** — similar goal, slightly different presentation. ([YouTube][10])

---

## 6) Community threads (sharp edges + tradeoffs)

These are "what you'll google at 1am" resources — worth bookmarking.

* **Exploratory notebooks best practice (forum, includes Jeremy replies)** — how to handle exploration vs library notebooks without wrecking structure. ([fast.ai Course Forums][11])
* **nbdev-extensions announcement (forum)** — shows the broader ecosystem and how power users smooth out workflow friction.
* **Formatting / linting with black/isort/mypy, etc. (forum how-to)** — how people reconcile nbdev's approach with external linters/formatters. ([fast.ai Course Forums][12])
* **Black formatter hook discussion (forum)** — specifically on integrating formatting into build flows. ([fast.ai Course Forums][13])

---

## 7) "Apprenticeship by immersion": read real codebases

The fastest learning is **reading the repos that embody the style**:

* **fastai repo** — large, mature codebase with the cultural norms in full force. ([GitHub][14])
* **nbdev itself** (and sibling fastai org repos) — smaller, more directly tied to the tooling decisions you're adopting. ([nbdev][1])

---

## Practical routing guide

1. **Workflow/how-to** → nbdev Walkthrough + Getting Started ([nbdev][2])
2. **Notebook structure & habits** → Notebook Best Practices ([nbdev][3])
3. **Repo hygiene (clean diffs, hooks)** → Pre-commit hooks + fastai CONTRIBUTING ([nbdev][4])
4. **Style/readability questions** → fastai Style Guide ([fastai][5])
5. **"How do people do X in practice?"** → forum threads ([fast.ai Course Forums][11])
6. **"What would Jeremy do?"** → read the template + skim fastai source ([GitHub][14])


[1]: https://nbdev.fast.ai/getting_started.html "Getting Started - nbdev - Fast.ai"
[2]: https://nbdev.fast.ai/tutorials/tutorial.html "End-To-End Walkthrough - nbdev"
[3]: https://nbdev.fast.ai/tutorials/best_practices.html "Notebook Best Practices - nbdev - Fast.ai"
[4]: https://nbdev.fast.ai/tutorials/pre_commit.html "Pre-Commit Hooks - nbdev - Fast.ai"
[5]: https://docs.fast.ai/dev/style.html "fastai coding style"
[6]: https://github.com/fastai/fastai/blob/main/CONTRIBUTING.md "fastai/CONTRIBUTING.md at main"
[7]: https://forums.fast.ai/t/how-to-contribute-to-fastai/37828 "How to contribute to fastai"
[8]: https://forums.fast.ai/t/fastai-style-guide-now-available/14009 "Fastai style guide now available - Part 1 (2018)"
[9]: https://www.youtube.com/watch?v=67FdzLSt4aA "nbdev tutorial (sped up)"
[10]: https://www.youtube.com/watch?v=l7zS8Ld4_iA "nbdev tutorial -- zero to published project in 90 minutes"
[11]: https://forums.fast.ai/t/nbdev-best-practice-for-exploratory-notebooks/98205 "Nbdev best practice for exploratory notebooks"
[12]: https://forums.fast.ai/t/howto-add-formating-and-linting-to-nbdev-black-isort-mypy-flake8-pylint/102743 "add formating and linting to nbdev"
[13]: https://forums.fast.ai/t/nbdev-build-hook-for-black-code-formatter/87114 "Nbdev_build hook for black code formatter"
[14]: https://github.com/fastai/fastai "The fastai deep learning library"
