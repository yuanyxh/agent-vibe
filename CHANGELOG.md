# 变更记录

种子仓库以 `SEEDS_VERSION` 为对外版本，使用语义版本。生成项目在 `.agent/profile.yaml` 记录 `seed_version`，升级按 `protocols/upgrade-seeds.md` 执行。

## 1.0.0 - 2026-10-29

- 首次版本化：新增 `SEEDS_VERSION`、本记录与 `protocols/upgrade-seeds.md`。
- 新增 Codex 适配器；`generic` 只覆盖通用平台。
- 新增 5 个高频领域参考定义：web-app、backend、cli、web-marketing、desktop。
- 记忆协议新增条目编号、容量归档与外部条目引用。
- 新增实例化校验脚本与 golden fixture；种子自检扩展语义检查。
- 新增 CI，推送与合并请求都执行种子校验。
