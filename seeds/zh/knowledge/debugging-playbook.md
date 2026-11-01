---
id: knowledge/debugging-playbook
kind: knowledge
summary: 按平台与症状分类的缺陷类型清单（含 UI/UX 显示与交互问题），及每种缺陷的最小排查手段与判定依据
applies_when: { project.type: any }
triggers: [排查缺陷, 选择调试工具, 性能分析, 内存问题, 死锁卡死, 界面显示异常, 交互失效]
sources: [Xcode Instruments 文档, Linux perf 文档, Go pprof 文档, Chrome DevTools 文档, 用户实战复盘 2026-10-29]
version: 1
updated: 2026-10-29
review_by: 2027-01-29
status: active
load: on-demand
---

# 缺陷类型与调试手册

本文回答一个问题：遇到某类缺陷时，先用哪个手段取证据、看到什么才算根因。按平台分节，每节先给缺陷类型表，再给命令与判据。工具名与命令均为本机或官方文档可核对的形态，不含推测用法。

## 总则：先分类，再选工具

缺陷先归到五类，工具选择由类别决定，不由直觉决定。

| 类别 | 典型表现 | 首选证据 |
| --- | --- | --- |
| 崩溃与卡死 | 闪退、无响应、界面冻结 | 崩溃日志、调用栈、信号 |
| 性能 | 卡顿、慢、CPU/GPU 高 | 火焰图、采样栈、trace |
| 资源 | 内存涨、句柄泄漏、磁盘满 | 内存快照、对象计数、句柄表 |
| 数据 | 状态错、脏数据、丢数据 | 前后快照、变更日志、约束校验 |
| 行为 | 功能不符预期、偶现 | 可重复断言、日志时间线 |

证据分三级，汇报时必须标注级别（见规则 TST-07）：L1 存在性、L2 行为、L3 端到端。

排查漏斗固定为六步：复现 → 观测 → 缩小 → 根因 → 修复 → 回归。任何一步缺证据都退回上一步，不进入下一步。

## 通用手段

以下手段跨平台通用，先确认哪一种能产出可判定的证据。

| 手段 | 适用缺陷 | 产出 |
| --- | --- | --- |
| 火焰图 | CPU 高、热点函数 | 按栈聚合的耗时分布 |
| 采样栈 | 卡死、死循环 | 多次中断的调用栈序列 |
| 内存快照 | 泄漏、膨胀 | 对象类型与引用链 |
| 系统调用跟踪 | 卡住、IO 慢 | 阻塞点与耗时 |
| 抓包 | 网络错误、超时 | 请求响应时间线 |
| 二分 | 回归、偶现 | 首个坏提交或配置项 |

死循环与卡死的通用判据：连续三次采样中同一调用栈位置反复出现，且线程状态不是等待 IO 或锁。

```bash
# macOS：按进程采样 10 秒，每 1 ms 一次
sample <pid> 10 1 -file /tmp/sample.txt

# Linux：对进程采样调用栈
perf record -F 99 -g -p <pid> -- sleep 30
perf script | stackcollapse-perf.pl | flamegraph.pl > /tmp/flame.svg
```

## UI 与交互

UI/UX 缺陷分三类：显示错、交互错、反馈缺失。三类的证据都必须是可见的（截图、录屏、可访问性树），日志只能辅助定位。

| 类型 | 典型症状 | 首选手段 | 判据 |
| --- | --- | --- | --- |
| 显示错位 | 元素偏移、截断、重叠 | 截图对比 + 多分辨率走查 | 与基线截图有超出阈值的差异 |
| 状态缺失 | 空态、加载、错误无提示 | 状态矩阵逐项走查 | 六态中任一态没有对应视图 |
| 交互失效 | 点击、拖拽、快捷键无反应 | 命中测试 + 事件日志 | 事件未到达目标或命中区域错误 |
| 焦点错乱 | Tab 顺序乱、焦点丢失 | 键盘走查 + 可访问性树 | 焦点顺序与视觉顺序不一致 |
| 文本问题 | 截断、乱码、溢出 | 伪本地化 + 超长文本注入 | 长文本膨胀 40% 后仍可读 |
| 对比度不足 | 暗色模式看不清 | 对比度检查 + 主题矩阵 | 文本对比度低于 4.5:1 |
| 反馈缺失 | 重复提交、无加载态 | 交互时序走查 | 操作后 100 ms 内没有任何反馈 |
| 层级遮挡 | 弹层被盖住、点不到 | 层叠顺序 dump + 命中测试 | 可视元素被不可见层拦截 |

### 状态矩阵

每个可见组件都要走查六态，缺一态即为缺陷。

| 状态 | 检查点 |
| --- | --- |
| 空数据 | 有空态文案与下一步引导，不是白屏 |
| 加载中 | 有骨架或进度，布局不跳动 |
| 失败 | 有错误文案与重试入口 |
| 禁用 | 视觉与行为一致，确实不可点 |
| 超长文本 | 截断规则明确，有完整内容入口 |
| 极端数值 | 0、负数、超大数不破坏布局 |

### 多环境矩阵

显示与交互问题大多只在某个维度复现，必须逐维走查。

| 维度 | 取值 |
| --- | --- |
| 分辨率与缩放 | 最低支持分辨率、Retina 与非 Retina、外接屏 |
| 主题 | 浅色、深色、跟随系统 |
| 语言 | 中文、英文、伪本地化长文本、从右到左 |
| 字体 | 系统默认、放大字号 |
| 输入 | 键盘、鼠标、触控板、输入法组合态 |

### 平台手段

| 平台 | 视觉回归 | 交互自动化 |
| --- | --- | --- |
| Web | Playwright `toHaveScreenshot`、Chromatic | Playwright 或 Cypress 驱动点击、拖拽、键盘 |
| macOS 与 iOS | XCTest 截图附件、快照测试 | XCUITest、Accessibility Inspector 检查可访问性树 |
| Android | Paparazzi 或 Roborazzi | Espresso、UI Automator |

截图对比必须掩码动态区域（时间、头像、随机内容）并设容差，追求零像素差异的基线无法维护。

命中与层级用系统 API 确认，不靠肉眼判断。

```javascript
// 浏览器：确认该坐标实际命中的元素
document.elementFromPoint(x, y)
```

```swift
// macOS：确认该点命中的视图
window.contentView?.hitTest(point)
```

输入法要单列测试项：中文组合输入、候选窗、全角符号。macOS 上输入法候选窗会抢 key window，不能用 `isKeyWindow` 判断真实焦点。

可用性验证用 5 名目标用户完成任务法，记录失败点与耗时；认知走查用于发现「用户不知道下一步」。两者都要留下录屏或笔记作为证据。

UI 结论一律按 L3 证据处理，必须附截图或录屏；只有代码断言或日志时最多算 L2。

## Web 前端

浏览器内的缺陷几乎都能用 Chrome DevTools 与 Performance 面板定位，本地复现优于线上猜测。

| 缺陷类型 | 典型症状 | 首选手段 | 判据 |
| --- | --- | --- | --- |
| 渲染卡顿 | 滚动掉帧、交互延迟 | Performance 面板录制 | 主线程长任务 > 50 ms，或帧时长 > 16 ms |
| 内存泄漏 | 内存阶梯上涨、页面越用越慢 | Memory 面板堆快照 | 三次快照间同一类对象持续增长且不可回收 |
| 白屏或加载慢 | 首屏空白、LCP 差 | Network 瀑布 + Web Vitals | 阻塞资源在关键路径上，或 LCP > 2.5 s |
| 事件无响应 | 点击无反应 | Performance 长任务 + 事件监听器 | 输入事件排队时间（INP）超阈值 |
| 样式错乱 | 布局跳动、层级错误 | Rendering 面板 + Layers | 出现 layout shift 区域或过多合成层 |
| 请求失败 | 4xx/5xx、CORS | Network 面板、HAR | 预检失败或响应头缺失 |
| 状态错乱 | 数据与界面不一致 | 状态管理 DevTools 时间旅行 | 回放某次 action 后可稳定复现 |
| 交互无反馈 | 点击后无加载、可重复提交 | 交互时序走查 | 操作后 100 ms 内无任何视觉反馈 |
| 文本溢出 | 长文案截断、布局撑破 | 伪本地化 + 多语言截图 | 长度膨胀 40% 后布局仍完整 |

前端内存排查要点：在 Memory 面板做三次快照（操作前、重复操作后、GC 后），用 Comparison 视图按 delta 排序；重点看 Detached DOM tree 与闭包持有的引用链。

```javascript
// 强制 GC 后取快照，需以 --js-flags=--expose-gc 启动
globalThis.gc?.()
```

性能数据采集用 Long Animation Frames 与 `PerformanceObserver`，避免自己写计时器引入噪声。

```javascript
new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (entry.duration > 50) console.log(entry)
  }
}).observe({ type: 'long-animation-frame', buffered: true })
```

移动端 WebView 用 Safari Web Inspector（iOS）或 `chrome://inspect`（Android）连真机，不用模拟器结论代替。

## macOS 与 iOS GUI

原生界面的卡顿与泄漏优先用 Instruments，命令行工具用于快速判断与线上采样。

| 缺陷类型 | 典型症状 | 首选手段 | 判据 |
| --- | --- | --- | --- |
| 界面卡顿 | 滚动掉帧、动画停顿 | Time Profiler + Animation Hitches | 主线程栈集中在布局或绘制，且帧超预算 |
| 主线程阻塞 | 点击无响应、转圈 | `sample` 或 `spindump` | 主线程栈停在同步等待或重计算 |
| 崩溃 | 闪退、异常退出 | 崩溃日志 + `atos` 符号化 | 异常类型与栈顶帧可对应代码 |
| 内存泄漏 | 内存持续上涨 | Instruments Leaks / Allocations | 对象有分配无释放，引用链指向持有者 |
| 启动慢 | 冷启动久 | `DYLD_PRINT_STATISTICS` + App Launch | 动态链接或初始化阶段占比最高 |
| 焦点与窗口异常 | 窗口消失、点不到 | 日志断言 + `CGWindowListCopyWindowInfo` | 窗口 `visible`、层级、前台应用三者对不上 |
| 资源缺失 | 启动崩溃、图标空白 | `codesign`、`otool`、产物内资源清单 | 包内缺少构建期声明的资源 |
| 视觉不一致 | 明暗模式错色、贴图模糊 | 截图对比 + Retina 走查 | 与设计基线或另一主题差异明显 |
| 命中与层级 | 点不到、弹层被盖 | `hitTest` + `CGWindowListCopyWindowInfo` | 命中视图不是预期目标 |

主线程卡顿的采样判据：三次采样都停在同一个函数，才判为热点；只出现一次的多为噪声。

```bash
# 崩溃日志位置
ls ~/Library/Logs/DiagnosticReports/*.ips

# 符号化
atos -o <binary>.dSYM/Contents/Resources/DWARF/<binary> -arch arm64 -l <load_address> <address>

# 快速查看窗口层级与可见性
swift -e 'import CoreGraphics; for w in CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as! [[String: Any]] { print(w[kCGWindowOwnerName as String] ?? "", w[kCGWindowName as String] ?? "", w[kCGWindowLayer as String] ?? "") }'
```

内存泄漏排查顺序：先看 Leaks 是否有确定泄漏，再用 Allocations 看增长类型，最后用 `leaks`/`heap`/`vmmap` 交叉确认。需要引用链时开启 MallocStackLogging。

```bash
leaks <pid>
heap <pid> -addresses all | head
vmmap --summary <pid>
```

窗口与焦点类缺陷不要靠肉眼猜，先埋断言：`isVisible`、`isKeyWindow`、`NSApp.isActive`、前台应用 bundle id 四个量分开记录，再对照时间线。

## 后端服务

服务端缺陷的核心是「在不重启的前提下取到运行时状态」，因此要提前具备采样、快照与指标三件套。

| 缺陷类型 | 典型症状 | 首选手段 | 判据 |
| --- | --- | --- | --- |
| CPU 高 | 负载高、延迟上升 | CPU 火焰图 | 单一函数族占比超过 30% |
| 死循环或卡死 | 请求不返回、线程不动 | 多次栈采样对比 | 同一栈位置连续出现且不在等待状态 |
| 内存泄漏 | RSS 单调上涨、最终 OOM | 堆快照 + 增长曲线 | 快照间某类型对象数量单调增长 |
| 内存溢出 | 进程被杀、OOM 日志 | 系统日志 + 限额配置 | `dmesg` 出现 OOM killer 记录 |
| 锁竞争 | 吞吐上不去、延迟抖动 | 阻塞/互斥采样 | 线程大量处于 BLOCKED 或等待队列 |
| 线程或协程泄漏 | 句柄与线程数上涨 | 运行时线程/协程指标 | 数量随请求量线性增长且不回落 |
| IO 慢 | 请求尾部延迟高 | 系统调用跟踪 | 阻塞集中在 read/write 或 fsync |
| 网络异常 | 连接超时、丢包 | 抓包 + 连接状态 | 重传、RST 或连接池耗尽 |
| 队列积压 | 消息延迟增长 | 积压指标 | 生产速率持续高于消费速率 |

各语言的等价命令，优先用自带 profiler，避免外部工具带来的停机风险。

```bash
# Go：CPU 与堆火焰图
go tool pprof -http=:6060 http://localhost:6060/debug/pprof/profile?seconds=30
go tool pprof -http=:6060 http://localhost:6060/debug/pprof/heap

# Go：卡死时导出全部 goroutine 栈
curl 'http://localhost:6060/debug/pprof/goroutine?debug=2'

# Python：采样栈，无需改代码
py-spy top --pid <pid>
py-spy dump --pid <pid>

# Java：线程栈与堆
jstack <pid> > /tmp/threads.txt
jcmd <pid> GC.heap_dump /tmp/heap.hprof

# Node.js：堆快照
node --inspect=0.0.0.0:9229 <entry>
```

死循环的判定方法固定为「隔 2 秒连续 dump 三次，比较栈顶」：三次完全一致且线程不处于 `TIMED_WAITING`、`epoll_wait`、`futex` 等等待态，才是忙循环。

内存是否泄漏先看趋势，不看单点：周期性记录 RSS 与堆使用量，若在稳定流量下单调上升且 GC 后不回落，才进入快照分析。

```bash
# 跨平台粗查（Linux）
cat /proc/<pid>/smaps_rollup | grep -E 'Rss|Pss'
# macOS
vmmap --summary <pid>
```

C/C++ 服务优先用 sanitizer 在测试环境复现，不要在生产上加检测。

```bash
gcc -fsanitize=address,undefined -g main.c
clang -fsanitize=thread -g main.c
```

## 数据库

数据库缺陷优先用执行计划与等待事件定位，避免直接猜索引。

| 缺陷类型 | 典型症状 | 首选手段 | 判据 |
| --- | --- | --- | --- |
| 慢查询 | 单条 SQL 偶发慢 | `EXPLAIN ANALYZE` | 全表扫描、行数估算与实际偏差大 |
| 锁等待 | 更新卡住、超时 | 锁视图 | 存在长时间持锁事务或等待链 |
| 死锁 | 周期性报错 | 死锁日志 | 两个以上事务循环等待同一资源 |
| 连接耗尽 | 请求排队 | 连接数指标 | 活跃连接接近上限 |
| 复制延迟 | 从库数据旧 | 复制状态 | 延迟秒数持续增长 |
| 统计信息过期 | 计划突然变差 | 表统计与计划对比 | 估算行数与实际行数相差一个数量级 |

```sql
-- PostgreSQL
EXPLAIN (ANALYZE, BUFFERS) SELECT ...;
SELECT pid, wait_event_type, wait_event, state, query FROM pg_stat_activity WHERE state <> 'idle';

-- MySQL
SHOW ENGINE INNODB STATUS;
SELECT * FROM performance_schema.data_lock_waits;
```

## CLI 与脚本

命令行缺陷优先排除环境差异，再查进程状态。

| 缺陷类型 | 典型症状 | 首选手段 | 判据 |
| --- | --- | --- | --- |
| 挂起不动 | 无输出、不退出 | SIGQUIT 栈转储或外部采样 | 栈停在等待输入或锁 |
| 退出码异常 | 静默失败 | `echo $?` + `strace -f` | 失败点对应具体系统调用 |
| 环境差异 | 换机器就错 | 清理环境重跑 | 仅特定 PATH、locale、版本下复现 |
| 资源未释放 | 文件句柄耗尽 | 句柄表 | 句柄数随运行增长 |

```bash
# 让挂起的进程打印栈（Java、Python、部分 shell）
kill -QUIT <pid>
# 外部采样（macOS）
sample <pid> 5 1
# 跟踪系统调用并显示耗时
strace -f -T -o /tmp/trace.txt <command>
```

## 移动端 Android

Android 侧优先用 Perfetto 看整机时间线，再用内置 Profiler 看进程内细节。

| 缺陷类型 | 典型症状 | 首选手段 | 判据 |
| --- | --- | --- | --- |
| 卡顿掉帧 | 滑动不跟手 | Perfetto / Systrace | 主线程帧耗时超预算或渲染线程阻塞 |
| 内存泄漏 | 内存持续上涨 | LeakCanary | 存在可达的 Activity 或 Context 泄漏引用 |
| ANR | 无响应弹窗 | `traces.txt` | 主线程阻塞在锁、IO 或消息队列 |
| 布局错乱 | 界面错位 | Layout Inspector | 约束冲突或尺寸测量异常 |
| 后台耗电 | 待机掉电快 | Battery Historian | 存在长时间唤醒锁或高频网络 |
| 状态缺失 | 空态白屏、无加载反馈 | 状态矩阵走查 | 六态中任一态没有对应视图 |

```bash
adb shell dumpsys activity processes | head -50
adb shell dumpsys meminfo <package>
adb shell am dumpheap <package> /data/local/tmp/heap.hprof
```

## 跨端与分布式

跨服务缺陷先拿一条完整链路，再定位到具体节点。

| 缺陷类型 | 典型症状 | 首选手段 | 判据 |
| --- | --- | --- | --- |
| 链路超时 | 整体慢、无明确错误 | 分布式追踪 | 关键路径上某节点耗时占比最高 |
| 雪崩 | 一个服务挂，全线报警 | 依赖图 + 熔断指标 | 重试与超时配置放大故障 |
| 数据不一致 | 两端状态不同 | 变更日志与对账 | 某次写入未达到最终状态 |
| 环境差异 | 预发正常、生产异常 | 配置与版本 diff | 仅某一维度取值不同 |

排查顺序固定为：trace 定位节点 → 该节点看指标（错误率、延迟分位、饱和度）→ 看日志时间线 → 必要时抓包或采样栈。

## 判定根因与收尾

根因必须回答三问，答不全就不是根因。

1. 触发条件是什么（输入、时序、配置、环境）。
2. 走了哪条代码路径，为什么会产生当前现象。
3. 为什么此前没有暴露（为什么不常发生、为什么测试没覆盖）。

修复阶段只改与根因相关的代码，保留原有行为；随后补一个能在缺陷重现时失败的检查（测试、脚本或断言），并按证据分级汇报。

## 症状速查

| 症状 | 首选手段 | 平台 |
| --- | --- | --- |
| 页面滚动掉帧 | Performance 面板 + 长任务 | Web |
| 桌面界面卡顿 | Time Profiler + `sample` | macOS |
| 服务 CPU 高 | `perf` / `pprof` 火焰图 | 后端 |
| 进程内存上涨 | 堆快照对比 + RSS 曲线 | 全平台 |
| 死循环或卡死 | 多次栈采样对比 | 全平台 |
| 请求偶发超时 | 链路追踪 + 抓包 | 分布式 |
| 数据库偶发慢 | `EXPLAIN ANALYZE` + 锁视图 | 数据库 |
| 换机器就出错 | 清理环境 + 配置 diff | CLI |
| 元素点不到 | 命中测试 + 层级 dump | UI |
| 文案截断或溢出 | 伪本地化 + 截图对比 | UI |
| 暗色模式看不清 | 对比度检查 + 主题矩阵 | UI |
