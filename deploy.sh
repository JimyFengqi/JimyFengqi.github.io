#!/usr/bin/env bash
# =============================================================================
# deploy.sh — 本地构建并发布 Hexo 博客到 GitHub(+Gitee) 的 master 分支
#
# 背景：
#   - 本仓库采用 "单仓双分支" 模式：hexo 分支存源码，master 分支存生成的静态站点。
#   - Travis CI 已不可用，改为在本机(CentOS + environment-modules)手动/脚本构建发布。
#   - Node 通过 `module load` 提供；GitHub token 存在 ~/.secrets.csh (tcsh 的 setenv 格式)。
#
# 用法：
#   bash deploy.sh                # 构建并推送到 GitHub(默认)
#   PUSH_GITEE=1 bash deploy.sh   # 同时推送到 Gitee 镜像
#   SKIP_INSTALL=1 bash deploy.sh # 跳过 npm 依赖安装(已装好时加速)
#
# 安全：
#   - 本脚本只从 ~/.secrets.csh 读取 token，绝不打印其明文。
#   - 推送 URL 含 token，使用后立即从内存变量清理；不写入任何文件。
# =============================================================================

set -euo pipefail

# ---- 可配置项 -----------------------------------------------------------------
NODE_MODULE="${NODE_MODULE:-nodejs/22.15.1}"      # 需要的 Node 版本(可用 module avail 查询)
SECRETS_FILE="${SECRETS_FILE:-$HOME/.secrets.csh}" # tcsh 格式的密钥文件
GITHUB_REPO="${GITHUB_REPO:-github.com/JimyFengqi/JimyFengqi.github.io.git}"
GITEE_REPO="${GITEE_REPO:-gitee.com/JimyFengqi/JimyFengqi.gitee.io.git}"
DEPLOY_BRANCH="${DEPLOY_BRANCH:-master}"
GIT_USER_NAME="${GIT_USER_NAME:-JimyFengqi}"
GIT_USER_EMAIL="${GIT_USER_EMAIL:-jmps515@163.com}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

log()  { printf '\033[1;32m[deploy]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[deploy]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[deploy][错误]\033[0m %s\n' "$*" >&2; exit 1; }

# ---- 1. 加载 Node (environment-modules) ---------------------------------------
load_node() {
  local want_ver="${NODE_MODULE##*/}"   # 例如 18.16.1

  # 若当前 node 已是目标版本则直接用
  if command -v node >/dev/null 2>&1 && [ "$(node -v)" = "v${want_ver}" ]; then
    log "Node 已是目标版本 $(node -v)"
    return 0
  fi

  # 尝试通过 module 系统加载
  if [ -f /usr/share/Modules/libexec/modulecmd.tcl ] && command -v tclsh >/dev/null 2>&1; then
    eval "$(tclsh /usr/share/Modules/libexec/modulecmd.tcl bash load "$NODE_MODULE" 2>/dev/null)" || true
  elif command -v modulecmd >/dev/null 2>&1; then
    eval "$(modulecmd bash load "$NODE_MODULE" 2>/dev/null)" || true
  fi

  # module 可能把目标版本追加在 PATH 靠后(被其它 node 版本遮挡)，
  # 这里显式把目标版本的 bin 目录提到最前，确保生效。
  local target_bin
  target_bin="$(echo "$PATH" | tr ':' '\n' | grep -m1 "nodejs/${want_ver}/bin" || true)"
  if [ -n "$target_bin" ]; then
    PATH="$target_bin:$PATH"
    export PATH
  fi

  command -v node >/dev/null 2>&1 || die "未找到 node，请确认 'module load $NODE_MODULE' 可用"
  log "使用 Node $(node -v) ($(command -v node))"
  log "使用 npm  $(npm -v)"
}

# ---- 2. 从 ~/.secrets.csh 解析 GITHUB_TOKEN -----------------------------------
# tcsh 语法:  setenv GITHUB_TOKEN ghp_xxx   或带引号 'ghp_xxx'
read_github_token() {
  [ -f "$SECRETS_FILE" ] || die "找不到密钥文件: $SECRETS_FILE"
  GH_TOKEN="$(sed -n "s/^[[:space:]]*setenv[[:space:]]\+GITHUB_TOKEN[[:space:]]\+['\"]\?\([^'\" ]*\)['\"]\?.*/\1/p" "$SECRETS_FILE" | head -n1)"
  [ -n "${GH_TOKEN:-}" ] || die "未能在 $SECRETS_FILE 中解析到 GITHUB_TOKEN (应为 setenv GITHUB_TOKEN ...)"
  log "已读取 GITHUB_TOKEN (长度 ${#GH_TOKEN}, 前缀 ${GH_TOKEN:0:4}****)"
}

# ---- 3. 安装依赖 + 构建 -------------------------------------------------------
build_site() {
  # 本机 IPv6 到 npm registry 的路由不通，强制 Node 优先用 IPv4 解析，
  # 否则 npm install 会 ETIMEDOUT。
  export NODE_OPTIONS="${NODE_OPTIONS:-} --dns-result-order=ipv4first"

  if [ "${SKIP_INSTALL:-0}" != "1" ]; then
    if [ -f package-lock.json ]; then
      log "安装依赖 (npm ci)..."
      npm ci
    else
      log "安装依赖 (npm install)..."
      npm install
    fi
  else
    log "SKIP_INSTALL=1，跳过依赖安装"
  fi

  log "清理旧产物 (hexo clean)..."
  npx hexo clean

  log "生成静态站点 (hexo generate)..."
  npx hexo generate

  [ -d public ] || die "构建失败: 未生成 public/ 目录"
}

# ---- 4. 发布 public/ 到 master 分支 -------------------------------------------
push_branch() {
  local host_repo="$1" cred_url="$2" label="$3"

  log "发布到 ${label} (${DEPLOY_BRANCH} 分支)..."
  (
    cd public
    git init -q
    git checkout -q -B "$DEPLOY_BRANCH"
    git config user.name  "$GIT_USER_NAME"
    git config user.email "$GIT_USER_EMAIL"
    # 本仓库全局开启了 commit/push 签名(push.gpgsign=true)，而 GitHub 的 HTTPS
    # 接收端不支持 --signed push，会报 "receiving end does not support --signed push"。
    # 这里在本地 public 仓库内显式关闭签名(不影响你的全局 git 配置)。
    git config commit.gpgsign false
    git config tag.gpgsign false
    git config push.gpgsign false
    git add -A
    git commit -q -m "Auto update site by deploy.sh ($(date '+%Y-%m-%d %H:%M:%S'))" || warn "无改动可提交"
    # --force 覆盖 master；token 仅存在于本次命令的进程内存中
    git -c push.gpgsign=false push --force --quiet "$cred_url" "${DEPLOY_BRANCH}:${DEPLOY_BRANCH}"
    rm -rf .git   # 清理，避免 token 残留在 public/.git/config
  )
  log "已发布到 ${label}"
}

# ---- main ---------------------------------------------------------------------
main() {
  load_node
  read_github_token
  build_site

  push_branch "$GITHUB_REPO" "https://${GH_TOKEN}@${GITHUB_REPO}" "GitHub"

  if [ "${PUSH_GITEE:-0}" = "1" ]; then
    local GITEE_USER GITEE_PASSWORD
    GITEE_USER="$(sed -n "s/^[[:space:]]*setenv[[:space:]]\+GITEE_USER[[:space:]]\+['\"]\?\([^'\" ]*\)['\"]\?.*/\1/p" "$SECRETS_FILE" | head -n1)"
    GITEE_PASSWORD="$(sed -n "s/^[[:space:]]*setenv[[:space:]]\+GITEE_PASSWORD[[:space:]]\+['\"]\?\([^'\" ]*\)['\"]\?.*/\1/p" "$SECRETS_FILE" | head -n1)"
    if [ -n "${GITEE_USER:-}" ] && [ -n "${GITEE_PASSWORD:-}" ]; then
      push_branch "$GITEE_REPO" "https://${GITEE_USER}:${GITEE_PASSWORD}@${GITEE_REPO}" "Gitee"
    else
      warn "PUSH_GITEE=1 但未在 $SECRETS_FILE 找到 GITEE_USER/GITEE_PASSWORD，跳过 Gitee"
    fi
  fi

  # 清理内存中的敏感变量
  unset GH_TOKEN GITEE_USER GITEE_PASSWORD 2>/dev/null || true
  log "全部完成 ✅"
}

main "$@"
