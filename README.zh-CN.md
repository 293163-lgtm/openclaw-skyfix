# skyfix
## 面向真实机器的 OpenClaw 维护专家

[English](./README.md) | **中文**

![skyfix banner](./assets/skyfix-banner.svg)

**OpenClaw 最靠谱的“修机佬”。**

`skyfix` 是一个自包含的 OpenClaw 维护专家，面向真实机器环境。
它负责安装、升级、修复、权限收口、gateway / LaunchAgent 恢复、桌面快捷方式、Telegram 诊断，以及语音链路排障——而且强调**验证结果**，不是靠玄学乱修。

---

## 它为什么存在

OpenClaw 的问题很少是一个干净单点 bug。
更多时候，它会同时缠在这些层上：

- 安装状态坏掉
- 配置混乱
- 模型 / 权限漂移
- gateway 或 LaunchAgent 异常
- Telegram 发送失败
- 语音链路依赖缺失
- 远端机器状态发散

`skyfix` 的价值就在于：

> 把这些问题当成**一个维护系统**来接，而不是一堆零散命令拼盘。

---

## 核心能力

- 在新机器上安装并初始化 OpenClaw
- 升级、重装、修复坏掉的 OpenClaw 状态
- 收口主模型、权限和关键配置
- 修复 gateway / LaunchAgent
- 生成桌面快捷方式与快捷访问入口
- 按故障层级诊断 Telegram / ASR / TTS / 语音发送问题
- 输出带验证的维护结果，而不是“我试过了”

---

## 它和一般修法有什么不同

### 1. 先分层，再动手
`skyfix` 会优先判断问题属于哪一层：

- 配置
- 凭证
- 网络
- 服务 / 运行时
- 媒体发送策略
- 缺少依赖
- 平台侧限制

这听起来像废话，但现实里大多数“修复流程”直接跳过这一步，先开始乱重装。

### 2. 它是唯一维护编排器
`skyfix` 的设计原则很明确：

- 可以吸收别的 skill 的能力
- 但不让外部 skill 的主控协议反客为主

这保证了它始终像一个完整系统，而不是套娃。

### 3. 它不是纸上谈兵
`skyfix` 已经跑过真实机器维护链路，包括：

- 运行时检查
- 配置收口
- gateway / LaunchAgent 修复
- 桌面快捷方式生成
- Telegram / 语音诊断

---

## v0.1 范围

### 已包含
- 安装 / 初始化
- 升级 / 重装 / 修复
- 配置与权限收口
- gateway / LaunchAgent 修复
- 桌面快捷方式
- Telegram 诊断
- ASR / TTS / Telegram 语音诊断
- Telegram 文件 / 媒体 / 语音发送诊断
- 维护后复盘建议

### 当前边界
- 微信在 v0.1 仅支持 **lite diagnosis**
- 自我进化仅为 **建议模式**，不做自治自改
- issue intelligence 只用于复杂 / 模糊故障，不是每个小毛病都联网查一遍

---

## 仓库结构

```text
openclaw-skyfix/
├── README.md
├── README.zh-CN.md
├── LICENSE
├── CHANGELOG.md
├── dist/
│   └── skyfix.skill
└── skill/
    └── skyfix/
        ├── SKILL.md
        ├── references/
        └── scripts/
```

---

## 安装方式

### 方式 A：直接下载打包 skill
1. 打开 **Releases**
2. 下载 `skyfix.skill`
3. 用你平时的 OpenClaw skill 导入 / 安装方式装进去

### 方式 B：直接使用展开目录
在本地开发或本地 skill 场景下，直接使用：

- `skill/skyfix/`

---

## 典型使用说法

- `帮我把这台机器的 OpenClaw 装好`
- `修一下 OpenClaw，并把配置收口`
- `把这台 Mac 的 gateway / LaunchAgent 修一下`
- `看看 Telegram 为什么发不出去`
- `检查语音回复链路到底缺了什么`
- `去 em2t 上把 OpenClaw 收口`

---

## 公开发布姿态

这个仓库是 `skyfix` 的**公开产品面**。
它比私有开发工作区更窄、更干净。

也就是说，这里只放：
- 可以公开的 skill 本体
- 面向公开用户的文档
- release 安装包

不会放：
- 个人记忆文件
- 无关项目
- 私有节点信息
- token / 密钥 / 机器凭证

---

## 版本策略

当前公开起点：

- **v0.1.0** —— 首个公开版本

为什么不是 `v1.0.0`？
因为它已经能用，也已经过真机验证；
但它还不是整个维护产品的最终形态。

这不是不自信，这是专业。

---

## License

当前仓库使用 MIT License。
如果后续公开策略变化，可以再调整。

---

## Release Notes

见：
- [`CHANGELOG.md`](./CHANGELOG.md)
- [`releases/v0.1.0.md`](./releases/v0.1.0.md)

---

## Maintainer Note

这个项目不是 demo，也不是炫技样品。
它是按“真实操作者工具”在打磨的。
如果你要用它，就把它丢进真实机器问题里，再像个成年人一样验收结果。
