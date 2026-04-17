#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${HOME}/Desktop/OpenClaw 快捷访问"
CONFIG_PATH="${HOME}/.openclaw/openclaw.json"
NODE_BIN_DEFAULT='${HOME}/.local/node/bin'
NODE_BIN_OVERRIDE=""

usage() {
  cat <<'EOF'
Usage: create_desktop_shortcuts.sh [options]

Create desktop launchers and quick-access symlinks for OpenClaw.

Options:
  --target-dir <path>    Desktop shortcut dir (default: ~/Desktop/OpenClaw 快捷访问)
  --config <path>        OpenClaw config path (default: ~/.openclaw/openclaw.json)
  --node-bin <path>      Explicit node/openclaw bin dir to export in launchers
  -h, --help             Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target-dir) TARGET_DIR="$2"; shift 2 ;;
    --config) CONFIG_PATH="$2"; shift 2 ;;
    --node-bin) NODE_BIN_OVERRIDE="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
done

OPENCLAW_HOME="${HOME}/.openclaw"
mkdir -p "$TARGET_DIR" "$OPENCLAW_HOME/skills"

OPTIONAL_LINK_TARGETS=(
  "$OPENCLAW_HOME/workspace|Work"
  "$OPENCLAW_HOME/skills|Skills"
  "$OPENCLAW_HOME|配置与数据"
  "$OPENCLAW_HOME/logs|日志"
  "$OPENCLAW_HOME/agents|代理"
  "$OPENCLAW_HOME/identity|身份与设备"
  "$OPENCLAW_HOME/devices|设备"
  "$OPENCLAW_HOME/canvas|Canvas"
  "$OPENCLAW_HOME/telegram|Telegram"
)

if [[ -n "$NODE_BIN_OVERRIDE" ]]; then
  NODE_BIN="$NODE_BIN_OVERRIDE"
else
  if command -v openclaw >/dev/null 2>&1; then
    NODE_BIN="$(dirname "$(command -v openclaw)")"
  else
    NODE_BIN="${HOME}/.local/node/bin"
  fi
fi

cat > "$TARGET_DIR/启动 OpenClaw.command" <<EOF
#!/bin/bash
export PATH="$NODE_BIN:\$PATH"
openclaw dashboard
EOF

cat > "$TARGET_DIR/首次配置 OpenClaw.command" <<EOF
#!/bin/bash
export PATH="$NODE_BIN:\$PATH"
openclaw onboard
read -p "按回车键关闭窗口..."
EOF

cat > "$TARGET_DIR/打开主配置文件.command" <<EOF
#!/bin/bash
open -e "$CONFIG_PATH"
read -p "按回车键关闭窗口..."
EOF

for entry in "${OPTIONAL_LINK_TARGETS[@]}"; do
  TARGET="${entry%%|*}"
  LABEL="${entry##*|}"
  if [[ -e "$TARGET" ]]; then
    ln -sfn "$TARGET" "$TARGET_DIR/$LABEL"
  else
    echo "[warn] Skipping missing target: $TARGET" >&2
  fi
done

chmod +x "$TARGET_DIR"/*.command
xattr -cr "$TARGET_DIR" || true

echo "Created desktop shortcut bundle at: $TARGET_DIR"
ls -la "$TARGET_DIR"
