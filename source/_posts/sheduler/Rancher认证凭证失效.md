---
title: 事件报告：Rancher 认证凭证失效导致模拟器测试全面失败
author: Fengqi
categories: sheduler
tags:
  - sheduler
abbrlink: 3863077733
date: 2026-10-21 09:11:00
---

# 事件报告：Rancher 认证凭证失效导致模拟器测试全面失败

> 本报告已脱敏，所有凭证值、账号标识、主机名均以占位符表示。

---

## 一、事件概要

| 项目 | 内容 |
|------|------|
| **事件名称** | Rancher API Token 失效导致 Simulator 测试无法执行 |
| **影响范围** | 所有通过 simulator-sched 调度的模拟器测试 |
| **影响时长** | 约 8 天 |
| **根本原因** | test-executor-service 使用的 Rancher API Token 被删除，无法通过认证 |
| **解决方式** | 在 Rancher 上重新创建 API Token 并更新到密钥管理系统 |
| **衍生问题** | Rancher 上积累了数千个自动生成的 kubeconfig token，导致清理任务超时失败 |
| **当前状态** | ✅ 已恢复 |

---

## 二、系统架构背景

测试执行的调用链路（简化）：

```
① 用户 / CI 触发测试
      ↓
② simulator-sched（模拟器调度器）接收并安排任务
      ↓
③ simulator-sched 调用 test-executor-service（测试执行服务）
      ↓
④ test-executor-service 通过 API Token 向 Rancher 集群发请求，创建测试运行环境（Pod）
      ↓
⑤ Rancher 集群启动测试容器，执行测试
```

问题出在第 ④ 步：test-executor-service 向 Rancher 认证时被拒绝。

---

## 三、根因分析

### 3.1 认证凭证的选择逻辑

test-executor-service 在构建 Rancher「站点」对象时，会根据站点名称选择不同的 API Token。关键代码（`test_executor_service/helpers/rancher_helper.py`）：

```python
class Site(object):
    """Rancher site object with all relevant info."""

    def __init__(self, name, url, cluster_id, project_id):
        self.name = name
        self.url = url
        self.cluster_id = cluster_id
        self.project_id = project_id
        self.project = f"c-{cluster_id}:p-{project_id}"
        self.pod = f"/v3/projects/{self.project}/pods/"
        self.pvc = f"/v3/project/{self.project}/persistentVolumeClaims/"
        self.config = f"/v3/project/{self.project}/configMaps/"
        self.namespace = NAMESPACE

        # 站点为 SIMULATOR 时用 simulator token，否则用 ru token
        if name.upper() == EnumSite.SIMULATOR:
            self.token = get_settings().simulator_rancher_auth_token
        else:
            self.token = get_settings().ru_rancher_auth_token
```

由于模拟器测试的站点名是 `SIMULATOR`，实际使用的是 `simulator_rancher_auth_token`。

### 3.2 Token 的使用方式

创建测试 Pod 时，token 作为 Bearer 认证头发给 Rancher（`import_yaml` 函数）：

```python
async def import_yaml(url, template, token):
    """Sends POST request to Rancher to import YAML file."""

    header = bearer_authorization(token)

    if is_dev_env():
        raise DevelopmentEnvironmentException
    async with httpx.AsyncClient(verify=False) as client:
        response = await client.post(
            url=url, content=template, headers=header, timeout=REQUEST_TIMEOUT_20_SECONDS
        )
        logger.info(f"Response {response.status_code} from {url}: {response.text}")

    return response
```

### 3.3 失败时的日志表现

```
test-executor-service  rancher_helper:
Response 401 from https://<RANCHER_HOST>/v3/clusters/<CLUSTER_ID>?action=importYaml:
{"type":"error","status":"401","message":"Unauthorized 401: must authenticate"}

test-executor-service  uvicorn.access:
<CLIENT_IP> - "POST /preparation-start HTTP/1.1" 401
```

### 3.4 直接原因：Token 被删除

通过 Rancher API 逐一验证发现，`simulator_rancher_auth_token` 对应的 token 在 Rancher 上已不存在（返回 404 Not Found），而非简单过期。

| Token（占位） | 在当前 Rancher 的状态 | 结论 |
|---------------|----------------------|------|
| simulator-token-A | 404 Not Found | 已删除 |
| simulator-token-B | 404 Not Found | 已删除 |

推测与 Rancher 平台的迁移/重建有关：平台从旧实例迁移到新实例后，旧 token 未被保留。

### 3.5 连锁错误：401 之后又出现 422

preparation 失败（401）后，simulator-sched 没有中止流程，继续发送了 job-start 请求，但此时关键参数 `command` 为空（`null`），触发了二次错误：

```
test-executor-service  main:
Error occurred due to: [{'type': 'string_type', 'loc': ('body', 'command'),
'msg': 'Input should be a valid string', 'input': None}]

test-executor-service  uvicorn.access:
<CLIENT_IP> - "POST /job-start HTTP/1.1" 422
```

调用方 simulator-sched 的流程代码（`simulator_sched/service/test_executor.py`）：

```python
def send_test_start_and_preparation_info(self, execution):
    jobs_dict = [{**job, "label": execution.label} for job in execution.dict()["jobs"]]

    if execution.one_preparation:
        self.start_execution(execution)
    else:
        for job in jobs_dict:
            self.send_preparation_info_old(job)   # ① preparation 失败只记日志，不抛异常
            self.send_test_start_info(job)         # ② 仍然继续执行 job-start
```

`send_preparation_info_old` 失败时只记录日志、发一条 `job_failed` 消息，**没有中断**，所以 `send_test_start_info` 照常执行。而 `command` 来自 preparation 返回的 `full_command`，preparation 失败后它一直是 `None`，最终被 test-executor-service 的模型校验拒绝（`command: str` 不接受 None）。

接收端的校验模型（`test_executor_service/api/job.py`）：

```python
class JobStartRequest(JobStartBase):
    one_preparation: bool | None = False
    job_type: str
    test_position: str
    command: str          # 非 Optional，不接受 None → 触发 422
    std_log_file: str | None = None
    token: str | None = None
    ...
```

---

## 四、衍生问题：数千个 kubeconfig token 积累

### 4.1 token 是如何自动产生的

Rancher 的 kubeconfig 认证机制下，**每次通过 `generateKubeconfig` 动作生成 kubeconfig（或用相应 kubeconfig 做认证），Rancher 都会自动创建一个 `kubeconfig-*` 前缀的临时 token**（默认有效期约 30 天）。

验证方式 —— 调用 generateKubeconfig 后返回的 kubeconfig 中内嵌一个新 token：

```yaml
apiVersion: v1
kind: Config
clusters:
- name: "<CLUSTER_NAME>"
  cluster:
    server: "https://<RANCHER_HOST>/k8s/clusters/<CLUSTER_ID>"
users:
- name: "<CLUSTER_NAME>"
  user:
    token: "kubeconfig-<USER_ID>:<SECRET>"   # ← 每次都会新建
contexts:
- name: "<CLUSTER_NAME>"
  context:
    user: "<CLUSTER_NAME>"
    cluster: "<CLUSTER_NAME>"
current-context: "<CLUSTER_NAME>"
```

simulator-sched 高频使用 `kubectl` 操作集群（查询 Pod、更新注解、删除资源、检查节点容量等），导致 `kubeconfig-*` token 不断积累。例如 `simulator_sched/helpers/kube_helper.py` 中的典型调用：

```python
def get_pods() -> str:
    """Method uses kubectl to get pods from cluster."""
    config = get_settings().kube_config_path
    result = subprocess.run(
        [
            "kubectl", "--kubeconfig", config,
            "get", "pods", "-n", "texec",
            "--field-selector=status.phase!=Succeeded,status.phase!=Failed",
            "-o", f"go-template={go_template}",
        ],
        capture_output=True, text=True,
    )
    ...
```

### 4.2 本应自动清理，但清理任务也失败了

test-executor-service 有一个定时清理任务，删除超过 24 小时的 `kubeconfig-*` token（`test_executor_service/tasks.py`）：

```python
async def clean_rancher_fid_api_keys(ctx, dry_run=False):
    """Clean rancher api keys from simulator cluster.
    Collect tokens from Rancher API and delete tokens starting with 'kubeconfig-'
    that are older than 24 hours.
    """

    logger.info("Starting cleanup of Rancher FID API keys")

    site = RancherSite.get_site("SIMULATOR")
    tokens = await fetch_resource_data(site, "/v3/tokens", ["id", "links", "created"])

    if tokens is False:
        logger.error("Failed to fetch token data from Rancher API")
        return

    logger.info(f"Found {len(tokens)} total tokens")
    cutoff_time = datetime.now(datetime.now().astimezone().tzinfo) - timedelta(hours=24)

    deleted_count = 0
    for token in tokens:
        if token["id"].startswith("kubeconfig-"):
            token_created = parser.parse(token["created"])
            if token_created < cutoff_time:
                await remove_resource(site, token["links"]["remove"], dry_run=dry_run)
                deleted_count += 1

    logger.info(
        f"Cleanup completed. {'[DRY RUN] ' if dry_run else ''}Removed {deleted_count} API keys "
        f"older than 24 hours."
    )
```

这里有两个叠加的问题，形成恶性循环：

1. **认证失败**：清理任务同样使用 `simulator_rancher_auth_token`，token 失效后它也无法登录 Rancher，`fetch_resource_data` 返回 `False`，直接 return。
2. **查询超时**：`fetch_resource_data` 的请求超时设为 15 秒，而 `GET /v3/tokens` 一次性拉取全部（数千个）token，无法在 15 秒内返回，超时失败。

```
恶性循环：
Token 失效 / 数据量过大 → 清理任务无法拉取 token 列表
→ 旧 token 无法删除 → token 越积越多
→ 查询更慢 → Rancher 管理页面也打不开
```

底层拉取函数的超时设置（`rancher_helper.py::fetch_resource_data`）：

```python
async with httpx.AsyncClient(verify=False) as client:
    response = await client.get(site.url + resource_url, headers=header, timeout=15)  # ← 15 秒
```

---

## 五、解决过程与措施

### 5.1 短期修复（已完成）

1. 在当前 Rancher 实例上重新创建 API Token
2. 将新 Token 更新到密钥管理系统（Vault）中对应的 secret
3. 重启 test-executor-service 使新凭证生效
4. 验证模拟器测试恢复正常

### 5.2 积累 token 的手动清理

由于定时任务一次性拉取全部 token 会超时，改用分批方式清理。思路：每批只取一部分 `kubeconfig-*` token，逐个删除，循环直到清空。

```bash
#!/bin/bash
# 批量删除 Rancher 上的 kubeconfig-* token（删除超过24小时的）
TOKEN="<RANCHER_API_TOKEN>"
BASE_URL="https://<RANCHER_HOST>"

CUTOFF=$(date -u -d '24 hours ago' +%Y-%m-%dT%H:%M:%SZ)
echo "Deleting kubeconfig tokens created before: $CUTOFF"

URLS=$(curl -sk -H "Authorization: Bearer $TOKEN" \
  "$BASE_URL/v3/tokens" \
  | jq -r --arg cutoff "$CUTOFF" \
    '.data[] | select(.id | startswith("kubeconfig-")) | select(.created < $cutoff) | .links.remove')

if [ -z "$URLS" ]; then
  echo "No kubeconfig tokens found. Done!"
  exit 0
fi

TOTAL=$(echo "$URLS" | wc -l)
echo "Found $TOTAL kubeconfig tokens to delete."

COUNT=0
while IFS= read -r url; do
  curl -sk -X DELETE -H "Authorization: Bearer $TOKEN" "$url" > /dev/null
  COUNT=$((COUNT + 1))
  if [ $((COUNT % 100)) -eq 0 ]; then
    echo "Deleted $COUNT / $TOTAL ..."
  fi
done <<< "$URLS"

echo "Done! Deleted $COUNT tokens."
```

### 5.3 长期改进建议

| # | 建议 | 优先级 | 说明 |
|---|------|--------|------|
| 1 | **Token 有效性监控与告警** | 高 | 定期检查关键 token 是否有效，提前预警，避免静默失效 |
| 2 | **修复 simulator-sched 的错误处理** | 高 | preparation 失败后应跳过 job-start，避免产生误导性的 422 |
| 3 | **清理任务加分页** | 高 | `fetch_resource_data` 一次拉全部 token 会超时，应分页拉取 |
| 4 | **优化 kubeconfig 认证方式** | 中 | 用固定的静态 token 认证，避免每次操作都新建 `kubeconfig-*` token |
| 5 | **服务账号 token 设为永不过期** | 中 | 配合监控机制使用，减少轮换遗漏 |
| 6 | **凭证管理文档化** | 低 | 记录各服务使用的 token、所在 Rancher 实例、负责人与轮换周期 |

---

## 六、通俗版复述（给非技术读者）

下面用大白话把整件事讲一遍。

### 发生了什么？

我们有一套自动跑测试的系统。其中一类"模拟器测试"连续 8 天全部跑不起来，一启动就失败。

### 为什么会这样？

可以把整个系统想象成一家工厂：

- **调度员**（simulator-sched）：接到任务，安排谁去干活。
- **车间主管**（test-executor-service）：真正去车间开机器干活的人。
- **车间大门**（Rancher）：进车间得刷门禁卡。
- **门禁卡**（API Token）：车间主管手里的那张卡。

这次的问题是：**车间主管手里的门禁卡失效了**（被系统注销了）。结果他刷卡进不去车间（门禁返回"未授权"），活自然干不了，所有模拟器测试全部失败。

进一步查发现，这张卡不是"到期作废"，而是"被直接删除了"。很可能是之前车间（Rancher 平台）搬过一次家，搬家后旧卡没带过去。

### 还有个连带问题

更麻烦的是，车间的"自动发临时卡"机制有点失控。

系统干活时，每进一次车间，门口都会自动发一张"临时门禁卡"（有效期约 30 天）。正常情况下，有个清洁工每天把过期的临时卡收走扔掉。但这次因为主卡失效，连清洁工也进不了门，没法清理。于是临时卡越堆越多，堆到了几千张。卡太多又导致门禁系统查询变慢，连管理页面都打不开，形成了死循环。

### 怎么解决的？

1. **补办一张新门禁卡**：在车间重新办了一张有效的卡，交给车间主管，活立刻又能干了。
2. **手动大扫除**：写了个小工具，把堆积的几千张临时卡分批清理掉。

### 以后怎么避免？

- **给门禁卡装个"快到期提醒"**：别等卡失效了、活全停了才发现。
- **让干活的人更聪明一点**：进不了门就别硬着头皮往下干（避免产生第二种误导性的错误，省得排查时绕弯路）。
- **改进清洁工的工作方式**：一次别想把几千张卡全查出来（会卡死），分批清理。
- **把卡的管理记清楚**：哪张卡谁在用、归谁管、什么时候换，都写进文档。

### 一句话总结

> 干活要刷的门禁卡被注销了，导致活全停了；顺带还发现系统自动发的临时卡堆积成山没人清理。补了张新卡、做了次大扫除，问题解决。后续要加提醒、改流程，防止再犯。

---

*报告整理完成*
