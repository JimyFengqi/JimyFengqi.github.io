---
title: Django视频网站搭建--step07收藏与点赞功能
categories: Django视频网站搭建
tags:
  - django
abbrlink: 282249136
date: 2020-11-17 18:05:47
---
#收藏与点赞功能
本节讲一下个人菜单中另外两个比较重要的功能，“我的收藏”与“我的喜欢”。
通过学习这两个功能，我们会加深对django中通用视图类的理解与应用。


##我的收藏
###模型
上一节已经实现这个模型了
我的收藏、我的喜欢，都是与我关联，又因为，我可以收藏多个视频，视频也可以被多个用户收藏，所以用户与视频是属于多对多的关系。
所以我们在video模型上添加两个字段liked和collected，分别对应我喜欢和我收藏。
```python
# video/models.py
class Video(models.Model):
    ......
    # 观看次数。数据类型是IntegerField，默认是0
    view_count = models.IntegerField(default=0, blank=True)
    # 喜欢的用户。数据类型是ManyToManyField，这是一种多对多的关系，表示一个视频可以被多个用户喜欢，一个用户也可以喜欢多个视频。记得设置用户表为settings.AUTH_USER_MODEL
    liked = models.ManyToManyField(settings.AUTH_USER_MODEL, blank=True, related_name="liked_videos")
    # 收藏的用户。数据类型是ManyToManyField，这是一种多对多的关系，表示一个视频可以被多个用户收藏，一个用户也可以收藏多个视频。设置用户表为settings.AUTH_USER_MODEL
    collected = models.ManyToManyField(settings.AUTH_USER_MODEL, blank=True, related_name="collected_videos")
    ......
    created_time = models.DateTimeField(auto_now_add=True, blank=True, max_length=20)
```

可以看出liked和collected字段都是属于ManyToManyField类型，表示视频与用户是多对多的关系。

并分别设置它们的别名为"liked_videos"和"collected_videos"，通过别名也可以访问到数据。
###路由设置
下面我们来添加两者的路由，添加在users/urls.py下面。
```python
path('<int:pk>/collect_videos/', views.CollectListView.as_view(), name='collect_videos'),
path('<int:pk>/like_videos/', views.LikeListView.as_view(), name='like_videos'),
```
其中，我的收藏的视图类是CollectListView，我的喜欢的视图类是LikeListView。我们先来实现CollectListView
```python
# userprofile/views.py
class CollectListView(generic.ListView):
    model = User
    template_name = 'users/collect_videos.html'
    context_object_name = 'video_list'
    paginate_by = 10

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super(CollectListView, self).get_context_data(**kwargs)
        paginator = context.get('paginator')
        page = context.get('page_obj')
        page_list = get_page_list(paginator, page)
        context['page_list'] = page_list
        return context
    def get_queryset(self):
        user = get_object_or_404(User, pk=self.kwargs.get('pk'))
        videos = user.collected_videos.all()
        return videos
```
   
与首页展示的功能类似，这里同样继承了ListView通用视图类。并使用了公共函数get_page_list对数据进行分页。
在获取收藏数据列表时，我们用的是user.collected_videos.all()，其中collected_videos就是前面定义的别名。 
并通过配置template_name将数据传递给模板文件users/collect_videos.html。
###前端代码
模板文件关键代码
```html
<h3 class="ui header">我的收藏</h3>
<div class="ui unstackable items">

    {% for item in video_list %}
    <div class="item">
        <div class="ui tiny image">
            {% thumbnail item.cover "300x200" crop="center" as im %}
            <img class="ui image" src="{{ im.url }}">
            {% empty %}
            {% endthumbnail %}
        </div>
        <div class="middle aligned content">
            <a class="header" href="{% url 'video:detail' item.pk %}">{{ item.title }}</a>
        </div>
    </div>
    {% empty %}
    <h3>暂无数据</h3>
    {% endfor %}

</div>

{% include "base/page_nav.html" %}
```

##我的喜欢

下面来开发我的喜欢功能

该功能与我的收藏功能类似。因为前面已经添加了like_videos路由，我们直接写LikeListView的代码
```python
class LikeListView(generic.ListView):
    model = User
    template_name = 'users/like_videos.html'
    context_object_name = 'video_list'
    paginate_by = 10

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super(LikeListView, self).get_context_data(**kwargs)
        paginator = context.get('paginator')
        page = context.get('page_obj')
        page_list = get_page_list(paginator, page)
        context['page_list'] = page_list
        return context

    def get_queryset(self):
        user = get_object_or_404(User, pk=self.kwargs.get('pk'))
        videos = user.liked_videos.all()
        return videos
```
与我的收藏的模式一模一样，同样是继承ListView并设置相关model与template_name变量。最终通过users/like_videos.html来渲染。
