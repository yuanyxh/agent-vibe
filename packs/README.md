# 技术包

可选扩展，用于让特定技术栈的项目结构可复现。核心仓库不内置任何技术包。

## 何时需要

- 同一技术栈需要反复创建项目。
- 团队对目录与配置有统一约定。
- 现场生成的结果不稳定，需要固定下来。

只有这些情况才值得建包；其余项目直接由 agent 现场生成。

## 结构

```
packs/<pack-name>/
├── pack.yaml
└── files/            # 可选，需要原样复制的文件
```

```yaml
---
id: pack/<name>
summary: <技术栈与适用形态>
applies_when:
  project.type: web
  stack.framework: react
requires: [stack.package_manager]
provides:
  - 构建与开发命令
  - 目录结构
verify:
  install: <命令>
  build: <命令>
  test: <命令>
---
```

正文写：目录约定、关键文件职责、与其他技术栈的差异、已知限制。

## 约束

- 技术包只能提供结构、配置与命令，不得覆盖种子规则；规则冲突时以种子为准。
- 包内不得包含凭据、私有地址与业务代码。
- 一个包必须实际生成并跑通验证命令后才能视为可用。
- 技术包是 fork 后的私有资产，不建议回贡到核心仓库；通用模式应先按 `protocols/distill.md` 提炼为种子。
