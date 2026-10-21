---
title: 音乐演示
date: 2021-10-18 19:12:55
type: "musics"
layout: "musics"
---
{% title h2, 音频文件加载演示 %}

> 音源说明：示例使用两个稳定可外链的公开音源 —— **SoundHelix**（`soundhelix.com`）与 **samplelib**（`samplelib.com`）。

## 一、横排展示（网格布局）

{% tabs tab-audios %}

<!-- tab 100%宽度 -->
100%宽度（1 首）
{% audios, 1 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3 %}
{% endaudios %}
<!-- endtab -->

<!-- tab 50%宽度 -->
50%宽度（4 首）
{% audios, 2 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3 %}
{% audio https://samplelib.com/lib/preview/mp3/sample-6s.mp3 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3 %}
{% audio https://samplelib.com/lib/preview/mp3/sample-9s.mp3 %}
{% endaudios %}
<!-- endtab -->

<!-- tab 25%宽度 -->
25%宽度（8 首）
{% audios, 4 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3 %}
{% audio https://samplelib.com/lib/preview/mp3/sample-3s.mp3 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3 %}
{% audio https://samplelib.com/lib/preview/mp3/sample-6s.mp3 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3 %}
{% audio https://samplelib.com/lib/preview/mp3/sample-9s.mp3 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3 %}
{% audio https://samplelib.com/lib/preview/mp3/sample-12s.mp3 %}
{% endaudios %}
<!-- endtab -->
{% endtabs %}

### 上述代码

```
{% tabs tab-audios %}

<!-- tab 100%宽度 -->
{% audios, 1 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3 %}
{% endaudios %}
<!-- endtab -->

<!-- tab 50%宽度 -->
{% audios, 2 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3 %}
{% audio https://samplelib.com/lib/preview/mp3/sample-6s.mp3 %}
... 共 4 首
{% endaudios %}
<!-- endtab -->

<!-- tab 25%宽度 -->
{% audios, 4 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3 %}
... 共 8 首
{% endaudios %}
<!-- endtab -->
{% endtabs %}
```

## 二、竖排展示（每首一行，共 13 首）

{% audios vertical %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3 %}
{% audio https://samplelib.com/lib/preview/mp3/sample-3s.mp3 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3 %}
{% audio https://samplelib.com/lib/preview/mp3/sample-6s.mp3 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3 %}
{% audio https://samplelib.com/lib/preview/mp3/sample-9s.mp3 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3 %}
{% audio https://samplelib.com/lib/preview/mp3/sample-12s.mp3 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3 %}
{% audio https://samplelib.com/lib/preview/mp3/sample-15s.mp3 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3 %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3 %}
{% endaudios %}

### 上述代码

```
{% audios vertical %}
{% audio https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3 %}
{% audio https://samplelib.com/lib/preview/mp3/sample-3s.mp3 %}
... 共 13 首 (两个音源交替)
{% endaudios %}
```
