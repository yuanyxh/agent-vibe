# 贡献指南

感谢改进 agent-vibe。本仓库是种子仓库：它描述可复用的 Agent 开发实践，不包含业务应用。

## 开始之前

- 阅读 `AGENTS.zh.md`，了解目录职责与种子格式。
- 新增种子前先搜索是否已有同类种子。
- 保持内容与具体技术、项目无关。种子必须能被至少两个不同技术栈的项目实例化。
- 提交前去掉具体项目名、路径、账号、密钥与版本号。

## 开发流程

1. fork 仓库，并从 `main` 创建分支。
2. 文档改动需同时修改两侧语言树：先改 `en/`，再同步到 `zh/`。
3. 本地执行检查：

```bash
scripts/check-format.sh
scripts/verify-seeds.sh --strict
scripts/test-fixtures.sh
```

4. 使用约定式提交信息，例如 `feat(seeds): add a capability seed` 或 `docs: clarify the loading protocol`。
5. 提交合并请求并填写模板。CI 会执行同一组检查。

## 新增或修改种子

- 使用 `AGENTS.zh.md` 记录的 frontmatter 字段，不得自创平台专属字段。
- 每条按需规则必须声明真实加载机制：`path`、`skill` 或 `read`。
- 改动影响对外种子契约时，更新 `SEEDS_VERSION` 与 `CHANGELOG.zh.md`。
- 不自动复制外部规则库；导入内容按种子格式重写，并去掉项目细节。
- 每条规则不得超过检查脚本强制的行数预算。

## 文档与翻译

- 英文（`en/`、`README.md`）为权威，中文（`zh/`、`README.zh.md`）为镜像。
- 两侧必须保持相同的标题、表格、列表数量与文件名。
- 只翻译自然语言；命令、路径、标识符与代码块保持不变。
- 语言树内的交叉引用必须指向本语言树。

## 报告安全问题

发现漏洞时不要开公开 Issue，按 [SECURITY.zh.md](SECURITY.zh.md) 处理。

## 行为准则

参与即表示你同意遵守 [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)。
