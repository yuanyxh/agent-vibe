---
id: adapter/cursor
applies_when: { agent.platform: cursor }
---

# Cursor 适配

## 落点

| 逻辑产物 | 目标位置 |
| --- | --- |
| `rule/always` | `.cursor/rules/core.mdc`，`alwaysApply: true`，≤ 60 行 |
| `rule/path` | `.cursor/rules/<name>.mdc`，`alwaysApply: false` + `globs` |
| `rule/skill` | `.agent/rules/<name>.md`，由对应 command 正文指向 |
| `rule/read` | `.agent/rules/<name>.md`，契约索引标记 `degraded` |
| `skill/<name>` | `.cursor/commands/<name>.md` |
| `contract` | `AGENTS.md` |
| `state/<name>` | `.agent/<name>.md`（`state/profile` 为 `.agent/profile.yaml`，`state/memory` 为 `.agent/memory/README.md`） |
| `project/root` | 项目根目录 |

## 规则文件头部

```yaml
---
description: <何时加载>
globs: <相关文件范围，可省略>
alwaysApply: <true 仅用于 core>
---
```

按种子头部映射：`load_via=path` → `alwaysApply: false` + `globs`；`load_via=skill` 或 `read` → 不生成 `.mdc`，由 command 或契约索引读取。只有核心使用 `alwaysApply: true`，且合并为单个文件。

`description` 写触发条件，`globs` 写文件范围；两者必须至少有一个，否则视为常驻，禁止用于非核心。种子元数据本身不写入目标文件。`status` 非 active 或 `review_by` 过期的规则不生成。`AGENTS.md` 中的核心内联块用 `<!-- core:start -->` 与 `<!-- core:end -->` 包裹，块内 ≤ 60 行。

## 技能处理

Cursor 没有与 Skill 等价的原生机制。技能正文写入 `.cursor/commands/<name>.md`，在正文首段写明执行前要读取的 `.agent/rules/*.md`，并在 `AGENTS.md` 中列出触发条件。命令机制不可用时，在契约中标记 `degraded`。

## 资产盘点

只读名称与描述，不复制内容，不记录个人路径。

| 范围 | 位置 |
| --- | --- |
| 项目 | `.cursor/rules/`、`.cursor/commands/`、`.cursor/mcp.json`、`AGENTS.md` |
| 用户 | 用户级规则与命令 |
| 插件与工具 | 已安装扩展与 MCP 服务 |

冲突时以项目规则和用户当前说明为准；第三方内容默认不采纳。

## 预算

- `AGENTS.md` ≤ 200 行。
- `core.mdc` ≤ 60 行。
- 单个按需规则 ≤ 120 行。
- 禁止把所有规则设为 `alwaysApply: true`。

## 限制

`globs` 只能约束文件范围，不能表达任务阶段；任务型规则交由 command 读取，并在契约中标注机制。
