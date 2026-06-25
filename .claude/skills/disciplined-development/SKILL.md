---
name: disciplined-development
description: >-
  Language- and layout-agnostic disciplined workflow for code changes and program
  analysis: proportional-engineering assessment first, docs-before-code, doc-code
  consistency verification, and concise test creation without execution. Discovers
  project conventions from repository guidance files rather than hardcoded paths.
  Use whenever the user asks to modify code, refactor, add features, fix bugs,
  optimize, or analyze any module — even if the request sounds simple. Also use
  when the user says "check", "analyze", "modify", "change", "refactor", "optimize",
  "implement", or describes a desired outcome for existing code.
---

# Disciplined Development Workflow

A fixed sequence for every code change. Skip steps only when explicitly justified.

**Scope:** language-, framework-, and repository-layout-agnostic. Discover where docs, tests, and conventions live from the project itself — never assume a fixed directory tree or toolchain.

---

## Phase 0: Proportional Engineering Assessment

Before writing or modifying any code, apply **proportional-engineering** principles (see `@proportional-engineering` when available):

1. **Evidence before change** — what concrete evidence (error, bug report, test failure, observed behavior) justifies this change?
2. **Reuse before build** — does existing code already solve this? Search the codebase first.
3. **Prefer deletion over addition** — can the problem be solved by removing code, simplifying, or removing a layer?
4. **Build only what exists today** — no future-proofing, no speculative abstractions, no patterns without a concrete problem.
5. **Stop when the goal is met** — once the requested behavior is verified, stop.

State your assessment briefly before proceeding.

---

## Phase 1: Documentation First (docs-before-code)

### Discover where documentation lives

Before editing code, locate the project's documentation conventions:

1. **READ** repository guidance files, in order of precedence when present:
   - root agent/readme files (`CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md`, `README.md`)
   - any documented "module docs" or architecture section they point to
2. **SEARCH** for docs that describe the target module or feature (by name, path, or responsibility — not a assumed folder name).
3. If the project defines a canonical doc location in those files, **follow that**; do not invent a parallel doc tree.

### If documentation exists

- **READ** the module's existing docs.
- **UPDATE** them to reflect the **target state** (what the module *should* do after changes). This becomes the specification for code changes.

### If documentation is missing

- Create **minimal** docs proportional to module complexity: purpose, inputs, outputs, key public surface (functions, types, endpoints, CLI, etc.).
- Place them where the project already keeps module or feature documentation; if none is defined, prefer the location implied by sibling modules or repository guidance.
- For very small units (roughly fewer than five related files), a concise doc block at the top of the primary source file is acceptable **only when** the project does not require separate module docs.

Docs describe **what** the unit does, not **how** every line works.

---

## Phase 2: Code Modification

```
1. READ   relevant source to understand current behavior
2. PLAN   the minimal set of changes that achieve the goal
3. MODIFY — each change must trace to one of:
           - a doc specification (Phase 1)
           - a concrete problem statement
           - a test case
4. VERIFY module boundaries remain intact:
           - language-appropriate dependency/reference graph not broken
           - public contracts (signatures, exports, APIs) still coherent
```

Match existing code style, naming, and layering in the files you touch.

---

## Phase 3: Documentation-Code Consistency Check

After code changes are complete:

```
1. COMPARE docs vs actual code:
   - Public surface (signatures, types, endpoints, config) matches docs?
   - Responsibilities and boundaries match docs?
   - Architecture or flow descriptions match reality?
2. If INCONSISTENT:
   → Is the code correct but docs outdated? OR is the code wrong?
   → The END GOAL decides which to fix:
     - Code achieves the goal but differs from docs → update docs
     - Code does NOT achieve the goal → fix code to match docs (the spec)
3. UPDATE either docs or code to restore consistency
```

**Docs are the specification; code is the implementation.** When they diverge, the end goal decides which was right.

---

## Phase 4: Test Creation (write only, do not execute)

### Discover test conventions

Before writing tests, infer from the repository (do not assume a framework):

1. **READ** project guidance and manifest files for test commands and layout (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `pom.xml`, `Makefile`, CI config, etc.).
2. **LOCATE** existing tests for the same area; mirror their directory, naming, and runner.
3. **REUSE** shared setup (fixtures, helpers, base classes, test containers) already in the repo.

### What to write

```
1. IDENTIFY test-worthy changes:
   - New validation or business logic → add tests
   - Bug fix → add reproduction test
   - Refactor with unchanged behavior → existing tests usually suffice
2. WRITE tests that are:
   - Concise: proportional to the change (~10 lines → 0–2 tests; ~100 lines of core logic → focused P0–P2 set)
   - Behavioral: assert input → output; avoid tests that only verify call counts or private structure
   - Named for the scenario under test, not implementation details
   - Mocking: only at true external boundaries (network, filesystem, clock, third-party services) when the project already does so; do not mock internal units by default
   - Deduplicated: prefer parametrized or table-driven cases over near-duplicate empty/null/blank clones
3. DO NOT execute tests — the user or CI runs them
```

Align async/sync, isolation, and assertion style with neighboring tests in the same package.

---

## Quick Reference

| Phase | Action | Question to answer |
|-------|--------|-------------------|
| 0 | Proportional-engineering check | Does this change justify its cost? |
| 1 | Docs first | What should this unit do after the change? Where does this repo document it? |
| 2 | Code | What is the minimal change to achieve that? |
| 3 | Consistency | Do docs and code agree? If not, which is right? |
| 4 | Tests | What test proves this works (using this repo's test stack)? |

---

## Repository overrides

When working in a repository that defines stricter or more specific conventions, **those override generic discovery** for that repo only.

In **AI-SEO-Agent**, see root `CLAUDE.md` (workflow section, `docs/modules/`, `app/tests/`, pytest). On conflict with a user instruction in the current turn, follow the user.
