---
title: ResultWeb 邮件服务迁移到 SMTPS
author: Fengqi
categories: resultweb
tags:
  - Postfix
  - SMTP
  - 邮件
  - Rails
abbrlink: 3020966047
date: 2026-10-21 09:03:00
---

## 背景

ResultWeb 应用原本通过本机 Postfix 中继到旧邮件服务器（无认证、无 TLS）。由于旧邮件服务器计划停用，需要迁移到新的内网邮件服务（带认证 + 加密）。

应用发信走本机 Postfix（localhost:25），因此迁移主要在 **Postfix 层**完成，应用层只需调整发件人地址配置。

> 关于"协议"的澄清：原始需求写的是"SMTPS / 587"，但这两者其实矛盾——传统 SMTPS 是 465 端口的隐式 TLS，而 587 是提交端口、用 STARTTLS 显式升级加密。实测确认目标服务是 **587 + STARTTLS**（明文起始、再升级为 TLS），因此配置按 STARTTLS 实现。

## 关键参数

- 端口：587（明文起始 + STARTTLS 升级加密，非 465 隐式 SMTPS）
- 认证：AUTH LOGIN，使用服务账号（裸账号名，非 UPN 格式）
- 证书：服务器证书由内部 CA 签发，需装入系统信任库
- 环境：Postfix 2.10.1 / EL7

## 排查与实施过程

### 1. 现状确认
- 旧配置：`relayhost = 旧邮件服务器`，无认证无 TLS
- Postfix 只监听 localhost:25，应用把邮件交给本机 Postfix 转发

### 2. 前置依赖安装
- **cyrus-sasl-plain**：Postfix 做 AUTH LOGIN 需要此包提供 `libplain.so` / `liblogin.so`，默认未安装
- **内部 CA 证书**：服务器证书由内部 CA 签发，系统默认信任库不含该 CA，需从内部 PKI 分发点下载并 `update-ca-trust extract` 装入；否则 STARTTLS 证书验证失败（`Verify return code: 20`）

### 3. Postfix 配置（main.cf）
```
relayhost = [新邮件服务器]:587
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_security_level = encrypt
smtp_tls_CAfile = /etc/pki/tls/certs/ca-bundle.crt
smtp_helo_name = <本机真实FQDN>
```
- `relayhost` 的方括号 `[]` 表示直接用主机名、不查 MX 记录
- `smtp_helo_name` 用本机真实 FQDN（各环境不同）

### 4. 认证密码文件
- `/etc/postfix/sasl_passwd`：`[服务器]:587  服务账号:密码`
- `postmap` 编译成 `.db`，权限 600 + root 属主（含明文密码）
- 运行时 Postfix 读 `.db`（`hash:` 前缀），改文本后必须重新 `postmap`

### 5. 认证问题排查（关键坑）
迁移过程中遇到几个认证障碍，逐一解决：

1. **`offered no supported AUTH mechanisms: 'NTLM'`**：邮件服务器是负载均衡集群，部分节点只提供 NTLM（Postfix 不支持 NTLM）。两个前提共同解决：一是**已安装 cyrus-sasl-plain**，Postfix 才具备 LOGIN 能力；二是**去掉 `smtp_sasl_mechanism_filter = login`**（这条会锁死只用 LOGIN，当某次连到只提供 NTLM 的节点时就无可用机制而失败），改为让 Postfix 自行协商——连到支持 LOGIN 的节点即成功，偶尔连到仅 NTLM 节点时该次失败、重试即可。
2. **`535 Authentication unsuccessful`**：早期用的账号 SMTP AUTH 权限未就绪 / 账号格式不对。最终确认用正确的服务账号（裸账号名）认证成功。
3. **`550 send-as`**：认证账号需要有权以指定发件地址发信（Send-As 授权）。确认服务账号对通知发件地址有 Send-As 权限后通过。

### 6. 验证
- 证书链：`openssl s_client -starttls smtp` 返回 `Verify return code: 0 (ok)`
- 端到端：应用发信 + 系统发信均 `status=sent`，走新邮件服务器投递成功

## 分环境推广差异

| 项 | 预发布环境 | 生产环境 |
|----|-----------|---------|
| `smtp_helo_name` | 各自真实 FQDN | 生产真实 FQDN |
| 发件人地址 | 各环境通知邮箱 | 生产通知邮箱 |
| 认证账号 | 同一服务账号 | 同一服务账号 |

其余配置（relay/sasl/tls、证书、cyrus-sasl-plain）各环境一致。生产为线上主机，变更分"不影响运行的前置"（装包、装证书、验证）和"影响运行的切换"（改 relay/认证）两阶段，切换安排在维护窗口。

## 成果

- 预发布与生产环境全部迁移到新邮件服务并验证通过
- 真实业务邮件正常走新服务器投递（STARTTLS + 认证 + Send-As 均通过）

---

## 通俗版复述

**这件事在解决什么？**

公司原来帮 ResultWeb 系统发邮件的那台"邮局"要退休了，得换一台新"邮局"。但新邮局比老邮局严格得多——老邮局谁来都收、直接帮你发；新邮局要求你**出示工牌（账号密码认证）**、还要**走加密通道（TLS）**、并且**核对你信封上写的寄件人是不是你本人（Send-As）**。

**怎么换的？**

ResultWeb 自己不直接连邮局，而是把信先交给"本机的一个收发室"（Postfix）。所以我们主要改这个收发室的设置：告诉它新邮局的地址、配好工牌（账号密码）、装好加密需要的"信任证书"、再装一个支持新认证方式的小插件。

**过程中踩的坑？**

1. 新邮局是一群窗口（负载均衡），有的窗口只认一种老式工牌（NTLM），我们的收发室不会用——解决办法是别锁死用哪种，让它自己挑会用的窗口。
2. 一开始用的工牌还没开通权限，被拒；换成正确的服务账号才通过。
3. 信封上的寄件人地址，必须是这个账号被授权能用的地址，否则邮局认为你冒名，拒收。

**结果**：预发布和生产环境都换成了新邮局，邮件能正常加密、认证、发出去了。
