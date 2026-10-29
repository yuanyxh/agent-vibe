---
name: build
description: 当用户要求开发功能、修改实现或继续上次任务时触发
---

# 构建

执行前读取 `.agent/rules/engineering.md` 与变更范围对应的路径规则。

1. 读 `.agent/status.md`，确认目标与阻塞。
2. 选一个可验证的最小切片实现。
3. 运行构建与测试，记录结果。
4. 更新状态与决策。
