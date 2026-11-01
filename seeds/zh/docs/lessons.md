---
id: seed/doc/lessons
kind: doc
summary: 项目教训沉淀
applies_when: { project.type: any }
requires: []
grow: on-init
emits: state/lessons
verify: 每条教训有事实来源与适用范围
---

# 项目教训

## 格式

### <日期> <一句话标题>

- **场景**：发生了什么。
- **事实**：日志、测试或复现证据。
- **决策**：之后怎么做。
- **范围**：仅本项目 / 本技术栈 / 可能通用。
- **晋升**：未评估 / 已提议 / 已确认。

## 规则

- 只记录有证据的经验。
- 与已有条目重复时合并，不新增同义条目。
- 标记为“可能通用”的条目，需经用户确认才可写入种子库。
