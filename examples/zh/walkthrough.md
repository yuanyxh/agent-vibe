# 一次完整生长

示例项目：一个本地记账命令行工具。仅用于展示流程，不代表推荐技术栈。

## 1. 加载 init

用户：帮我从零做一个记账工具。

Agent 读取 `seeds/zh/skills/init/SKILL.md`，探测目录为空，开始提问。

## 2. 第一轮：定位

| 问题 | 推荐 | 用户回答 |
| --- | --- | --- |
| 项目名 | ledger | 采用 |
| 一句话 | 本地记录与统计日常收支 | 采用 |
| 形态 | cli | 采用 |
| 规模 | mvp | 采用 |

## 3. 第二轮：技术栈

Agent 依据 `project.type = cli` 给出语言与包管理器选项。用户选择推荐值。

## 4. 后续轮次

按问题树补齐数据、交付、质量与 Agent 平台。用户对每轮回答“按推荐”。

## 5. 摘要确认

Agent 输出全部字段与来源，用户只修改一处：不需要 CI。其余确认。

## 6. 生长

按 `protocols/zh/grow.md` 生成（落点以 Claude Code 适配器为例）：

```text
ledger/
├── <项目正常结构>
├── AGENTS.md
├── .claude/
│   ├── skills/{build,review,hunt,learn,upgrade,ship,operate}/SKILL.md
│   └── rules/{core,build,review,deploy}.md
└── .agent/
    ├── profile.yaml
    ├── status.md
    ├── decisions.md
    └── lessons.md
```

命中规则：core 全部；`by-type/cli`；`by-concern/testing`。未命中：`deploy` 因部署目标为 none，`ui` 因无界面。

## 7. 校验

执行 `protocols/zh/verify.md`：路径齐全、无占位符、构建与测试命令通过、契约包含四项索引。

## 8. 后续循环

- 实现一条命令：加载 `build`。
- 发现金额精度错误：加载 `hunt`，补回归测试。
- 合并前：加载 `review`。
- 复盘：加载 `learn`，项目教训写入 `.agent/lessons.md`。
- 依赖过期：加载 `upgrade`。
- 发布新版本：加载 `ship`。
