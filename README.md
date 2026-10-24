# agent-vibe

一个与具体技术、具体项目无关的 Agent 开发种子仓库。fork 它，加载 `init`，agent 会问完项目画像，然后把规则、技能与项目结构实例化到你所用 Agent 的标准位置。

## 它不是什么

- 不是脚手架集合：不预置 React、Spring 或 Flutter 的代码。
- 不是规则文档库：规则以种子形式存在，按项目画像筛选后才落地。
- 不是运行时框架：仓库本身不被执行。

## 它是什么

- `seeds/`：抽象种子。原则、能力、规则、技能、问题树与结构要求，全部与技术和平台无关。
- `seeds/capabilities/`：能力定义。说明要保证什么、何时触发、要问什么、要查什么、如何验证；具体产物在上下文确定后生成。记忆能力只定义协议与降级，不内置任何记忆内容。
- `seeds/domains/`：领域定义规范。领域是开放集合，项目初始化时按上下文生成；`examples/domains/` 提供写法参考。
- `seeds/knowledge/`：通用架构知识包。鉴权、权限、缓存、队列、文件、通知、一致性、时区、导入导出、PDF、更新、配置、测试、组件、部署、可观测性、系统定义；按主题加载，不整册注入。
- `protocols/`：生长、提炼、校验、演进、加载、研究、环境探测与记忆协议。规则带生命周期与加载方式，按平台能力按需加载。
- `adapters/`：平台映射。把种子写到 Claude Code、Cursor 或通用 `AGENTS.md` 的约定位置。
- `packs/`：可选技术包。核心仓库留空；需要固定某技术栈的项目结构时再自行添加。

## 能力手册

每项能力做什么、什么时候触发、用了会得到什么：见 [CAPABILITIES.md](CAPABILITIES.md)。

## 三步开始

1. fork 或复制本仓库到你的新项目目录。
2. 按 `adapters/<你的平台>/install.md` 安装入口技能，让平台能自动触发 `init`。
3. 对 agent 说“我要做一个 X”或“开始”。`init` 会逐轮提问，直到画像与领域必问项完备。
4. 确认画像后，agent 在目标目录生成工程基座：项目骨架、工程化配置、`.agent/`、规则、技能与启动契约。
5. 你确认基座后，init 结束。后续功能开发在目标项目目录执行 `build`，不在种子仓库内进行。

## 生成后你会得到

以 Claude Code 为例；其他平台的落点见 `adapters/`。

```
<project>/
├── <项目正常结构>              # 按画像生成
├── CLAUDE.md                   # 启动契约：常驻底线 + 加载索引
├── .claude/
│   ├── skills/                 # 技能正文，按需触发
│   └── rules/                  # 仅带 paths 的路径规则
└── .agent/
    ├── profile.yaml            # 项目画像
    ├── research.md             # 最佳实践研究简报
    ├── rules/                  # 任务型规则，由技能读取
    ├── status.md               # 单一事实源
    ├── decisions.md            # 决策日志
    └── lessons.md              # 自学习沉淀
```

常驻只有 `CLAUDE.md`；其余按路径、技能或显式读取进入上下文，规则见 `protocols/loading.md`。`.agent/` 是平台无关的状态目录，所有平台共用；其余路径由适配器决定。

## 后续循环

| 场景 | 加载 |
| --- | --- |
| 日常开发 | `build` |
| 缺陷排查 | `hunt` |
| 变更审查 | `review` |
| 经验沉淀 | `learn` |
| 依赖与框架升级 | `upgrade` |
| 发布 | `ship` |
| 运行期维护 | `operate` |

## 维护种子

新增能力只需新增种子，不改目录结构。规则见 `protocols/`。改动后执行 `scripts/verify-seeds.sh`；首次 clone 后执行 `git config core.hooksPath .githooks`，提交前自动校验。
