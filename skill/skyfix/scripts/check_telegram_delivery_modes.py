#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path


def load_json(path: Path):
    if not path.exists():
        return None, None
    try:
        return json.loads(path.read_text()), None
    except Exception as e:
        return None, str(e)


def detect_strategy(cfg: dict):
    telegram = cfg.get("channels", {}).get("telegram", {}) if cfg else {}
    return {
        "streaming": telegram.get("streaming"),
        "bot_token_present": bool(telegram.get("botToken")),
        "recommended_voice_hint": "Use asVoice for Telegram voice-note style delivery when the payload is audio and the UX target is voice bubble.",
        "recommended_file_hint": "Use asDocument/forceDocument when preserving file fidelity or avoiding media compression matters.",
        "recommended_media_hint": "Use standard media send when preview/rendering matters more than file fidelity.",
        "common_failure_checks": [
            "payload too large",
            "wrong mime/content-type",
            "asVoice used with non-voice-compatible format",
            "asDocument/forceDocument omitted when compression should be avoided",
            "voice bubble expectation mismatch with plain audio attachment",
        ],
    }


def main():
    p = argparse.ArgumentParser(description="Diagnose Telegram delivery mode choices for files/media/voice flows.")
    p.add_argument("--config", default=str(Path.home() / ".openclaw" / "openclaw.json"))
    p.add_argument("--kind", choices=["file", "media", "voice", "auto"], default="auto")
    p.add_argument("--mime")
    p.add_argument("--size-bytes", type=int)
    p.add_argument("--prefer", choices=["fidelity", "preview", "voice-bubble"])
    args = p.parse_args()

    cfg, cfg_error = load_json(Path(args.config).expanduser())
    cfg = cfg or {}
    strategy = detect_strategy(cfg)

    warnings = []
    if args.kind == "voice" or args.prefer == "voice-bubble":
        voice_mime_ok = {"audio/ogg", "audio/opus", "audio/mpeg", "audio/mp3", "audio/x-wav", "audio/wav"}
        if args.mime and args.mime not in voice_mime_ok:
            warnings.append(f"MIME may not be suitable for Telegram voice-note UX: {args.mime}")
        if args.size_bytes and args.size_bytes > 50 * 1024 * 1024:
            warnings.append("Payload is large; Telegram delivery may fail or need a different strategy.")

    if args.kind == "file" and args.size_bytes and args.size_bytes > 50 * 1024 * 1024:
        warnings.append("Large file payload; confirm Telegram limits and prefer document strategy.")

    recommendation = "inspect manually"
    if args.kind == "voice" or args.prefer == "voice-bubble":
        recommendation = "Prefer asVoice with Telegram-compatible audio/voice format; fall back to plain audio only if voice-note delivery is unavailable."
    elif args.kind == "file" or args.prefer == "fidelity":
        recommendation = "Prefer asDocument/forceDocument to preserve file fidelity and avoid Telegram recompression."
    elif args.kind == "media" or args.prefer == "preview":
        recommendation = "Prefer standard media send so Telegram can render preview/inline playback."

    report = {
        "telegram_delivery_diagnosis": {
            "inputs": {
                "kind": args.kind,
                "mime": args.mime,
                "size_bytes": args.size_bytes,
                "prefer": args.prefer,
            },
            "strategy": strategy,
            "config_parse_error": cfg_error,
            "warnings": warnings,
            "recommendation": recommendation,
        }
    }
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
