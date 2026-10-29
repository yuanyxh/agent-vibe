## 变更

<!-- 说明改了哪些种子、协议或适配器，以及影响范围 -->

## 校验

- [ ] `scripts/check-format.sh`
- [ ] `scripts/verify-seeds.sh --strict`
- [ ] `scripts/test-fixtures.sh`
- [ ] 改动种子时已更新 `SEEDS_VERSION` 与 `CHANGELOG.md`
- [ ] 新规则可由命令或检查验证

## 审查清单

- [ ] 种子不包含具体项目、技术栈、个人路径或凭据
- [ ] 规则有触发条件、加载方式与验证方式
- [ ] 适配器与 `protocols/loading.md` 的平台矩阵一致
- [ ] 文档引用与链接可达
- [ ] 未降低 golden fixture 的校验结果

## 关联

<!-- 决策记录、迁移影响或回滚方式 -->
