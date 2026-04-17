#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="${HOME}/.openclaw/openclaw.json"
WORKSPACE_PATH="${HOME}/.openclaw/workspace"
GATEWAY_LOG="${HOME}/.openclaw/logs/gateway.log"
GATEWAY_ERR_LOG="${HOME}/.openclaw/logs/gateway.err.log"
TAIL_LINES=25

usage() {
  cat <<'EOF'
Usage: check_platform_integrations.sh [options]

Inspect high-frequency OpenClaw integration lanes with emphasis on Telegram,
ASR/TTS voice paths, and Telegram file/media sending issues.

Options:
  --config <path>       Config path (default: ~/.openclaw/openclaw.json)
  --workspace <path>    Workspace path (default: ~/.openclaw/workspace)
  --tail <n>            Tail lines for gateway logs (default: 25)
  -h, --help            Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --config) CONFIG_PATH="$2"; shift 2 ;;
    --workspace) WORKSPACE_PATH="$2"; shift 2 ;;
    --tail) TAIL_LINES="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
done

python3 - "$CONFIG_PATH" "$WORKSPACE_PATH" "$GATEWAY_LOG" "$GATEWAY_ERR_LOG" "$TAIL_LINES" <<'PY'
import json, subprocess, sys
from pathlib import Path

config_path, workspace_path, gateway_log, gateway_err_log, tail_n = sys.argv[1:]
tail_n = int(tail_n)


def tail(path):
    p = Path(path).expanduser()
    if not p.exists():
        return None
    return "\n".join(p.read_text(errors='ignore').splitlines()[-tail_n:])


def run(cmd: str):
    p = subprocess.run(["bash", "-lc", cmd], capture_output=True, text=True)
    return {
        "code": p.returncode,
        "stdout": p.stdout.strip(),
        "stderr": p.stderr.strip(),
    }

cfg = {}
cfg_error = None
config_file = Path(config_path).expanduser()
if config_file.exists():
    try:
        cfg = json.loads(config_file.read_text())
    except Exception as e:
        cfg_error = str(e)

workspace = Path(workspace_path).expanduser()
telegram = cfg.get("channels", {}).get("telegram", {}) if cfg else {}
env_vars = cfg.get("env", {}).get("vars", {}) if cfg else {}

network_probe = run("curl -I -sS --max-time 5 https://api.telegram.org | head -n 1")
if network_probe["stdout"]:
    network_status = "reachable"
elif network_probe["stderr"]:
    network_status = "network-error"
else:
    network_status = "unknown"

asr_wrapper = workspace / "scripts" / "asr" / "transcribe_telegram_voice.sh"
minimax_tts_script = workspace / "scripts" / "minimax-tts-async.sh"

voice_findings = []
if not asr_wrapper.exists():
    voice_findings.append("ASR wrapper missing: scripts/asr/transcribe_telegram_voice.sh")
if not minimax_tts_script.exists():
    voice_findings.append("MiniMax TTS script missing: scripts/minimax-tts-async.sh")
if not any(k.startswith("MINIMAX") for k in env_vars.keys()):
    voice_findings.append("No MINIMAX_* key detected in env vars")

report = {
    "telegram": {
        "enabled": telegram.get("enabled", False),
        "has_bot_token": bool(telegram.get("botToken")),
        "dmPolicy": telegram.get("dmPolicy"),
        "groupPolicy": telegram.get("groupPolicy"),
        "streaming": telegram.get("streaming"),
        "network_probe": network_probe["stdout"],
        "network_probe_error": network_probe["stderr"],
        "network_status": network_status,
        "config_parse_error": cfg_error,
        "diagnosis": {
            "likely_layer": (
                "config-parse" if cfg_error else
                "config-missing-token" if telegram.get("enabled") and not telegram.get("botToken") else
                "network" if telegram.get("enabled") and network_status == "network-error" else
                "undetermined"
            )
        },
    },
    "voice_pipeline": {
        "asr_wrapper_exists": asr_wrapper.exists(),
        "minimax_tts_script_exists": minimax_tts_script.exists(),
        "has_nowcoding_key": "NOWCODING_API_KEY" in env_vars,
        "has_minimax_key": any(k.startswith("MINIMAX") for k in env_vars.keys()),
        "sag_available": bool(run("command -v sag")["stdout"]),
        "findings": voice_findings,
        "next_steps": [
            "Install or sync the ASR wrapper into workspace/scripts/asr if Telegram voice transcription is expected.",
            "Install or sync minimax-tts-async.sh if MiniMax TTS should be available.",
            "Provide required MINIMAX_* env vars before expecting MiniMax voice generation to work.",
        ],
    },
    "telegram_file_media": {
        "message_tooling_hint": "Inspect asVoice/asDocument/forceDocument/contentType strategy in calling workflow",
        "recent_gateway_telegram_log": tail(gateway_log),
        "recent_gateway_telegram_err": tail(gateway_err_log),
    },
}

print(json.dumps(report, ensure_ascii=False, indent=2))
PY
