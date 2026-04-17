#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path


def parse_env(value: str):
    if "=" not in value:
        raise argparse.ArgumentTypeError("--env must look like KEY=VALUE")
    return value.split("=", 1)


def parse_alias(value: str):
    if "=" not in value:
        raise argparse.ArgumentTypeError("--alias must look like model/id=Alias Name")
    return value.split("=", 1)


def ensure_nowcoding_gpt54(cfg: dict, api_key: str | None):
    env = cfg.setdefault("env", {}).setdefault("vars", {})
    existing_provider = cfg.setdefault("models", {}).setdefault("providers", {}).get("nowcoding", {})
    resolved_api_key = api_key or env.get("NOWCODING_API_KEY") or existing_provider.get("apiKey")
    if not resolved_api_key:
        raise ValueError("ensure_nowcoding_gpt54 requires a NOWCODING API key via --nowcoding-api-key or existing config/env")
    env["NOWCODING_API_KEY"] = resolved_api_key

    auth = cfg.setdefault("auth", {}).setdefault("profiles", {})
    auth["nowcoding:default"] = {"provider": "nowcoding", "mode": "api_key"}

    models = cfg.setdefault("models", {})
    models["mode"] = models.get("mode", "merge")
    providers = models.setdefault("providers", {})
    providers["nowcoding"] = {
        "baseUrl": "https://nowcoding.ai/v1",
        "apiKey": resolved_api_key,
        "api": "openai-completions",
        "models": [
            {
                "id": "gpt-5.4",
                "name": "GPT-5.4 (NowCoding)",
                "api": "openai-completions",
                "reasoning": True,
                "input": ["text", "image"],
                "cost": {"input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0},
                "contextWindow": 450000,
                "contextTokens": 450000,
                "maxTokens": 32768,
            }
        ],
    }

    defaults = cfg.setdefault("agents", {}).setdefault("defaults", {})
    model = defaults.setdefault("model", {})
    model["primary"] = "nowcoding/gpt-5.4"
    defaults.setdefault("models", {})["nowcoding/gpt-5.4"] = {"alias": "GPT-5.4 (NowCoding)"}


def main():
    p = argparse.ArgumentParser(description="Patch OpenClaw config with common skyfix normalization operations.")
    p.add_argument("--config", default=str(Path.home() / ".openclaw" / "openclaw.json"))
    p.add_argument("--primary-model")
    p.add_argument("--fallback-model", action="append", default=[])
    p.add_argument("--alias", action="append", type=parse_alias, default=[])
    p.add_argument("--env", action="append", type=parse_env, default=[])
    p.add_argument("--tools-profile")
    p.add_argument("--exec-security")
    p.add_argument("--exec-ask")
    p.add_argument("--elevated-default", choices=["on", "off"])
    p.add_argument("--ensure-nowcoding-gpt54", action="store_true")
    p.add_argument("--nowcoding-api-key")
    p.add_argument("--stdout", action="store_true", help="Print patched config subset")
    args = p.parse_args()

    config_path = Path(args.config).expanduser()
    cfg = json.loads(config_path.read_text()) if config_path.exists() else {}

    defaults = cfg.setdefault("agents", {}).setdefault("defaults", {})

    if args.primary_model:
        model = defaults.setdefault("model", {})
        model["primary"] = args.primary_model
        if args.fallback_model:
            model["fallbacks"] = args.fallback_model
    elif args.fallback_model:
        model = defaults.setdefault("model", {})
        model["fallbacks"] = args.fallback_model

    for key, value in args.env:
        cfg.setdefault("env", {}).setdefault("vars", {})[key] = value

    for model_id, alias in args.alias:
        defaults.setdefault("models", {})[model_id] = {"alias": alias}

    if any([args.tools_profile, args.exec_security, args.exec_ask]):
        tools = cfg.setdefault("tools", {})
        if args.tools_profile:
            tools["profile"] = args.tools_profile
        exec_cfg = tools.setdefault("exec", {})
        if args.exec_security:
            exec_cfg["security"] = args.exec_security
        if args.exec_ask:
            exec_cfg["ask"] = args.exec_ask

    if args.elevated_default:
        defaults["elevatedDefault"] = args.elevated_default

    if args.ensure_nowcoding_gpt54:
        ensure_nowcoding_gpt54(cfg, args.nowcoding_api_key)

    config_path.write_text(json.dumps(cfg, ensure_ascii=False, indent=2) + "\n")

    if args.stdout:
        print(json.dumps({
            "config": str(config_path),
            "primary_model": cfg.get("agents", {}).get("defaults", {}).get("model"),
            "tools": cfg.get("tools"),
            "elevatedDefault": cfg.get("agents", {}).get("defaults", {}).get("elevatedDefault"),
        }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
