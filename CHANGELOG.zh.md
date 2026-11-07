# 变更记录

种子仓库以 `SEEDS_VERSION` 为对外版本，使用语义版本。生成项目在 `.agent/profile.yaml` 记录 `seed_version`，升级按 `protocols/zh/upgrade-seeds.md` 执行。

## 1.5.0 - 2026-11-07

- 新增 `capability/agent-environment` 与 `steward`：周期性检查提示词、规则、技能、记忆、钩子、MCP、子代理、命令、插件与环境；腐化发现带证据与可回滚动作。
- 新增 `capability/isolated-environment` 与 `sandbox`：选择容器、进程、虚拟机或阻塞；创建使用合成数据、默认拒绝外联并可验证拆除的端到端环境。
- 新增 `protocols/{en,zh}/maintenance.md` 与 MNT-01 至 MNT-04：变更后捕获、周期性 agent 体检、E2E 前隔离、用户修正优先。
- `learn` 增加架构、反模式与死代码检测；新增 `code-health` 与 `agent-maintenance` 知识包。
- 画像新增维护与隔离字段；`init` 创建体检基线并记录隔离决策；适配器映射钩子、自动化与调度，并显式标注降级。

## 1.4.0 - 2026-11-02

- 新增依赖检查：锁定文件存在、安装可复现、漏洞与许可证审计、升级扫描。
- 画像、启动契约与验证命令新增 `stack.lockfile`、`verify.outdated`、`verify.audit`。
- 新增 `.agent/upgrades.md`，记录版本候选项、推荐与升级决策。
- `upgrade` 增加检测、推荐、确认与升级后重扫；供应链能力与实例化校验同步扩展。

## 1.3.0 - 2026-11-02

- 新增计划能力、计划协议，以及任务计划与待办文档种子。
- 新增 `CTX-04` 至 `CTX-06`：多步骤计划必须写入 `.agent/plans/`，逐步对账并附证据；未排期工作必须进入唯一的 `.agent/backlog.md`。
- 把计划机制接入 `init`、`build`、`operate`、启动契约、加载策略、基座生成与校验。
- 新增偏移记录，要求写明原因与影响，使计划变更可见而非静默发生。
- 从 1.2 升级的生成项目需补充 `.agent/backlog.md` 与 `.agent/plans/_template.md`；初始化已默认创建两者。

## 1.2.0 - 2026-11-02

- 新增 `VCS-07` 任务分支隔离：确认工作区干净，从最新主干创建 `<type>/<task-slug>` 分支，禁止在主干直接开发，并明确处理既有未提交改动。
- 画像、启动契约与实例化流程新增 `delivery.trunk_branch`。
- `build` 与 `review` 增加分支预检，并检查分支基点与工作区卫生。

## 1.1.0 - 2026-11-01

- 文档改为 `seeds/`、`protocols/`、`adapters/`、`examples/`、`packs/` 下的 `en/` 与 `zh/` 双目录结构。
- 英文成为权威文档语言，并补齐完整中文镜像。
- 新增 `LICENSE`（MIT）、`CONTRIBUTING.md`、`SECURITY.md`、`CODE_OF_CONDUCT.md`、Issue 模板与扩展后的 `.gitignore`。
- `scripts/verify-seeds.sh` 扩展为同时校验两侧语言树、平台矩阵、适配器与跨文档链接。
- 脚本用户可见输出改为英文。
- 新增中英双语 README、CAPABILITIES、AGENTS 与 CHANGELOG。

## 1.0.0 - 2026-10-29

- 首次版本化：新增 `SEEDS_VERSION`、本记录与 `protocols/upgrade-seeds.md`。
- 新增 Codex 适配器；`generic` 只覆盖通用平台。
- 新增 5 个高频领域参考定义：web-app、backend、cli、web-marketing、desktop。
- 记忆协议新增条目编号、容量归档与外部条目引用。
- 新增实例化校验脚本与 golden fixture；种子自检扩展语义检查。
- 新增 CI，推送与合并请求都执行种子校验。
