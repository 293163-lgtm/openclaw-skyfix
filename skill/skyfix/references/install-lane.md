# install-lane

适用场景：
- 新机安装 OpenClaw
- 当前机器还没跑顺 OpenClaw
- 需要初始化 dashboard / gateway / desktop 入口

## 优先脚本
- `../scripts/install_openclaw_user_node.sh`

当判断应走用户目录 Node 路线时，优先直接调用它，而不是现场临时重写安装脚本。

## 工作流

### 1. 环境识别
先检查：
- macOS 版本
- Xcode Command Line Tools
- Node / npm 是否存在
- Homebrew 是否可用
- 架构（x64 / arm64）

关键判断：
- 若 Homebrew 路径顺且版本满足，可走 brew 路线
- 若 brew 不稳、权限麻烦、或旧系统编译易炸，优先用户目录 Node 路线

### 2. 选择安装路径
优先顺序：
1. 已有稳定 Node 22+ → 直接安装 OpenClaw
2. Homebrew 可用且风险低 → Homebrew Node
3. 其余情况 → 用户目录 Node（更可控）

### 3. 安装 OpenClaw
- 安装指定版本或 latest
- 明确记录安装路径与版本
- 必要时运行 onboard / 初始配置
- 若采用用户目录 Node 路线，优先调用：
  ```bash
  bash scripts/install_openclaw_user_node.sh --openclaw-version <version>
  ```

### 4. 基础验收
至少验证：
- `openclaw --version`
- gateway 能启动
- dashboard 可打开或可探测
- 配置文件位置明确
- 优先调用：
  ```bash
  bash scripts/check_openclaw_runtime.sh
  ```

### 5. 可选：桌面入口
如果用户要桌面快捷方式：
- 再读 `desktop-shortcuts.md`
- 不让它阻塞主安装链

## 输出要求
安装完成后必须告诉用户：
- 安装版本
- 安装路径
- gateway 状态
- dashboard 情况
- 是否还缺配置
