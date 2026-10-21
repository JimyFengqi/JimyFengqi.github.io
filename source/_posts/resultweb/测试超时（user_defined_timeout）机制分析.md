---
title: ResultWeb 测试超时（user_defined_timeout）机制分析报告
author: Fengqi
categories: resultweb
tags:
  - 超时
  - Rails
  - 任务调度
  - 源码分析
abbrlink: 1057111619
date: 2026-10-21 09:09:00
---

# ResultWeb 测试超时（user_defined_timeout）机制分析报告

> 分析目标：ResultWeb 如何处理 `user_defined_timeout` 字段来取消/中止测试执行


---

## 总体流程概览

1. **用户输入** `user_defined_timeout`（单位：分钟），通过 UI 或 API 提交
2. **TimeoutDuration concern** 将分钟转换为秒（`* 60`），写入 `suites_hash[suite][:timeout]`
3. **JobBuilder** 将超时值编码进测试命令字符串：`--test_suite=elvis:suite.xml:123:7200:band=...`
4. 远端 load VM 上的 **run_ru_test** 解析命令，创建带超时的 `Crbs::TestSuite`
5. **TestFramework** 执行时启动一个 **sleeper 线程**，等待 `timeout` 秒后 **SIGKILL** 整个进程组
6. 超时后 `@timed_out = true`，回报给 ResultWeb，`status_info: "Timed out after HH:MM:SS"`，`success: false`
7. **ResultWeb** 通过 `status_info =~ /^Timed/` 识别超时的执行
8. 若用户未指定超时，默认值为 `CFG['RU_TEST_TIMEOUT']` = **21600 秒（6 小时）**

---

## 1. 用户输入与数据流

**文件：`app/models/radio_test_execution.rb`（第 26 行）**
```ruby
attr_accessor :user_defined_timeout
```
这是一个临时属性（非直接持久化到数据库），通过 API/表单接收。

**文件：`app/views/execution_results/_radio_test_execution_fields.html.erb`（第 17 行）**
```erb
<%= f.input :user_defined_timeout,
            label: 'Timeout (minutes)',
            input_html: { type: 'number', min: 1, oninput: "validity.valid||(value='');"},
            hint: 'Leaving empty will fetch default suite timeout' %>
```
用户在界面上以**分钟**为单位输入超时值。

**文件：`app/controllers/execution_results_controller.rb`（第 448 行）**
```ruby
:user_defined_timeout,
```
在控制器中作为 strong parameter 被允许。

---

## 2. 超时计算（TimeoutDuration Concern）

**文件：`app/concerns/timeout_duration.rb`**
```ruby
module TimeoutDuration
  extend ActiveSupport::Concern

  def suites_timeout_time(suites_hash, timeout = nil)
    suites = suites_hash.keys
    suites.each do |suite|
      suite_name = suites_hash[suite][:name]
      user_defined_timeout = suites_hash[suite][:user_defined_timeout].to_i
      found_suite = TestSuite.find_by(name: suite_name)
      timeout ||= TestSuite.new(name: suite_name).timeout_time

      suites_hash[suite][:timeout] = if user_defined_timeout > 0
                                       user_defined_timeout * 60   # 分钟 → 秒
                                     elsif found_suite.nil?
                                       timeout                     # 使用配置默认值
                                     else
                                       found_suite.timeout_time    # 使用套件特定超时
                                     end
    end
    suites_hash
  end
end
```

**优先级顺序：**
1. `user_defined_timeout`（分钟，`* 60` 转换为秒）
2. TestSuite 数据库记录中的套件特定 `timeout_time`
3. 配置文件中的默认值 `CFG['RU_TEST_TIMEOUT']`

---

## 3. 默认超时值

**文件：`app/models/test_suite.rb`（第 37-38 行）**
```ruby
def set_default_timeout_time
  self.timeout_time ||= Integer(CFG['RU_TEST_TIMEOUT'])
end
```

**文件：`crbs/etc/crbs/config/production.yml`（第 213-215 行）**
```yaml
RU_LOAD_TIMEOUT:           120     # 120 秒加载超时
RU_TEST_EXTRA_TIMEOUT:     600     # 600 秒额外缓冲
RU_TEST_TIMEOUT:           21600   # 21600 秒 = 360 分钟 = 6 小时
RU_CANCEL_TIMEOUT:         604580  # ~7 天的取消截止时间
```

> **注意：** 默认值是 **21600 秒（6 小时）**，而不是 7200 秒（120 分钟）。
> API 文档中显示的 120 只是 `user_defined_timeout` 的示例值，实际默认值是 6 小时。

---

## 4. 任务构建 —— 超时如何进入测试命令

**文件：`app/models/execution_result/job_builder.rb`（第 33-50 行）**
```ruby
suites =
  @radio_test_load.radio_test_executions.each_with_object({}) do |rte, sh|
    sh[rte.id] = { name: rte.suite,
                   band: band_command(rte),
                   rte_id: rte.id,
                   user_defined_timeout: rte.user_defined_timeout,
                   config_mode: config_mode_command(rte),
                   pass_through_arguments: assign_pta(rte) }
  end

suites_with_timeout = suites_timeout_time(suites)  # 应用 TimeoutDuration concern

Job.find_or_create_job(
  test_command: test_command(suites_with_timeout, term, er, merge_params),
  max_duration: max_duration(suite_names),  # 用于资源层面的 deadline
  ...
)
```

**max_duration（资源层面的 deadline，第 167-169 行）：**
```ruby
def max_duration(suite_names)
  CFG['RU_LOAD_TIMEOUT'] + TestSuite.total_execution_time(suite_names) + CFG['RU_TEST_EXTRA_TIMEOUT']
end
```
资源 deadline = 加载时间 + 所有套件超时之和 + 额外缓冲。

---

## 5. 测试命令格式 —— 超时编码进命令字符串

**文件：`crbs/lib/ruby/lib/crbs/ru_test/test_framework/class_methods.rb`（第 40-50 行）**
```ruby
def self.suites_with_params(suites_hash)
  suites = suites_hash.values.map { |suite| suite[:name] }
  frameworks(suites).zip(suites_hash.keys).map do |fw, suite|
    [fw,
     suites_hash[suite][:name],
     suites_hash[suite][:rte_id],
     suites_hash[suite][:timeout],       # ← 超时（秒）嵌入命令参数
     suites_hash[suite][:band],
     suites_hash[suite][:config_mode],
     suites_hash[suite][:pass_through_arguments]].
      reject(&:nil?).join(':')
  end.reject(&:nil?).reject(&:empty?).join(',,')
end
```

命令行参数格式：`--test_suite=<framework>:<name>.<ext>:<rte_id>:<timeout_seconds>:<band>:<config_mode>:<pta>`

**文件：`crbs/lib/ruby/lib/crbs/ru_test/test_suite.rb`** —— 解析这个格式的 `TestSuite.parse` 类，将 `timeout` 字段读出。

---

## 6. 实际超时执行（进程杀死机制）

**文件：`crbs/lib/ruby/lib/crbs/ru_test/test_framework/execution.rb`**
```ruby
def run_with_timeout
  Open3.popen2e(*@command, @spawn_opts) do |_, output, wait_thr|
    CHILDREN << wait_thr.pid
    log = File.open(@framework_log_file, 'w')
    time_out = @book_with_xlf ? BOOK_ELVIS_LOAD_TIMEOUT : @test_suite.timeout

    with_timeout(pid: wait_thr.pid, timeout: time_out) do
      output.each_line do |line|
        info << line
        log << line
      end
    end
    # ...
  end
  @fw_exit_code = exit_status
rescue Error => ex
  @timed_out = ex.is_a? ExecutionTimeout
  @fw_exit_code = exit_status
end

def with_timeout(pid:, timeout:)
  damocles = Process.getpgid(pid)
  sword = sleeper(timeout, damocles)
  yield
  sword.exit
end

def sleeper(timeout, pgid)
  Thread.new do
    sleep timeout
    Process.kill 'KILL', -pgid                    # ← SIGKILL 整个进程组
    Thread.main.raise ExecutionTimeout, "Timeout after #{timeout} s"
  end
end
```

**机制：** 一个后台线程 sleep 指定的超时时长。线程唤醒后，向测试执行的整个进程组发送 `SIGKILL`，然后在主线程上抛出 `ExecutionTimeout`。

---

## 7. 超时状态回报给 ResultWeb

**文件：`crbs/lib/ruby/lib/crbs/ru_test/test_framework/resultweb.rb`（第 17-21 行）**
```ruby
if @timed_out
  info.puts 'publishing timeout'
  @post_execution_publishers.each do |publisher|
    publisher.publish_timeout(@test_suite.timeout)
  end
end
```

**文件：`crbs/lib/ruby/lib/crbs/ru_test/execution_publisher.rb`（第 19-22 行）**
```ruby
def publish_timeout(timeout)
  message = Time.at(timeout).utc.strftime('Timed out after %T')
  publish_execution(success: false, status: message)
end
```
这会向 ResultWeb 的 `radio_test_executions/status_report` 接口发送 POST，带 `success: false` 和 `status_info: "Timed out after HH:MM:SS"`。

**退出码 8（来自 `fw_codes.rb`）：**
```ruby
8 => 'Suite timed out by user suite timeout timer.'
```

---

## 8. ResultWeb 对超时执行的检测

**文件：`app/controllers/execution_results_controller.rb`（第 291-293 行）**
```ruby
@timeout_rtes = @radio_test_executions.select do |rte|
  rte.success == false && rte.status_info =~ /^Timed/
end
```

---

## 9. 资源层面的 Deadline / 取消机制

**文件：`app/models/resource.rb`（第 293 行）**
任务启动时，资源会获得一个 `deadline`：
```ruby
update_attributes(deadline: job.max_duration.seconds.since.utc, ...)
```

触发取消时（第 170-212 行）：
```ruby
# Cancel ongoing job (or timeout if user=nil)
def cancel(user = nil)
  current_job.stop(user, pid, host, enabled)
  deadline = CFG['RU_CANCEL_TIMEOUT'].seconds.since.utc
  update_attributes(cancel_allowed: false,
                    status: Crbs::ResourceStatus::STOPPING,
                    deadline: deadline)
end
```

`Job#kill` 方法（`job.rb` 第 91-103 行）通过 SSH 连到主机并发送 `SIGINT`：
```ruby
def kill(pid, host)
  Net::SSH.start(host, ssh_user, timeout: CFG['SSH_CONNECTION_TIMEOUT']) do |ssh|
    timeout CFG['SSH_EXEC_TIMEOUT'] do
      ssh.exec("kill -s SIGINT #{pid}")
    end
  end
end
```

---

## 10. 调度 / 后台任务系统

**文件：`config/schedule.rb`**
```ruby
job_type :delayed_job, 'cd :path;bin/delayed_job :task :workers :monitor'

every :reboot do
  rake 'crbs:start_delayed_jobs'
end

every(1.day, at: ['10:05 am', '00:05 am']) do
  rake 'crbs:restart_delayed_jobs'
end
```

另有 `rake crbs:cleanup_jobs` 任务，调用 `Resource.all.each(&:cleanup_jobs)` 清理死亡/挂起的进程（通过 SSH 到主机检查 PID 是否还存活）。

---

## 关键结论

| 要点 | 内容 |
|------|------|
| 单位转换 | 用户输入分钟，`TimeoutDuration` 乘以 60 转为秒 |
| 默认超时 | `RU_TEST_TIMEOUT` = 21600 秒（6 小时），**不是** 7200 秒 |
| 超时执行者 | 远端 load VM 上的 crbs 库，而非 ResultWeb 主应用 |
| 杀进程方式 | 后台 sleeper 线程 + `Process.kill 'KILL', -pgid`（SIGKILL 进程组） |
| 超时退出码 | 8 = "Suite timed out by user suite timeout timer." |
| 回报状态 | `success: false`，`status_info: "Timed out after HH:MM:SS"` |
| 两层超时 | ① 套件级超时（真正杀测试进程）② 资源级 deadline（max_duration） |

---

## 附录：通俗版讲解（"ResultWeb 是怎么掐表停测试的"）

想象你在跑一个测试任务，你怕它卡死跑不完，于是想给它设个闹钟——"超过 X 分钟就强制停掉"。ResultWeb 就是这么干的，整个过程分几步：

### 第一步：你填个分钟数
在网页界面上有个输入框叫 "Timeout (minutes)"，你填个数字（比如 120 分钟）。如果留空，系统就用默认值。这个值在代码里叫 `user_defined_timeout`。

### 第二步：分钟换算成秒
程序内部真正用的是"秒"。所以有个叫 `TimeoutDuration` 的小模块负责把你填的分钟乘以 60 变成秒。这里有个优先级：你填了就用你的；你没填就查这个测试套件在数据库里有没有预设超时；都没有就用全局默认值。

### 第三步：默认值其实是 6 小时
这里有个要特别纠正的点——可能会以为默认超时是 7200 秒（120 分钟），但代码里实际的默认值 `RU_TEST_TIMEOUT` 是 **21600 秒，也就是 6 小时**。那个 120 只是 API 文档里举的一个例子而已。

### 第四步：超时值被"打包"进命令
ResultWeb 自己不跑测试，它只是把测试任务和超时值一起打包成一行命令字符串（类似 `--test_suite=elvis:xxx.xml:123:7200`，那个 7200 就是超时秒数），然后发到远端真正干活的测试机（load VM）上去执行。

### 第五步：真正的"闹钟"在远端
测试机这边有个很形象的设计（代码注释甚至用了"达摩克利斯之剑"的比喻）：测试一启动，就同时起一个后台线程当"计时器"，这个线程啥也不干，就 `sleep` 睡你设定的秒数。时间一到，它立刻醒来，直接 `SIGKILL`（强制杀死）整个测试进程组——不是温柔地请它退出，而是直接拍死。

### 第六步：杀完要"报告"回来
测试被掐掉后，远端会标记 `timed_out = true`，然后回报给 ResultWeb，告诉它："这个测试超时了，状态是 `Timed out after 02:00:00`，结果是失败（success: false）"。对应的退出码是 **8**，含义就是"被用户设定的超时计时器掐掉了"。

### 第七步：ResultWeb 识别超时结果
ResultWeb 收到回报后，用一个正则 `status_info =~ /^Timed/` 把所有超时的测试挑出来，在界面上单独显示。

### 额外一层：资源级的"大限"
除了掐单个测试的超时，还有一层更粗的保护——资源（测试位）本身有个 `deadline`（截止时间 = 加载时间 + 所有套件超时总和 + 缓冲）。如果用户手动点取消，或者任务整体超期，系统会通过 SSH 连到测试机发 `SIGINT` 信号来中止。

### 一句话总结
你填的分钟 → 乘 60 变秒 → 塞进命令发到测试机 → 测试机起个定时线程睡够时间就 SIGKILL 杀掉测试 → 回报"超时失败"给 ResultWeb 显示。默认 6 小时，不是 2 小时。
