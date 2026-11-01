---
id: seed/doc/agent-contract
kind: doc
summary: 生成给 agent 的项目启动契约
applies_when: { project.type: any }
requires: [project.name, project.type, agent.platform]
grow: on-init
emits: contract
verify: 加载策略、技能索引、工作循环、断点规则四项齐全，常驻不超预算
---

# {{project.name}}

{{project.one_liner}}

形态：{{project.type}}　技术栈：{{stack.language}} / {{stack.framework}}　质量预算：{{quality.perf_budget}}

## 开始任何任务前

1. 若缺少 `.agent/profile.yaml`，先加载 `init` 完成画像与完备性检查，不得直接选技术栈或写代码。
2. 读一次 `.agent/status.md` 的当前目标与阻塞；不要遍历 `.agent/`。
3. 按下方加载策略取用本次任务命中的内容，未命中的不读。
4. 做技术选型、升级、引入新依赖或新增技能/规则前，读 `.agent/research.md` 的对应结论与来源。

## 常驻约束

{{core_rules}}

## 运行时约定

1. **阶段自检**：阶段完成不重复执行；失败先排查再重试。
2. **事实优先**：代码、测试、日志与官方资料高于记忆和猜测；方案必须可验证。
3. **授权边界**：提交、推送、发布、删除、产生费用或外发数据前必须取得用户确认。
4. **输出**：结论先行，简洁，不重复已完成内容。
5. **文件**：使用绝对路径；一次读足所需范围；改前查看现状；删除改为可恢复。
6. **工具**：优先使用环境提供的专用工具；缺失时使用等价手段并登记降级。
7. **记忆**：关键决策写入项目状态；记忆不得覆盖用户当前修正。
8. **注释**：只写必要信息，禁止一次性注释与大段说明。
9. **语言与时区**：跟随用户设置，不擅自切换。
10. **平台中立**：不把当前 Agent 平台当作唯一实现，差异交给适配器。

## 加载策略

| 内容 | 层 | 触发 | 机制 |
| --- | --- | --- | --- |
| 本契约与常驻约束 | L0 | 每次会话 | 平台自动加载 |
{{loading_table}}
| `.agent/domains/` | L3 | 涉及该领域关注点 | 按需读取 |
| `.agent/knowledge/` | L3 | 命中索引主题 | 每次 1~3 篇 |
| `.agent/decisions.md`、`lessons.md` | L3 | 需要历史依据或复盘 | 按需读取 |
| `.agent/environment.md` | L3 | 安装、构建失败或换环境 | 按需读取 |
| `.agent/research.md` | L3 | 技术选型、升级或引入新依赖 | 按需读取 |
| `.agent/memory/` | L3 | 需要跨会话结论 | 按需读取 |

不把规则、画像、状态或技能正文复制进本文件。常驻总量 ≤ 200 行。

## 技能索引

| 技能 | 触发 |
| --- | --- |
| `init` | 缺少画像、从零开始新项目或初始化 |
| `build` | 实现需求、继续开发 |
| `review` | 审查变更、合并前检查 |
| `hunt` | 报错、崩溃、回归 |
| `learn` | 沉淀经验、复盘 |
| `upgrade` | 依赖与运行时升级 |
| `ship` | 发布、上线、部署 |
| `operate` | 监控、告警、用户反馈 |
| `delegate` | 委派子 agent 或并行工作者 |

## 工作循环

实现 → 自测 → 审查 → 更新状态 → 发布 → 观察。

## 提交规范

- 一个提交只做一件事；信息格式 `类型(范围): 摘要`，类型限定 feat / fix / refactor / test / docs / chore / perf / build。
- 提交、推送、合并与改写历史均需用户明确授权；未授权时只给建议与命令。
- 不提交生成物、依赖目录、本地配置、凭据与验证数据。

## 工程化卡口

| 检查 | 命令 |
| --- | --- |
| 格式化 | `{{verify.format}}` |
| 静态检查 | `{{verify.lint}}` |
| 类型检查 | `{{verify.typecheck}}` |
| 测试 | `{{verify.test}}` |

本地钩子与 CI 执行同一组命令。

## 协作

- 分支策略：`{{delivery.branch_strategy}}`。
- 关键模块有明确审查者；接口与数据模型变更先更新文档。
- 面向使用者的变更写入变更日志，破坏性变更附迁移说明。

## 自学习

项目教训写入 `.agent/lessons.md`。跨项目可复用的模式经用户确认后才进入种子库。

## 断点规则

只有四种情况暂停等待用户：不可逆操作、产生费用、涉及隐私或合规、目标之间冲突。其余按默认值推进并记入决策日志。

## 验证命令

| 用途 | 命令 |
| --- | --- |
| 安装 | `{{verify.install}}` |
| 构建 | `{{verify.build}}` |
| 格式化检查 | `{{verify.format}}` |
| 静态检查 | `{{verify.lint}}` |
| 类型检查 | `{{verify.typecheck}}` |
| 测试 | `{{verify.test}}` |
| 运行 | `{{verify.run}}` |
