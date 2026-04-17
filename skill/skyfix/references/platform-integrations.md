# platform-integrations

适用场景：
- Telegram 连不上
- 微信接入异常
- 语音消息 / TTS / ASR 有问题
- Telegram 文件 / 媒体发送异常

## 优先脚本
- `../scripts/check_platform_integrations.sh`
- `../scripts/check_telegram_delivery_modes.py`

## 总体原则
先分层，不要混修：
1. OpenClaw 配置问题
2. 凭证 / token / webhook 问题
3. 网络问题
4. 媒体格式 / 发送策略问题
5. 平台侧限制问题

先跑：
```bash
bash scripts/check_platform_integrations.sh
```

## A. Telegram Core
检查：
- bot token / channel 配置
- webhook / polling 状态
- 网络是否能通 Telegram API
- gateway 日志中的 telegram 错误

优先看这几个字段：
- `telegram.enabled`
- `telegram.has_bot_token`
- `telegram.network_status`
- `telegram.network_probe_error`
- `telegram.diagnosis.likely_layer`

输出要区分：
- 配置错
- 网络超时 / 网络不可达
- 平台 API 拒绝
- 已修复 / 未修复

## B. Voice Pipeline
### ASR
检查：
- 本地 ASR 依赖是否存在
- 模型缓存 / 路径是否存在
- OpenClaw 配置是否指向正确链路
- Telegram 语音输入是否能被转录
- 若缺 wrapper，要明确指出缺少 `scripts/asr/transcribe_telegram_voice.sh`

### TTS
检查：
- TTS 触发路径
- 声音模型 / 配置 / 脚本是否可用
- 生成格式是否满足目标平台
- 若缺依赖，要明确指出 MiniMax 脚本或 `MINIMAX_*` 环境变量缺失

### Telegram Voice
检查：
- 是否是普通音频而非 voice-note
- 格式、封装、发送参数是否正确
- 是否走错发送策略

## C. Telegram File / Media Sending
高频问题包括：
- 文件发不出去
- 媒体类型不对
- 语音泡泡不生效
- 大小 / content-type / asDocument / asVoice 策略错位

修复时至少判断：
- 文件大小
- mime/content-type
- 平台发送参数
- 是否需要文档发送、媒体发送或语音发送

优先调用：
```bash
python3 scripts/check_telegram_delivery_modes.py --kind <file|media|voice> --prefer <fidelity|preview|voice-bubble>
```

## D. WeChat Lite
V1 只做 lite 诊断：
- 看配置是否存在
- 看依赖是否缺失
- 看路径是否合理
- 给出下一步建议

不在 V1 承诺全自动修复。

## 输出标准
平台问题结束后必须说明：
- 问题在哪一层
- 已执行什么修复
- 现在通不通
- 如果还没通，卡在什么点
