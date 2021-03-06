---
title: 主题介绍-文章Front-matter
author: Fengqi
categories: 本站介绍
tags: [Hexo,markdown]
top: false  
swiper: true
swiperDesc: 我是文章在轮播图中的摘要
password: d2332d7ab769e19baf41be831a6c57b320ef6842b13498f11af402f54db13eff
abbrlink: 3831565538
date: 2021-10-25 07:30:00
---

## 文章 Front-matter 介绍
这个指的是你在你的文章页面里面写的参数，针对的是这一篇文章，例如

```yaml
---
title: Hexo主题--Bamboo介绍
date: 2021-10-24 14:06
swiper: true # 将改文章放入轮播图中
swiperImg: '/medias/1.jpg' # 该文章在轮播图中的图片，可以是本地目录下图片也可以是http://xxx图片
img: '/medias/1.jpg' # 该文章图片，可以是本地目录下图片也可以是http://xxx图片
categories: 前端
tags: [Hexo, hexo-theme-bamboo]
top: true

---

```
`Front-matter` 选项中的所有内容均为**非必填**的。但我仍然建议至少填写 `title` 和 `date` 的值。


| 配置选项            | 默认值                 | 描述                                                         
| ----------------- | --------------------- | -------------------------------------------------------- 
| title             | `Markdown` 的文件标题   | 文章标题，强烈建议填写此选项                                    
| date              | 文件创建时的日期时间      | 发布时间，强烈建议填写此选项，且最好保证全局唯一
| author            | Fengqi                | 文章作者，没有设置默认是Fengqi
| categories 	    | 无 	                | 文章分类，本主题的分类表示宏观上大的分类，只建议一篇文章一个分类 
| tags      	    | 无 	                | 文章标签，一篇文章可以多个标签  
| top 	            | false 	            | 将该值设为true，则将该篇文章显示在首页的置顶栏目中
| toc 	            | true 	                | 将该值设为false，则该篇文章不显示右侧目录
| tocOpen 	        | true 	                | 将该值设为false，则该篇文章右侧目录默认收缩
| onlyTitle 	    | false 	            | 文章详情页头部是否只显示标题，不显示日期等信息
| excerpt 	        | 无 	                | 文章描述（摘要），该文章在首页的描述文字，如果没有，则取swiperDesc,如果swiperDesc也没有，则取文章内容（优先取 `<!-- more --> "`上面的内容）
| swiper            | false                 | 表示该文章是否需要加入到首页轮播封面中       
| swiperImg         | 无                    | 表示该文章在首页轮播封面需要显示的图片路径，如果没有，则默认使用文章的特色图片                                               
| swiperDesc        | 无 	                | 表示该文章在首页轮播封面需要显示的文字描述（摘要），如果没有，则使用excerpt，如果excerpt也没有，则取文章内容
| img 	            | 无 	                | 文章特征图，该文章显示的图片，没有则默认使用文章的特色图片
| bgImg 	        | - 	                | 单独为这篇文章设置背景图片或者背景颜色，可以是数组，数组里面放图片链接，可以是字符串，字符串里面是颜色值，空值则背景颜色透明
| bgImgTransition 	| fade 	                | 该篇文章的bgImg设置为数组,该值表示背景图片切换的动画, 有三种值（fade, scale, translate-fade）
| bgImgDelay 	    | 180000(三分钟) 	    | 该篇文章的bgImg设置为数组,该值表示背景图片切换的延迟时间 
| comments  	    | true 	                | 将该值设为false，则该篇文章不显示评论
| share 	        | true 	                | 将该值设为false，则该篇文章不显示分享按钮
| copyright 	    | true 	                | 将该值设为false，则该篇文章不显示版权声明
| donate 	        | true 	                | 将该值设为false，则该篇文章不显示打赏按钮
| prismjs 	        | 无 	                | 如果使用的是hexo自带的prismjs代码高亮，通过设置该值为该篇文章设置不同的代码高亮主题（default, coy, dark, funky, okaidia, solarizedlight, tomorrow, twilight）
| mathjax   	    | false 	            | mathjax公式 


以上基本就是所有的配置项了

