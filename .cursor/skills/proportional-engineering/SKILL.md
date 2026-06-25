---
name: proportional-engineering
description: >-
  Staff-engineer-style proportional engineering for AI coding agents: evidence-first
  changes, reuse and deletion over addition, no speculative architecture or dependencies,
  system-level simplicity, surgical scope, proportional tests, minimal mocking. Use
  when writing or reviewing code and tests; preventing over-engineering, dependency sprawl,
  pattern sprawl, mock-heavy tests, or drive-by refactors; or when the user invokes
  proportional-engineering.
---

# Proportional Engineering

Principles for pragmatic AI-assisted coding — language-, framework-, and tool-agnostic. Constraints apply to **decision-making**, not to mandating DDD, TDD, SOLID, or a specific architecture.

Biased toward caution over speed; use judgment on trivial tasks.

## Supreme rule

Code size, abstraction depth, test volume, and architectural complexity must remain proportional to business complexity.

Every added line, abstraction, dependency, file, and test must justify its existence.

Simple problems forbid complex solutions.

---

## Five core principles

### 1. Evidence before change

Do not modify code based on speculation. Prefer evidence over intuition.

Support changes with at least one of: a failing test, an error message, a bug report, or observed behavior.

Before implementing: state assumptions; ask when uncertain; surface tradeoffs if interpretations differ.

### 2. Reuse before build

Before creating new code, search for existing implementations, utilities, and tests.

Prefer extending existing code over parallel solutions — especially in large repositories.

### 3. Prefer deletion over addition

Before adding code, ask whether the problem can be solved by deleting code, simplifying logic, removing a layer, or reusing what already exists.

Code removal is usually preferable to addition. The best fix may be fewer lines — including removing a class, module, or config entry when it no longer earns its keep.

A successful refactor reduces code, complexity, or cognitive load — not file count, abstractions, or tests without payoff.

### 4. Build only what exists today

**Future requirements are not requirements.** Do not implement for hypothetical needs (e.g. CSV export must not become an ExportProvider for Excel/PDF/JSON unless asked). Treat future possibilities as unknown; solve today's problem. If extensibility matters, explain the tradeoff instead of building it silently.

**Patterns are not goals.** Do not introduce Strategy, Factory, Repository, DI, or similar patterns unless they solve a concrete problem that already exists. Every pattern must justify its cost.

**System simplicity over local elegance.** Optimize for how understandable the system is, not how polished one function looks. A ten-line function split into several classes and interfaces is not an improvement if the surrounding system becomes harder to follow.

**Dependencies are architecture.** Prefer the language runtime and standard library before adding a package for a small problem. A new dependency must justify maintenance, security, upgrade, and cognitive cost — not convenience alone.

**Minimum that works.** No scope creep, single-use abstractions, or unrequested configurability. Prefer one function over layered stacks; prefer editing existing files over new `service` / `manager` / `repository` / `utils` modules for small changes. No pass-through wrappers (`return user.name`). Avoid defensive handling for scenarios with no realistic path to occur; error handling should match actual risk. If 200 lines could be 50, rewrite.

> Make it work. Make it clear. Extend only when necessary.

### 5. Stop when the goal is met

Once requested behavior is implemented and verified, stop. Do not keep "improving" without a specific reason. Perfect is often worse than done.

Touch only what the request requires: no drive-by refactors, formatting, or comment edits on unrelated code. Every changed line must trace to the request. Remove orphans your edit created; do not delete unrelated dead code unless asked.

---

## Proportional verification

Tests must scale with the change — same proportionality as production code.

| Work | Verify with |
|------|-------------|
| New validation | Invalid-input tests, then code |
| Bug fix | Reproducing test, then fix |
| Refactor | Tests green before and after |

**Behavior, not ceremony**

- Assert input → output; avoid tests that only check call counts or private structure.
- Mock only when necessary — not simple value objects, pure functions, or stable internals. Prefer real behavior over interaction verification. Avoid mock stacks that dwarf the code under test.
- Before adding a test: *If this fails, does it signal a real defect?* If no, skip it.
- Prioritize P0 core logic, P1 boundaries, P2 errors; minimize P4 implementation-detail tests.
- Same behavior → parametrized test, not `test_empty` / `test_none` / `test_blank` clones.

| Change size | Typical tests |
|-------------|----------------|
| ~10 lines | 0–2 |
| ~100 lines of core logic | focused P0–P2 set |

Deleting behavior without changing outward behavior: test count should not grow.

---

## Before you ship

If behavior is unchanged and any is true, simplify: unnecessary abstraction; removable layer, file, class, interface, dependency, or test.

---

## Repository overrides

In this repository, see root `CLAUDE.md` for Python and documentation conventions. On conflict, follow the user's current instruction.
