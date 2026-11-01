---
id: domain-schema
kind: schema
summary: 领域定义的格式与生成方法
load: on-demand
trigger: 生成、读取或更新领域定义时
status: active
version: 1
updated: 2026-10-23
review_by: 2027-01-23
---

# 领域定义规范

领域是开放集合，不要求预先枚举。`seeds/zh/domains/` 提供少量高频参考定义，命中则复用；未命中时按本规范现场生成。

## 何时生成

- 项目画像确定 `project.domain` 时。
- 进入一个新的行业、平台或问题空间时。
- 现有领域定义无法覆盖当前问题，且问题在两个以上项目中重复出现。

## 一个领域必须包含

| 字段 | 要求 |
| --- | --- |
| `summary` | 一句话说明这类项目要解决什么 |
| `applies_when` | 什么画像会命中 |
| `core_concerns` | 3~8 条专业核心问题，每条可验证 |
| `questions` | 必须向用户确认的领域问题 |
| `research` | 生成前必须查证的外部事实 |
| `generates` | 可能产物的**类别**，不写具体实现 |
| `verify` | 如何证明关注点被覆盖 |
| `pitfalls` | 常见失败模式 |

## 生成步骤

1. 从项目画像、用户描述与现有代码提取领域关键词。
2. 查证该领域当前的实践、规范与法规，记录来源与时间。
3. 写出可验证的 `core_concerns`，避免口号。
4. 写入项目 `.agent/domains/<name>.md`，并在启动契约中登记。
5. 在两个以上项目中复用时，按 `protocols/zh/distill.md` 提议晋升为示例或共享定义。

## 禁止

- 把某个领域写成所有项目的默认。
- 用固定清单代替按上下文生成。
- 在领域定义里写具体产品、版本或配置。
- 未核实来源就断言某规范“必须如此”。

## 参考

`seeds/zh/domains/` 提供高频参考定义（web-app、backend、cli、web-marketing、desktop），命中即复用；`examples/zh/domains/` 提供其余写法参考，不是固定集合。
