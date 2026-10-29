---
id: adapter/codex
applies_when: { agent.platform: codex }
---

# Codex 适配

## 落点

| 逻辑产物 | 目标位置 |
| --- | --- |
| `skill/<name>` | `.agents/skills/<name>/SKILL.md` |
| `rule/always` | 内联进 `AGENTS.md`，≤ 60 行 |
| `rule/path` | 子目录 `AGENTS.md`；当前版本不支持层级读取时降级为 `.agent/rules/<name>.md` + 索引 |
| `rule/skill` | `.agent/rules/<name>.md`，由技能正文指向 |
| `rule/read` | `.agent/rules/<name>.md`，契约索引标记 `degraded` |
| `contract` | `AGENTS.md` |
| `state/<name>` | `.agent/<name>.md`（`state/profile` 为 `.agent/profile.yaml`，`state/memory` 为 `.agent/memory/README.md`） |
| `project/root` | 项目根目录 |

## 技能格式

`SKILL.md` 头部只保留：

```yaml
---
name: <kebab-case>
description: 何时触发，包含用户可能的说法
---
```

正文首段写目标与完成条件，随后写步骤、产物、要读取的规则路径与禁止事项。种子元数据全部剥离。

技能通过 `$<name>` 显式调用，也可由描述触发。安装到项目时保留完整技能目录；只复制 `SKILL.md` 会丢失引用资源。

## 加载策略

| 层 | 机制 | 触发 |
| --- | --- | --- |
| L0 | `AGENTS.md` 内联 | 每次会话 |
| L1 | 子目录 `AGENTS.md` | 进入该目录时；不支持则降级 |
| L2 | `.agents/skills/*/SKILL.md` 正文读取 `.agent/rules/*.md` | 技能被调用时 |
| L3 | 契约索引指向 `.agent/` 文件 | 命中触发时显式读取 |

- `.agents/skills/` 不可用时退回 `.agent/skills/`，并在契约中标记 `degraded`。
- 没有原生机制的内容必须写明读取动作，不得写成“自动加载”。
- `AGENTS.md` ≤ 200 行，核心内联 ≤ 60 行，单个按需规则 ≤ 120 行；核心块用 `<!-- core:start -->` 与 `<!-- core:end -->` 包裹。

## 资产盘点

只读名称与描述，不复制内容，不记录个人路径。

| 范围 | 位置 |
| --- | --- |
| 项目 | `AGENTS.md`、`.agents/skills/`、`.agent/rules/`、项目级 MCP 配置 |
| 用户 | `~/.agents/skills/`、`~/.codex/config.toml` |
| 插件与工具 | 平台列出的技能包与 MCP 服务 |

冲突时以项目规则和用户当前说明为准；第三方内容默认不采纳。

## 限制

不同版本的技能目录、层级 `AGENTS.md` 与 MCP 配置位置可能不同。生成前查证当前版本；无法确认时按降级路径写入并标注，不假设自动加载。
