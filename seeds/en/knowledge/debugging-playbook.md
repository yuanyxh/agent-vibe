---
id: knowledge/debugging-playbook
kind: knowledge
summary: A defect-type checklist organized by platform and symptom (including UI/UX display and interaction issues), with the minimum investigation techniques and judgment criteria for each defect type
applies_when: { project.type: any }
triggers: [investigating defects, choosing debugging tools, performance analysis, memory issues, deadlocks and hangs, UI display anomalies, interaction failures]
sources: [Xcode Instruments documentation, Linux perf documentation, Go pprof documentation, Chrome DevTools documentation, user hands-on postmortem 2026-10-29]
version: 1
updated: 2026-10-29
review_by: 2027-01-29
status: active
load: on-demand
---

# Defect Types and Debugging Playbook

This document answers one question: when encountering a certain type of defect, which technique should be used first to gather evidence, and what must be observed before concluding a root cause. It is organized by platform; each section first gives a defect-type table, then commands and criteria. Tool names and commands are in forms verifiable on this machine or in official documentation, with no speculative usage.

## General Principles: Classify First, Then Choose Tools

Classify defects into five categories first; tool choice follows the category, not intuition.

| Category | Typical signs | Preferred evidence |
| --- | --- | --- |
| Crashes and hangs | Crashes, unresponsiveness, frozen UI | Crash logs, call stacks, signals |
| Performance | Jank, slowness, high CPU/GPU | Flame graphs, sampled stacks, traces |
| Resources | Memory growth, handle leaks, full disk | Memory snapshots, object counts, handle tables |
| Data | Wrong state, dirty data, lost data | Before/after snapshots, change logs, constraint checks |
| Behavior | Behavior differs from expectations, intermittent | Repeatable assertions, log timelines |

Evidence has three levels, and the level must be stated when reporting (see rule TST-07): L1 existence, L2 behavior, L3 end-to-end.

The investigation funnel is fixed at six steps: reproduce → observe → narrow → root cause → fix → regression. If any step lacks evidence, return to the previous step; do not proceed.

## Common Techniques

The following techniques are cross-platform; first confirm which one can produce decisive evidence.

| Technique | Applicable defects | Output |
| --- | --- | --- |
| Flame graph | High CPU, hot functions | Time distribution aggregated by stack |
| Sampled stacks | Hangs, infinite loops | Sequences of call stacks from repeated interrupts |
| Memory snapshot | Leaks, growth | Object types and reference chains |
| System call tracing | Stuck, slow IO | Blocking points and durations |
| Packet capture | Network errors, timeouts | Request-response timeline |
| Bisection | Regressions, intermittence | First bad commit or configuration item |

General criterion for infinite loops and hangs: the same call-stack location appears repeatedly in three consecutive samples, and the thread state is not waiting on IO or a lock.

```bash
# macOS: sample the process for 10 seconds at 1 ms intervals
sample <pid> 10 1 -file /tmp/sample.txt

# Linux: sample the process call stack
perf record -F 99 -g -p <pid> -- sleep 30
perf script | stackcollapse-perf.pl | flamegraph.pl > /tmp/flame.svg
```

## UI and Interaction

UI/UX defects fall into three categories: display errors, interaction errors, and missing feedback. Evidence for all three must be visible (screenshots, screen recordings, accessibility trees); logs can only assist in locating.

| Type | Typical symptoms | Preferred technique | Criterion |
| --- | --- | --- | --- |
| Misalignment | Elements shifted, truncated, overlapping | Screenshot comparison + multi-resolution walkthrough | Differences from baseline screenshots exceed the threshold |
| Missing states | Empty, loading, or error states without guidance | Item-by-item walkthrough of the state matrix | Any of the six states has no corresponding view |
| Failed interaction | Click, drag, or shortcut does not respond | Hit testing + event logs | The event does not reach the target or the hit area is wrong |
| Focus disorder | Tab order scrambled, focus lost | Keyboard walkthrough + accessibility tree | Focus order differs from visual order |
| Text problems | Truncation, garbled text, overflow | Pseudo-localization + long-text injection | Still readable after text expands by 40% |
| Insufficient contrast | Unreadable in dark mode | Contrast checks + theme matrix | Text contrast below 4.5:1 |
| Missing feedback | Duplicate submissions, no loading state | Interaction timing walkthrough | No feedback within 100 ms of the action |
| Occlusion | Popups covered, unclickable | Stacking-order dump + hit testing | Visible elements intercepted by invisible layers |

### State Matrix

Every visible component must be checked in six states; missing any state is a defect.

| State | Checkpoint |
| --- | --- |
| Empty data | Has empty-state copy and a next-step guide, not a blank screen |
| Loading | Has a skeleton or progress, layout does not jump |
| Failure | Has error copy and a retry entry point |
| Disabled | Visuals and behavior are consistent; truly not clickable |
| Very long text | Truncation rules are clear, with an entry to the full content |
| Extreme values | 0, negative numbers, and very large numbers do not break layout |

### Multi-Environment Matrix

Display and interaction issues mostly reproduce only along one dimension; walk through each dimension.

| Dimension | Values |
| --- | --- |
| Resolution and scaling | Minimum supported resolution, Retina and non-Retina, external displays |
| Theme | Light, dark, follow system |
| Language | Chinese, English, pseudo-localized long text, right-to-left |
| Font | System default, enlarged font size |
| Input | Keyboard, mouse, trackpad, input method composition states |

### Platform Techniques

| Platform | Visual regression | Interaction automation |
| --- | --- | --- |
| Web | Playwright `toHaveScreenshot`, Chromatic | Playwright or Cypress driving clicks, drags, and keyboard |
| macOS and iOS | XCTest screenshot attachments, snapshot tests | XCUITest, Accessibility Inspector to inspect the accessibility tree |
| Android | Paparazzi or Roborazzi | Espresso, UI Automator |

Screenshot comparison must mask dynamic regions (time, avatars, random content) and set tolerances; a zero-pixel-difference baseline cannot be maintained.

Confirm hit testing and layering with system APIs, not by eye.

```javascript
// Browser: identify the element actually hit at that coordinate
document.elementFromPoint(x, y)
```

```swift
// macOS: identify the view hit at that point
window.contentView?.hitTest(point)
```

Input methods must be tested separately: Chinese composition input, candidate windows, and full-width symbols. On macOS, the input method candidate window takes the key window, so `isKeyWindow` cannot be used to judge the real focus.

Usability validation uses the five-target-user task method, recording failure points and time; cognitive walkthroughs find where "users do not know the next step." Both must leave screen recordings or notes as evidence.

All UI conclusions are treated as L3 evidence and must include screenshots or screen recordings; with only code assertions or logs, they count as L2 at most.

## Web Frontend

Defects in the browser can almost always be located with Chrome DevTools and the Performance panel; local reproduction beats online guessing.

| Defect type | Typical symptoms | Preferred technique | Criterion |
| --- | --- | --- | --- |
| Render jank | Dropped frames while scrolling, interaction delay | Performance panel recording | Main-thread long task > 50 ms, or frame duration > 16 ms |
| Memory leak | Memory climbs in steps, pages get slower with use | Memory panel heap snapshots | The same object type keeps growing across three snapshots and cannot be collected |
| White screen or slow load | Blank first screen, poor LCP | Network waterfall + Web Vitals | Blocking resources on the critical path, or LCP > 2.5 s |
| Unresponsive events | Clicks do not respond | Performance long tasks + event listeners | Input event queuing time (INP) exceeds the threshold |
| Style breakage | Layout shifts, wrong layering | Rendering panel + Layers | Layout-shift regions appear or too many composited layers |
| Request failures | 4xx/5xx, CORS | Network panel, HAR | Preflight failure or missing response headers |
| State corruption | Data and UI disagree | State management DevTools time travel | Replaying an action reproduces it reliably |
| No interaction feedback | No loading after click, duplicate submissions | Interaction timing walkthrough | No visual feedback within 100 ms of the action |
| Text overflow | Long copy truncated, layout broken | Pseudo-localization + multilingual screenshots | Layout still intact after a 40% length increase |

Frontend memory investigation essentials: take three snapshots in the Memory panel (before the operation, after repeating it, after GC), and sort by delta in the Comparison view; focus on detached DOM trees and reference chains held by closures.

```javascript
// Take the snapshot after a forced GC; start with --js-flags=--expose-gc
globalThis.gc?.()
```

Performance data collection uses Long Animation Frames and `PerformanceObserver` instead of writing custom timers that add noise.

```javascript
new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (entry.duration > 50) console.log(entry)
  }
}).observe({ type: 'long-animation-frame', buffered: true })
```

Mobile WebViews use Safari Web Inspector (iOS) or `chrome://inspect` (Android) connected to a real device; simulator conclusions do not substitute.

## macOS and iOS GUI

For jank and leaks in native UI, prefer Instruments; command-line tools are for quick judgment and online sampling.

| Defect type | Typical symptoms | Preferred technique | Criterion |
| --- | --- | --- | --- |
| UI jank | Dropped frames while scrolling, animation stutter | Time Profiler + Animation Hitches | Main-thread stacks concentrate in layout or drawing, and frames exceed budget |
| Main-thread blocking | Clicks do not respond, spinning | `sample` or `spindump` | The main-thread stack is stuck in synchronous waiting or heavy computation |
| Crashes | Crashes, abnormal exits | Crash logs + `atos` symbolication | The exception type and top frame map to code |
| Memory leaks | Memory keeps rising | Instruments Leaks / Allocations | Objects allocated without release; the reference chain points to the owner |
| Slow launch | Long cold start | `DYLD_PRINT_STATISTICS` + App Launch | Dynamic linking or initialization takes the largest share |
| Focus and window anomalies | Windows disappear, unclickable | Log assertions + `CGWindowListCopyWindowInfo` | Window `visible`, layering, and foreground app do not agree |
| Missing resources | Startup crashes, blank icons | `codesign`, `otool`, resource manifest in the artifact | Resources declared at build time are missing from the package |
| Visual inconsistency | Wrong colors in light/dark mode, blurry images | Screenshot comparison + Retina walkthrough | Clear differences from the design baseline or the other theme |
| Hit testing and layering | Unclickable, popups covered | `hitTest` + `CGWindowListCopyWindowInfo` | The hit view is not the expected target |

Main-thread jank sampling criterion: only when three samples all stop in the same function is it a hot spot; a one-off occurrence is mostly noise.

```bash
# Crash log location
ls ~/Library/Logs/DiagnosticReports/*.ips

# Symbolicate
atos -o <binary>.dSYM/Contents/Resources/DWARF/<binary> -arch arm64 -l <load_address> <address>

# Inspect window hierarchy and visibility quickly
swift -e 'import CoreGraphics; for w in CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as! [[String: Any]] { print(w[kCGWindowOwnerName as String] ?? "", w[kCGWindowName as String] ?? "", w[kCGWindowLayer as String] ?? "") }'
```

Memory leak investigation order: first check whether Leaks confirms a leak, then use Allocations to see growth types, and finally cross-check with `leaks`/`heap`/`vmmap`. Enable MallocStackLogging when reference chains are needed.

```bash
leaks <pid>
heap <pid> -addresses all | head
vmmap --summary <pid>
```

Window and focus defects should not be guessed by eye; instrument assertions first: record `isVisible`, `isKeyWindow`, `NSApp.isActive`, and the foreground app bundle id as four separate values, then compare against the timeline.

## Backend Services

The core of server-side defects is capturing runtime state without restarting, so sampling, snapshots, and metrics must be available in advance.

| Defect type | Typical symptoms | Preferred technique | Criterion |
| --- | --- | --- | --- |
| High CPU | High load, rising latency | CPU flame graph | A single function family exceeds 30% |
| Infinite loop or hang | Requests do not return, threads stall | Comparison of multiple stack samples | The same stack location appears repeatedly and is not in a waiting state |
| Memory leak | RSS rises monotonically, eventually OOM | Heap snapshots + growth curve | Some object type grows monotonically across snapshots |
| Out of memory | Process killed, OOM logs | System logs + limit configuration | `dmesg` shows OOM killer records |
| Lock contention | Throughput plateaus, latency jitter | Blocking/mutex sampling | Many threads are BLOCKED or in wait queues |
| Thread or coroutine leak | Handle and thread counts rise | Runtime thread/coroutine metrics | Counts grow linearly with request volume and do not fall back |
| Slow IO | High tail latency | System call tracing | Blocking concentrates in read/write or fsync |
| Network anomalies | Connection timeouts, packet loss | Packet capture + connection states | Retransmits, RSTs, or connection pool exhaustion |
| Queue backlog | Message latency grows | Backlog metrics | Production rate stays above consumption rate |

Equivalent commands per language; prefer the built-in profiler to avoid the downtime risk of external tools.

```bash
# Go: CPU and heap flame graphs
go tool pprof -http=:6060 http://localhost:6060/debug/pprof/profile?seconds=30
go tool pprof -http=:6060 http://localhost:6060/debug/pprof/heap

# Go: dump all goroutine stacks when hung
curl 'http://localhost:6060/debug/pprof/goroutine?debug=2'

# Python: sample stacks without code changes
py-spy top --pid <pid>
py-spy dump --pid <pid>

# Java: thread stacks and heap
jstack <pid> > /tmp/threads.txt
jcmd <pid> GC.heap_dump /tmp/heap.hprof

# Node.js: heap snapshot
node --inspect=0.0.0.0:9229 <entry>
```

The criterion for infinite loops is fixed as "dump three times, 2 seconds apart, and compare the stack tops": only when all three are identical and the thread is not in a waiting state such as `TIMED_WAITING`, `epoll_wait`, or `futex` is it a busy loop.

Whether memory is leaking is judged by trend, not a single point: record RSS and heap usage periodically; only if they rise monotonically under stable traffic and do not fall back after GC do you proceed to snapshot analysis.

```bash
# Cross-platform quick check (Linux)
cat /proc/<pid>/smaps_rollup | grep -E 'Rss|Pss'
# macOS
vmmap --summary <pid>
```

For C/C++ services, reproduce in test environments with sanitizers; do not add instrumentation in production.

```bash
gcc -fsanitize=address,undefined -g main.c
clang -fsanitize=thread -g main.c
```

## Databases

Database defects are best located with execution plans and wait events; avoid guessing at indexes directly.

| Defect type | Typical symptoms | Preferred technique | Criterion |
| --- | --- | --- | --- |
| Slow query | A single SQL statement is occasionally slow | `EXPLAIN ANALYZE` | Full table scan, or row estimate far from actual |
| Lock waits | Updates stuck, timeouts | Lock views | Long-held lock transactions or wait chains |
| Deadlocks | Periodic errors | Deadlock logs | Two or more transactions cyclically wait for the same resource |
| Connection exhaustion | Requests queue | Connection count metrics | Active connections near the limit |
| Replication lag | Replicas serve stale data | Replication status | Lag in seconds keeps growing |
| Stale statistics | Plans suddenly degrade | Table statistics vs. plan comparison | Estimated rows differ from actual rows by an order of magnitude |

```sql
-- PostgreSQL
EXPLAIN (ANALYZE, BUFFERS) SELECT ...;
SELECT pid, wait_event_type, wait_event, state, query FROM pg_stat_activity WHERE state <> 'idle';

-- MySQL
SHOW ENGINE INNODB STATUS;
SELECT * FROM performance_schema.data_lock_waits;
```

## CLI and Scripts

For command-line defects, rule out environment differences first, then check process state.

| Defect type | Typical symptoms | Preferred technique | Criterion |
| --- | --- | --- | --- |
| Hangs | No output, does not exit | SIGQUIT stack dump or external sampling | The stack is stuck waiting for input or a lock |
| Abnormal exit code | Silent failure | `echo $?` + `strace -f` | The failure point maps to a specific system call |
| Environment differences | Breaks on another machine | Clean environment rerun | Reproduces only under a specific PATH, locale, or version |
| Unreleased resources | File handles exhausted | Handle table | Handle count grows with runtime |

```bash
# Make a hung process print its stack (Java, Python, some shells)
kill -QUIT <pid>
# External sampling (macOS)
sample <pid> 5 1
# Trace system calls with timings
strace -f -T -o /tmp/trace.txt <command>
```

## Mobile Android

On Android, prefer Perfetto for the whole-device timeline, then the built-in Profiler for in-process details.

| Defect type | Typical symptoms | Preferred technique | Criterion |
| --- | --- | --- | --- |
| Jank and dropped frames | Scrolling does not track the finger | Perfetto / Systrace | Main-thread frame time exceeds budget or the render thread is blocked |
| Memory leak | Memory keeps rising | LeakCanary | Reachable leaked Activity or Context references |
| ANR | Unresponsive dialog | `traces.txt` | Main thread blocked on a lock, IO, or the message queue |
| Layout breakage | Misaligned UI | Layout Inspector | Constraint conflicts or abnormal size measurement |
| Background battery drain | Fast drain in standby | Battery Historian | Long wake locks or high-frequency networking |
| Missing states | Blank empty state, no loading feedback | State matrix walkthrough | Any of the six states has no corresponding view |

```bash
adb shell dumpsys activity processes | head -50
adb shell dumpsys meminfo <package>
adb shell am dumpheap <package> /data/local/tmp/heap.hprof
```

## Cross-Device and Distributed

For cross-service defects, capture a complete trace first, then locate the specific node.

| Defect type | Typical symptoms | Preferred technique | Criterion |
| --- | --- | --- | --- |
| Trace timeouts | Slow overall, no clear error | Distributed tracing | One node on the critical path has the highest time share |
| Cascading failure | One service down, alerts everywhere | Dependency graph + circuit breaker metrics | Retry and timeout configuration amplifies the failure |
| Data inconsistency | States differ on both ends | Change logs and reconciliation | A write never reached the final state |
| Environment differences | Fine in staging, broken in production | Configuration and version diff | Only one dimension's value differs |

The investigation order is fixed: trace locates the node → look at that node's metrics (error rate, latency percentiles, saturation) → read the log timeline → capture packets or sample stacks when necessary.

## Determining Root Cause and Wrapping Up

A root cause must answer three questions; if any is unanswered, it is not a root cause.

1. What is the trigger condition (input, timing, configuration, environment).
2. Which code path ran, and why did it produce the current symptom.
3. Why was it not exposed before (why is it uncommon, why did tests not cover it).

In the fix phase, change only code related to the root cause and preserve existing behavior; then add a check that fails when the defect reappears (test, script, or assertion), and report according to the evidence levels.

## Symptom Quick Reference

| Symptom | Preferred technique | Platform |
| --- | --- | --- |
| Dropped frames while scrolling the page | Performance panel + long tasks | Web |
| Desktop UI jank | Time Profiler + `sample` | macOS |
| High service CPU | `perf` / `pprof` flame graph | Backend |
| Process memory growth | Heap snapshot comparison + RSS curve | All platforms |
| Infinite loop or hang | Comparison of multiple stack samples | All platforms |
| Intermittent request timeouts | Distributed tracing + packet capture | Distributed |
| Intermittent database slowness | `EXPLAIN ANALYZE` + lock views | Database |
| Breaks on another machine | Clean environment + configuration diff | CLI |
| Elements unclickable | Hit testing + layer dump | UI |
| Copy truncated or overflowing | Pseudo-localization + screenshot comparison | UI |
| Unreadable in dark mode | Contrast checks + theme matrix | UI |
