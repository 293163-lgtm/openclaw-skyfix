# desktop-shortcuts

适用场景：
- 用户要桌面快捷方式
- 用户要 OpenClaw 快捷访问文件夹
- 用户要 launcher / quick links

## 优先脚本
- `../scripts/create_desktop_shortcuts.sh`

优先直接调用它，不要每次手写 `.command` 和 symlink。

## 目标
为小白用户提供：
- 启动 OpenClaw 的 `.command`
- 首次配置入口
- 打开主配置文件入口
- 工作目录 / 配置 / 日志 / skills 等快捷访问目录

## 工作流

### 1. 先确认路径
需要知道：
- OpenClaw 安装路径中的 node/openclaw 可执行路径
- `~/.openclaw` 数据目录
- 桌面路径

### 2. 创建启动器
典型入口：
- 启动 dashboard
- 首次配置 / onboard
- 打开主配置文件

优先调用：
```bash
bash scripts/create_desktop_shortcuts.sh
```

### 3. 创建快捷访问目录
常见链接：
- workspace
- skills
- 配置与数据
- logs
- agents
- devices / canvas / telegram

### 4. 修正权限与隔离
常见问题：
- `.command` 没执行权限
- macOS quarantine 导致双击没反应

处理后要告诉用户：
- 快捷方式放在哪
- 双击能做什么

## 设计原则
- 桌面入口是增强体验，不应阻塞主维护链
- 小白视角优先，名字要人话，不要工程术语过多
