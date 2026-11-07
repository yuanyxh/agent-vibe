# golden

Web 管理后台，提供登录后的业务操作。

<!-- core:start -->
- 开始任务前只读本文件与 `.agent/status.md`。
- 事实优先；不确认就不提交、不推送。
- 不越权修改用户文件。
<!-- core:end -->

## 加载策略

| 内容 | 层 | 触发 | 机制 |
| --- | --- | --- | --- |
| 常驻底线 | L0 | 每次会话 | 本文件 |
| 界面规则 | L1 | 编辑 `src/ui/**` | `.claude/rules/ui.md` 的 `paths` |
| 工程规则 | L2 | 调用 `build` | 技能正文读取 `.agent/rules/engineering.md` |
| 状态与领域 | L3 | 命中触发 | `.agent/` 显式读取 |
| agent 体检 | L3 | 体检到期或行为冲突 | `.agent/agent-health.md` |
| 隔离验证 | L3 | 集成或 E2E 前 | `.agent/sandbox.md` |

## 技能索引

- `build`：开发、修改与继续实现。
- `learn`：沉淀经验、复盘、架构/反模式/死代码检查。
- `steward`：agent 环境体检与腐化整理。
- `sandbox`：集成或 E2E 的隔离环境。

## 工作循环

开始任务前只读本文件与 `.agent/status.md`。缺陷修复、发布、重构或用户修正后运行 `learn`；按节奏运行 `steward`；集成或 E2E 前运行 `sandbox`，不得触碰生产。

## 验证

- 构建：`true`
- 测试：`true`
