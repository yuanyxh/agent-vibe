---
id: seed/doc/backlog
kind: doc
summary: 未排期与延后工作的唯一队列
applies_when: { project.type: any }
requires: []
grow: on-init
emits: state/backlog
verify: 每个未完成事项都有优先级、状态与来源
---

# 待办

## 事项

| 编号 | 事项 | 优先级与状态 | 来源与备注 |
| --- | --- | --- | --- |
| todo-YYYYMMDD-NNN | <一句话结果> | <P0-P3；open/active/blocked/done/dropped> | <用户/故障/评审/计划；计划路径或备注> |

## 规则

- 一行一个事项；编号稳定，不复用。
- 优先级：P0 阻塞发布或用户，P1 当前阶段，P2 后续阶段，P3 可选。
- 只放未排期或延后事项；当前任务步骤留在任务计划中。
- 一个事项只有一个归属；需要时链接计划，不复制其步骤。
- 完成或拒绝时更新状态，并把该行移入下方归档。

## 归档

| 编号 | 事项 | 结果 | 日期 |
| --- | --- | --- | --- |
| <编号> | <事项> | <完成/放弃及原因> | <日期> |
