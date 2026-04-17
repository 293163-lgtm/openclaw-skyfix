#!/usr/bin/env bash
set -euo pipefail

PORT="18789"
CONFIG_PATH="${HOME}/.openclaw/openclaw.json"
GATEWAY_LOG="${HOME}/.openclaw/logs/gateway.log"
GATEWAY_ERR_LOG="${HOME}/.openclaw/logs/gateway.err.log"
SHOW_LOG_TAIL=20

usage() {
  cat <<'EOF'
Usage: check_openclaw_runtime.sh [options]

Inspect the local OpenClaw runtime and print a compact JSON report.

Options:
  --port <port>             Gateway port (default: 18789)
  --config <path>           Config path (default: ~/.openclaw/openclaw.json)
  --gateway-log <path>      Gateway log path
  --gateway-err-log <path>  Gateway error log path
  --tail <n>                Tail lines for log snippets (default: 20)
  -h, --help                Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --port) PORT="$2"; shift 2 ;;
    --config) CONFIG_PATH="$2"; shift 2 ;;
    --gateway-log) GATEWAY_LOG="$2"; shift 2 ;;
    --gateway-err-log) GATEWAY_ERR_LOG="$2"; shift 2 ;;
    --tail) SHOW_LOG_TAIL="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
done

python3 - "$PORT" "$CONFIG_PATH" "$GATEWAY_LOG" "$GATEWAY_ERR_LOG" "$SHOW_LOG_TAIL" <<'PY'
import json, os, subprocess, sys
from pathlib import Path

port, config_path, gateway_log, gateway_err_log, tail_n = sys.argv[1:]
tail_n = int(tail_n)


def run(cmd):
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, check=False)
        return {"code": p.returncode, "stdout": p.stdout.strip(), "stderr": p.stderr.strip()}
    except Exception as e:
        return {"code": -1, "stdout": "", "stderr": str(e)}


def tail(path):
    p = Path(path).expanduser()
    if not p.exists():
        return None
    try:
        lines = p.read_text(errors='ignore').splitlines()
        return "\n".join(lines[-tail_n:])
    except Exception as e:
        return f"<tail failed: {e}>"

cfg = None
cfg_error = None
config_file = Path(config_path).expanduser()
if config_file.exists():
    try:
        cfg = json.loads(config_file.read_text())
    except Exception as e:
        cfg_error = str(e)

version = run(["bash", "-lc", "command -v openclaw >/dev/null 2>&1 && openclaw --version || true"])
node_v = run(["bash", "-lc", "command -v node >/dev/null 2>&1 && node --version || true"])
npm_v = run(["bash", "-lc", "command -v npm >/dev/null 2>&1 && npm --version || true"])
whiches = {
    "openclaw": run(["bash", "-lc", "command -v openclaw || true"]),
    "node": run(["bash", "-lc", "command -v node || true"]),
    "npm": run(["bash", "-lc", "command -v npm || true"]),
}
lsof = run(["bash", "-lc", f"lsof -nP -iTCP:{port} -sTCP:LISTEN || true"])

report = {
    "runtime": {
        "openclaw_version": version["stdout"],
        "node_version": node_v["stdout"],
        "npm_version": npm_v["stdout"],
        "which": {k: v["stdout"] for k, v in whiches.items()},
    },
    "config": {
        "path": str(config_file),
        "exists": config_file.exists(),
        "parse_error": cfg_error,
        "primary_model": None if cfg is None else cfg.get("agents", {}).get("defaults", {}).get("model"),
        "tools": None if cfg is None else cfg.get("tools"),
        "gateway": None if cfg is None else cfg.get("gateway"),
    },
    "gateway": {
        "port": int(port),
        "listener": lsof["stdout"],
        "gateway_log_tail": tail(gateway_log),
        "gateway_err_log_tail": tail(gateway_err_log),
    },
}

print(json.dumps(report, ensure_ascii=False, indent=2))
PY
