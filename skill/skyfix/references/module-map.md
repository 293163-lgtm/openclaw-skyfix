# skyfix Module Map

> This document is a first-class companion doc, not a mirror.

## 1. Top-Level Module Graph

```text
                           ┌──────────────────────────┐
                           │        skyfix            │
                           │   master orchestrator    │
                           └────────────┬─────────────┘
                                        │
        ┌───────────────────────────────┼───────────────────────────────┐
        │                               │                               │
        ▼                               ▼                               ▼
┌──────────────────┐          ┌──────────────────┐            ┌──────────────────┐
│ maintenance-core │          │ config-normalizer│            │ desktop-integ.   │
│ install/repair   │          │ model/perm/gw    │            │ launchers/links  │
└────────┬─────────┘          └────────┬─────────┘            └──────────────────┘
         │                             │
         │                             │
         ▼                             ▼
┌──────────────────┐          ┌──────────────────┐
│ platform-repair  │          │ issue-intelligence│
│ tg/voice/files   │          │ github/docs/community
└────────┬─────────┘          └──────────────────┘
         │
         ▼
┌──────────────────┐
│ evolution-bridge │
│ retrospective    │
│ suggestions only │
└──────────────────┘
```

---

## 2. Module Responsibilities

### 2.1 `maintenance-core`
Own:
- install/bootstrap
- upgrade/reinstall/repair
- backup creation
- state detection
- minimal runtime acceptance

Do not own:
- detailed model normalization policy
- long-form issue research
- autonomous self-improvement

### 2.2 `config-normalizer`
Own:
- model migration
- permission normalization
- gateway / LaunchAgent config consistency
- config validation

Canonical targets include:
- top-level `tools.profile`
- `tools.exec.security`
- `tools.exec.ask`
- `agents.defaults.elevatedDefault`
- target primary model

### 2.3 `desktop-integration`
Own:
- desktop launcher generation
- quick-access folder/symlink layout
- launcher permission/quarantine fixes

### 2.4 `platform-repair`
Own the repair playbooks for:
- Telegram connectivity
- ASR path diagnosis
- TTS path diagnosis
- Telegram voice-message behavior
- Telegram file/media sending behavior
- WeChat lite diagnosis

Internal lanes:
```text
platform-repair/
  telegram-core
  voice-pipeline
    ├── asr
    ├── tts
    └── telegram-voice
  telegram-file-send
  wechat-lite
```

### 2.5 `issue-intelligence`
Own:
- external issue/doc/community lookup on ambiguous failures
- hypothesis generation
- evidence-ranked repair suggestions

Trigger rule:
- do not run on every task
- run only when local diagnosis is insufficient or signals conflict

### 2.6 `evolution-bridge`
Own:
- post-run retrospective handoff
- maintenance lessons extraction
- improvement suggestion generation
- periodic review design hooks

This module integrates `self-improving-agent` logic in a controlled way.

It does **not** own:
- runtime maintenance orchestration
- knowledge-base protocol enforcement
- automatic self-editing release loops in V1

---

## 3. Execution Flow

## 3.1 Standard maintenance flow

```text
user request
   ↓
classify target problem
   ↓
connect (local or via skyssh)
   ↓
maintenance-core state detection
   ↓
config-normalizer if config/model/permission scope exists
   ↓
platform-repair if channel/voice/file symptoms exist
   ↓
issue-intelligence only if ambiguity remains
   ↓
acceptance checks
   ↓
human-readable report
   ↓
evolution-bridge retrospective
```

## 3.2 Telegram/voice specialized flow

```text
symptom: telegram/voice broken
   ↓
platform-repair entry
   ↓
split into:
  - telegram-core
  - voice-pipeline
  - telegram-file-send
   ↓
identify failure layer:
  config / credentials / network / media-format / delivery-strategy
   ↓
repair or downgrade to explicit residual issue
```

---

## 4. Authority Rules

- `skyfix` is the only runtime orchestrator.
- Internal modules do not compete for top-level control.
- External skill-derived logic must be absorbed into one of these modules, never left as a second orchestrator.

---

## 5. V1 vs V2 Boundary by Module

### Fully in V1
- maintenance-core
- config-normalizer
- desktop-integration
- platform-repair.telegram-core
- platform-repair.voice-pipeline
- platform-repair.telegram-file-send
- issue-intelligence (conditional)
- evolution-bridge (suggestion-only)

### Lite in V1
- platform-repair.wechat-lite

### V2 candidates
- multi-machine fleet checks
- broad channel parity expansion
- autonomous change proposal pipelines
- self-updating release machinery
