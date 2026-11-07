# agent 环境自检、learn 增强与隔离环境任务清单

- [x] T1 维护协议与常驻规则（依赖：无，规模：M）
- [x] T2 agent 环境能力定义（依赖：无，规模：S）
- [x] T3 steward 技能与维护钩子模板（依赖：T1,T2，规模：M）
- [x] T4 隔离能力与 sandbox 技能（依赖：T1，规模：M）
- [x] T5 learn 增强与代码健康知识包（依赖：T2，规模：M）
- [x] T6 agent 维护知识包（依赖：T1，规模：S）
- [x] T7 画像、init、契约与 loading 同步（依赖：T3,T4,T6，规模：M）
- [x] T8 四个 adapter 同步（依赖：T7，规模：M）
- [x] T9 注册文档与版本（依赖：T5,T8，规模：S）
- [x] T10 verify-seeds 校验扩展（依赖：T9，规模：S）
- [x] T11 实例校验与 golden fixture（依赖：T10，规模：M）
- [x] T12 全量校验与收尾（依赖：T11，规模：S）

## 任务 1：维护协议与常驻规则

**文件**

- 新建：`protocols/en/maintenance.md`
- 新建：`protocols/zh/maintenance.md`
- 新建：`seeds/en/rules/core/maintenance.md`
- 新建：`seeds/zh/rules/core/maintenance.md`
- 修改：`protocols/en/loading.md:56-74`
- 修改：`protocols/zh/loading.md:56-74`

**接口**

- 消费：`protocols/en/loading.md` 的四层模型；`seeds/en/docs/agent-contract.md` 的常驻约束占位符 `{{core_rules}}`。
- 产出：机制类别 `native-hook`、`session-scheduler`、`cloud-automation`、`os-ci-scheduler`、`advisory`；状态文件 `.agent/.maintenance-state`；规则 ID `MNT-01` 至 `MNT-04`。

**验收**

- [x] 协议写明触发条件、模式、节流、钩子契约、降级顺序与验证方法。
- [x] 常驻规则 4 条，每条含 Rule、Prohibited、Verify，ID 不重复。
- [x] `loading.md` 的 L3 表新增 `.agent/agent-health.md` 与 `.agent/sandbox.md`，并引用维护协议。

**验证**

- 命令：`bash scripts/verify-seeds.sh --strict`
- 期望：0 错误；新规则 ID 无重复；`protocols/{en,zh}/maintenance.md` 均存在。

**依赖 / 规模**：无 / M

- [x] 步骤 1：写 `protocols/en/maintenance.md`，定义机制类别、触发、模式、节流、钩子契约、降级、验证。
- [x] 步骤 2：按英文写 `protocols/zh/maintenance.md`，保持标题与表格形状一致。
- [x] 步骤 3：写 `seeds/en/rules/core/maintenance.md`，加入 MNT-01~04。
- [x] 步骤 4：写中文镜像 `seeds/zh/rules/core/maintenance.md`。
- [x] 步骤 5：在 `protocols/{en,zh}/loading.md` 的 L3 表加入体检报告与隔离报告，并写明维护协议引用。
- [x] 步骤 6：运行校验，确认规则 ID 与 front matter 通过。

## 任务 2：agent 环境能力定义

**文件**

- 新建：`seeds/en/capabilities/agent-environment.md`
- 新建：`seeds/zh/capabilities/agent-environment.md`
- 修改：`seeds/en/capabilities/environment.md:1-63`
- 修改：`seeds/zh/capabilities/environment.md:1-63`
- 修改：`seeds/en/capabilities/agent-assets.md:1-48`
- 修改：`seeds/zh/capabilities/agent-assets.md:1-48`

**接口**

- 消费：`seeds/en/rules/core/maintenance.md` 的 MNT 规则；`protocols/en/maintenance.md` 的触发与降级。
- 产出：能力 ID `capability/agent-environment`；体检维度清单；腐化信号清单；输出位置 `.agent/agent-health.md`。

**验收**

- [x] 能力覆盖平台与模型、提示词与契约、规则、技能、记忆、钩子与自动化、MCP、子代理/命令/插件、环境探针、git 与会话证据十类资产。
- [x] 明确写出“不检测业务代码腐化”，并指向 `learn` 与 `review`。
- [x] 与 `environment`、`agent-assets` 的边界各有一句说明，避免重复能力。

**验证**

- 命令：`bash scripts/verify-seeds.sh --strict`
- 期望：capability 必填字段齐全，ID 唯一。

**依赖 / 规模**：无 / S

- [x] 步骤 1：写能力 front matter，填写 triggers、questions、research、generates、verify。
- [x] 步骤 2：写正文：检测顺序、十类资产、腐化信号、证据来源、输出格式、应用策略、误报与反例。
- [x] 步骤 3：写中文镜像。
- [x] 步骤 4：在 `environment.md` 与 `agent-assets.md` 各加一句边界说明。
- [x] 步骤 5：运行校验。

## 任务 3：steward 技能与维护钩子模板

**文件**

- 新建：`seeds/en/skills/steward/SKILL.md`
- 新建：`seeds/zh/skills/steward/SKILL.md`
- 新建：`seeds/scaffolds/hooks/agent-maintenance`
- 修改：`seeds/scaffolds/README.md:40-48`
- 修改：`seeds/scaffolds/README.zh.md:40-48`

**接口**

- 消费：`.agent/agent-health.md` 时间戳；`.agent/profile.yaml` 的 `agent.maintenance_stale_days`；git 历史与 `.agent/` 状态文件。
- 产出：技能名 `steward`；体检报告章节；建议动作 `keep`、`merge`、`split`、`deprecate`、`move-to-trash`、`add`；钩子脚本参数 `--root <project>`。

**验收**

- [x] `description` ≤ 500 字符，包含“agent 体检”“规则/记忆/skill 整理”“提示词/MCP/hook 检查”“agent 腐化”“定期维护”等触发词。
- [x] 正文步骤覆盖快照、资产盘点、腐化检测、git/记忆证据、分级、确认后应用、记录、节奏建议。
- [x] 钩子脚本无网络、< 2 秒、缺失或过期时只输出一行提醒，否则静默退出 0。

**验证**

- 命令：`bash seeds/scaffolds/hooks/agent-maintenance --root tests/fixtures/golden`
- 期望：`tests/fixtures/golden/.agent/agent-health.md` 存在且新鲜时无输出；把其时间戳改为 8 天前后输出一行提醒。

**依赖 / 规模**：T1,T2 / M

- [x] 步骤 1：写 `steward` front matter 与正文，明确不碰业务代码、不自动改动、删除走可恢复清理。
- [x] 步骤 2：写中文镜像。
- [x] 步骤 3：写 `seeds/scaffolds/hooks/agent-maintenance`，解析 `stale_days`，用 `find -mtime` 判断。
- [x] 步骤 4：在脚手架 README 的 hooks 表登记脚本用途与目标位置。
- [x] 步骤 5：在 golden fixture 上手工验证“新鲜静默、过期提醒、缺失提醒”三种路径。

## 任务 4：隔离能力与 sandbox 技能

**文件**

- 新建：`seeds/en/capabilities/isolated-environment.md`
- 新建：`seeds/zh/capabilities/isolated-environment.md`
- 新建：`seeds/en/skills/sandbox/SKILL.md`
- 新建：`seeds/zh/skills/sandbox/SKILL.md`
- 修改：`seeds/en/capabilities/dev-environment.md:1-45`
- 修改：`seeds/zh/capabilities/dev-environment.md:1-45`
- 修改：`seeds/en/capabilities/target-environment.md:1-47`
- 修改：`seeds/zh/capabilities/target-environment.md:1-47`

**接口**

- 消费：`.agent/profile.yaml` 的 `target.*`、`data.*`、`verify.*`；`protocols/en/environment.md` 的探测结果。
- 产出：能力 ID `capability/isolated-environment`；技能名 `sandbox`；隔离级别 `container`、`process`、`vm`、`block`；报告 `.agent/sandbox.md`。

**验收**

- [x] 能力写明隔离对象：数据、网络、凭据、外部服务、操作系统/设备、硬件。
- [x] 技能写明生产地址/凭据检测、默认拒绝外联、合成数据、拆除与残留校验。
- [x] 移动端、macOS、Windows 目标在有模拟器/虚拟机时使用，不可用时明确阻塞，不伪造 E2E。

**验证**

- 命令：`bash scripts/verify-seeds.sh --strict`
- 期望：capability 与 skill front matter 齐全；技能 description 含“测试影响生产”“隔离环境”“端到端验证”等触发词。

**依赖 / 规模**：T1 / M

- [x] 步骤 1：写隔离能力定义与正文，包含级别、触发、问题、研究项、生成物、验证。
- [x] 步骤 2：写 `sandbox` 技能，按“探测→分类→选级→防生产→确认→创建→E2E→拆除→记录”组织。
- [x] 步骤 3：写中文镜像。
- [x] 步骤 4：在 `dev-environment.md` 与 `target-environment.md` 各加一句指向隔离能力。
- [x] 步骤 5：运行校验。

## 任务 5：learn 增强与代码健康知识包

**文件**

- 修改：`seeds/en/skills/learn/SKILL.md:1-40`
- 修改：`seeds/zh/skills/learn/SKILL.md:1-40`
- 新建：`seeds/en/knowledge/code-health.md`
- 新建：`seeds/zh/knowledge/code-health.md`
- 修改：`seeds/en/knowledge/INDEX.md:12-37`
- 修改：`seeds/zh/knowledge/INDEX.md:12-37`

**接口**

- 消费：项目现有的静态检查、测试、`project_lookup`、`project_impact` 结果。
- 产出：learn 的“代码健康扫描”步骤；知识包 `knowledge/code-health`；发现分级 `lesson`、`backlog`、`refactor-task`。

**验收**

- [x] learn 正文包含架构、反模式、死代码三个维度，并要求 `file:line` 与证据。
- [x] 明确“只记录与提议，不自动重构、不自动删除”，删除走可恢复清理。
- [x] 知识包被 `INDEX.md` 登记，且只写问题、模式、取舍、验证与反例，不写具体项目实现。

**验证**

- 命令：`bash scripts/verify-seeds.sh --strict`
- 期望：knowledge 必填字段齐全；INDEX 列出的文件存在且无遗漏。

**依赖 / 规模**：T2 / M

- [x] 步骤 1：修改 learn 的 description，加入架构审查、反模式、死代码、重构后、发布后等触发词。
- [x] 步骤 2：在 learn 正文加入三维检测清单与发现处理规则。
- [x] 步骤 3：写 `code-health.md` 与中文镜像。
- [x] 步骤 4：更新两个 INDEX。
- [x] 步骤 5：运行校验。

## 任务 6：agent 维护知识包

**文件**

- 新建：`seeds/en/knowledge/agent-maintenance.md`
- 新建：`seeds/zh/knowledge/agent-maintenance.md`
- 修改：`seeds/en/knowledge/INDEX.md:12-37`
- 修改：`seeds/zh/knowledge/INDEX.md:12-37`

**接口**

- 消费：`capability/agent-environment` 的维度与信号。
- 产出：平台无关的腐化模式、证据要求、误报来源、验证方法、节奏建议。

**验收**

- [x] 知识包不出现平台路径与具体产品默认值。
- [x] 覆盖规则冲突、技能不触发、记忆矛盾、提示词漂移、钩子静默失败、MCP 失效、预算超限、死引用、重复资产九类模式。
- [x] 每类模式给出可复现证据与反例。

**验证**

- 命令：`bash scripts/verify-seeds.sh --strict`
- 期望：无平台路径泄漏；INDEX 完整。

**依赖 / 规模**：T1 / S

- [x] 步骤 1：写 `agent-maintenance.md` 与中文镜像。
- [x] 步骤 2：更新两个 INDEX。
- [x] 步骤 3：运行校验。

## 任务 7：画像、init、契约与 loading 同步

**文件**

- 修改：`seeds/en/questions/project-profile.md:80-96`
- 修改：`seeds/zh/questions/project-profile.md:80-96`
- 修改：`seeds/en/skills/init/SKILL.md:29-132`
- 修改：`seeds/zh/skills/init/SKILL.md:29-132`
- 修改：`seeds/en/docs/agent-contract.md:29-107`
- 修改：`seeds/zh/docs/agent-contract.md:29-107`
- 修改：`protocols/en/loading.md:56-74`
- 修改：`protocols/zh/loading.md:56-74`

**接口**

- 消费：新 capability、skill、protocol 的触发条件与输出路径。
- 产出：profile 字段 `agent.maintenance_cadence`、`agent.maintenance_mode`、`agent.maintenance_stale_days`、`agent.isolation_level`、`agent.isolation_egress`；初始化产物 `.agent/agent-health.md`；契约中的技能索引与 L3 表。

**验收**

- [x] 五个字段有默认值、取值枚举与推断规则。
- [x] init 完成标准包含体检基线与隔离决策；步骤 2 会问维护与隔离；步骤 6 创建报告；步骤 7 校验报告。
- [x] 契约技能索引包含 `steward` 与 `sandbox`，L3 表包含两份新报告，常驻约定包含 MNT 摘要。

**验证**

- 命令：`bash scripts/verify-seeds.sh --strict && bash scripts/verify-instantiation.sh tests/fixtures/golden`
- 期望：种子校验通过；golden 在补充 fixture 后通过（与 T11 联合验收）。

**依赖 / 规模**：T3,T4,T6 / M

- [x] 步骤 1：在 profile 字段表加入五个字段，并在问题顺序第 10 步加入维护与隔离问题。
- [x] 步骤 2：更新 init 的完成标准、提问、研究、生成、校验步骤。
- [x] 步骤 3：更新契约的常驻约定、加载表、技能索引、自学习段。
- [x] 步骤 4：更新 loading 的 L3 表与维护协议引用。
- [x] 步骤 5：写中文镜像。
- [x] 步骤 6：运行种子校验。

## 任务 8：四个 adapter 同步

**文件**

- 修改：`adapters/en/claude-code.md:60-85`
- 修改：`adapters/zh/claude-code.md:60-85`
- 修改：`adapters/en/cursor.md:40-62`
- 修改：`adapters/zh/cursor.md:40-62`
- 修改：`adapters/en/codex.md:37-64`
- 修改：`adapters/zh/codex.md:37-64`
- 修改：`adapters/en/generic.md:24-66`
- 修改：`adapters/zh/generic.md:24-66`

**接口**

- 消费：`protocols/{en,zh}/maintenance.md` 的机制类别。
- 产出：各平台钩子/定时/自动化落点、事件名、持久化位置、版本核对与降级说明。

**验收**

- [x] Claude Code：写明 hooks 在 `.claude/settings.json`、会话开始/结束/Stop 事件、`CronCreate` 持久化位置与 7 天过期、skill 描述预算与 `paths` 确定性激活。
- [x] Cursor：写明 Automations 的计划/事件触发与云端沙箱，明确本地无等价 hook 时降级为 command/契约。
- [x] Codex：写明 Automations、CLI hooks 版本核对、无法确认时降级为 `AGENTS.md` + `$steward` + 外部调度。
- [x] Generic：写明系统定时/CI 调度与显式调用降级。
- [x] 四个 adapter 都引用 `protocols/{en,zh}/maintenance.md`，不写种子元数据。

**验证**

- 命令：`bash scripts/verify-seeds.sh --strict`
- 期望：平台矩阵与 adapter 文件对应；无平台路径泄漏到 seeds。

**依赖 / 规模**：T7 / M

- [x] 步骤 1：更新 Claude Code adapter，加入 Hooks and Scheduling 段与资产路径。
- [x] 步骤 2：更新 Cursor adapter，加入 Automations 与降级。
- [x] 步骤 3：更新 Codex adapter，加入 Automations、hooks 版本核对与降级。
- [x] 步骤 4：更新 Generic adapter，加入系统定时/CI。
- [x] 步骤 5：写四个中文镜像。
- [x] 步骤 6：运行校验。

## 任务 9：注册文档与版本

**文件**

- 修改：`CAPABILITIES.md:17-64`
- 修改：`CAPABILITIES.zh.md:17-64`
- 修改：`README.md:72-115`
- 修改：`README.zh.md:72-115`
- 修改：`AGENTS.md:5-22`
- 修改：`AGENTS.zh.md:5-22`
- 修改：`CHANGELOG.md:5`
- 修改：`CHANGELOG.zh.md:5`
- 修改：`SEEDS_VERSION:1`

**接口**

- 消费：新技能名 `steward`、`sandbox`；新能力名。
- 产出：用户可发现的能力表、技能表、版本记录。

**验收**

- [x] `CAPABILITIES.md` 与中文镜像各新增两行能力、两行技能，并更新 learn 描述。
- [x] `README` 与中文镜像的技能/能力清单同步。
- [x] `AGENTS.md` 目录职责写明新 capability、protocol、skill。
- [x] `CHANGELOG` 增加 1.5.0，`SEEDS_VERSION` 为 1.5.0。

**验证**

- 命令：`bash scripts/verify-seeds.sh --strict`
- 期望：技能已在 README 或 CAPABILITIES 注册；版本与 CHANGELOG 匹配。

**依赖 / 规模**：T5,T8 / S

- [x] 步骤 1：更新 CAPABILITIES 中英文。
- [x] 步骤 2：更新 README 中英文。
- [x] 步骤 3：更新 AGENTS 中英文。
- [x] 步骤 4：更新 CHANGELOG 中英文与 SEEDS_VERSION。
- [x] 步骤 5：运行校验。

## 任务 10：verify-seeds 校验扩展

**文件**

- 修改：`scripts/verify-seeds.sh:1-320`

**接口**

- 消费：新文件路径、规则 ID、技能名、知识包名。
- 产出：校验函数 `check_required_assets()`；适配器章节关键词检查；维护协议引用检查。

**验收**

- [x] 缺少 `protocols/{en,zh}/maintenance.md`、两个 capability、两个 skill、两个知识包时失败。
- [x] 四个 adapter 缺少维护/调度章节关键词时失败。
- [x] learn 正文缺少架构、反模式、死代码关键词时失败。

**验证**

- 命令：`bash scripts/verify-seeds.sh --strict`
- 期望：当前仓库通过；临时移走任一必检文件时输出明确 FAIL（手工验证后恢复）。

**依赖 / 规模**：T9 / S

- [x] 步骤 1：加入必检文件与技能集合。
- [x] 步骤 2：加入 adapter 章节关键词检查。
- [x] 步骤 3：加入 learn 关键词检查。
- [x] 步骤 4：运行严格校验。
- [x] 步骤 5：临时移走一个文件验证失败路径，再恢复。

## 任务 11：实例校验与 golden fixture

**文件**

- 修改：`scripts/verify-instantiation.sh:95-113`
- 修改：`scripts/test-fixtures.sh:1-45`
- 修改：`tests/fixtures/golden/.agent/profile.yaml`
- 新建：`tests/fixtures/golden/.agent/agent-health.md`
- 新建：`tests/fixtures/golden/.agent/sandbox.md`
- 新建：`tests/fixtures/golden/.claude/settings.json`
- 新建：`tests/fixtures/golden/.claude/hooks/agent-maintenance.sh`
- 新建：`tests/fixtures/golden/.claude/skills/steward/SKILL.md`
- 新建：`tests/fixtures/golden/.claude/skills/sandbox/SKILL.md`

**接口**

- 消费：profile 的 `seed_version`、`agent.maintenance_*`、`agent.isolation_*`。
- 产出：体检报告必检逻辑；维护模式告警逻辑；夹具与钩子测试。

**验收**

- [x] `seed_version >= 1.5.0` 且缺少 `.agent/agent-health.md` 时失败； `< 1.5.0` 时只告警。
- [x] `agent.maintenance_mode=hook` 且找不到平台 hook 配置时告警。
- [x] golden 通过；broken 仍被拒绝；维护钩子的三种路径测试通过。

**验证**

- 命令：`bash scripts/test-fixtures.sh`
- 期望：`OK fixtures`；新增测试全部通过。

**依赖 / 规模**：T10 / M

- [x] 步骤 1：扩展 `check_states()`，加入版本感知的体检报告检查。
- [x] 步骤 2：加入维护模式与 hook 配置告警。
- [x] 步骤 3：更新 golden profile 与新增文件，给钩子脚本加可执行权限。
- [x] 步骤 4：在 `test-fixtures.sh` 加入新鲜/过期/缺失三种钩子测试，以及临时复制 golden 后删除体检报告的失败测试。
- [x] 步骤 5：运行夹具测试。

## 任务 12：全量校验与收尾

**文件**

- 修改：无新增；根据校验结果修正前序文件。

**接口**

- 消费：全部任务产物。
- 产出：可提交前的干净校验结果与 `git diff --stat` 摘要。

**验收**

- [x] `scripts/check-format.sh` 通过。
- [x] `scripts/verify-seeds.sh --strict` 通过且 0 警告。
- [x] `scripts/test-fixtures.sh` 通过。
- [x] en/zh 文件数量一致，所有新增文件成对存在。
- [x] `git status` 只包含计划内文件；没有意外删除。

**验证**

- 命令：`bash scripts/check-format.sh && bash scripts/verify-seeds.sh --strict && bash scripts/test-fixtures.sh`
- 期望：三条命令退出码均为 0。

**依赖 / 规模**：T11 / S

- [x] 步骤 1：运行三条校验命令。
- [x] 步骤 2：修复失败项，逐项重跑。
- [x] 步骤 3：核对 en/zh 文件数量与新增文件对。
- [x] 步骤 4：输出 `git diff --stat` 与未提交说明；等待用户授权后再提交。

## 检查点 A（T1-T4）

- [x] 新协议、常驻规则、两个 capability、两个 skill 文件存在且 front matter 完整
- [x] `scripts/verify-seeds.sh --strict` 无错误
- [x] 维护钩子脚本在 golden fixture 上可运行
- [x] `steward` 与 `sandbox` 的 description 均 ≤ 500 字符

## 检查点 B（T5-T9）

- [x] learn 正文包含架构、反模式、死代码三个维度
- [x] 四个 adapter 均包含平台维护触发与降级说明
- [x] CAPABILITIES、README、AGENTS、CHANGELOG、SEEDS_VERSION 全部同步
- [x] en/zh 文件数量与结构一致

## 检查点 C（T10-T12）

- [x] `scripts/check-format.sh` 通过
- [x] `scripts/verify-seeds.sh --strict` 通过
- [x] `scripts/test-fixtures.sh` 通过
- [x] golden fixture 通过实例校验，broken fixture 仍被拒绝
