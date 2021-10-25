---
title: 朋友链接
date: 2021-10-20 17:46:20
img: 'https://pic2.zhimg.com/80/v2-2407599a217ba89f9499c282f129d44d_1440w.jpg?source=1940ef5c'
desc: '朋友啊，愿你出走半生，归来仍是少年'
toc: false
wordcount:
  on: false
---

# 友情链接


{% sitegroup %}
    {% site A2Data, url=https://www.a2data.cn, screenshot=https://statics.sh1a.qingstor.com/2019/06/01/24logo.png, avatar=https://statics.sh1a.qingstor.com/2019/06/01/24logo.png, description=武术跨行大数据，用技术推动梦想的落地！ %}
{% endsitegroup %}


## 来自Github的小伙伴们
{% issues sites | api=https://api.github.com/repos/yuang01/friends/issues?sort=updated&state=open&page=1&per_page=100&labels=active %}
## 来自Gitee的小伙伴们
{% issues sites | api=https://gitee.com/api/v5/repos/yuang01/friends/issues?sort=updated&state=open&page=1&per_page=100&labels=active %}
