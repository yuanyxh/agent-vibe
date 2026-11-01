# agent-vibe 仓库约定

本仓库是种子仓库，不直接作为业务项目运行。

## 目录职责

- `README.zh.md`：面向使用者的入口；只写上手步骤与产物结构。
- `CAPABILITIES.zh.md`：能力导航；只写有什么、何时用、得到什么，不复制协议细节。
- `seeds/zh/`：与 `seeds/zh/` 对应的中文镜像。结构与语义必须与英文侧保持一致。
- `seeds/zh/`：权威抽象内容。不得出现具体项目名、路径、账号、密钥、技术版本号；生成与校验以英文侧为准。
- `seeds/zh/capabilities/`：能力定义，只写触发、问题、研究项、产物类别与验证标准；不写具体产品配置。记忆能力只写协议、分层与降级，不写入任何记忆内容。
- `seeds/zh/domains/`：领域定义规范（`_schema.md`）与高频参考定义。领域是开放集合；未命中参考定义时现场生成，`examples/zh/domains/` 仅为写法参考。
- `seeds/zh/knowledge/`：通用架构知识包与索引。只写问题、模式、取舍、验证与反例，不写具体项目实现；按主题加载。
- `protocols/zh/`：生长、提炼、校验、演进、升级、加载、研究、环境探测与记忆协议。改动协议需同步更新 `adapters/`。
- `adapters/zh/`：平台落点映射，覆盖 Claude Code、Cursor、Codex 与通用平台，只描述位置与格式转换，不承载业务内容。
- `SEEDS_VERSION`、`CHANGELOG.md`：种子仓库对外版本与变更记录；生成项目的 `seed_version` 与升级依据。
- `tests/`：实例化校验的 golden fixture；`.github/`：推送与合并请求的种子校验。
- `packs/`：可选技术包，由 fork 后自行添加；核心仓库不内置任何技术包。
- `scripts/`：仓库自检工具（格式、种子、实例化）；不进入种子产物。
- `.githooks/`：提交前检查入口；只调用 `scripts/`，不承载规则内容。
- `examples/zh/`：完整实例示例，可含具体技术栈，但不被 init 读取。

## 语言布局

- 目录按语言分层：`protocols/{en,zh}/`、`adapters/{en,zh}/`、`examples/{en,zh}/`、`packs/{en,zh}/`、`seeds/{en,zh}/`。
- 根目录文档按语言后缀区分：`README.md` 与 `README.zh.md`，`CAPABILITIES`、`AGENTS`、`CHANGELOG`、`CONTRIBUTING`、`SECURITY` 同理。
- `seeds/en/` 是生成与校验的权威来源；`seeds/zh/` 是面向人的镜像。
- 语言副本必须结构对齐：标题层级、表格形状、列表数量、文件名与各自语言树内的交叉引用保持一致。

## 种子格式

产物种子（rule / skill / playbook / scaffold / doc / config / question）：

```yaml
---
id: seed/<kind>/<name>
kind: rule | skill | playbook | scaffold | doc | config | question
version: 1
updated: YYYY-MM-DD
review_by: YYYY-MM-DD
status: active | deprecated | superseded
load: always | on-demand
trigger: <按需加载的触发条件；load 为 always 时可省略>
load_via: path | skill | read        # 仅 rule；on-demand 必填
path_scope: source | ui | server | tests | config | domain
skills: [build, review]              # load_via=skill 时必填
summary: 一句话说明
applies_when: { project.type: any }
requires: []
grow: on-init | on-signal | on-demand
emits: <逻辑产物，如 rule/always、rule/path、rule/skill、skill/init、contract、state/status>
verify: 实例化后的检查项
---
```

以上字段只存在于种子层，不是任何平台的配置字段。平台只识别各自的内建字段，例如 Claude Code skill 的 `name`/`description`、Cursor 规则的 `description`/`globs`/`alwaysApply`。生成时必须剥离或由适配器转换，不得原样写入目标项目。

生命周期字段按 `protocols/zh/evolve.md` 维护；加载方式按 `protocols/zh/loading.md` 落地：`always` 内联进契约，`on-demand` 由 `load_via` 指定真实机制，`trigger` 只写进契约索引。

规则种子必须显式声明加载路径，禁止只写 `on-demand` 而没有机制：`path` 用 `path_scope` 映射为文件范围，`skill` 用 `skills` 指向触发的技能，`read` 用于平台无原生机制时的显式降级。

领域定义（domain）描述某类项目的专业核心，格式见 `seeds/zh/domains/_schema.md`；可在种子库或项目 `.agent/domains/` 中生成，不直接产出固定文件：

```yaml
---
id: domain/<name>
kind: domain
summary: 这类项目要解决什么
applies_when: { project.domain: <name> }
core_concerns: [必须回答的专业问题]
questions: [需要向用户确认什么]
research: [生成前必须查证的外部事实]
generates: [{ 类型: 配置, examples: [可能产物] }]
verify: [如何证明覆盖]
pitfalls: [常见失败模式]
---
```

知识包（knowledge）是参考材料，不是规则：

```yaml
---
id: knowledge/<topic>
kind: knowledge
summary: 一句话说明
applies_when: { project.domain: <name> }
triggers: [何时需要阅读]
sources: [来源与依据]
version: 1
updated: YYYY-MM-DD
review_by: YYYY-MM-DD
status: active
load: on-demand
---
```

正文写问题、模式、取舍、验证与反例；不写具体项目实现。

能力种子（capability）不直接产出固定文件，使用另一组字段：

```yaml
---
id: capability/<name>
kind: capability
summary: 要保证的结果
triggers: [何时需要]
questions: [必须向用户确认什么]
research: [生成前必须查证的外部事实]
generates: [{ 类型: 配置, examples: [可能产物] }]
verify: [如何证明已达成]
---
```

正文只写概念、判断标准、实例化步骤与反例，不写具体实现代码。

## 新需求入口

用户提出新项目、新产品或从零开始的任何需求时，先加载 `seeds/zh/skills/init/SKILL.md`：完成画像、领域问题与完备性检查后，才允许技术选型与实现。禁止直接进入 think、websearch 或编码。

init 的职责到“工程基座 + 用户确认”为止，不得在 init 内实现业务功能。基座确认后，后续开发切换到目标项目执行 `build`。

## 硬性约束

- 种子必须能被至少两个不同技术栈的项目实例化，否则不属于本仓库。
- 具体技术栈内容放入 `seeds/` 下的独立文件，并由 `applies_when` 限定。
- 任何源自具体项目的经验，必须先去掉项目细节才能进入 `seeds/`。
- 外部规则库（如 Agent Rules）只作为人工补充来源，不做自动同步；导入内容须去项目细节后按种子格式重写。
- 改动种子后必须同时通过 `scripts/verify-seeds.sh --strict` 与 `scripts/test-fixtures.sh`，并执行 `scripts/check-format.sh`。
- 修改一侧语言树时，必须同步修改另一侧，保持 `seeds/zh/` 与 `seeds/zh/` 一致。
