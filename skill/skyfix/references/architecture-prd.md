# skyfix Formal Architecture PRD

> This document is a first-class companion doc, not a mirror.

## 1. Product Positioning

`skyfix` is a self-contained OpenClaw maintenance expert skill.

It is designed to be distributable as a single skill package to other machines while still preserving professional internal architecture. It must therefore satisfy two constraints at once:

1. **Operational completeness** — enough built-in capability to install, repair, and normalize OpenClaw without external skill dependencies.
2. **Architectural cleanliness** — a layered internal design so the package remains understandable, maintainable, and evolvable.

`skyfix` is not a generic system-admin pack. It is a maintenance orchestrator centered on the OpenClaw lifecycle.

---

## 2. V1 Product Goal

Deliver a V1 that can reliably handle the most common and highest-value OpenClaw maintenance tasks for real machines with human-readable diagnosis and controlled repair execution.

V1 should be able to:
- install OpenClaw on a fresh machine
- upgrade or reinstall OpenClaw on a broken machine
- normalize model / permissions / gateway configuration
- create desktop shortcuts and quick-access entries
- repair high-frequency Telegram-related failures
- repair high-frequency voice pipeline failures (ASR/TTS/Telegram voice)
- investigate difficult issues using external issue intelligence when needed
- produce post-run improvement suggestions through a controlled evolution bridge

---

## 3. V1 Must-Have Capabilities

## 3.1 Maintenance Core

### A. Install / Bootstrap
- inspect environment (macOS, Node, npm, Xcode CLT, Homebrew path viability)
- choose install path (Homebrew vs user-local Node)
- install target OpenClaw version
- run initial setup as needed
- verify dashboard / gateway baseline availability

### B. Upgrade / Reinstall / Repair
- detect current install state
- back up prior config and key state
- identify half-broken or stale installs
- clean and reinstall when needed
- upgrade to a specific version or latest
- rebuild gateway / LaunchAgent state
- verify runtime baseline

### C. Config / Permissions Normalization
- migrate or set primary model
- normalize top-level tools / exec permissions
- enable elevated default where required
- validate configuration structure
- report exact effective state

## 3.2 Desktop Integration
- create desktop launchers
- create quick-access folder / symlink structure
- fix executable bits and quarantine issues when applicable
- treat this as optional during install, but fully supported in V1

## 3.3 Platform Repair (V1 target)

### Telegram core
- token / webhook / network / config diagnosis
- distinguish OpenClaw config failure from external network/API failure
- repair the common cases when possible

### Voice pipeline repair
- ASR path diagnosis
- TTS path diagnosis
- Telegram voice-message delivery issues
- identify whether the fault sits in:
  - OpenClaw config
  - local runtime dependencies
  - media format / pipeline assumptions
  - Telegram channel behavior

### Telegram file/media sending repair
- file send failures
- media send failures
- voice bubble / audio-as-voice behavior issues
- payload size / content-type / strategy mismatch diagnosis

## 3.4 Issue Intelligence
- activate only on difficult or ambiguous failures
- search and synthesize from:
  - GitHub issues
  - official docs
  - official/community troubleshooting material
  - known local failure patterns
- output:
  - likely hypotheses
  - validation path
  - ranked repair order

## 3.5 Controlled Evolution
- integrate `self-improving-agent` as post-run reflection engine
- support:
  - maintenance retrospective
  - extracted lessons
  - improvement suggestions
- V1 explicitly stops short of autonomous self-modification and self-release

---

## 4. V1 Lite / Limited-Support Capability

### WeChat integration repair
WeChat belongs in V1 only as a **lite diagnosis lane**:
- config inspection
- connectivity/path diagnosis
- dependency gap identification
- human-readable next-step guidance

V1 does **not** promise full automatic repair parity with Telegram.

---

## 5. V1 Non-Goals

V1 should not attempt to be:
- a generic sysadmin framework
- a generic macOS repair assistant
- a full replacement for all OpenClaw internal doctor/status logic
- a full-channel universal repair engine
- an autonomous self-modifying self-publishing agent

Also explicitly out of scope for V1:
- fully automated WeChat repair parity
- multi-machine unattended fleet orchestration
- automatic PR creation and auto-merge loops
- direct adoption of foreign skill control protocols as runtime dependencies

---

## 6. User Experience Requirements

Every `skyfix` maintenance run should leave the user with a stable, human-readable answer to these questions:

1. What was broken or missing?
2. What did skyfix actually do?
3. What is the current version?
4. What is the current primary model?
5. What is the current permission state?
6. Is gateway / LaunchAgent healthy?
7. Are Telegram / voice / file-send lanes healthy?
8. What backup/log/config locations matter?
9. What remains unresolved?

This reporting requirement is not optional. It is core product behavior.

---

## 7. V1 Decision Log (confirmed)

The following have already been confirmed:

- Telegram enters V1 as full baseline repair target.
- WeChat enters V1 only as lite diagnostic support.
- Issue intelligence triggers only on difficult/ambiguous failures.
- Self-improvement in V1 is suggestion-only, not autonomous self-modification.
- `auto-skill` will not be included as a runtime dependency chain; only selected ideas may be borrowed.
- `self-improving-agent` is the chosen evolution integration.

Additional V1 high-frequency repair targets newly confirmed:
- ASR repair
- TTS repair
- Telegram voice issues
- Telegram file/media send issues

---

## 8. Quality Bar for V1

V1 is acceptable only if it is:
- **reliable** on core maintenance paths
- **explainable** to non-technical users
- **self-contained** as a distributable skill package
- **layered** enough to evolve without collapsing into a monolith

If a capability cannot meet that bar, it should be explicitly downgraded to lite diagnosis or moved to V2.
