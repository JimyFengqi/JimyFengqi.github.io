---
name: hexo-deploy-local
description: 在受限/企业环境中本地构建并发布 Hexo 博客到 GitHub(可选 Gitee) 的双分支工作流。涵盖 environment-modules 加载 Node、从 tcsh 风格密钥文件读取 token、绕过 signed-push、IPv4 DNS 修复、force-push 到 master、以及用 GitHub Actions 做自动部署。当需要构建/发布 Hexo 站点、排查 npm/git 推送失败、或在 module-load 环境配置 Node 时使用。
---

# Hexo 本地构建与发布（受限环境）

适用场景：Hexo 站点采用"单仓双分支"——`hexo` 分支存源码，`master` 分支存 `hexo generate` 生成的静态产物，GitHub Pages 从 `master` 提供服务。

## 关键环境陷阱与对策

### 1. Node 用 environment-modules 加载（非 nvm）
`module avail` 找版本，`module load nodejs/X` 加载。但在非交互 shell 里 `module` 函数常不可用，用底层命令：
```bash
eval "$(tclsh /usr/share/Modules/libexec/modulecmd.tcl bash load nodejs/22.15.1 2>/dev/null)"
```
加载后目标版本可能被 PATH 里已有的其它 Node 版本遮挡——显式把目标 bin 提到最前：
```bash
target_bin="$(echo "$PATH" | tr ':' '\n' | grep -m1 'nodejs/22.15.1/bin')"
export PATH="$target_bin:$PATH"
```
Hexo 8 要求 Node >= 20.19；Hexo 5 可用 14/18。

### 2. npm 卡 ETIMEDOUT = IPv6 路由坏
现象：`npm ci` 卡在 `connect ETIMEDOUT <IPv6地址>`，但 curl 能通。对策强制 IPv4：
```bash
export NODE_OPTIONS="--dns-result-order=ipv4first"
```

### 3. 从 tcsh 密钥文件读 token（绝不硬编码/提交）
token/账号放在本机 `~/.secrets.csh`（权限 600，不在仓库），用 sed 解析 `setenv` 语法：
```bash
GH_TOKEN="$(sed -n "s/^[[:space:]]*setenv[[:space:]]\+GITHUB_TOKEN[[:space:]]\+['\"]\?\([^'\" ]*\)['\"]\?.*/\1/p" ~/.secrets.csh | head -n1)"
```
用完 `unset`；日志里永远用 `sed "s/${GH_TOKEN}/***/g"` 掩码；只按变量名引用，绝不打印明文。

### 4. signed-push 被 GitHub HTTPS 拒绝
若全局 `push.gpgsign=true`，会报 `the receiving end does not support --signed push`。
所有 push 加 `-c push.gpgsign=false`（不改全局配置）。

### 5. push 必加超时+禁交互，防卡死
```bash
GIT_TERMINAL_PROMPT=0 timeout 180 git -c push.gpgsign=false push --force "https://${GH_TOKEN}@github.com/<owner>/<repo>.git" master:master
```
(退出码 124 = 超时。遇到卡死先 `curl -m8 https://host` 和 `bash -c 'cat</dev/null>/dev/tcp/host/443'` 判断是 DNS/端口/带宽哪一层。)

## 发布到 master 的完整流程
```bash
cd <site>; export NODE_OPTIONS="--dns-result-order=ipv4first"
npm ci && npx hexo clean && npx hexo generate   # 生成 public/
cd public
rm -rf .git; git init -q; git checkout -q -B master
git config user.name "X"; git config user.email "x@y"
git config commit.gpgsign false
git add -A; git commit -q -m "deploy $(date '+%F %T')"
GIT_TERMINAL_PROMPT=0 timeout 180 git -c push.gpgsign=false push --force "https://${GH_TOKEN}@github.com/<o>/<r>.git" master:master
rm -rf .git   # 清理, 避免 token 残留在 public/.git/config
```

## 验证（本地 git status 不可信）
显式 URL 推送**不会更新**本地 `origin/*` 跟踪引用，`git status` 会误报 "ahead by N commits"。
验证真实远程要用 `git ls-remote`，或 `git fetch origin` 刷新跟踪引用。

## 首选：GitHub Actions 自动部署（免 token 维护）
`.github/workflows/deploy.yml`：push 到 `hexo` 即云端构建发布 master。关键点：
- `permissions: contents: write`（并在仓库 Settings→Actions→Workflow permissions 选 Read and write）
- 认证用内置 `${{ secrets.GITHUB_TOKEN }}`（每次运行自动注入、一次性、无需自备 PAT/无过期）
- `peaceiris/actions-gh-pages@v4` + `force_orphan: true` 覆盖式发布
- `concurrency: cancel-in-progress` 取消过期构建
- `npm ci` 要求 lockfile 与 package.json 同步，否则 CI 失败

## Gitee 镜像
若本机到 Gitee 端口被封/上行限速（push 超时），用 Gitee 后台"镜像同步"从 GitHub 自动拉，或在能访问的机器上 `PUSH_GITEE=1`。
