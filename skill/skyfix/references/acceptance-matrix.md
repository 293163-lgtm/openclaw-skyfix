# acceptance-matrix

> This document is a first-class companion doc, not a mirror.

## skyfix V1 acceptance matrix

| Area | Test | Pass condition | Evidence |
|---|---|---|---|
| Install | user-local Node install path works | script finishes, Node/OpenClaw versions reported | version output |
| Runtime inspect | runtime report parses cleanly | valid JSON + expected core fields present | `check_openclaw_runtime.sh` output |
| Config normalize | primary model + permissions set correctly | config validate passes, target fields present | patched config summary |
| Gateway repair | LaunchAgent/gateway recovered | listener appears on target port | `lsof` / gateway status |
| Desktop shortcuts | launcher bundle created | `.command` files + symlinks present | directory listing |
| Telegram inspect | core Telegram state detectable | token/config/network signals reported | platform integration report |
| Voice pipeline inspect | ASR/TTS/voice paths detectable | wrapper/scripts/keys/path hints reported | platform integration report |
| Telegram file/media | delivery strategy diagnosis works | recommendation matches requested kind/preference | `check_telegram_delivery_modes.py` output |
| Issue intelligence | difficult-issue search bootstrap works | docs/github/community starter produced | `collect_issue_intelligence.sh` output |
| Reporting UX | final answer is human-readable | result explains what broke, what changed, what remains | final operator report |

## Minimum V1 field-proof bar

V1 is field-proven enough to continue if it can pass these core rows on a real host:
- Runtime inspect
- Config normalize
- Gateway repair
- Desktop shortcuts
- Telegram inspect
- Reporting UX

The following are desirable but can remain partial during first field iteration:
- Voice pipeline inspect
- Telegram file/media diagnosis
- Issue intelligence quality depth
