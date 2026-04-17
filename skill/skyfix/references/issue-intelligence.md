# issue-intelligence

适用场景：
- 本地日志看不清根因
- 修了几轮仍然不收口
- 怀疑是 OpenClaw 已知问题、版本问题、社区常见问题

## 优先脚本
- `../scripts/collect_issue_intelligence.sh`

## 触发规则
不要默认每次都查外部资料。

只在以下情况触发：
- 本地信号冲突
- 本地修复无效
- 故障症状明显像上游已知问题
- 涉及特定版本兼容 / 平台 API / 渠道怪异行为

## 搜索源
优先顺序：
1. 本地 docs
2. OpenClaw troubleshooting / FAQ / 官方文档
3. GitHub issues
4. 社区 / 讨论 / 已知故障线索

可以先用脚本生成搜索入口，再做人类判断：
```bash
bash scripts/collect_issue_intelligence.sh "openclaw telegram voice issue"
```

## 输出形式
不要把搜索结果倾倒给用户。

要转译成：
- 当前最可能的 1-3 个假设
- 每个假设的验证方法
- 优先修复顺序
- 哪些证据支持这个判断

## 原则
- 目标是缩短诊断路径，不是证明你会搜
- 先讲判断，再讲证据，不要反过来
