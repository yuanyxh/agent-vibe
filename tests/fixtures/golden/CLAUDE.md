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

## 技能索引

- `build`：开发、修改与继续实现。

## 工作循环

开始任务前只读本文件与 `.agent/status.md`。

## 验证

- 构建：`true`
- 测试：`true`
