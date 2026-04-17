---
name: skyfix
description: OpenClaw 全面维护专家。Use when the user wants to install, initialize, upgrade, reinstall, repair, normalize, or deeply troubleshoot OpenClaw on the current machine or a remote machine. Covers OpenClaw environment checks, version upgrades, broken installs, gateway / LaunchAgent / dashboard issues, model migration, permission elevation, desktop shortcuts, Telegram integration repair, ASR/TTS/Telegram voice issues, Telegram file/media sending issues, and difficult OpenClaw bug triage using GitHub/docs/community intelligence. Prefer this when the task is about keeping OpenClaw healthy across real machines, not generic SSH or generic sysadmin work.
---

# skyfix

`skyfix` 是 OpenClaw 的维护总工程师。

它负责把 OpenClaw 在真实机器上的生命周期接住：安装、升级、修复、配置收口、平台接入、疑难排障、维护后复盘。

## 先读什么

按任务类型读取：

1. **安装 / 初始化 / 重装 / 升级 / 修复主链**
   - 先读 `references/install-lane.md`
   - 如目标机已装过或状态混乱，再读 `references/upgrade-repair-lane.md`

2. **模型 / 权限 / 配置收口**
   - 读 `references/permissions-normalization.md`

3. **桌面快捷方式 / 快捷访问目录**
   - 读 `references/desktop-shortcuts.md`

4. **Telegram / 语音 / 文件发送问题**
   - 读 `references/platform-integrations.md`

5. **复杂故障、需要外部证据**
   - 读 `references/issue-intelligence.md`

6. **如何保持过程专业、避免瞎修**
   - 读 `references/process-discipline.md`

7. **维护后复盘 / 进化建议**
   - 读 `references/self-evolution.md`

8. **真实机器试跑 / 验收矩阵**
   - 读 `references/real-machine-trial.md`
   - 读 `references/acceptance-matrix.md`

9. **中文总入口与当前架构判断**
   - 读 `references/cn.md`

## 核心立场

- `skyfix` 是**唯一主编排器**。
- 可以复用 `skyssh` 做远端接入，但不把 SSH 连接层并入自己。
- 可以吸收别的 skill 能力，但**不引入外部 skill 的主控协议**。
- 默认先判断问题层级，再动手，不靠拍脑袋乱修。
- 默认先备份，再做删除/重装/覆盖配置。
- 修完必须给出**验收结果**与**残余问题**。

## 任务分流

### A. Install / Bootstrap
当用户要：
- 安装 OpenClaw
- 初始化 OpenClaw
- 新机部署 OpenClaw
- 做桌面快捷入口

执行：
1. 读 `references/install-lane.md`
2. 如涉及快捷方式，再读 `references/desktop-shortcuts.md`
3. 先检查环境，再安装，不跳过前置判断

### B. Upgrade / Reinstall / Repair
当用户要：
- 升级 OpenClaw
- 重装 OpenClaw
- 修 OpenClaw
- gateway / LaunchAgent / dashboard 起不来
- 清理旧版或坏状态

执行：
1. 读 `references/upgrade-repair-lane.md`
2. 如涉及模型/权限，再读 `references/permissions-normalization.md`
3. 先识别当前状态，再决定轻修、重装还是升级

### C. Config / Permission Normalization
当用户要：
- 切主模型
- 提升 agent 权限
- 把配置收口为某个标准

执行：
1. 读 `references/permissions-normalization.md`
2. 明确报告目标状态与当前状态差异
3. 改完必须 validate / restart / verify

### D. Platform Repair
当用户要：
- 修 Telegram
- 修语音回复
- 修 ASR / TTS
- 修 Telegram 文件 / 媒体 / 语音发送
- 检查微信接入

执行：
1. 读 `references/platform-integrations.md`
2. 先区分：配置问题 / 凭证问题 / 网络问题 / 媒体格式问题 / 平台侧问题
3. 微信在 V1 只做 lite 诊断，不承诺全自动修好

### E. Difficult Bug Triage
当本地诊断不够时：
1. 读 `references/issue-intelligence.md`
2. 才去搜 GitHub / docs / community / troubleshooting
3. 不要每个小问题都联网放大

### F. Post-Run Reflection
当任务已完成或告一段落：
1. 读 `references/self-evolution.md`
2. 生成复盘与改进建议
3. V1 不自动改 skyfix 自己，不自动发布

## 输出标准

每次维护任务结束，至少输出：
- 当前版本
- 当前主模型
- 当前权限状态
- gateway / LaunchAgent 状态
- 平台接入状态（若本次涉及）
- 备份路径 / 关键日志路径
- 剩余问题

## 禁止事项

- 不把 `tools` 写进 `agents.defaults`
- 不把 `auto-skill` 当成 skyfix 的全局前置协议
- 不在没有备份判断的情况下直接粗暴重装
- 不在没有验证前宣称“修好了”
- 不把通用电脑维修扩成 skyfix 的默认职责
