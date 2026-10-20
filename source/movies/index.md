---
title: movies
date: 2021-10-18 19:13:13
type: "movies"
layout: "movies"
---


{% title h2, video演示 %}
{% tabs tab-website %}

<!-- tab 100%宽度 -->

100%宽度
{% video https://assets.mixkit.co/videos/4839/4839-720.mp4 %}
<!-- endtab -->

<!-- tab 50%宽度 -->
50%宽度
{% videos, 2 %}
{% video  https://assets.mixkit.co/videos/4157/4157-720.mp4 %}
{% video  https://assets.mixkit.co/videos/6804/6804-720.mp4 %}
{% video  https://assets.mixkit.co/videos/1778/1778-720.mp4 %}
{% video  https://assets.mixkit.co/videos/862/862-720.mp4 %}
{% endvideos %}
<!-- endtab -->

<!-- tab 25%宽度 -->
25%宽度
{% videos, 4 %}
{% video  https://assets.mixkit.co/videos/4702/4702-720.mp4 %}
{% video  https://assets.mixkit.co/videos/452/452-720.mp4 %}
{% video  https://assets.mixkit.co/videos/4829/4829-720.mp4 %}
{% video  https://assets.mixkit.co/videos/40933/40933-720.mp4 %}
{% video  https://assets.mixkit.co/videos/956/956-720.mp4 %}
{% video  https://assets.mixkit.co/videos/862/862-720.mp4 %}
{% video  https://assets.mixkit.co/videos/39883/39883-720.mp4 %}
{% video  https://assets.mixkit.co/videos/40053/40053-720.mp4 %}
{% endvideos %}
<!-- endtab -->
{% endtabs %}
# 上述代码
```
{% title h2, video演示 %}

100%宽度
{% video  https://assets.mixkit.co/videos/preview/mixkit-down-the-river-in-a-bamboo-canoe-6804-large.mp4 %}

50%宽度
{% videos, 2 %}
{% video  https://assets.mixkit.co/videos/preview/mixkit-down-the-river-in-a-bamboo-canoe-6804-large.mp4 %}
{% video  https://assets.mixkit.co/videos/preview/mixkit-down-the-river-in-a-bamboo-canoe-6804-large.mp4 %}
{% video  https://assets.mixkit.co/videos/preview/mixkit-down-the-river-in-a-bamboo-canoe-6804-large.mp4 %}
{% video  https://assets.mixkit.co/videos/preview/mixkit-down-the-river-in-a-bamboo-canoe-6804-large.mp4 %}
{% endvideos %}

25%宽度
{% videos, 4 %}
{% video  https://assets.mixkit.co/videos/preview/mixkit-down-the-river-in-a-bamboo-canoe-6804-large.mp4 %}
{% video  https://assets.mixkit.co/videos/preview/mixkit-down-the-river-in-a-bamboo-canoe-6804-large.mp4 %}
{% video  https://assets.mixkit.co/videos/preview/mixkit-down-the-river-in-a-bamboo-canoe-6804-large.mp4 %}
{% video  https://assets.mixkit.co/videos/preview/mixkit-down-the-river-in-a-bamboo-canoe-6804-large.mp4 %}
{% video  https://assets.mixkit.co/videos/preview/mixkit-down-the-river-in-a-bamboo-canoe-6804-large.mp4 %}
{% video  https://assets.mixkit.co/videos/preview/mixkit-down-the-river-in-a-bamboo-canoe-6804-large.mp4 %}
{% video  https://assets.mixkit.co/videos/preview/mixkit-down-the-river-in-a-bamboo-canoe-6804-large.mp4 %}
{% video  https://assets.mixkit.co/videos/preview/mixkit-down-the-river-in-a-bamboo-canoe-6804-large.mp4 %}
{% endvideos %}
```