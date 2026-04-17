# real-machine-trial

> This document is a first-class companion doc, not a mirror.

## 1. Goal

Run the first real-machine trial for `skyfix` as a distributable OpenClaw maintenance expert.

The immediate goal is **not** full production proof. The goal is to verify that V1 can survive real-machine friction and produce human-readable, evidence-backed maintenance outcomes.

## 2. Recommended first trial host

### Primary candidate
- `em2t` host (`192.168.31.15`)

Why this is the best first target:
- already reachable
- already has a live OpenClaw installation
- has a proven history of install / upgrade / permission / gateway work
- is suitable for regression and normalization tests

## 3. Trial philosophy

The first field trial should verify three things:

1. **Can skyfix inspect reality correctly?**
2. **Can skyfix repair the common maintenance paths without losing state?**
3. **Can skyfix explain the outcome clearly to a non-expert operator?**

Do not try to prove every capability in one shot.

## 4. Trial phases

### Phase A — Read-only inspection
Validate that skyfix can correctly inspect the target host without mutating it.

Test:
- runtime detection
- config detection
- gateway state detection
- platform integration inspection

Evidence to keep:
- OpenClaw version
- primary model
- permission state
- gateway listener state
- Telegram/voice diagnostic summary

### Phase B — Safe normalization
Apply non-destructive normalization actions.

Test:
- config normalization
- permission normalization
- gateway/LaunchAgent repair

Evidence to keep:
- before/after config diff summary
- validate result
- post-restart listener result

### Phase C — UX-layer repair
Apply small but visible operator-facing features.

Test:
- desktop shortcuts creation
- launcher usability
- quick-access links

Evidence to keep:
- generated files/links listing
- executable/quarantine status

### Phase D — Platform-focused repair
Use real symptoms if available.

Priority order:
1. Telegram core
2. Telegram voice / TTS / ASR
3. Telegram file/media send strategy
4. WeChat lite diagnosis

Evidence to keep:
- exact symptom
- diagnosed failure layer
- applied repair
- residual issue if still blocked

### Phase E — Difficult issue intelligence
Trigger only if ambiguity remains after local repair attempts.

Evidence to keep:
- ranked hypotheses
- search sources used
- chosen next repair path

## 5. What counts as a successful first trial

The first real-machine trial is successful if all of the following are true:
- skyfix can inspect and report the target state accurately
- skyfix can complete at least one normalization repair end-to-end
- skyfix produces a clear final report with evidence
- any unresolved issue is explicitly identified as config / network / third-party / platform-side
- at least one concrete lesson is captured for V1 iteration

## 6. What to avoid in the first trial

- Do not test every platform in one pass.
- Do not force WeChat full-repair proof in V1.
- Do not introduce autonomous self-modification.
- Do not mix product validation with unrelated system administration.

## 7. Recommended first trial order on em2t

1. runtime inspection
2. config/permission inspection
3. gateway/LaunchAgent normalization
4. desktop shortcut generation (safe UX validation)
5. Telegram/voice diagnostic pass
6. optional file/media delivery strategy diagnosis
7. retrospective

## 8. Trial output contract

Every real-machine trial should end with this structure:
- machine tested
- starting state
- actions performed
- current version/model/permissions/gateway state
- platform findings
- unresolved issues
- recommended next iteration for skyfix
