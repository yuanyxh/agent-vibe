---
id: knowledge/index
kind: index
summary: 通用架构知识包索引
load: on-demand
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
---

# 知识包索引

按任务主题加载，单次只取相关条目，不整册注入。知识包是参考，不是强制规则；与项目规则冲突时以项目规则为准。

| 主题 | 文件 | 适用场景 | 触发 |
| --- | --- | --- | --- |
| 登录与身份 | `authn.md` | 有用户体系、会话或第三方登录 | 设计或修改认证流程 |
| 权限与授权 | `authorization.md` | 角色、菜单、接口或数据权限 | 设计权限模型或出现越权 |
| 缓存 | `caching.md` | 热点数据、重复计算、权限缓存 | 出现性能瓶颈或一致性问题 |
| 异步任务与队列 | `async-jobs.md` | 长任务、批量处理、重试 | 引入后台任务或消息队列 |
| 文件服务 | `file-service.md` | 上传、下载、预览、存储 | 设计文件能力 |
| 消息通知 | `notification.md` | 站内信、邮件、短信、推送 | 设计通知或触达 |
| 最终一致性 | `consistency.md` | 跨服务、三方同步、对账 | 出现状态不同步 |
| 时区与国际化 | `timezone-i18n.md` | 多地区、多语言、日期金额 | 产品进入新地区 |
| 导入导出 | `import-export.md` | 批量数据、模板、报表 | 设计导入导出 |
| 文档生成 | `pdf-generation.md` | PDF、打印、报表 | 生成可分发文档 |
| 自动更新 | `auto-update.md` | 桌面或客户端分发 | 设计升级通道 |
| 配置化 | `configuration.md` | 环境差异、特性开关 | 配置分散或频繁改代码 |
| 测试策略 | `testing.md` | 分层测试、质量门 | 设计测试或缺陷回归 |
| 代码设计与模式 | `design-patterns.md` | 模块复用、抽象时机、模式选择 | 复制代码增多或抽象失控 |
| 组件与主题 | `component-design.md` | 界面复用、设计系统 | 组件膨胀或风格不一致 |
| 部署自动化 | `deployment.md` | 构建、发布、回滚 | 进入持续交付 |
| 异常与轨迹 | `observability.md` | 崩溃、错误上报、用户轨迹 | 线上问题难以定位 |
| 系统定义与标准化 | `system-definition.md` | 项目启动、术语、边界 | 新项目或多人协作 |
| 缺陷类型与调试手段 | `debugging-playbook.md` | 卡顿、内存、卡死、慢查询、UI 显示与交互 | 选择调试工具或定位根因 |

## 加载规则

- 先读索引，再读 1~3 篇相关主题。
- 引用时写明主题与版本。
- 项目内反复验证的新模式，按 `protocols/distill.md` 提议新增知识包。
