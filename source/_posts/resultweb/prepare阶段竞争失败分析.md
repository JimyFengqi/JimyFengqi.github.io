---
title: ResultWeb Preparation Stage Failure — Root Cause Analysis
author: Fengqi
categories: resultweb
tags:
  - resultweb
abbrlink: 780857378
date: 2026-10-21 09:04:00
---

# ResultWeb Preparation Stage Failure — Root Cause Analysis

## Summary

A CI Loop test execution failed immediately at the **preparation stage**. The
`prepare_for_test.rb` script produced zero log output, and ResultWeb received a
callback reporting `exit status -1`. Investigation traced the failure to a
**race condition** in the debug-log cleanup logic of `wrap_program`, which
crashed the wrapper process before the actual preparation command could run.

---

## 5W1H Root Cause Analysis

### What

A CI Loop test execution failed immediately at the preparation stage.
`prepare_for_test.rb` produced zero log output. ResultWeb received a callback
with `exit status -1`, and a Kafka `job_failed` message was emitted.

### Where

```
File:   crbs/lib/ruby/lib/crbs/wrap_program/log_methods.rb
Method: old_logs
Host:   ResultWeb FEP server
Path:   wrap_program.rb
          -> start
            -> debug
              -> init_debugging
                -> remove_old_logs
                  -> old_logs
                    -> File.ctime raises Errno::ENOENT
```

### When

During concurrent creation of multiple CI Loop execution results (two ERs
submitted nearly simultaneously).

### Who

- **Triggered by**: CI Loop automation, submitting multiple test executions
  concurrently.
- **Impacted**: The affected execution result — preparation was killed before
  it started. XLFs were not cached, test suites were not fetched, and the
  hardware test ultimately failed.

### Why

**Root cause chain:**

```
1. Multiple ERs created concurrently
     |
2. Multiple wrap_program processes spawned simultaneously on the same FEP
     |
3. Each instance calls init_debugging -> remove_old_logs -> old_logs on startup
     |
4. old_logs performs two steps: Dir.glob (list files) -> File.ctime (sort by time)
     |
5. Between these two steps, another concurrent instance deletes one of the listed files
     |
6. File.ctime on the deleted file -> raises Errno::ENOENT
     |
7. Exception is unhandled, bubbles up to wrap_program.rb top-level rescue
     |
8. wrap_program exits; ensure block sends exit_status = -1 via send_done
     |
9. prepare_for_test.rb was never executed
```

**Design flaws:**

| Flaw | Description |
|------|-------------|
| Inconsistent defense | `remove_old_logs` rescues `Errno::ENOENT` on `File.unlink`, but `old_logs` does not rescue it on `File.ctime` / `File.owned?` |
| No fault isolation | A non-critical auxiliary operation (debug log cleanup) sits on the critical path with no exception boundary — its failure kills the entire preparation flow |
| Single-instance assumption | The "keep newest 5, delete the rest" strategy implicitly assumes low concurrency; under high concurrency all instances race to delete each other's files |

### How (Fix)

**Two-layer protection implemented:**

| Layer | Change | Effect |
|-------|--------|--------|
| `old_logs` method | Added `rescue Errno::ENOENT` around `File.ctime` and `File.owned?` | Eliminates the race condition trigger point |
| `init_debugging` method | Wrapped `remove_old_logs` in a `rescue` block | Ensures any cleanup failure cannot crash the main flow |

**Fixed code — `old_logs`:**

```ruby
def old_logs
  # Bigger = newer, so we get oldest first.
  # Protect against Errno::ENOENT: another concurrent wrap_program
  # instance may delete files between Dir.glob and File.ctime/owned?.
  sorted_logs = Dir["/tmp/#{DEBUG_FILE_NAME_TEMPLATE}*"].sort_by do |f|
    begin
      File.ctime(f)
    rescue Errno::ENOENT
      Time.at(0)
    end
  end
  own_sorted_logs = sorted_logs.select do |f|
    begin
      File.owned?(f)
    rescue Errno::ENOENT
      false
    end
  end
  # We want to keep the five newest, so don't regard them as old
  own_sorted_logs[0..-6] || []
end
```

**Fixed code — `init_debugging`:**

```ruby
def init_debugging
  begin
    remove_old_logs
  rescue => ex
    # Debug log cleanup is non-critical; do not let it kill the main flow.
    STDERR.puts "Warning: remove_old_logs failed: #{ex.message}"
  end
  @debug_log = Tempfile.create(DEBUG_FILE_NAME_TEMPLATE)
  @debug_log.sync = true
  @stamper.map_separators(@debug_log => %w([ ]))
end
```

**Preventive recommendations:**

- Non-critical auxiliary operations (log cleanup, metrics collection) must never
  share an exception chain with critical-path logic.
- Any code operating on shared filesystems (e.g. `/tmp`) under concurrency must
  tolerate `ENOENT` on every file operation.
- Monitor for the appearance of wrapper exception dump files as an early warning
  signal for this class of failures.

---

## Execution Flow Reference

The end-to-end chain from the ResultWeb controller down to the failing cleanup
logic:

```
ResultWeb Controller (create action)
  |-- execution_result.prepare_test
  |     |-- SystemCommand::Local.new(WRAPPER_PROGRAM)   (build command)
  |         |-- command.execute
  |             |-- fork_exec_daemon(args)              (fork + exec)
  |                 |-- exec "wrap_program.rb --for-execution-result ..."
  |                     |-- wrap_program.rb (independent process on FEP)
  |                         |-- parse_options
  |                         |-- sleep (wait for previous wrap to finish)
  |                         |-- start
  |                             |-- debug 'start'       (first debug call)
  |                             |   |-- init_debugging
  |                             |       |-- remove_old_logs
  |                             |           |-- old_logs
  |                             |               |-- Dir.glob -> File.ctime  (CRASH)
  |                             |-- (popen3 of prepare_for_test.rb never reached)
  |-- execution_result.run_test   (queues Job regardless of prepare result)
```

Key insight: because `prepare_test` and `run_test` are called sequentially but
non-blockingly, the test job is still enqueued even though preparation already
crashed. The preparation failure does not stop job creation, but it does cause
the test to fail later because required files were never cached.

---

## 通俗语言复述（中文）

### 一句话概括

两个测试同时启动，它们在清理临时日志文件时"撞车"了：一个程序正要读取某个文件的信息，另一个程序却刚好把这个文件删掉了，结果第一个程序直接崩溃，导致测试的"准备阶段"还没开始就失败了。

### 打个比方

想象一个公共储物间（`/tmp` 目录），每个来办事的人（`wrap_program` 进程）进门第一件事都是"顺手清理一下太旧的杂物，只留最新的 5 件"。

- 甲进门，先把储物间里所有东西列了个清单，准备挨个看看哪些是旧的要扔掉。
- 就在甲低头看清单的这一瞬间，乙也进来了，乙手脚麻利，把清单上的某件东西扔掉了。
- 甲抬头按清单去拿那件东西，发现"东西没了！"——甲当场懵掉、罢工走人。

问题是：甲这次来储物间的**真正任务**（启动测试准备程序）还没开始做，就因为"清理杂物"这个本来无关紧要的小事崩溃了。

### 为什么平时没事，偏偏这次出事

平时测试一个一个来，储物间里就甲一个人，不会有人跟他抢东西，所以从来没出过问题。
但 CI Loop 会**同时启动很多测试**，储物间里一下子挤进来好几个人，大家都在抢着扔旧杂物，"撞车"的概率就大大增加了。

### 代码到底哪里不对

1. **防护不一致**：删除文件的那段代码已经考虑了"文件可能被别人删掉了"的情况（做了保护），但读取文件时间的那段代码却忘了加同样的保护。
2. **小事不该搞垮大事**：清理旧日志只是个辅助性的"打扫卫生"动作，它失败了本不该影响测试准备这个核心任务，但代码没有把它们隔离开。
3. **没考虑多人同时在场**："只留最新 5 个"这套清理逻辑，默认了储物间里只有自己一个人，没考虑高并发下大家互相抢的情况。

### 怎么修的

做了两道防线：

- **第一道（治标）**：读取文件信息时加上保护——万一文件被别人删了，就当它是最旧的跳过，不再崩溃。
- **第二道（治本思路）**：把"清理旧日志"整个动作用保护罩罩起来——就算它因为任何原因失败了，也绝不会连累核心的测试准备流程。

这样一来，即使以后储物间再挤、再乱，甲也能安安稳稳地完成他真正要做的事。
