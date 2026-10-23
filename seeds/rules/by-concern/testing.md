---
id: seed/rule/concern-testing
kind: rule
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
trigger: 编写测试、修复缺陷或发布前验证时
load_via: skill
skills: [build, review]
summary: 测试与质量门
applies_when: { project.type: any }
requires: [quality.test_level]
grow: on-init
emits: rule/skill
verify: 每条规则可由命令或检查验证
---

# 测试规则

## TST-01 验证行为

**规则**：测试断言用户可观察的行为与契约，不断言内部实现细节。

**禁止**：为通过测试而暴露私有实现。

**验证**：重构内部结构后行为测试仍通过。

## TST-02 缺陷先失败

**规则**：修复缺陷前先写一个能失败的测试，修复后该测试通过。

**禁止**：无复现证据直接改代码。

**验证**：测试在修复前失败、修复后通过。

## TST-03 独立可重复

**规则**：测试不依赖执行顺序、外部时间、真实网络与共享可变状态。

**禁止**：测试之间通过残留数据互相影响。

**验证**：随机顺序与单独执行均通过。

## TST-04 质量门以命令为准

**规则**：测试级别对应的命令写入启动契约，发布前必须实际执行。

**禁止**：用人工判断代替可执行的质量门。

**验证**：最近一次执行结果记录在 `.agent/status.md`。
