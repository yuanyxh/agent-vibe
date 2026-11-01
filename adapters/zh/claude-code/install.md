---
id: adapter/claude-code-install
applies_when: { agent.platform: claude-code }
---

# Claude Code 安装

种子仓库本身不直接运行。fork 到目标项目后，先把入口技能安装到 Claude Code 能自动触发的位置。

## 步骤

1. 创建 `.claude/skills/init/`。
2. 复制 `seeds/zh/skills/init/SKILL.md`，只保留 `name` 与 `description` 头部，正文保持不变。
3. 确认 `.claude/skills/init/SKILL.md` 存在，且 `description` 包含“开始”“开工”“我想做”“帮我做一个”等自然语言。
4. 生成 `CLAUDE.md` 启动契约，第一条写明：缺少 `.agent/profile.yaml` 时先执行 init。
5. 启动新会话，输入“我要做一个 X”，确认 init 被加载并开始提问。

## 为什么

`seeds/zh/skills/` 是抽象种子，平台不会自动发现。只有位于 `.claude/skills/` 时才由 `description` 触发。未安装时，模型可能直接进入技术选型或编码。

## 安装后自检

- 不提供画像时，agent 不得直接选技术栈。
- 提问覆盖定位、领域、环境、交付、质量、治理、供应链。
- 生成前输出完备性检查表。

## 其他平台

Cursor 与通用 `AGENTS.zh.md` 的落点见对应适配器；核心要求相同：入口必须位于平台能发现的位置。
