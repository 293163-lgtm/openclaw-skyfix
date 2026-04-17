# permissions-normalization

适用场景：
- 切主模型
- 提升 OpenClaw agent 权限
- 统一多台机器配置口径
- 修正错误字段落点

## 优先脚本
- `../scripts/patch_openclaw_config.py`
- `../scripts/check_openclaw_runtime.sh`
- `../scripts/repair_gateway_launchagent.sh`（若改完需要重建 service）

## 关键规则

### 1. `tools` 只能放顶层
正确：
```json
"tools": {
  "profile": "full",
  "exec": {
    "security": "full",
    "ask": "off"
  }
}
```

错误：
```json
"agents": {
  "defaults": {
    "tools": { ... }
  }
}
```

### 2. 最大权限口径
若用户要“权限拉满”，默认目标是：
- `tools.profile = "full"`
- `tools.exec.security = "full"`
- `tools.exec.ask = "off"`
- `agents.defaults.elevatedDefault = "on"`

### 3. 模型收口
若用户要求迁模型或统一主模型：
- 写入 `agents.defaults.model.primary`
- 必要时补 auth profile / provider / env vars
- 改完要验证配置、再验证服务

## 标准流程
1. 读当前配置
2. 对比目标状态
3. 修改最小必要字段
   - 优先调用：
     ```bash
     python3 scripts/patch_openclaw_config.py ... --stdout
     ```
4. `openclaw config validate`
5. 重启 gateway / service
6. 回报最终有效状态

## 输出要求
必须明确告诉用户：
- 主模型是什么
- 权限是否已达到目标档位
- validate 是否通过
- 是否已重启并生效
