---
title: Django视频网站搭建--step15数据总览功能
categories: Django视频网站搭建
tags:
  - django
abbrlink: 2725073212
date: 2020-08-28 16:57:53
---
#数据总览功能
数据总览功能，是对网站中产生的数据进行一个统计，统计出视频数、发布数、用户数、评论数，等等。让管理者对网站数据有一个清晰的认识，做到心中有数。

在本站中，笔者一共列举了下面几种数据：视频数、发布中
未发布、用户数、用户新增、评论数、评论新增，等几项内容。

我们把所有的数据都封装到了一个函数里面，即 IndexView 它位于后台管理的首页。
##路由设置
```python
path('', views.IndexView.as_view(), name='index'),
```

##视图设置
通过IndexView实现视图，IndexView代码如下
```python
class IndexView(AdminUserRequiredMixin, generic.View):

    def get(self, request):
        video_count = Video.objects.get_count()
        video_has_published_count = Video.objects.get_published_count()
        video_not_published_count = Video.objects.get_not_published_count()
        user_count = User.objects.count()
        user_today_count = User.objects.exclude(date_joined__lt=datetime.date.today()).count()
        comment_count = Comment.objects.get_count()
        comment_today_count = Comment.objects.get_today_count()
        data = {"video_count": video_count,
                "video_has_published_count": video_has_published_count,
                "video_not_published_count": video_not_published_count,
                "user_count": user_count,
                "user_today_count": user_today_count,
                "comment_count": comment_count,
                "comment_today_count": comment_today_count}
        return render(self.request, 'myadmin/index.html', data)
```

与视频相关的统计，我们封装到了Video的models.py下面, 之前已经写好了，现在来调用它
```python
# video/models.py
class VideoQuerySet(models.query.QuerySet):
    # 视频总数
    def get_count(self):
        return self.count()

    # 发布数
    def get_published_count(self):
        return self.filter(status=0).count()

    # 未发布数
    def get_not_published_count(self):
        return self.filter(status=1).count() 
```
以上数据，大都使用了filter过滤器进行了过滤，最后通过count()函数返回给业务方。

与用户相关的统计，我们直接通过count和exclude将相关数据过滤出来。

与评论相关的统计，封装到了Comment的models.py下面，
```python

class CommentQuerySet(models.query.QuerySet):

    # 评论总数
    def get_count(self):
        return self.count()

    # 今日新增
    def get_today_count(self):
        return self.exclude(timestamp__lt=datetime.date.today()).count()

```
其中，今日新增评论，我们通过exclude来过滤时间，使用了 lt 标签来过滤
