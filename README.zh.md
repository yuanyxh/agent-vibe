# agent-vibe

[![种子校验](https://github.com/yuanyxh/agent-vibe/actions/workflows/seed-check.yml/badge.svg?branch=main)](https://github.com/yuanyxh/agent-vibe/actions/workflows/seed-check.yml)
[![许可证: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![种子版本](https://img.shields.io/badge/seeds-1.4.0-informational)](SEEDS_VERSION)

[English](README.md) | 中文

一个与具体技术、具体项目无关的 Agent 开发种子仓库。fork 它，加载 `init`，agent 会先问完项目画像，再把规则、技能与项目结构实例化到你所用 Agent 平台的标准位置。

## 为什么

多数 Agent 配置从一堆提示词和「写干净的代码」开始。这个顺序产出的上下文要么太大，要么太具体，要么来得太晚。

agent-vibe 把顺序倒过来：先画像，再种子，最后才是项目。项目画像决定哪些规则、能力、领域定义与知识包值得加载，其余内容在需要之前不进入上下文。

## 它不是什么

- 不是脚手架集合：不预置现成的应用代码。
- 不是规则文档库：规则以种子形式存在，按项目画像筛选后才落地。
- 不是运行时框架：仓库本身不被执行。

## 它是什么

| 区域 | 作用 |
| --- | --- |
| `seeds/zh/` | 抽象种子：原则、能力、规则、技能、问题树与结构要求，全部与具体技术、平台无关。 |
| `seeds/zh/` | 同一批种子的中文镜像；生成时以 `seeds/en/` 为准。 |
| `seeds/zh/capabilities/` | 能力定义：要保证什么、何时触发、要问什么、要查什么、如何验证。具体产物在上下文确定后生成。 |
| `seeds/zh/domains/` | 领域定义规范与高频参考领域。领域是开放集合：命中参考定义则复用，未命中时按上下文生成。 |
| `seeds/zh/knowledge/` | 通用架构知识包：鉴权、权限、缓存、队列、文件、通知、一致性、时区、导入导出、PDF、更新、配置、测试、组件、部署、可观测性、系统定义。按主题加载，不整册注入。 |
| `protocols/zh/` | 生长、提炼、校验、演进、升级、加载、研究、环境探测、记忆与计划协议。规则带生命周期与加载方式。 |
| `adapters/zh/` | 平台映射：把种子写到 Claude Code、Cursor、Codex 或通用 `AGENTS.md` 的约定位置。 |
| `packs/` | 可选技术包。核心仓库不内置；需要固定某技术栈时自行添加。 |
| `examples/zh/` | 完整示例与领域示例，不被 `init` 读取。 |

`protocols/`、`adapters/`、`examples/`、`packs/`、`seeds/` 下均提供 `en/` 与 `zh/` 两个版本；生成时以 `en/` 为权威。根目录文档改用语言后缀区分：`README.md` 与 `README.zh.md`。

## 三步开始

1. fork 或复制本仓库到你的新项目目录。
2. 按 `adapters/zh/<你的平台>/install.md` 安装入口技能，让平台能自动触发 `init`。
3. 对 agent 说“我要做一个 X”或“开始”。`init` 会逐轮提问，直到画像与领域必问项完备。
4. 确认画像后，agent 在目标目录生成工程基座：项目骨架、工程化配置、`.agent/`、规则、技能与启动契约。
5. 你确认基座后，init 结束。后续功能开发在目标项目目录执行 `build`，不在种子仓库内进行。

## 仓库结构

```text
agent-vibe/
├── README.md / README.zh.md
├── CAPABILITIES.md / CAPABILITIES.zh.md
├── AGENTS.md / AGENTS.zh.md
├── CHANGELOG.md / CHANGELOG.zh.md
├── CONTRIBUTING.md / CONTRIBUTING.zh.md
├── SECURITY.md / SECURITY.zh.md
├── LICENSE
├── SEEDS_VERSION
├── seeds/
│   ├── en/                  # 权威种子
│   ├── zh/                  # 中文镜像
│   └── scaffolds/           # 平台无关的钩子与模板
├── protocols/{en,zh}/
├── adapters/{en,zh}/
├── examples/{en,zh}/
├── packs/{en,zh}/
├── scripts/                 # 仓库自检工具，不进入种子产物
├── tests/                   # 实例化校验的 golden fixture
└── .github/                 # CI 与社区模板
```

## 能力手册

每项能力做什么、什么时候触发、用了会得到什么：见 [CAPABILITIES.zh.md](CAPABILITIES.zh.md)。

## 生成后你会得到

以 Claude Code 为例；其他平台的落点见 `adapters/zh/`。

```text
<project>/
├── <项目正常结构>              # 按画像生成
├── .githooks/{pre-commit,commit-msg}  # 提交前检查与提交信息校验
├── .github/PULL_REQUEST_TEMPLATE.md   # GitHub 项目的合并前清单
├── CLAUDE.md                   # 启动契约：常驻底线 + 加载索引
├── .claude/
│   ├── skills/                 # 技能正文，按需触发
│   ├── hooks/                  # 维护提醒脚本
│   ├── settings.json           # 钩子注册与权限
│   └── rules/                  # 仅带 paths 的路径规则
└── .agent/
    ├── profile.yaml            # 项目画像，含 seed_version
    ├── research.md             # 最佳实践研究简报
    ├── agent-health.md         # agent 环境体检报告
    ├── sandbox.md              # 隔离方案与证据
    ├── .maintenance-state      # 维护节流状态
    ├── rules/                  # 任务型规则，由技能读取
    ├── memory/                 # INDEX.md 索引 + 主题文件
    ├── plans/                  # _template.md 与按需创建的单任务计划
    ├── status.md               # 单一事实源
    ├── backlog.md              # 未排期与延后工作的队列
    ├── upgrades.md             # 依赖扫描与升级推荐
    ├── decisions.md            # 决策日志
    └── lessons.md              # 自学习沉淀
```

常驻只有 `CLAUDE.md`；其余按路径、技能或显式读取进入上下文，规则见 `protocols/zh/loading.md`。`.agent/` 是平台无关的状态目录，所有平台共用；其余路径由适配器决定。

## 后续循环

| 场景 | 加载 |
| --- | --- |
| 日常开发 | `build` |
| 缺陷排查 | `hunt` |
| 变更审查 | `review` |
| 经验沉淀与代码健康 | `learn` |
| agent 环境体检 | `steward` |
| 隔离的集成与 E2E 验证 | `sandbox` |
| 并行子任务 | `delegate` |
| 依赖与框架升级 | `upgrade` |
| 发布 | `ship` |
| 运行期维护 | `operate` |

## 种子版本

- 种子仓库版本见 `SEEDS_VERSION`，变更记录见 `CHANGELOG.zh.md`；生成项目在 `.agent/profile.yaml` 记录 `seed_version`，按 `protocols/zh/upgrade-seeds.md` 升级。
- 外部规则库只作人工补充来源，不自动同步；导入内容先去掉项目细节，再按种子格式重写。

## 贡献

见 [CONTRIBUTING.zh.md](CONTRIBUTING.zh.md)。提交合并请求前执行：

```bash
scripts/check-format.sh
scripts/verify-seeds.sh --strict
scripts/test-fixtures.sh
```

CI 在推送与合并请求时执行同一组检查。

## 许可证

[MIT](LICENSE)
