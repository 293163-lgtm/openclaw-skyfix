# skyfix Vendor Strategy

> This document is a first-class companion doc, not a mirror.

## 1. Core Principle

`skyfix` should ship as a **self-contained single package**.

That means the target machine should not need preinstalled helper skills for core value delivery.

But self-contained does **not** mean blindly copying whole upstream skills with all their runtime assumptions and control protocols.

The professional strategy is:

> **Vendor capability, not foreign sovereignty.**

Meaning:
- absorb useful knowledge
- absorb deterministic scripts/patterns where needed
- reject upstream control logic that would override skyfix's orchestration

---

## 2. Vendor Categories

## 2.1 Directly vendorable (high confidence)
These can be absorbed with minimal architectural conflict:

### From install/permissions skills
- install steps
- Node user-local install path logic
- desktop shortcut creation recipes
- permission normalization rules
- config field placement rules

These become:
- `references/install-lane.md`
- `references/permissions-normalization.md`
- `references/desktop-shortcuts.md`
- related scripts

## 2.2 Vendor as methodology (not runtime dependency)

### `superpowers-openclaw`
What to absorb:
- design-before-code discipline
- plan-before-change discipline
- root-cause-first debugging stance
- verification-before-completion bar

What **not** to absorb literally:
- its identity as top-level workflow controller
- generic development-task routing that exceeds skyfix's domain

Result:
- convert into `references/process-discipline.md`
- use as internal design law, not runtime dependency

## 2.3 Vendor selectively with strict boundary

### `self-improving-agent`
What to absorb or integrate:
- retrospective structure
- pattern abstraction model
- controlled improvement proposal flow
- memory of maintenance lessons

What not to absorb literally in V1:
- autonomous self-modifying release loops
- broad hooks behavior beyond skyfix's needs

Result:
- formal integration through `references/self-evolution.md`
- optional future scripts for retrospective generation
- keep skyfix as controller

### `auto-skill`
What to borrow:
- useful experience-capture ideas
- knowledge categorization ideas
- “ask before recording durable experience” pattern

What **not** to absorb:
- global forced protocol role
- auto-patching external global rule files
- assumption that every task must invoke it first

Result:
- no runtime dependency
- no top-level inclusion in control loop
- selective design inspiration only

---

## 3. Integration Decision Matrix

```text
Skill                    Keep as runtime dep?   Vendor-in?   Notes
--------------------------------------------------------------------------
install/shortcut tips    No                     Yes          Fully absorb
permissions config tips  No                     Yes          Fully absorb
superpowers-openclaw     No                     Yes          Methodology only
self-improving-agent     No*                    Yes/Bridge   Controlled evolution bridge
auto-skill               No                     Partial only Borrow ideas, not protocol
skyssh                   External runtime use   No           Keep as connection substrate
```

`No*`: `self-improving-agent` is conceptually integrated, but skyfix should not require the external original skill to be installed on the target machine.

---

## 4. Packaging Rule

The distributed `skyfix` package should contain:
- its own `SKILL.md`
- its own `references/`
- its own `scripts/`
- its own vendorized logic summaries and playbooks

It should **not** require:
- reading external skill folders at runtime
- foreign hook protocols to already exist
- upstream skill installation state to be correct

---

## 5. Anti-Conflict Rules

### Rule 1
Only one orchestrator: `skyfix`.

### Rule 2
No vendored component may rewrite global rules to make itself mandatory ahead of skyfix.

### Rule 3
No vendored component may introduce a second evolution authority.

### Rule 4
If a vendored source is broader than skyfix's domain, keep only the relevant subset.

### Rule 5
Prefer distilled internal references over raw upstream copy when the upstream text is too broad, too repetitive, or too opinionated for skyfix's scope.

---

## 6. Recommended V1 Vendor Decision

### Absorb now
- install/shortcut knowledge
- permissions/config normalization knowledge
- superpowers methodology subset
- self-improvement retrospective subset
- Telegram / voice / file-send repair playbooks

### Borrow lightly
- auto-skill memory-capture patterns

### Hold for later
- autonomous self-upgrade machinery
- broad hook ecosystems
- large cross-channel protocol sets

---

## 7. Final Position

A professional `skyfix` package should feel like one coherent system, not a bag of imported personalities.

The user should receive one integrated maintenance expert.
Internally, that expert may be built from multiple sources.
But externally, it must behave like a single mind.
