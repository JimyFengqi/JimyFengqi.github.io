---
title: Helm 仓库 403 构建失败排查报告
author: Fengqi
categories: follow_your_commit
tags:
  - Helm
  - Artifactory
  - 权限
  - Jenkins
  - CI/CD
date: 2026-10-21 09:00:00
---

# Helm 仓库 403 构建失败排查报告

## 一、问题概述

FYC 的 Jenkins 流水线（Master Build）在执行构建脚本时失败，构建被标记为 `FAILURE`。

核心报错信息如下：

```
Error: looks like "https://<artifactory-host>/artifactory/proj-one-toolbox-helm" is not a valid chart repository or cannot be reached: failed to fetch https://<artifactory-host>/artifactory/proj-one-toolbox-helm/index.yaml : 403
```

即：在 `helm repo add` 添加 `otb` 这个 Helm 仓库时，Artifactory 返回了 **HTTP 403（Forbidden，拒绝访问）**，导致脚本在 `set -e` 的保护下立即中止。

---

## 二、相关构建脚本（已脱敏）

```bash
#!/bin/bash
set -e

module() {
    eval `/app/modules/0/bin/modulecmd bash $*`
}

# 依赖工具
module add helm/3.2.1
module add yq/3.3.4

# 变量定义
helm_repository=https://<artifactory-host>/artifactory/proj-fyc-helm
otb_helm_repository=https://<artifactory-host>/artifactory/proj-one-toolbox-helm

# 添加 helm 仓库
helm repo add fyc-staging-build $helm_repository --username=$ARTIFACTORY_USER --password=$ARTIFACTORY_TOKEN
helm repo add otb $otb_helm_repository --username $ARTIFACTORY_USER --password $ARTIFACTORY_TOKEN   # <-- 这一步返回 403

# 设置 chart 版本
yq w -i helm-chart/Chart.yaml version 0.0.0-master
yq w -i helm-chart/requirements.yaml dependencies[*].version 0.0.0-master
yq w -i helm-chart/values.yaml metadata.commitHash $GIT_COMMIT
yq w -i helm-chart/values.yaml metadata.version 0.0.0-master
yq w -i helm-chart/values.yaml tlsSecret <tls-secret-name>

# 更新依赖
helm dependency update helm-chart

# 打包 chart
helm package helm-chart

# 推送 chart
curl -u "${ARTIFACTORY_USER}:${ARTIFACTORY_TOKEN}" -T fyc-0.0.0-master.tgz "$helm_repository/fyc-0.0.0-master.tgz"

# 清理
helm repo remove fyc-staging-build
helm repo remove otb
/bin/rm fyc-0.0.0-master.tgz
module unload helm/3.2.1
module unload yq/3.3.4
```

---

## 三、排查过程

### 1. 定位报错步骤

日志中有一条关键线索：

```
"fyc-staging-build" has been added to your repositories   <-- 第一个仓库添加成功
Error: ... proj-one-toolbox-helm ... : 403                <-- 第二个仓库添加失败
```

说明凭据能够连上 Artifactory（第一个仓库添加成功），但对 `proj-one-toolbox-helm` 仓库被拒绝访问。

### 2. 排除 Token 过期

- Token 的过期时间晚于当前时间，尚未过期。
- 重新生成了一个全新的 Token，`otb` 仓库**仍然返回 403**。

因此可以排除「凭据过期/失效」这一可能。

### 3. 对比测试（关键验证）

使用同一个有效 Token，分别访问三个地址，对比 HTTP 状态码：

```bash
# A) 问题仓库 otb
curl -s -o /dev/null -w "otb:   %{http_code}\n" \
  -u "${ARTIFACTORY_USER}:${ARTIFACTORY_TOKEN}" \
  "https://<artifactory-host>/artifactory/proj-one-toolbox-helm/index.yaml"

# B) 正常仓库 fyc
curl -s -o /dev/null -w "fyc:   %{http_code}\n" \
  -u "${ARTIFACTORY_USER}:${ARTIFACTORY_TOKEN}" \
  "https://<artifactory-host>/artifactory/proj-fyc-helm/index.yaml"

# C) Token 有效性检查
curl -s -o /dev/null -w "ping:  %{http_code}\n" \
  -H "Authorization: Bearer ${ARTIFACTORY_TOKEN}" \
  "https://<artifactory-host>/artifactory/api/system/ping"
```

> 说明：`%{http_code}` 是 curl 的内置输出变量，运行时会被自动替换成实际的 HTTP 状态码，无需修改。

**实测结果：**

```
otb:   403
fyc:   200
ping:  200
```

### 4. 对比历史成功构建

| 对比项 | 成功的构建 | 失败的构建 |
|--------|-----------|-----------|
| 代码 commit | 相同 | 相同 |
| 构建节点 | 相同 | 相同 |
| 账号 | 相同 | 相同 |
| 构建脚本 | 相同 | 相同 |
| `helm repo add fyc-staging-build` | ✅ 成功 | ✅ 成功 |
| `helm repo add otb` | ✅ 成功 | ❌ 403 |
| 后续步骤 | ✅ 全部成功，部署 SUCCESS | ❌ 因 `set -e` 中止 |

成功构建的依赖下载日志显示，3 个依赖**全部来自 `proj-fyc-helm` 仓库**：

```
Downloading app-service      from repo https://<artifactory-host>/artifactory/proj-fyc-helm
Downloading ui               from repo https://<artifactory-host>/artifactory/proj-fyc-helm
Downloading event-transformer from repo https://<artifactory-host>/artifactory/proj-fyc-helm
```

**没有任何一个依赖来自 `otb`（proj-one-toolbox-helm）仓库。**

---

## 四、根因结论

综合所有证据：

- `ping: 200` → Token 有效，账号能正常登录 Artifactory。
- `fyc: 200` → 同一 Token 对 `proj-fyc-helm` 有读权限，认证链路完全正常。
- `otb: 403` → 单独针对 `proj-one-toolbox-helm` 被拒绝。
- 更换新 Token 后 `otb` 仍为 403，且脚本/代码/节点均无变化。

**根本原因：构建账号对 `proj-one-toolbox-helm` 仓库的读权限在服务端被变更（收回），与脚本、代码、凭据均无关。这是 Artifactory 服务端的授权问题。**

---

## 五、解决方案

### 方案 A：恢复仓库授权（根本解决）

联系 OTB（One Toolbox）团队或 Artifactory 管理员，为构建账号恢复 `proj-one-toolbox-helm` 仓库的读（download）权限，并确认该仓库是否已迁移至新地址。

### 方案 B：临时绕过（快速恢复构建）

鉴于历史成功构建中**没有任何依赖来自 otb 仓库**，可将脚本中与 otb 相关的两行注释掉：

```bash
# 添加仓库处（注释掉）
# helm repo add otb $otb_helm_repository --username $ARTIFACTORY_USER --password $ARTIFACTORY_TOKEN

# 清理处也要一起注释，否则在 set -e 下 "remove 不存在的 repo" 会再次导致失败
# helm repo remove otb
```

> 注意：
> 1. `helm repo remove otb` 必须同步注释，否则因仓库不存在会报错并再次中止构建。
> 2. 该方案为临时绕过；若将来 chart 确实需要 otb 仓库的依赖，仍需走方案 A 恢复权限。
> 3. 注释后建议先跑一次构建，确认 `helm dependency update` 正常。

---

## 六、通俗语言复述（给非技术同学看）

想象你要去两个「仓库」各取一些零件来组装产品：

- **仓库一（fyc）**：你刷工卡，门开了，顺利拿到东西。✅
- **仓库二（otb）**：你刷同一张工卡，门却弹出「禁止进入」。❌（就是那个 403）

一开始我们怀疑是不是你的「工卡过期了」。于是重新办了一张新工卡去刷——结果仓库二的门还是不给进。这就说明**问题不在工卡**。

接着做了个很简单的测试：拿同一张工卡去刷三道门——

- 刷「总入口」的门：能进（说明工卡本身是好的）；
- 刷「仓库一」的门：能进（说明工卡的权限是正常的）；
- 刷「仓库二」的门：不让进。

三道门里只有「仓库二」单独把你挡在外面，所以结论很清楚：**不是工卡坏了，而是「仓库二」的管理员把你的进门权限取消了。**

而且我们还翻了以前的记录：之前用**一模一样的工卡、一模一样的流程**是能顺利进仓库二的，中间谁也没动过流程。这就更加确定——是仓库二那边后来改了门禁规则，把我们的权限去掉了。

**那怎么办？**

- **彻底解决**：找管理「仓库二」的团队，把我们的进门权限加回来。
- **临时应急**：我们检查了过去的记录，发现其实**根本没从仓库二拿过任何零件**，所有零件都是从仓库一拿的。所以干脆先「不去仓库二」——把流程里「去仓库二刷卡」和「离开时在仓库二登记」这两步暂时划掉，产品照样能正常组装出来。等以后真需要仓库二的零件时，再把权限补回来即可。
