---
title: Django综合篇之django-haystack配置详解过程
categories: Django全网站搭建
tags:
  - django
abbrlink: 3096121977
date: 2020-11-29 02:11:04
---

# 前言

django是python语言的一个web框架，功能强大。配合一些插件可为web网站很方便地添加搜索功能。

搜索引擎使用whoosh，是一个纯python实现的全文搜索引擎，小巧简单。

中文搜索需要进行中文分词，使用jieba。

直接在django项目中使用whoosh需要关注一些基础细节问题，而通过haystack这一搜索框架，可以方便地在django中直接添加搜索功能，无需关注索引建立、搜索解析等细节问题。

haystack支持多种搜索引擎，不仅仅是whoosh，使用solr、elastic search等搜索，也可通过haystack，而且直接切换引擎即可，甚至无需修改搜索代码。
# 配置搜索
## 1.安装相关包
```shell
pip install django-haystack
pip install whoosh
pip install jieba
```
## 2.配置django的settings

修改settings.py文件，添加haystack应用：
```python
INSTALLED_APPS = (
    ...
    'haystack', #将haystack放在最后
)
```
在settings中追加haystack的相关配置：
```python
HAYSTACK_CONNECTIONS = {
    'default': {
        # 此处为默认的WhooshEngine，后面会修改它,因此把它注释掉
        # 'ENGINE': 'haystack.backends.whoosh_cn_backend.WhooshEngine', 
        'ENGINE': 'blog.whoosh_cn_backend.WhooshEngine',
        'PATH': os.path.join(BASE_DIR, 'whoosh_index'),
    }
}
# 添加此项，当数据库改变时，会自动更新索引，非常方便
HAYSTACK_SIGNAL_PROCESSOR = 'haystack.signals.RealtimeSignalProcessor'
```
- HAYSTACK_CONNECTIONS 的 ENGINE 指定了 django haystack 使用的搜索引擎，这里我们使用了 blog.whoosh_cn_backend.WhooshEngine，虽然目前这个引擎还不存在，但我们接下来会创建它。

- PATH 指定了索引文件需要存放的位置，我们设置为项目根目录 BASE_DIR 下的 whoosh_index 文件夹（在建立索引是会自动创建）。

- HAYSTACK_SIGNAL_PROCESSOR 指定什么时候更新索引，这里我们使用haystack.signals.RealtimeSignalProcessor，作用是每当有文章更新时就更新索引。由于博客文章更新不会太频繁，因此实时更新没有问题。
## 3.添加url

在整个项目的urls.py中，配置搜索功能的url路径：
```python
urlpatterns = [
    ...
    # path('search/', include('haystack.urls')), #这是默认的搜索路由
    path('blog_search/', BlogSearchView(), name='haystack'),                  
]
```
如果不重新搜索视图，那么添加上面注释掉的路由就可以了。
我们添加了自己重新写的一个搜索视图，下面会具体介绍。
## 4.在应用目录下，添加一个索引

在子应用的目录下，创建一个名为 search_indexes.py 的文件。
**这是 django haystack 的规定**。要相对某个 app 下的数据进行全文检索，就要在该 app 下创建一个 search_indexes.py 文件，然后创建一个 XXIndex 类（XX 为含有被检索数据的模型，如这里的 Blog），并且继承 SearchIndex 和 Indexable。
```python 
from haystack import indexes
from .models import Blog   # 修改此处，添加自己model


# 类名必须为需要检索的Model_name+Index，这里需要检索Blog，所以创建BlogIndex
class BlogIndex(indexes.SearchIndex, indexes.Indexable):
    text = indexes.CharField(document=True, use_template=True)
    
③ # 此外可以存在，可以不存在，看具体需要的数据
    """下面这些字段，在索引类中进行申明，在REST framework中，索引类的字段可以被作为索引查询结果返回数据额来源"""
    
    id = indexes.IntegerField(model_attr='id')
    name = indexes.CharField(model_attr='name')
    price = indexes.DecimalField(model_attr='price')

    """也就是说，前端在索引的时候，可以按照text=xxx,也可以按照id=xxx,name=xxx等，我们的数据返回也是返回id,name,price """
    def get_model(self):
        return Blog                     # 添加自己model

    def index_queryset(self, using=None):
        return self.get_model().objects.all()
```
说明：
  - 修改上文中三处注释即可
 - 此文件指定如何通过已有数据来建立索引。get_model处，直接将django中的model放过来，便可以直接完成索引啦，无需关注数据库读取、索引建立等细节。
 - text=indexes.CharField ，指定了将模型类中的哪些字段建立索引，而use_template=True说明后续我们还要指定一个模板文件，告知具体是哪些字段
每个索引里面必须有且只能有一个字段为 document=True，这代表 django haystack 和搜索引擎将使用此字段的内容作为索引进行检索(primary field)。注意，如果使用一个字段设置了document=True，则一般约定此字段名为text，这是在 SearchIndex 类里面一贯的命名，以防止后台混乱

- use_template=True 在 text 字段中，这样就允许我们使用数据模板去建立搜索引擎索引的文件，说得通俗点就是索引里面需要存放一些什么东西，例如 Post 的 title 字段，这样我们可以通过 title 内容来检索 Post 数据了。举个例子，假如你搜索 Python ，那么就可以检索出 title 中含有 Python 的Blog了。

## 5.指定索引模板文件
在项目的“templates/search/indexes/应用名称/”下创建“模型类名称_text.txt”文件（例如 templates/search/indexes/blog/blog_text.txt),全小写即可。

此文件指定将模型中的哪些字段建立索引，写入如下内容：（不要改掉object,可以继续添加其他的字段) 
```
# templates/search/indexes/blog/blog_text.txt
{{ object.title }}
{{ object.body }}
```
## 6.指定搜索结果页面

在templates/search/下面，建立一个search.html页面。
```html
<!DOCTYPE html>
<html>
<head>
    <title></title>
</head>
<body>
{% if query %}
    <h3>搜索结果如下：</h3>
    {% for result in page.object_list %}
        <a href="/{{ result.object.id }}/">{{ result.object.title}}</a><br/>
    {% empty %}
        <p>啥也没找到</p>
    {% endfor %}

    {% if page.has_previous or page.has_next %}
        <div>
            {% if page.has_previous %}<a href="?q={{ query }}&amp;page={{ page.previous_page_number }}">{% endif %}&laquo; 上一页{% if page.has_previous %}</a>{% endif %}
        |
            {% if page.has_next %}<a href="?q={{ query }}&amp;page={{ page.next_page_number }}">{% endif %}下一页 &raquo;{% if page.has_next %}</a>{% endif %}
        </div>
    {% endif %}
{% endif %}
</body>
</html>
```
## 7.使用jieba中文分词器

在haystack的安装文件夹下，找到文件路径如“/usr/local/lib/python3.6/dist-packages/django_haystack-2.8.1-py3.6.egg/haystack/backends/whoosh_backend.py”，复制一份到自己的app 路径下重命名为whoosh_cn_backend.py，然后添加修改如下内容：
```python
# 顶部引入jieba中的中文分词器
from jieba.analyse import ChineseAnalyzer

# 在整个py文件中，查找
analyzer=StemmingAnalyzer()
全部改为改为
analyzer=ChineseAnalyzer()
总共大概有两三处吧
```
## 8.修改搜索默认引擎

如果之前已经做了修改，这一步就可以跳过了，修改settings.py文件

```python
HAYSTACK_CONNECTIONS = {
    'default': {
        # 此处为默认的WhooshEngine，后面会修改它,因此把它注释掉
        # 'ENGINE': 'haystack.backends.whoosh_cn_backend.WhooshEngine', 
        'ENGINE': 'blog.whoosh_cn_backend.WhooshEngine',
        'PATH': os.path.join(BASE_DIR, 'whoosh_index'),
    }
}
```


```
## 10.实现搜索入口

在网页中加入搜索框：
```html
<form method='get' action="/blog/blog_search/" target="_blank">
    <input type="text" name="q">
    <input type="submit" value="查询">
</form>
```
注意，由于我们自定义了search_view的路由，因此，这里的action需要写成写对的位置，或者
```html
<form action="{% url 'blog:haystack' %}" method="get" name="form">
```
## 10. 自定义搜索视图


## 11. 序列化API设置
###  1.安装相关包
```shell
pip install drf-haystack 
pip install djangorestframework 
```
安装需要的第三方包
### 2.编写序列化类
```python
# blog/serializer.py
from .models import *
from .search_indexes import BlogIndex

from rest_framework.serializers import ModelSerializer
from drf_haystack.serializers import HaystackSerializerMixin

class BlogSerializers(ModelSerializer):
    class Meta:
        model = Blog
        fields = '__all__'
        
class BlogIndexSerializer(HaystackSerializerMixin, BlogSerializers):
    class Meta(BlogSerializers.Meta):
        index_classes = [BlogIndex]
        search_fields = ['text', 'title', 'content']  # 不能和正常搜索一样使用q参数
```
这里序列化Blog数据 和BlogIndex数据

注意BlogIndexSerializer 中的search_fields ，这里可查询的数据源对应Blog的Model中的数据
### 3.视图设置
```python
from drf_haystack.viewsets import HaystackViewSet
from .serializers import *
from .models improt Blog

class BlogSearchViewSet(HaystackViewSet):
    """
    返回博客文章搜索列表
    """
    index_models = [Blog]
    serializer_class = BlogIndexSerializer
 ```
### 4.配置urls路由
```python
from django.urls import path
from blog import views as blog_view
from rest_framework import routers

router = routers.DefaultRouter()
# 因为视图没有定义query_set字段，因此需要加上basename字段
router.register(r'blog_search', blog_view.BlogSearchViewSet, basename='blog_search')
urlpatterns = [
    path('api/', include(router.urls)),   # API路由
]
```
## 12.生成索引


手动生成一次索引：
```shell
python3 manage.py rebuild_index
```
# 丰富的自定义
上面只是快速完成一个基本的搜索引擎，haystack还有更多可自定义，来实现个性化的需求。

    参考官方文档：http://django-haystack.readthedocs.io/en/master/

# 自定义搜索view
上面的配置中，搜索相关的请求被导入到haystack.urls中，如果想自定义搜索的view，实现更多功能，可以修改。
## 1.自定义路由
haystack.urls中内容其实很简单，
```python
from django.conf.urls import url  
from .views import SearchView  
  
urlpatterns = [  
    path('blog_search/', BlogSearchView(), name='haystack'),  
]  
```
## 2.自定义视图
那么，我们写一个view，继承自SearchView，即可将搜索的url导入到自定义view中处理啦。
```python
from haystack.views import SearchView
from .models import Blog
import json
from django.http import HttpResponse


class BlogSearchView(SearchView):
    # 重写template的位置
    template = 'search/blog_search.html'

    def get_context(self):
        context = super(BlogSearchView, self).get_context()

        results = self.results
        # 当搜索引擎找不到时，重新从数据库中找一遍
        if results.__len__() <= 0:
            results = []
            search_blogs = Blog.objects.filter(title__icontains=self.query,
                                               content__icontains=self.query).order_by('-created_time')
            for search_blog in search_blogs:
                results.append({"object": search_blog})
		# 将result结果返回为Blog列表
        results = [blog['object'] for blog in results.values('object')] if results.__len__() > 0 else results

        context.update({
            'title': '博客搜索',
            'results': results
        })
        return context
```

查看SearchView的源码或文档，了解每个方法是做什么的，便可有针对性地进行修改。
-  上面重写了template变量，修改了搜索结果页面模板的位置。
-  重写get_context方法，添加一些自己想要的字段，修改results的格式
## 3.高亮搜索关键字

在搜索结果页的模板中，可以使用highlight标签（需要先load一下）
```
{% highlight <text_block> with <query> [css_class "class_name"] [html_tag "span"] [max_length 200] %}
```
text_block即为全部文字，query为高亮关键字，后面可选参数，可以定义高亮关键字的html标签、css类名，以及整个高亮部分的最长长度。

    高亮部分的源码位于 haystack/templatetags/lighlight.py 和 haystack/utils/lighlighting.py文件中，可复制进行修改，实现自定义高亮功能。
