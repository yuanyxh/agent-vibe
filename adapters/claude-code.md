---
id: adapter/claude-code
applies_when: { agent.platform: claude-code }
---

# Claude Code 适配

## 落点

| 逻辑产物 | 目标位置 |
| --- | --- |
| `skill/<name>` | `.claude/skills/<name>/SKILL.md` |
| `rule/always` | 内联进 `CLAUDE.md`，不单独成文件 |
| `rule/path` | `.claude/rules/<name>.md`，头部只有 `paths` |
| `rule/skill` | `.agent/rules/<name>.md`，由对应技能正文指向 |
| `rule/read` | `.agent/rules/<name>.md`，契约索引标记降级 |
| `contract` | `CLAUDE.md` |
| `state/<name>` | `.agent/<name>.md`（`state/profile` 为 `.agent/profile.yaml`，`state/memory` 为 `.agent/memory/README.md`） |
| `project/root` | 项目根目录 |
| 权限与钩子 | `.claude/settings.json` |

## 技能格式

`SKILL.md` 使用以下头部：

```yaml
---
name: <kebab-case>
description: 何时触发，包含用户可能的说法
---
```

正文首段写目标与完成条件，随后写步骤、产物与禁止事项。技能内引用的其他文件使用相对路径，并说明加载时机。

种子头部的 `id`、`kind`、`version`、`updated`、`review_by`、`status`、`load`、`load_via`、`path_scope`、`skills`、`trigger`、`summary`、`applies_when`、`requires`、`grow`、`emits`、`verify` 只用于生长时匹配，**不得写入目标文件**。目标 `SKILL.md` 只保留 `name` 与 `description`；路径规则只保留平台字段 `paths`，其余规则只写正文。

## 规则格式

- `rule/always`：合并内联到 `CLAUDE.md`，每条压成一行摘要（编号 + 行为 + 禁止项），总行数 ≤ 60；完整正文不进项目。
- `rule/path`：写入 `.claude/rules/<name>.md`，YAML 头部只允许 `paths`，值为 glob 列表。
- `rule/skill`：写入 `.agent/rules/<name>.md`，由技能正文要求执行前读取。
- `rule/read`：写入 `.agent/rules/<name>.md`，在契约索引标记 `degraded`。

`.claude/rules/` 中**没有 `paths` 的文件会在每次会话加载**。因此除核心外不得生成无范围规则；核心已经内联，不再生成 `core.md`。

## 启动契约

`CLAUDE.md` 必须包含：

1. 项目一句话、形态、技术栈与质量预算。
2. 加载策略：内容、层级、触发条件、实际机制。
3. 技能索引：名称与触发条件。
4. 工作循环与验证命令。
5. 运行时约定：自检、事实优先、授权边界、输出、文件、工具、记忆、平台中立。
6. 自学习位置与断点规则。

契约只写索引与摘要，不复制规则、画像、状态、决策或技能正文。

## 资产盘点

只读名称与描述，不复制内容，不记录个人路径。

| 范围 | 位置 |
| --- | --- |
| 项目 | `.claude/skills/`、`.claude/rules/`、`.claude/agents/`、`.claude/commands/`、`.claude/settings.json`、`CLAUDE.md` |
| 用户 | `~/.claude/skills/`、`~/.claude/agents/`、`~/.claude/CLAUDE.md` |
| 插件与工具 | 已安装插件、MCP 服务列表 |

冲突时以项目规则和用户当前说明为准；第三方内容默认不采纳。

## 加载策略

| 层 | 机制 | 触发 |
| --- | --- | --- |
| L0 | `CLAUDE.md` | 每次会话 |
| L1 | `.claude/rules/*.md` 的 `paths` | 操作匹配文件时自动加载 |
| L2 | `.claude/skills/*/SKILL.md` 正文读取 `.agent/rules/*.md` | 技能被调用时 |
| L3 | 契约索引指向 `.agent/` 文件 | 命中触发时显式读取 |

- 禁止用 `@import` 引入按需规则；导入内容与引用文件同时加载。
- 常驻总量控制在 200 行以内；超出时把低频内容降到 L1~L3。
- 技能 `description` 只写触发条件，正文写步骤与要读取的规则路径。
- 生成后用 `/context` 核对 Memory files，用 `InstructionsLoaded` 钩子核对懒加载原因。
- `status` 非 `active` 的规则不生成；`review_by` 过期先按 `protocols/evolve.md` 复核。
