# 个人博客

> 我的[个人博客](https://JimyFengqi.github.io/)仓库。
>
> 技术栈：**Hexo 8.1.2** + 魔改版 **hexo-theme-bamboo**（基于其 dev 分支 2.6.9 修改）。
> 运行环境：**Node.js >= 20.19**（推荐 22.x）。

## 目录

- [一、项目结构](#一项目结构)
- [二、分支模型](#二分支模型)
- [三、环境准备](#三环境准备)
- [四、本地开发](#四本地开发)
- [五、构建与发布](#五构建与发布)
- [六、常用 Git 操作](#六常用-git-操作)
- [七、维护记录与注意事项](#七维护记录与注意事项)

---

## 一、项目结构

```
.
├── _config.yml                # Hexo 站点配置
├── package.json               # 依赖与脚本 (engines: node>=20.19)
├── deploy.sh                  # 本地构建 + 发布脚本 (替代已停用的 Travis CI)
├── scaffolds/                 # 新建文章/页面模板
├── source/                    # 站点源内容
│   ├── _posts/                # 文章 (算法题解/前端/数据库/本站介绍 等)
│   ├── _data/                 # 数据文件: widget.yml(首页挂件) / friends.json(友链)
│   ├── about|friends|gallery|movies|musics|books|website|acg/  # 独立页面
│   └── custom_widget/         # 首页自定义挂件 (欢迎/相守时光/微博热搜/历史上的今天 等)
└── themes/bamboo/             # 主题 (EJS 模板 + JS/CSS 资源 + 标签插件)
    ├── _config.yml            # 主题配置 (菜单/评论/挂件/CDN 等)
    ├── layout/                # 页面与局部模板 (*.ejs)
    ├── scripts/               # 主题扩展脚本 (自定义标签、helper 等)
    └── source/                # 主题静态资源 (js/css/medias)
```

## 二、分支模型

同一个仓库，**双分支**：

| 分支 | 用途 |
| :---: | :--- |
| `hexo` | **源码分支**（默认分支）。所有源内容、主题、配置都在这里。 |
| `master` | **发布分支**。存放 `hexo generate` 生成的静态站点，GitHub Pages 从此分支提供服务。 |

工作流：改源码 → 提交到 `hexo` → 构建产物强制推送到 `master`。

## 三、环境准备

### 1. Node.js

Hexo 8 要求 **Node.js >= 20.19**。

```sh
node -v     # 确认 >= v20.19，推荐 v22.x
```

> 若使用 Environment Modules 的环境，可用 `module avail` 查找、`module load nodejs/22.15.1` 加载。
> `deploy.sh` 顶部的 `NODE_MODULE` 变量即为要加载的版本，可按需修改。

### 2. 安装依赖

```sh
npm ci        # 推荐，按 package-lock.json 精确安装
# 或 npm install
```

> **网络提示**：若 `npm install` 卡在 `ETIMEDOUT`，多为 IPv6 到 registry 的路由问题，
> 可强制 IPv4：`NODE_OPTIONS="--dns-result-order=ipv4first" npm ci`。
> `deploy.sh` 已内置该处理。

## 四、本地开发

`package.json` 提供的脚本：

```sh
npm run server    # 本地预览 (hexo server)，访问 http://localhost:4000/
npm run clean     # 清理缓存与 public (hexo clean)
npm run build     # 生成静态文件 (hexo generate)
npm run deploy:local   # 本地构建并发布 (= ./deploy.sh)
```

## 五、构建与发布

> 旧的 **Travis CI 已停用**（`.travis.yml` 仅作历史保留，不再生效）。
> 现在统一用本地脚本 `deploy.sh` 构建并发布。

### 5.1 一键发布（推荐）

```sh
bash deploy.sh                 # 构建并强制推送到 GitHub 的 master
PUSH_GITEE=1 bash deploy.sh    # 同时推送到 Gitee 镜像
SKIP_INSTALL=1 bash deploy.sh  # 依赖已装好时跳过安装以加速
```

`deploy.sh` 的流程：

1. 加载指定版本的 Node（`module load`，并把目标版本置于 PATH 最前）。
2. 从本地密钥文件读取发布所需的令牌/账号（见下方"凭据"）。
3. `npm ci` → `hexo clean` → `hexo generate` 生成 `public/`。
4. 在 `public/` 内初始化一个临时 git 仓库，提交后 **强制推送**到 `master`；推送完删除临时 `.git`，避免令牌残留。

### 5.2 凭据管理（重要）

- 发布所需的凭据**不写入仓库**，而是放在本地的密钥文件里（例如 `~/.secrets.csh`，仅本机、权限 600）。
- `deploy.sh` 运行时从该文件按**变量名**读取，用完即从内存清除；仓库内不出现任何明文令牌/密码。

需要用到的变量（名称，**不含值**）：

| 变量名 | 说明 |
| :---: | :--- |
| `GITHUB_TOKEN` | GitHub 个人访问令牌，用于向 `master` 推送（有有效期，过期后需自行更新） |
| `GITEE_USER` | Gitee 账号（仅在 `PUSH_GITEE=1` 时需要） |
| `GITEE_PASSWORD` | Gitee 密码（仅在 `PUSH_GITEE=1` 时需要） |

> ⚠️ 切勿将上述令牌/密码提交到仓库或写进任何被 git 跟踪的文件。

### 5.3 本地已配置提交签名时

若本机开启了 git 提交/推送签名（`commit.gpgsign` / `push.gpgsign = true`），
而远程（如 GitHub HTTPS）不支持 signed push，推送会报
`the receiving end does not support --signed push`。
`deploy.sh` 已在发布时对该临时仓库关闭签名（不影响你的全局 git 配置）。
手动推送时可加 `-c push.gpgsign=false`。

## 六、常用 Git 操作

本仓库是"同库双分支"，常有跨分支操作。

拉取（pull）：远程在前、本地在后

```sh
git pull origin <远程分支名>:<本地分支名>
git pull origin <远程分支名>            # 拉到当前分支
```

推送（push）：本地在前、远程在后

```sh
git push origin <本地分支名>:<远程分支名>
git push origin <本地分支名>            # 推到同名远程分支
git push --set-upstream origin <本地分支名>   # 关联远程同名分支
```

只下载 `.git`（指定分支、不检出工作区）：

```sh
git clone --no-checkout -b master <仓库地址> .deploy_git
```

查看 git 库位置：

```sh
git rev-parse --git-dir
git rev-parse --show-toplevel
git rev-parse --show-cdup
```

提交相关：

```sh
git commit --no-verify                         # 跳过本地 pre-commit 等钩子
git commit --amend --author="Name <email@x>"   # 修改提交者信息
```

## 七、维护记录与注意事项

该博客多年未更新，近期做了一轮较大的现代化维护，要点如下（供日后排查参考）：

### 升级
- **Hexo 5.4.2 → 8.1.2**，全部 `hexo-*` 插件升级到兼容版本；移除未使用的废弃渲染器
  `hexo-renderer-jade` / `hexo-renderer-swig`（主题全部为 EJS）。
- Node 要求随之提升到 **>= 20.19**（`package.json` 的 `engines` 与 `deploy.sh` 已同步）。

### 发布链路
- 弃用 Travis CI，改为本地 `deploy.sh`（见上文第五节）。
- Gitee 镜像：若本机到 Gitee 的网络受限（端口被封/上行限速）导致推送超时，
  可改用 **Gitee 后台的"镜像同步"** 从 GitHub 自动拉取，或在网络通畅的机器上执行 `PUSH_GITEE=1 bash deploy.sh`。

### 失效的第三方服务（已替换/关闭）
- 代码高亮：Hexo 7+ 需在 `_config.yml` 顶层设置 `syntax_highlighter: prismjs`，否则 prismjs 配置不生效、代码块无高亮。
- 首页挂件接口：微博热搜/历史上的今天/一言改用 **60s API**（`60s.viki.moe`）。
- 随机图片：改用较稳定的图源，并对关键图片加 `onerror` 兜底（失败时回退本地 `/medias/logo.png`）。
- 进度条 Pace、cursor 特效的 animejs：原 `cdn.bootcss.com` 已停服，改用 jsDelivr。
- 天气组件（qweather）：域名失效且级联报错，已关闭（`weather.on: false`）。
- 评论（Valine/LeanCloud、utterance）：后端失效/未配置，已关闭；如需评论，建议配置 giscus / twikoo / utterance 之一。
- 首页 banner 视频、`movies/` 演示视频：mixkit 旧直链 `/videos/download/` 已 403，改用现行直链 `/videos/{id}/{id}-720.mp4`。

### 图标兜底
- 网站收藏(`website`)与友链(`friends`)的图标：当站点 favicon 加载失败时，自动回退到 `icon.horse`（按域名取图标），再失败回退本地 logo。

### 图表（echarts）
- 关于页文章统计图、分类页雷达图：图表容器若被 ScrollReveal 隐藏（初始 0 尺寸），echarts 会在 0×0 上初始化导致空白。
  已移除图表直接容器上的 `reveal`，并让雷达图在容器有实际尺寸后再初始化、支持 `resize()`。

### acg 随机图 API
- 原为 PHP + SQLite 接口，但 GitHub Pages 无法执行 PHP。已改造为**纯前端静态版**：
  数据库导出为 `source/acg/acgimg.json`，由页面前端随机抽取（等价于原随机 API），并在站点配置中对 `acg/**` 设置 `skip_render` 使其原样输出。

### 导航菜单
- 一级菜单精简为：首页 / 分类 / 标签 / 关于 / 友链；归档移入"更多"子菜单；
  移除失效的"音乐"与冗余空页"书单"（读书内容并入关于页读书区）。

---

> 以上维护记录仅描述改动点与排查线索，**不包含任何密钥、令牌、账号或密码**。
> 发布凭据一律通过本机密钥文件按变量名注入（见第 5.2 节）。
