# upgrade-repair-lane

适用场景：
- OpenClaw 已装过，但状态不干净
- 需要升级、重装、清理旧版
- gateway / LaunchAgent / dashboard 有问题
- 怀疑配置残留、版本混乱、半安装状态

## 优先脚本
- `../scripts/check_openclaw_runtime.sh`
- `../scripts/repair_gateway_launchagent.sh`
- `../scripts/patch_openclaw_config.py`

## 工作流

### 1. 先做状态盘点
先拿到：
- 当前 OpenClaw 版本
- 当前 Node/npm 路径
- 当前配置文件路径
- 当前 gateway / LaunchAgent 状态
- 当前日志路径

优先执行：
```bash
bash scripts/check_openclaw_runtime.sh
```

### 2. 决定修法
按风险从低到高：
1. **轻修**：只改配置 / 重启服务
2. **中修**：重建 gateway / LaunchAgent / 补装依赖
3. **重修**：备份后清旧版并重装

不要默认一上来就重装。

### 3. 先备份
涉及以下动作前，默认先备份：
- 删旧 OpenClaw
- 覆盖主配置
- 重建 service

至少说明：
- 备份目录
- 备份了哪些关键内容

### 4. 执行修复
可包含：
- 停止旧 gateway
- 清理旧版二进制 / npm 全局包 / 半旧路径
- 安装目标版本
- 重写或补丁更新配置
- 重建 LaunchAgent / gateway

若重点是配置与权限，优先调用：
```bash
python3 scripts/patch_openclaw_config.py ...
```

若重点是 gateway / LaunchAgent，优先调用：
```bash
bash scripts/repair_gateway_launchagent.sh
```

### 5. 验收
至少验证：
- 版本正确
- 配置合法
- gateway 监听正常
- dashboard / status 基础可用

再次优先执行：
```bash
bash scripts/check_openclaw_runtime.sh
```

### 6. 报告残余问题
如果还有：
- 外部网络问题
- 平台侧 API 问题
- token / webhook 问题
- 旧日志噪声

要明确说明“不是本体安装失败，而是外部尾巴”。
