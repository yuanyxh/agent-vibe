---
id: seed/question/project-profile
kind: question
summary: 项目画像问题树与完备判据
applies_when: { project.type: any }
requires: []
grow: on-init
emits: state/profile
verify: 所有必填字段有值，且无推断项未标注
---

# 项目画像

init 只维护一份画像。提问、生长、校验都以它为输入。

## 字段

| 字段 | 必填 | 默认 | 说明 |
| --- | --- | --- | --- |
| `seed_version` | 是 | 当前 `SEEDS_VERSION` | 生成基座使用的种子版本，升级时比对 |
| `project.name` | 是 | 无 | 项目名，同时用于目录与包名 |
| `project.one_liner` | 是 | 无 | 一句话说明做什么、给谁用 |
| `project.type` | 是 | 无 | web / mobile / backend / desktop / cli / library |
| `project.domain` | 是 | 按 type 与用途推导 | 领域名称，可多个；开放集合，不限于预置列表 |
| `project.scale` | 是 | mvp | prototype / mvp / production |
| `project.team` | 否 | solo | solo / small / large |
| `stack.language` | 是 | 按 type 推荐 | 编程语言 |
| `stack.framework` | 是 | 按 type 推荐 | 主框架，可为 none |
| `stack.package_manager` | 是 | 按语言推荐 | 包管理器 |
| `stack.runtime` | 否 | 按语言推荐 | 运行时版本约束 |
| `ui.has_ui` | 是 | 按 type 推导 | 是否存在可视化界面 |
| `ui.design_system` | 否 | none | 组件库或设计系统 |
| `ui.i18n` | 否 | false | 是否需要多语言 |
| `ui.a11y` | 否 | standard | none / standard / strict |
| `data.storage` | 是 | none | none / file / sqlite / postgres / mysql / mongo / cloud |
| `data.auth` | 是 | none | none / session / jwt / oauth / sso |
| `data.files` | 否 | none | none / local / s3 |
| `data.external_services` | 否 | [] | 第三方服务清单 |
| `delivery.vcs` | 是 | git | git / none |
| `delivery.repo_host` | 是 | github | github / gitlab / gitee / local |
| `delivery.branch_strategy` | 是 | 按 team 推导 | trunk / feature-branch |
| `delivery.trunk_branch` | 是 | 从仓库探测，否则 main | 主干分支名，任务分支的基点 |
| `delivery.ci` | 是 | 按 repo_host 推荐 | github-actions / gitlab-ci / none |
| `delivery.deploy_target` | 是 | 按 type 推荐 | static / serverless / container / vps / app-store / none |
| `delivery.environments` | 是 | [dev, prod] | 环境列表 |
| `delivery.domain` | 否 | 无 | 访问域名 |
| `quality.test_level` | 是 | standard | none / basic / standard / strict |
| `quality.security_level` | 是 | standard | basic / standard / high |
| `quality.format` | 是 | 按语言推荐 | 格式化工具名，或 none |
| `quality.lint` | 是 | 按语言推荐 | 静态检查工具名，或 none |
| `quality.typecheck` | 否 | 按语言推荐 | 类型检查工具名，或 none |
| `quality.perf_budget` | 否 | 无 | 可度量的性能上限 |
| `quality.compliance` | 否 | [] | privacy / payment / health / finance |
| `verify.install` | 是 | 按包管理器推导 | 安装依赖命令 |
| `verify.build` | 是 | 按技术栈推导 | 构建命令 |
| `verify.format` | 是 | 按 quality.format 推导 | 格式化检查命令 |
| `verify.lint` | 是 | 按 quality.lint 推导 | 静态检查命令 |
| `verify.typecheck` | 否 | 按 quality.typecheck 推导 | 类型检查命令 |
| `verify.test` | 是 | 按测试级别推导 | 测试命令 |
| `verify.run` | 否 | 按形态推导 | 本地启动命令 |
| `dev.editors` | 否 | [] | 用户实际使用的编辑器或 IDE；未指定则不生成相关配置 |
| `dev.toolchain_managers` | 否 | [] | 版本管理方式；未指定则只写版本声明 |
| `dev.task_entry` | 否 | 无 | 命令入口偏好；未指定则沿用生态默认 |
| `dev.containerized` | 否 | false | 是否需要容器化开发环境 |
| `dev.env_files` | 否 | true | 是否需要环境变量示例 |
| `target.platforms` | 是 | 按 type 推导 | 目标平台与设备，自由文本 |
| `target.versions` | 否 | {} | 各平台的最低支持版本 |
| `target.constraints` | 否 | [] | 网络、存储、权限、内存、离线等硬约束 |
| `governance.openness` | 是 | private | private / public |
| `governance.license` | 否 | private 为 internal | 许可证标识；公开项目必填 |
| `governance.contribution` | 否 | 按 openness 推导 | 贡献与审查方式 |
| `governance.security_contact` | 否 | 无 | 安全问题报告渠道 |
| `supply_chain.dependency_updates` | 否 | 按 scale 推导 | 依赖更新责任与频率 |
| `supply_chain.vulnerability_scan` | 否 | 按 scale 推导 | 漏洞扫描要求 |
| `supply_chain.license_audit` | 否 | false | 是否需要许可证审计 |
| `supply_chain.sbom` | 否 | false | 是否需要物料清单 |
| `agent.platform` | 是 | claude-code | claude-code / cursor / codex / generic |
| `agent.rules_scope` | 是 | core+type+concern | 规则加载范围 |

## 提问顺序

每轮最多四问，只问缺失且前置已确定的字段。每个问题附推荐值，用户回答“按推荐”即采用默认。

1. **定位**：name、one_liner、type、domain、scale。domain 由用途、行业与问题空间命名，可用自由文本；不确定时先写候选，生成时按 `seeds/zh/domains/_schema.md` 定义。
2. **技术栈**：按 `type` 动态生成语言、框架、包管理器、运行时选项。
3. **界面**：仅在 `ui.has_ui` 为真时询问设计系统、国际化、可访问性。
4. **数据**：存储、鉴权、文件、第三方服务。
5. **交付**：版本控制、仓库托管、分支策略与主干分支、CI、部署目标、环境、域名。
6. **质量**：测试级别、安全级别、格式化、静态检查、类型检查、性能预算、合规要求。
7. **协作**：仅在 `team != solo` 时询问审查方式与变更日志要求。
8. **环境**：编辑器与工具链偏好、目标平台与版本、硬约束；用户未提及的项不追问，登记为待生长。
9. **治理与供应链**：公开性、许可证、安全报告方式；生产或公开项目询问依赖更新与扫描要求。
10. **Agent**：平台与规则范围。
11. **种子版本**：不提问，生成时取种子仓库 `SEEDS_VERSION` 写入 `seed_version`。

## 推断规则

能从已有回答或仓库事实推断的字段不再提问，但必须在摘要中标注“推断”。例如：

- `type = web` 时 `ui.has_ui = true`。
- `repo_host = github` 且未指定 CI 时推荐 `github-actions`。
- `scale = prototype` 且未指定测试级别时推荐 `basic`。
- 未指定 `delivery.vcs` 时默认 `git`；`team = solo` 时 `branch_strategy = trunk`，否则 `feature-branch`。仓库已存在时探测其默认分支作为 `trunk_branch`，否则默认 `main`。
- `quality.format/lint/typecheck` 按语言推荐主流工具，并同步推导 `verify.*` 命令。
- `project.domain` 由 `type`、行业与用途推导，名称是自由文本；不要求在种子库中已存在同名定义。
- `target.platforms` 由 `project.type` 推导；版本范围在生成时查证，不在此处硬编码。
- `governance.openness = public` 时许可证必问；`scale = production` 时依赖更新与漏洞扫描默认启用。
- 产品名只作为用户回答或示例出现，不作为字段默认值。
- 仓库中存在 `package.json`、`pom.xml`、`go.mod` 等文件时，优先读事实而不是提问。

## 完备判据

上表所有必填字段有值，且每个推断值已在摘要中标注，才允许进入生成阶段。

## 摘要格式

生成前一次性输出：字段、取值、来源（用户回答 / 默认 / 推断）。用户可只改其中任意项。确认后写入 `.agent/profile.yaml`，`seed_version` 取种子仓库 `SEEDS_VERSION`。
