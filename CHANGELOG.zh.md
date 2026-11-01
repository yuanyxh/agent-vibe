# 变更记录

种子仓库以 `SEEDS_VERSION` 为对外版本，使用语义版本。生成项目在 `.agent/profile.yaml` 记录 `seed_version`，升级按 `protocols/zh/upgrade-seeds.md` 执行。

## 1.1.0 - 2026-11-01

- 文档改为 `seeds/`、`protocols/`、`adapters/`、`examples/`、`packs/` 下的 `en/` 与 `zh/` 双目录结构。
- 英文成为权威文档语言，并补齐完整中文镜像。
- 新增 `LICENSE`（MIT）、`CONTRIBUTING.md`、`SECURITY.md`、`CODE_OF_CONDUCT.md`、Issue 模板与扩展后的 `.gitignore`。
- `scripts/verify-seeds.sh` 扩展为同时校验两侧语言树、平台矩阵、适配器与跨文档链接。
- 脚本用户可见输出改为英文。
- 新增中英双语 README、CAPABILITIES、AGENTS 与 CHANGELOG。

## 1.0.0 - 2026-10-29

- 首次版本化：新增 `SEEDS_VERSION`、本记录与 `protocols/upgrade-seeds.md`。
- 新增 Codex 适配器；`generic` 只覆盖通用平台。
- 新增 5 个高频领域参考定义：web-app、backend、cli、web-marketing、desktop。
- 记忆协议新增条目编号、容量归档与外部条目引用。
- 新增实例化校验脚本与 golden fixture；种子自检扩展语义检查。
- 新增 CI，推送与合并请求都执行种子校验。
