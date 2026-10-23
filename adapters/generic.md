---
id: adapter/generic
applies_when: { agent.platform: "generic|codex" }
---

# 通用 Agent 适配

适用于支持 `AGENTS.md` 约定的 Agent。

## 落点

| 逻辑产物 | 目标位置 |
| --- | --- |
| `rule/always` | `AGENTS.md` 内联，≤ 60 行 |
| `rule/path` | 子目录 `AGENTS.md`（平台支持层级读取时）；否则 `.agent/rules/<name>.md` + 索引 |
| `rule/skill` | `.agent/rules/<name>.md`，由技能正文指向 |
| `rule/read` | `.agent/rules/<name>.md`，契约索引标记 `degraded` |
| `skill/<name>` | `.agent/skills/<name>/SKILL.md` |
| `contract` | `AGENTS.md` |
| `state/<name>` | `.agent/<name>.md`（`state/profile` 为 `.agent/profile.yaml`，`state/memory` 为 `.agent/memory/README.md`） |
| `project/root` | 项目根目录 |

## 加载策略

| 层 | 机制 | 触发 |
| --- | --- | --- |
| L0 | `AGENTS.md` 内联 | 每次会话 |
| L1 | 子目录 `AGENTS.md` | 进入该目录时 |
| L2 | `.agent/skills/*/SKILL.md` 正文读取 `.agent/rules/*.md` | 技能被调用时 |
| L3 | 契约索引指向 `.agent/` 文件 | 命中触发时显式读取 |

- 平台支持层级 `AGENTS.md` 时用 L1；不支持时 L1 降级为索引 + 读取，并在契约中标记。
- 没有原生机制的内容不得写成“自动加载”，必须写明读取动作。
- `AGENTS.md` ≤ 200 行，核心内联 ≤ 60 行，单个按需规则 ≤ 120 行。
- 种子元数据不写入目标规则文件。`status` 非 active 或 `review_by` 过期的规则不生成。

## 资产盘点

只读名称与描述，不复制内容，不记录个人路径。

| 范围 | 位置 |
| --- | --- |
| 项目 | `AGENTS.md`、`.agent/skills/`、`.agent/rules/`、平台 MCP 配置 |
| 用户 | 用户级技能与规则 |
| 插件与工具 | 平台列出的技能包与 MCP 工具 |

冲突时以项目规则和用户当前说明为准；第三方内容默认不采纳。

## 契约要求

`AGENTS.md` 顶部写明项目一句话、形态与技术栈，随后给出：

1. 规则文件索引与加载时机。
2. 技能目录索引与触发条件。
3. 工作循环与验证命令。
4. 运行时约定：自检、事实优先、授权边界、输出、文件、工具、记忆、平台中立。
5. 断点规则。
6. 自学习文件位置。

若 Agent 支持按目录自动发现技能，`.agent/skills/` 可直接生效；否则在契约中列出每个技能的路径，要求按需读取。

## 限制

不同 Agent 的上下文注入机制不同，规则文件必须自包含，不假设自动加载。
