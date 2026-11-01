---
id: seed/rule/concern-deploy
kind: rule
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
trigger: 发布、部署、回滚或配置环境时
load_via: skill
skills: [ship, operate]
summary: 发布与部署
applies_when: { project.type: any, delivery.deploy_target: "!none" }
requires: [delivery.deploy_target, delivery.environments]
grow: on-init
emits: rule/skill
verify: 每条规则可对应到发布清单
---

# 部署规则

## DPL-01 可回滚

**规则**：每次发布都有明确回滚版本与操作步骤，关键步骤演练过。

**禁止**：在没有回滚路径时上线。

**验证**：回滚步骤记录在发布说明中。

## DPL-02 配置与代码分离

**规则**：环境差异通过配置或环境变量注入，同一构建产物可部署到不同环境。

**禁止**：把环境地址、密钥与开关写死在代码中。

**验证**：构建产物中检索不到环境特定值。

## DPL-03 环境一致

**规则**：开发、预发与生产的运行时版本、依赖与配置结构保持一致，差异有清单。

**禁止**：只在本地验证后直接上生产。

**验证**：环境差异清单存在且被评审。

## DPL-04 发布说明

**规则**：每次发布包含版本、变更、影响范围、已知问题与回滚方式。

**禁止**：无说明的静默发布。

**验证**：发布记录可追溯到版本与变更清单。

## DPL-05 发布后验证

**规则**：发布后检查健康状态与关键路径，观察窗口内确认无异常再结束。

**禁止**：部署命令成功即宣布完成。

**验证**：健康检查与关键路径结果记录在状态文件。
