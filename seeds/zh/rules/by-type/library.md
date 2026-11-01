---
id: seed/rule/type-library
kind: rule
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
trigger: 设计或修改公开接口、版本与发布时
load_via: path
path_scope: source
summary: 可复用库通用规则
applies_when: { project.type: library }
requires: []
grow: on-init
emits: rule/path
verify: 规则与语言无关且可判定
---

# 库规则

## LIB-01 公共接口稳定

**规则**：公开接口有明确语义与版本策略；破坏性变更升主版本并给出迁移说明。

**禁止**：在小版本中改变既有接口行为。

**验证**：接口清单与版本记录一致。

## LIB-02 依赖最小

**规则**：运行依赖只保留必需项，开发依赖不进入发布产物。

**禁止**：为少量功能引入大型依赖。

**验证**：发布产物的依赖清单逐项有理由。

## LIB-03 错误可处理

**规则**：错误类型可被调用方区分与处理，不吞掉异常。

**禁止**：只返回字符串错误或静默失败。

**验证**：调用方能在不解析文本的情况下区分错误类型。

## LIB-04 文档即契约

**规则**：每个公开接口有用途、参数、返回值、错误与示例。

**禁止**：公开接口缺少文档或示例不可执行。

**验证**：文档示例可运行且结果符合描述。
