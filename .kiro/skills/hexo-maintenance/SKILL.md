---
name: hexo-maintenance
description: 维护本 Hexo 博客(魔改 bamboo 主题)时的非显而易见的坑与修复。涵盖 prismjs 代码高亮回归、pjax 下 echarts/脚本不初始化、ScrollReveal 导致图表 0 尺寸空白、abbrlink(crc32)手动生成、skip_render 独立页、front-matter 批处理、翻页页布局 gating。当修复主题功能失效、新增/批量处理文章、或调整首页/分页布局时使用。
---

# Hexo 老站维护常见坑

> 环境前提：本站 Hexo 8 + Node>=20.19 + 魔改 bamboo 主题；代码在 `hexo` 分支、产物发布到 `master`(见 hexo-deploy-local skill)。

## 代码高亮(prismjs)
Hexo 7+ 必须在站点 `_config.yml` 顶层设 `syntax_highlighter: prismjs`，否则旧的 `prismjs.enable:true` 不生效、代码块无 `token` 类、样式全丢。构建不报错，只能靠看产物 `grep 'class="token'` 发现。

## pjax 下脚本/图表不初始化
主题若用 pjax(无刷新跳转)，站内跳转**不触发** `window.onload`，且默认不执行新注入的 `<script>`。
- 内联初始化脚本要加 `data-pjax`，pjax 才会在 `pjax:complete` 重新执行它。
- 用 `window.onload` 的旧库(如 3D 标签云)：改成可复用 init 函数，首次加载 + `document.addEventListener('pjax:complete', init)` 都调用；重入时先清理旧定时器/状态。

## echarts 图表空白(常被误判为"没加载")
根因往往是容器被 **ScrollReveal**(`.reveal` 类)设为隐藏/0 尺寸，echarts 在 0×0 上 init 就永远空白。
- 对策：移除图表**直接容器**的 `reveal` 类；或 init 前轮询等 `clientWidth>0` 再 `echarts.init()` 并 `resize()`。
- 顺带：echarts 5 已废弃 `itemStyle.normal.*`，`areaStyle` 直接放 series 下。
- echarts 本体要在 `<head>`(theme.import.script)全局加载一次；pjax 不重载 head，所以它跨页常驻。

## abbrlink：crc32(title) 手动生成
若移除了 `hexo-abbrlink` 插件(它常是漏洞源，且当 permalink 不是 `:abbrlink` 时并不驱动 URL)，新文章不会自动生成 abbrlink。需要时手动算(与插件 crc32/dec 算法一致)：
```js
function crc32(s){const T=[];for(let n=0;n<256;n++){let c=n;for(let k=0;k<8;k++)c=c&1?0xEDB88320^(c>>>1):c>>>1;T[n]=c>>>0;}
  const b=Buffer.from(s,'utf8');let c=0xFFFFFFFF;for(let i=0;i<b.length;i++)c=(c>>>8)^T[(c^b[i])&0xFF];return (c^0xFFFFFFFF)>>>0;}
// abbrlink = crc32(post_title)  // 验证: crc32("1-两数之和(Two Sum)")===868110745
```
注意：移除插件/abbrlink **不影响 URL**(拼音 permalink `post/:title` 驱动)——改前后 `find public/post -name index.html` 列表应 diff=0。

## 批量导入文章 / 处理 front-matter
- "文件夹即分类"：`categories: <folder>`。
- 无 front-matter 的 .md：从首个 `# 标题` 派生 title，补 author/categories/tags/date。
- 用 node 脚本正则处理，只动 front-matter 块；删字段用 `^field:.*\n` 按行删，别误伤正文。
- tags 要通读正文提炼，别用占位/文件夹名充数。

## 独立静态页不套主题布局
想让某页(如自建的 API/展示页)原样输出、不被主题 layout 包裹：站点 `_config.yml` 设 `skip_render: ['dir/**']`。
PHP 等动态脚本在 GitHub Pages 跑不了 → 改纯前端(数据导出为 json，前端 fetch)。

## 翻页页(page 2+)布局
首页专属内容(banner/公告/挂件/侧边栏)在分页页重复很突兀。在 index.ejs 顶部算一次 `var isFirstPage=(page.current===1)`，把首页专属 partial 统一包进 `if(isFirstPage)`。注意有些 partial 内部已自带 `page.current===1` gate，有些(如 home_widget)没有——以 index.ejs 层统一控制最可靠。
分页器居中：若第1页无"上一页"按钮，`justify-content:space-between` 会把页码挤偏 → 给页码块 `flex:1;text-align:center`。

## 通用验证
每次改完 `hexo clean && hexo generate`，grep 错误；改依赖后 `npm ci` 确认 lockfile 同步；改 URL 相关的对比产物 URL 列表 diff；清理临时文件。
