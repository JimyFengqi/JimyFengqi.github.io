---
title: Django视频网站搭建--step3首页功能
categories: Django视频网站搭建
tags:
  - django
abbrlink: 3889211928
date: 2020-11-17 18:05:47
---
#首页功能
在本讲中，我们开始首页功能的开发，在开发过程中，
学习到Django中的通用视图类、分页对象paginator以及foreignKey外键的使用。

首页拆解为4个小的业务模块来开发，分别是：列表显示、分页功能、搜索功能、分类功能。

下面我们分别对这四个功能模块进行开发讲解。
开发思路

开发一个功能的基本思路是：先新建应用，然后分析功能涉及到哪些业务，从而分析出需要的数据库字段，然后编写模型，之后就是展示阶段，通过url路由配置视图函数，来将模型里面的数据显示出来。

ok，我们通过命令建立应用，命名为video。执行后，django将为我们新建video文件夹。

    python3 manage.py startapp video

下面的功能模块开发都在该应用(video)下进行。
##建模型

此处，我们需要建立两个模型，分别是分类表(classification)和视频列表(video)。

他们是多对一的关系(一个分类对应多个视频，一个视频对应一个分类)。

首先编写Classification表，在model.py下面，我们键入如下代码。

字段有title(分类名称)和status(是否启用)
```python
from django.db import models

class Classification(models.Model):
    list_display = ("title",)
    title = models.CharField(max_length=100,blank=True, null=True)
    status = models.BooleanField(default=True)

    class Meta:
        db_table = "v_classification"
```
字段说明

    title      分类名称。数据类型是CharField，最大长度为max_length=100，允许为空null=True
    status     是否启用。数据类型是BooleanField,默认为default=True
    db_table   表名

然后编写Video模型，根据网站业务，我们设置了title(标题)、 desc(描述)、 classification(分类)、file(视频文件)、cover(封面)、status(发布状态)等字段。

其中classification是一个ForeignKey外键字段，表示一个分类对应多个视频，一个视频对应一个分类(多对一)
```python
from django.db import models

class Video(models.Model):
    STATUS_CHOICES = (
        ('0', '发布中'),
        ('1', '未发布'),
    )
    title = models.CharField(max_length=100, blank=True, null=True)                             # 标题
    desc = models.CharField(max_length=255, blank=True, null=True)                              # 描述
    classification = models.ForeignKey(Classification, on_delete=models.CASCADE, null=True)     # 外键关联分类
    file = models.FileField(max_length=255)                                                     # 视频文件地址
    cover = models.ImageField(upload_to='cover/', blank=True, null=True)                        # 封面,设置了存贮目录
    status = models.CharField(max_length=1, choices=STATUS_CHOICES, blank=True, null=True)      # 发布状态
    created_time = models.DateTimeField(auto_now_add=True, blank=True, max_length=20)            # 创建时间 自动生成时间

    class Meta:
        db_table = "v_video"
```
字段说明

    title       视频标题。数据类型是charField，最大长度为max_length=100，允许为空null=True
    desc        视频描述。数据类型是charField，最大长度为max_length=255，允许为空null=True
    file        视频文件地址。数据类型是fileField。其中存的是视频文件的地址，在之后的视频管理中我们将会对视频的上传进行具体的讲解。
    cover       视频封面。数据类型是ImageField。存储目录为upload_to=‘cover/’，允许为空null=True
    status      视频状态。是一个选择状态，用choices设置多选元祖。
    created_time 创建时间。数据类型是DateTimeField 。设置自动生成时间auto_now_add=True

ForeignKey  表明一种一对多的关联关系。

比如这里我们的视频和分类的关系，一个视频只能对应一个分类，而一个分类下可以有多个视频。

更多关于ForeinkKey的说明，可以参看 [ForeignKey](https://docs.djangoproject.com/zh-hans/3.1/topics/db/examples/many_to_one/ "官方介绍")

将新建好的模型注册一下,在video/admin.py 注册如下
```python
from django.contrib import admin
from .models import *

# Register your models here.)
admin.site.register(Classification)
admin.site.register(Video)
```
##路由配置和注册app

要想访问到首页，必须先配置好路由。在video下建立urls.py文件
命名空间为app的名字‘video’，添加路由信息
```python
from django.urls import path
from . import views

app_name = 'video'
urlpatterns = [
    path('index', views.IndexView.as_view(), name='index'),
    path('search/', views.SearchListView.as_view(), name='search'),
]
```
同时在project中的urls.py 添加路由信息
```python
urlpatterns = [
    path('index', views.IndexView.as_view(), name='index'),
    path('search/', views.SearchListView.as_view(), name='search'),
    ...
```
在设置中添加安装和使用的app， settings。py
```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'users',
    'video',                     # 新添加的app
    'sorl.thumbnail',            # 本次使用的app，通过thumbnail添加缩略图  
]
```
一条path语句就代表一条路由信息。这样我们就可以在浏览器输入127.0.0.1:8000/video/index来访问首页了。
##显示列表
显示列表数据非常简单，我们使用django中内置的视图模版类ListView来显示，首先在view.py中编写IndexView类，用它来显示列表数据。键入如下代码
```python
class IndexView(generic.ListView):
    model = Video
    template_name = 'video/index.html'
    context_object_name = 'video_list'  
```
此处，我们使用了django提供的通用视图类ListView, ListView使用很简单，只需要我们简单的配置几行代码，即可将数据库里面的数据渲染到前端。比如上述代码中，我们配置了

    model = Video, 作用于Video模型
    template_name = ‘video/index.html’ ，告诉ListView要使用我们已经创建的模版文件。
    context_object_name = ‘video_list’ ，上下文变量名，告诉ListView，在前端模版文件中，可以使用该变量名来展现数据。


##分类功能

在写分类功能之前，我们先学习一个回调函数 get_context_data()
 
这是ListView视图类中的一个函数，在 get_context_data() 函数中，可以传一些额外内容到模板。

因此我们可以使用该函数来传递分类数据。

要使用它，很简单。

只需要在IndexView类下面，追加get_context_data()的实现即可。
```python
class IndexView(generic.ListView):
    model = Video
    template_name = 'video/index.html'
    context_object_name = 'video_list' 

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super(IndexView, self).get_context_data(**kwargs)
        classification_list = Classification.objects.filter(status=True).values()
        context['classification_list'] = classification_list
        return context
```
在上述代码中，我们将分类数据通过Classification.objects.filter(status=True).values()从数据库里面过滤出来，然后赋给classification_list，最后放到context字典里面。

在前端模板（templates/video/index.html）中，就可以通过classification_list来取数据。添加代码
```html
<div class="classification">
    <a class="ui red label" href="">全部</a>
    {% for item in classification_list %}
    <a class="ui label" href="">{{ item.title }}</a>
    {% endfor %}
</div>
```
当然现在只是实现了分类展示效果，我们还需要继续实现点击效果，即点击不同的分类，显示不同的视频列表。

我们先给每个分类按钮加上href链接
```html
<div class="classification">
    <a class="ui red label" href="{% url 'home' %}">全部</a>
    {% for item in classification_list %}
    <a class="ui label" href="?c={{ item.id }}">{{ item.title }}</a>
    {% endfor %}
</div>
```
通过添加?c={{ item.id }} 这里用c代表分类的id，点击后，会传到视图类中，在视图类中，我们使用 get_queryset() 函数，将get数据取出来。通过self.request.GET.get(“c”, None) 赋给c，判断c是否为None，如果为None，就响应全部，如果有值，就通过get_object_or_404(Classification, pk=self.c)先获取当前类，然后classification.video_set获取外键数据。
```python
    def get_queryset(self):
        self.c = self.request.GET.get("c", None)
        if self.c:
            classification = get_object_or_404(Classification, pk=self.c)
            return classification.video_set.all().order_by('-created_time')
        else:
            return Video.objects.filter(status=0).order_by('-created_time')
```
##分页功能

在Django中，有现成的分页解决方案，我们开发者省了不少事情。如果是简单的分页，只需要配置一下paginate_by即可实现。
```python
class IndexView(generic.ListView):
    model = Video
    template_name = 'video/index.html'
    context_object_name = 'video_list'
    paginate_by = 12
    c = None
```
这样每页的分页数据就能正确的显示出来来，现在来完善底部的页码条。

页码列表需要视图类和模板共同来完成，我们先来写视图类。

在前面我们已经写过get_context_data了，该函数的主要功能就是传递额外的数据给模板。这里，我们就利用get_context_data来传递页码数据。

我们先定义一个工具函数，叫get_page_list。
 在项目根目录下，新建一个文件helpers.py该文件当作一个全局的工具类，用来存放各种工具函数。
 
 把get_page_list放到helpers.py里面 该函数用来生产页码列表，不但这里可以使用，以后在其他地方也可以调用该函数。
```python
def get_page_list(paginator, page):

    page_list = []

    if paginator.num_pages > 10:
        if page.number <= 5:
            start_page = 1
        elif page.number > paginator.num_pages - 5:
            start_page = paginator.num_pages - 9
        else:
            start_page = page.number - 5

        for i in range(start_page, start_page + 10):
            page_list.append(i)
    else:
        for i in range(1, paginator.num_pages + 1):
            page_list.append(i)

    return page_list

```
分页逻辑：
```python
if 页数>=10:
    当前页<=5时，起始页为1
    当前页>(总页数-5)时，起始页为(总页数-9)
    其他情况 起始页为(当前页-5)
```
举例：

    假设一共16页
    情况1: 当前页==5  则页码列表为[1,2,3,4,5,6,7,8,9,10]
    情况2: 当前页==8  则页码列表为[3,4,5,6,7,8,9,10,11,12]
    情况3: 当前页==15 则页码列表为[7,8,9,10,11,12,13,14,15,16]`

当然你看到这个逻辑会有点乱，建议大家读着代码，多试验几遍。

当拿到页码列表，我们继续改写get_context_data()函数。 将获取到的classification_list追加到context字典中。
```python
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.c = self.request.GET.get("c", None)

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super(IndexView, self).get_context_data(**kwargs)
        classification_list = Classification.objects.filter(status=True).values()
        context['classification_list'] = classification_list

        paginator = context.get('paginator')             # 返回的是分页对象
        page = context.get('page_obj')                   # 返回的是当前页码
        page_list = get_page_list(paginator, page)
        context['page_list'] = page_list

        context['c'] = self.c
        context['classification_list'] = classification_list
        return
```

当数据传递给模板之后，模板就负责显示出来就行了。

因为分页功能比较常用，所以需要把它单独拿出来封装到一个单独的文件中，我们新建templates/base/page_nav.html文件。然后在index.html里面我们将该文件include进来。

    {% include "base/page_nav.html" %}

打开page_nav.html，写入代码
```html
{% if is_paginated %}
<div class="video-page">
    <div class="ui circular labels">
        {% if page_obj.has_previous %}
        <a class="ui circular label" href="?page={{ page_obj.previous_page_number }}{% if c %}&c={{c}}{% endif %}{% if q %}&q={{q}}{% endif %}">&lt;</a>
        {% endif %}
        {% for i in page_list %}
        {% if page_obj.number == i %}
        <a class="ui red circular label">{{ i }}</a>
        {% else %}
        <a class="ui circular label" href="?page={{ i }}{% if c %}&c={{c}}{% endif %}{% if q %}&q={{q}}{% endif %}">{{ i }}</a>
        {% endif %}
        {% endfor %}
        {% if page_obj.has_next %}
        <a class="ui circular label" href="?page={{ page_obj.next_page_number }}{% if c %}&c={{c}}{% endif %}{% if q %}&q={{q}}{% endif %}">&gt;</a>
        {% endif %}
    </div>
</div>
{% endif %}
```
 
上面代码中，我们用到了page_obj对象的几个属性：

        has_previous
        previous_page_number
        next_page_number
通过这几个属性，即可实现复杂的页码显示效果。其中我们还这href里面加了

    {% if c %}&c={{c}}
代表分类的id。
##搜索功能

要实现搜索，我们需要一个搜索框

因为搜索框是很多页面都需要的，所以我们把代码写到templates/base/header.html文件里面。
```html
<div class="ui small icon input v-video-search">
    <input class="prompt" value="{{ q }}" type="text" placeholder="搜索视频" id="v-search">
    <i id="search" class="search icon" style="cursor:pointer;"></i>
</div>
```
点击搜索或回车的代码写在了static/js/header.js里面。

我们还需要配置一下路由，添加一行搜索的路由。
```python
app_name = 'video'
urlpatterns = [
    path('index', views.IndexView.as_view(), name='index'),
    path('search/', views.SearchListView.as_view(), name='search'),
]
```
搜索路由指向的视图类为SearchListView

下面我们来写SearchListView的代码
```python
class SearchListView(generic.ListView):
    model = Video
    template_name = 'video/search.html'
    context_object_name = 'video_list'
    paginate_by = 8
    q = ''

    def get_queryset(self):
        self.q = self.request.GET.get("q","")
        return Video.objects.filter(title__contains=self.q).filter(status=0)

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super(SearchListView, self).get_context_data(**kwargs)
        paginator = context.get('paginator')
        page = context.get('page_obj')
        page_list = get_page_list(paginator, page)
        context['page_list'] = page_list
        context['q'] = self.q
        return context
```

关键代码就是Video.objects.filter(title__contains=self.q).filter(status=0)
title__contains是包含的意思，表示查询title包含q的记录。利用filter将数据过滤出来。这里写了两层过滤，第一层过滤搜索关键词，第二层过滤status已发布的视频。

另外，这里也用到了get_context_data来存放额外的数据，包括分页数据、q关键词。

配置模板文件是templates/video/search.html

因此模板代码写在search.html里面
```html
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

##其他
media 媒体文件需要添加
在设置中需要添加
```python
# 媒体文件上传路径，包括视频封面，个人头像
MEDIA_ROOT = os.path.join(BASE_DIR, 'upload')
MEDIA_URL = '/upload/'
```
同时需要讲媒体文件路径加入到路由表中
```python
from django.conf import settings
from django.conf.urls.static import static
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
```

