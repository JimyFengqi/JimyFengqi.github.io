---
name: dead-resource-triage
description: 系统排查并替换网站/项目中失效的外部资源(第三方API、CDN、图床、字体、脚本、视频、友链)。涵盖用 curl 探测连通性与 CORS、区分真死与反爬、选择仍在运营的替代源、以及给图片/图标加 onerror 兜底。当站点加载慢/超时、图片裂图、接口报错、或需要清理老项目的失效外链时使用。
---

# 失效外部资源排查与替换

老项目最常见的腐烂点：依赖的免费第三方 API/图床/CDN 关停或改规则。症状包括页面加载慢(浏览器等死链超时)、裂图、控制台报错。

## 第一步：探测连通性（区分"真死" vs "活着只是拦我")
对每个 URL：
```bash
curl -sS -4 -A "Mozilla/5.0 Chrome/120" --connect-timeout 6 -m 12 -D /tmp/h -o /dev/null \
  -w "%{http_code} ct=%{content_type} t=%{time_total}s" "$URL"
grep -i 'access-control-allow-origin' /tmp/h   # 浏览器端用的资源必须有 CORS
```
判读（**关键，别误删活站**）：
- `rc=6`(DNS无法解析)/`rc=7`(连接拒绝)/`rc=60/51`(SSL失败)/`rc=28`(超时) → **基本是真死**
- `403/401/429/521` → 多半是**反爬/限流/Cloudflare**，站点其实活着，浏览器带正确 referer 能访问 → **保留**
- `200` → 活
- `302` 跳到图片 + `ct=image/*` → 随机图 API 正常
- 慢(t>2s) 但 200 → 活但不稳，可换更快的源
对 DNS/超时的，用 `getent hosts <host>` 和带浏览器 UA 重试二次确认，避免误判。

## 第二步：批量定位引用
先区分"渲染的资源"和"文章/文档正文里的文本"——后者动了会改内容。
```bash
grep -rlE 'dead1\.com|dead2\.cn' <active-code-dirs>   # 模板/配置/数据, 不含 posts 正文
```
注意：被注释掉的块、已关闭功能(on:false)的 dormant 配置、打包库里的字符串都是**假阳性**，不产生请求。

## 第三步：替换为已验证可用的源（本会话实测可用，CORS 友好）
| 用途 | 可用替代 |
|------|---------|
| 聚合API(热搜/历史上的今天/一言) | `60s.viki.moe/v2/{weibo,today_in_history,hitokoto}` (CORS *) |
| 一言 | `v1.hitokoto.cn` (CORS *) |
| 随机二次元图(慢) | `loliapi.com/acg/`、`/bg/` (302, CORS *, 但 1~3s 偏慢) |
| 快速稳定随机图(非ACG) | `picsum.photos/seed/<seed>/W/H` (~0.15s, 确定性) |
| 站点favicon兜底 | `icon.horse/icon/<domain>` |
| 失效CDN(bootcss已停服) | jsDelivr `cdn.jsdelivr.net/npm/<pkg>@<ver>/...` |
| 演示视频(mixkit旧/download/preview已403) | `assets.mixkit.co/videos/{id}/{id}-720.mp4`(id在旧文件名里)；或 w3.org/soundhelix 等 |
| 演示音频 | `soundhelix.com/examples/mp3/SoundHelix-Song-N.mp3`、`samplelib.com/lib/preview/mp3/sample-Ns.mp3` |
注意：换新 API 若 JSON 结构不同，要同步改前端解析字段。

## 第四步：加兜底，根治裂图/超时
给所有外链 `<img>` 加 onerror 多级回退（原图 → favicon服务 → 本地占位图）：
```html
<img src="X" onerror="if(this.dataset.fb!=='1'){this.dataset.fb='1';this.src='https://icon.horse/icon/<host>';}else{this.onerror=null;this.src='/local/logo.png';}">
```
CSS background-image 不能用 onerror → 用 JS `new Image()` 预检失败再换。
无法换的死链(技术插图原图丢失) → 直接删除引用(避免浏览器等超时)，但保留正文超链接(非图片)。

## 处置原则
- 混合内容：`https` 站点里的 `http://` 资源会被浏览器拦截，统一换 https。
- 优先本地化(下载到 source/)彻底去外部依赖；次选换稳定源；再次 onerror 兜底；无解则删。
