---
id: seed/doc/decisions
kind: doc
summary: 决策日志
applies_when: { project.type: any }
requires: []
grow: on-init
emits: state/decisions
verify: 每条决策含级别、决定者与可回退方式
---

# 决策日志

| 日期 | 级别 | 决定 | 决定者 | 依据 | 可回退方式 |
| --- | --- | --- | --- | --- | --- |
| <日期> | D1-D4 | <决定> | <用户/Agent> | <事实或默认值> | <回滚步骤> |

## 记录规则

- D1、D2 必须由用户决定，记录用户原话要点。
- D3 由 Agent 决定，记录默认值来源。
- 决定被推翻时新增一条，不删除旧记录。
