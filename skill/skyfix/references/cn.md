# skyfix 中文架构入口

> This document is a first-class companion doc, not a mirror.

## 你现在应该先读什么

如果你是第一次接触 `skyfix`，或者你就是想要一份**中文小白说明书**，先打开：

0. `beginner-guide-cn.html` —— 中文 HTML 使用说明书（最适合小白）
1. `architecture-prd.md` —— 正式架构版 PRD（V1/V2 边界、功能清单、约束）
2. `module-map.md` —— 模块拆分图、依赖关系、执行流
3. `vendor-strategy.md` —— 外部 skill 能力如何内置、哪些能吸收、哪些不能照搬
4. `acceptance-matrix.md` —— V1 验收矩阵
5. `real-machine-trial.md` —— 真实机器试跑 runbook

## 当前权威判断

- `skyfix` 是 **OpenClaw 全面维护专家**，不是通用运维框架。
- V1 必须先把 **OpenClaw 本体维护闭环** 做稳。
- 平台对接里，V1 主攻：
  - Telegram 接入修复
  - ASR / TTS / Telegram 语音链路修复
  - Telegram 文件 / 媒体 / 语音发送修复
- 微信在 V1 只做 **lite 诊断位**，不承诺全自动修复。
- `self-improving-agent` 正式纳入进化外挂。
- `auto-skill` 不整包纳入运行链，只借鉴可用机制。
- `superpowers-openclaw` 作为方法论内化来源，不做运行期硬依赖。

## 当前设计立场

`skyfix` 必须满足这三个条件：

1. **单包自包含**：发到别的电脑也能直接用，不依赖目标机器先装一堆 skill。
2. **多文件分层**：不能做成单文件巨兽。
3. **主控统一**：`skyfix` 自己是唯一维护编排器；外部 skill 的能力只被吸收或受控挂接。

## 当前 V1 高优先能力

### Core maintenance
- 安装 / 初始化
- 升级 / 重装 / 修复
- 配置收口 / 权限提升
- gateway / LaunchAgent / dashboard 修复
- 最小验收与结果报告

### Platform repair
- Telegram 接入修复
- ASR / TTS / Telegram 语音问题修复
- Telegram 文件 / 媒体发送异常修复

### Intelligence
- 疑难问题时再查 GitHub / docs / community / FAQ / troubleshooting

### Evolution
- 维护后复盘
- 改进建议生成
- 周期性 review（后续挂接）

## 不要误解的点

- `skyfix` 可以很强，但 V1 不该做全渠道全自动修复。
- `skyfix` 可以自我进化，但 V1 不该自动改自己并自动发布。
- `skyfix` 可以吸收别的 skill 能力，但不能把外部 skill 的主控协议一起带进来。
