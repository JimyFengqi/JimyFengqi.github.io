---
title: Django综合篇之添加xadmin功能
categories: Django全网站搭建
tags:
  - django
abbrlink: 2146647189
date: 2020-09-17 23:49:29
---
#添加xadmin功能

django2.0,以及django3.0直接使用xadmin功能已经不太友好了
如果直接使用pip的方式安装 django-xadmin会遇到很多错误的坑
这里使用一个新的方式添加xadmin功能
##下载文件
在这里https://gitee.com/voldemort/xadmin-django3/tree/master 我们需要的xadmin内容

下载之后只使用xadmin这个文件夹
将整个文件夹复制 然后在自己的项目文件夹下新建文件夹 extra_apps,然后xadmin粘贴过来

同时需要安装

    django-crispy-forms==1.8.1
    django-import-export==2.0.2
    django-reversion==3.0.7
    django-formtools==2.2.0
    future==0.18.2
    httplib2==0.9.2
    six==1.14.0
上面标注的版本,最好是大于等于其版本
DjangoUEditor是根据老的xadmin新添加的功能

```
##添加到项目中
settings.py下新增
```python
import sys
sys.path.insert(0,os.path.join(BASE_DIR,'extra_apps'))
```
这样我们的项目就可以访问到xadmin了
```python
INSTALLED_APPS = [
    'django.contrib.admin',#管理网站
    'django.contrib.auth',#认证模块
    'django.contrib.contenttypes',#内部框架
    'django.contrib.sessions',#会话管理
    'django.contrib.messages',#消息框架
    'django.contrib.staticfiles',#映射的静态资源

    'xadmin',                   # xadmin　　相关
    'crispy_forms',             # xadmin　　相关
    'DjangoUeditor',            # xadmin　　内的富文本编辑器
	

]
```
将xadmin添加到项目中,毕竟他也是一个新的app,同时添加的还有crispy_forms
 

##添加路由
urls.py中新增路由
```python 
from django.urls import path, include
import xadmin
    # 富文本相关url
    path('xadmin/', xadmin.site.urls),                      # xadmin相关
    path('ueditor/', include('DjangoUeditor.urls')),        # 富文本编辑器
```

##将自己的app注册到xadmin
在admin.py同级目录下建立adminx.py,配置格式如下
```python
import xadmin

from .models import *
# Register your models here.

import xadmin
from .models import *
from xadmin import views


# 此类可以定义admin后台显示的字段，比如文章列表显示标题，创建时间，
class BlogAdmin(object):
    """博客文章"""
    # 展示的字段
    list_display = ['id', 'title', 'excerpt', 'read_num', 'appreciate',
                    'created_time', 'tags', 'category', 'status']
    # 按文章名进行搜索
    search_fields = ['title']
    # 筛选
    list_filter = ['id', 'title', 'created_time', 'category', 'status']
    # 修改图标
    model_icon = 'fa fa-file-text'
    # 修改默认排序
    ordering = ['-id']

    # 设置只读字段
    readonly_fields = ['read_num']

    # 不显示某一字段
    exclude = ['']

    list_display_link = ['title']

    style_fields = {'content': 'ueditor'}


class CategoryAdmin(object):
    """分类"""
    list_display = ['id', 'name', 'created_time']
    search_fields = ['name']
    model_icon = 'fa fa-file-text'


class TagAdmin(object):
    """标签"""
    list_display = ['id', 'name']
    search_fields = ['name']
    model_icon = 'fa fa-file-text'


xadmin.site.register(Blog, BlogAdmin)
xadmin.site.register(Category, CategoryAdmin)
xadmin.site.register(Tag, TagAdmin)


# 修改xadmin的基础配置
class BaseSetting(object):
    # 允许使用主题
    enable_themes = True            # 开启自定义主题
    use_bootswatch = True


# 修改xadmin的全局配置
class GlobalSetting(object):
    site_title = '自己的全站'
    site_footer = '2020中自己建立的全站'

    # Models收起功能
    menu_style = 'accordion'


xadmin.site.register(views.CommAdminView, GlobalSetting)
xadmin.site.register(views.BaseAdminView, BaseSetting)
```
##更新数据库
建立与xadmin相关的表,并将表添加到数据库

    python manage.py makemigrations
    python manage.py migrate
##更换xadmin的logo
base.py更改源码,换logo

    base.png

##汉化显示菜单名字

首先自己定义的model文件中，对于每一个变量，添加参数verbose_name

	author = models.ForeignKey(UserInfo, verbose_name='作者', on_delete=models.CASCADE)
	title = models.CharField(max_length=128, verbose_name="标题")

对于app.py文件做出对应的修改
```python
from django.apps import AppConfig


class BlogConfig(AppConfig):
    name = 'blog'
    verbose_name = "博客管理"　　　#对应汉化
    mean_icon = 'fa fa-user'	　# 添加图标
```

最后一步，相对应的app下面的__init__.py文件中，添加如下：

	default_app_config = "blog.apps.BlogConfig"


