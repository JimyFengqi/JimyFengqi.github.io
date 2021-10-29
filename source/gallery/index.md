---
title: 精选图库
date: 2021-10-20 17:46:20
toc: false
img: https://pic2.zhimg.com/80/v2-2cf3b62a87045ee279096449cf6f3ac1_1440w.jpg?source=1940ef5c
onlyTitle: true
---

{% title h2, 图库文件展示 %}


{% tabs tab-1 %}
<!-- tab 单张图片 -->
{% gallery %}
![图片描述](https://pic4.zhimg.com/80/v2-5dfab6525ec92b4caf3f09e1ee72a23b_1440w.jpg?source=1940ef5c)
![图片描述](https://pic4.zhimg.com/80/v2-5c062983ace7db9601880019190fb5a8_1440w.jpg?source=1940ef5c)
{% endgallery %}
<!-- endtab -->
<!-- tab 多组图片 -->

<div class="gallery-group-main">
    {% galleryGroup '壁纸' '收藏的一些壁纸' '/gallery/bizhi' https://pic1.zhimg.com/80/v2-23c3820e8abfb1cef689531af2dc6d09_1440w.jpg?source=1940ef5c %}
    {% galleryGroup '古典图片' '中国古典图片' '/gallery/gudian' https://pic1.zhimg.com/80/v2-8d542d68cbbf0e5f503da9e3f72b8447_1440w.jpg?source=1940ef5c %}
    {% galleryGroup '风景' '风景图片' '/gallery/fengjing' https://pic1.zhimg.com/80/v2-56164ef0695767475935c9e019c594ae_1440w.jpg?source=1940ef5c %}
    {% galleryGroup '必应' '必应壁纸图片' '/gallery/bing' /gallery/bing/2021/08/20211022.jpg %}
</div>
<!-- endtab -->
{% endtabs %}




## 以上示例

```
{% title h2 图库文件展示 %}
{% tabs tab-1 %}
<!-- tab 单张图片 -->
{% gallery %}
![图片描述](https://pic4.zhimg.com/80/v2-5dfab6525ec92b4caf3f09e1ee72a23b_1440w.jpg?source=1940ef5c)
![图片描述](https://pic4.zhimg.com/80/v2-5c062983ace7db9601880019190fb5a8_1440w.jpg?source=1940ef5c)
{% endgallery %}
<!-- endtab -->
<!-- tab 多组图片 -->

<div class="gallery-group-main">
    {% galleryGroup '壁纸' '收藏的一些壁纸' '/gallery/bizhi' https://pic1.zhimg.com/80/v2-23c3820e8abfb1cef689531af2dc6d09_1440w.jpg?source=1940ef5c %}
    {% galleryGroup '古典图片' '中国古典图片' '/gallery/gudian' https://pic1.zhimg.com/80/v2-8d542d68cbbf0e5f503da9e3f72b8447_1440w.jpg?source=1940ef5c %}
    {% galleryGroup '风景' '风景图片' '/gallery/fengjing' https://pic1.zhimg.com/80/v2-56164ef0695767475935c9e019c594ae_1440w.jpg?source=1940ef5c %}
</div>
<!-- endtab -->
{% endtabs %}
```