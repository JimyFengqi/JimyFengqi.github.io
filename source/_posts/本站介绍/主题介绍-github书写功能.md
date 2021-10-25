---
title: 主题介绍-github书写功能
author: Fengqi
categories: 本站介绍
tags:
  - Hexo
  - markdown
abbrlink: 1527967124
date: 2021-10-24 10:05:00
---

{% title h1, Github用户卡片 %}
{% ghcard jimyfengqi %}
### 上述示例代码
```markdown
{% ghcard jimyfengqi %}
```
## 表格中加入用户卡片
| {% ghcard jimyfengqi %} | {% ghcard jimyfengqi, theme=vue %} 
| -- | -- |
| {% ghcard jimyfengqi, theme=buefy %} | {% ghcard jimyfengqi, theme=solarized-light %} 
| {% ghcard jimyfengqi, theme=onedark %} | {% ghcard jimyfengqi, theme=solarized-dark %} 
| {% ghcard jimyfengqi, theme=algolia %} | {% ghcard jimyfengqi, theme=calm %} 

### 上述示例代码

```markdown
| {% ghcard jimyfengqi %} | {% ghcard jimyfengqi, theme=vue %} |
| -- | -- |
| {% ghcard jimyfengqi, theme=buefy %} | {% ghcard jimyfengqi, theme=solarized-light %} |
| {% ghcard jimyfengqi, theme=onedark %} | {% ghcard jimyfengqi, theme=solarized-dark %} |
| {% ghcard jimyfengqi, theme=algolia %} | {% ghcard jimyfengqi, theme=calm %} |
```
## 单个项目卡片
{% ghcard jimyfengqi/hexo-theme-bomboo %}
{% ghcard jimyfengqi/hexo-theme-bomboo %}
{% ghcard jimyfengqi/hexo-theme-bomboo %}
{% ghcard jimyfengqi/hexo-theme-bomboo %}
### 上述事例代码
```markdown
{% ghcard jimyfengqi/hexo-theme-bomboo %}
{% ghcard jimyfengqi/hexo-theme-bomboo %}
{% ghcard jimyfengqi/hexo-theme-bomboo %}
{% ghcard jimyfengqi/hexo-theme-bomboo %}
```
## 表格中加入单个项目卡片
| {% ghcard jimyfengqi/hexo-theme-bomboo %} | {% ghcard jimyfengqi/hexo-theme-bomboo, theme=vue %} |
| -- | -- |
| {% ghcard jimyfengqi/hexo-theme-bomboo, theme=buefy %} | {% ghcard jimyfengqi/hexo-theme-bomboo, theme=solarized-light %} |
| {% ghcard jimyfengqi/hexo-theme-bomboo, theme=onedark %} | {% ghcard jimyfengqi/hexo-theme-bomboo, theme=solarized-dark %} |
| {% ghcard jimyfengqi/hexo-theme-bomboo, theme=algolia %} | {% ghcard jimyfengqi/hexo-theme-bomboo, theme=calm %} |

### 上述事例代码
```markdown
| {% ghcard jimyfengqi/hexo-theme-bomboo %} | {% ghcard jimyfengqi/hexo-theme-bomboo, theme=vue %} |
| -- | -- |
| {% ghcard jimyfengqi/hexo-theme-bomboo, theme=buefy %} | {% ghcard jimyfengqi/hexo-theme-bomboo, theme=solarized-light %} |
| {% ghcard jimyfengqi/hexo-theme-bomboo, theme=onedark %} | {% ghcard jimyfengqi/hexo-theme-bomboo, theme=solarized-dark %} |
| {% ghcard jimyfengqi/hexo-theme-bomboo, theme=algolia %} | {% ghcard jimyfengqi/hexo-theme-bomboo, theme=calm %} |
```

{% title h1, issues-sites标签 %}

该标签会去拿到某个repo仓库的issue内容，用sites标签的形式显示出来，可以用做网站的友链功能
该标签和issues-timeline标签都适用于github和gitee

## 使用方法

issue里面需要有JSON代码块：
```json
{
    "title": "",
    "url": "",
    "avatar": "",
    "screenshot": "",
    "description": ""
}
```
### Github写法
```markdown
{% issues sites | api=https://api.github.com/repos/jimyfengqi/friends/issues?sort=updated&state=open&page=1&per_page=100&labels=active %}
```
### Gitee写法
```markdown
{% issues sites | api=https://gitee.com/api/v5/repos/jimyfengqi/friends/issues?sort=updated&state=open&page=1&per_page=100&labels=active %}
```
yuang01: 用户名，friends: 仓库名
上例中的 labels=active 参数可以控制默认的 issue 不显示，只有自己审核通过添加了 active 标签之后才会显示。
当然label也是自己设置的，你可以自己选择一个好识别的标签
上述示例对应的仓库链接：
[github](https://github.com/jimyfengqi/friends)
[gitee](https://gitee.com/jimyfengqi/friends)
## 效果
可以点击 [友链](https://jimyfengqi.github.io/friends/) 查看

{% title h1, issues-timeline标签 %} 
该标签会去拿到某个repo仓库的issue内容，用timeline标签的形式显示出来


### github写法
```markdown
{% issues timeline | api=https://api.github.com/repos/jimyfengqi/hexo-theme-bomboo/issues?sort=updated&state=closed&page=1&per_page=100 %}

```
    api=xxx:
    jimyfengqi是我的github用户名，hexo-theme-bomboo是我的仓库名，state=closed，表示拿到状态为close的issue，根据自己实际情况更改

### Gitee写法
```markdown
{% issues timeline | api=https://gitee.com/api/v5/repos/jimyfengqi/friends/issues %}
```
    api=xxx:
    jimyfengqi是我的gitee用户名，friends是我gitee的仓库名，其他参数请见文档

## issue api
[github的开放api](https://docs.github.com/cn/rest/overview/resources-in-the-rest-api)
[gitee的开放api](https://gitee.com/api/v5/swagger#/getV5ReposOwnerRepoIssues)



## repo仓库效果

下面的效果是来自于这这两个仓库的issue

hexo-theme-bomboo (Github)

https://github.com/jimyfengqi/hexo-theme-bomboo/issues?q=is%3Aissue+is%3Aclosed+sort%3Aupdated-desc

friends (Gitee)

https://gitee.com/jimyfengqi/friends/issues
### Github效果(example)
{% issues timeline | api=https://api.github.com/repos/jimyfengqi/hexo-theme-bomboo/issues?sort=updated&state=closed&page=1&per_page=100 %}
### Gitee效果(example)

{% issues timeline | api=https://gitee.com/api/v5/repos/jimyfengqi/friends/issues %}
