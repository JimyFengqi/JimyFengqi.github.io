# hexo-theme-bamboo（本站定制版）

> 本主题 **fork 并大量修改** 自 [yuang01/hexo-theme-bamboo](https://github.com/yuang01/hexo-theme-bamboo)
> （最初基于其 dev 分支 2.6.9 版本），为本博客 <https://jimyfengqi.github.io/> 定制。
>
> ⚠️ 本目录已与上游分叉，**不要直接用上游版本覆盖**，否则会丢失下列定制。
> 升级上游前请先 `git clone https://github.com/yuang01/hexo-theme-bamboo.git` 对比差异。

## 与上游的主要差异（本站定制）

### 兼容性
- 适配 **Hexo 8**（上游早期版本面向 Hexo 5）。
- 代码高亮依赖站点配置顶层 `syntax_highlighter: prismjs` 才生效（Hexo 7+ 变更）。

### 首页文章列表改版（`layout/_partial/card/post.ejs` + `source/css/_partial/posts.styl`）
- 由横向单卡列表改为 **3 列网格的竖向卡片**：
  - 上半 50% 封面图 + 居中标题
  - 概要取正文前 250 字符（去标签/解码实体）
  - 时间(左) + 分类(右)，底部横向标签
- 悬停动画：封面放大 + 遮罩变浅 + 卡片上浮。
- 暗色模式适配卡片文字/背景（`source/css/_partial/dark.styl`）。

### 翻页行为（`layout/index.ejs`）
- 顶部统一用 `isFirstPage` 判断：翻页（第 2 页起）保留 banner，移除公告/欢迎挂件/座右铭/推荐文章/右侧边栏，内容区占满。

### 分页器（`source/css/_partial/paginator.styl`）
- `.page-info` 居中修复：第 1 页无"上一页"按钮时页码也居中（全站分页通用）。
- tags/categories 详情页文章网格限宽 70%，与分页器对齐。

### 失效外链治理
- 失效 CDN（bootcss 的 pace/animejs）改用 jsDelivr。
- 默认随机封面兜底改为本地 `source/medias/defaultImage/`；`{% site %}` 标签与友链头像增加 `onerror` 兜底（失败回退 icon.horse，再回退本地 logo）。
- 默认关闭已失效/无意义的服务：天气组件（qweather）、百度推送（baiduPush）、Valine/LeanCloud 评论。

### 媒体标签增强（`scripts/tag/media.js` + `source/css/_tag/media.styl`）
- 新增 `audios` 网格标签（对应已有的 `videos`），支持 `col 1/2/3/4/8` 横排与 `vertical` 竖排，用于音乐演示页。

### 图表（echarts）
- 关于页文章统计图、分类页雷达图：修复被 ScrollReveal 隐藏导致 0 尺寸初始化空白的问题；初始化加 `data-pjax` 以适配 pjax 跳转。

> 以上为主要改动清单，细节以源码为准。本主题由站点仓库一并维护，不单独发布。

---

## 原主题安装方式（仅供参考）

进入 hexo 的 `themes` 文件夹下 clone 上游主题：

```bash
git clone https://github.com/yuang01/hexo-theme-bamboo.git
```

然后在站点 `_config.yml` 中把 `theme` 指向该主题目录，并在主题的 `_config.yml` 中配置。

> 注意：本站用的是**定制版**（即本目录），并非上游原版。
