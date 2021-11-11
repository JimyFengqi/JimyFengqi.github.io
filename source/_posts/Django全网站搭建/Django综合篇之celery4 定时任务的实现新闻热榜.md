---
title: Django综合篇之celery4 定时任务的实现新闻热榜
categories: Django全网站搭建
tags:
  - django
top: true
swiper: true
abbrlink: 51645094
date: 2020-12-01 15:15:10
---
# 环境配置

系统：Ubuntu系统
编辑器：Pycharm
Python版本：python3.6（自带celery4.3.0）
第三方包依赖： django3.0.8

# 本文简介
这篇文章主要介绍了celery4+django3定时任务的实现, 用于定时获取热门网站的榜单，组成一个新闻聚合网站

网上有很多celery + django实现定时任务的教程，不过它们大多数是基于djcelery + celery3的； 或者是使用django_celery_beat配置较为繁琐的。

显然简洁而高效才是我们最终的追求，而celery4已经不需要额外插件即可与django结合实现定时任务了，原生的celery beat就可以很好的实现定时任务功能。

当然使用原生方案的同时有几点插件所带来的好处被我们放弃了：

    1.插件提供的定时任务管理将不在可用，当我们只需要任务定期执行而不需要人为调度的时候这点忽略不计。
    2.无法高效的管理或追踪定时任务，定时任务的跟踪其实交给日志更合理，但是对任务的修改就没有那么方便了，不过如果不需要经常变更/增减任务的话这点也在可接受范围内。
# 项目内容
## 创建项目
```sh
django-admin startproject Website
cd Website
python3 manage.py startapp hot
touch ./Website/celery.py  ./hot/tasks.py start-celery.sh
```
上面的命令分别为：
- 创建一个名字为Website的项目
- 创建一个名字为hot的应用
- 创建celery相关的文件
创建完成后，基本的目录结构：
```shell
../Website/
├── hot
│   ├── admin.py
│   ├── apps.py
│   ├── __init__.py
│   ├── migrations
│   │   └── __init__.py
│   ├── models.py
│   ├── tasks.py
│   ├── tests.py
│   └── views.py
├── manage.py
├── start-celery.sh
└── Website
    ├── asgi.py
    ├── celery.py
    ├── __init__.py
    ├── settings.py
    ├── urls.py
    └── wsgi.py

```

其中hot是我们的app，用于新闻聚合，Website则是我们的project。

## 模型设计
需要考虑是否仅仅展示实时的信息
如果仅仅展示实时的信息，将获取到的新闻榜单内容做成json格式直接送给前端
如果还需要将每条信息排序，统计一下历史信息
那么需要设计一个新的model，来存贮每条信息
```python
# hot/models.py
class Hot(models.Model):
    STATUS = (
        (0, '无效'),
        (1, '有效')
    )
    hot_name = models.CharField(verbose_name='热榜源', max_length=256, null=True)
    type_name = models.CharField(verbose_name='榜单类型', max_length=256, null=True)
    content = models.TextField(verbose_name='内容', null=True)
    create_time = models.DateTimeField(auto_now_add=True, verbose_name="创建时间")
    update_time = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    status = models.SmallIntegerField(choices=STATUS, default=1, verbose_name='是否有效')
    sorted = models.SmallIntegerField('排序', default=0)

    def __str__(self):
        return self.hot_name + self.type_name

    class Meta:
        ordering = ['-sorted']
```
## 视图内容
```python
# hot/views.py
from django.shortcuts import render
from .models import Hot

def hot(request):
    """
    返回榜单信息
    :param request:
    :return:
    """
    hot_queryset = Hot.objects.all().filter(status=1)
    data = {
        'title': '热点聚合',
        'hot_queryset': hot_queryset
    }  
    return render(request, 'hot/hot.html', context=data)
```
## task设置
```python
from __future__ import absolute_import, unicode_literals
import sys
import os
import django
from subprocess import getstatusoutput

# 将当前目录加入django环境
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))))
os.environ.update({"DJANGO_SETTINGS_MODULE": "Website.settings"})
django.setup()


from celery import shared_task
from concurrent.futures import ThreadPoolExecutor
from hot.crawler import *
from hot.models import Hot


@shared_task
def run_crawler():
    """
    定时一个小时更新一次爬取
    :return:
    """
    crawler_list = [crawler_github]# 可以自己添加其他内容

    with ThreadPoolExecutor(max_workers=4) as pool:
        def get_result(future):
            """
            这个是 add_done_callback()方法来添加回调函数,
            future.result()为函数运行的结果
            :param future:
            :return:
            """
            crawler_result = future.result()
            hot_name = crawler_result.get('hot_name', '')
            type_name = crawler_result.get('type_name', '')
          
            content = crawler_result.get('content', '')
            if hot_name:
                hot = Hot.objects.filter(hot_name=hot_name).first()
                
                if not hot:
                    Hot.objects.create(hot_name=hot_name, type_name=type_name, content=content)
                else:
                    hot.content = content
                    hot.save()
 
        for future1 in crawler_list:
            pool.submit(future1).add_done_callback(get_result)
    print('done')


run_crawler()
```
注意到了这里用到自己写的crawler ， 这里面放的是各种爬虫
这里拿一个举例
## github 爬虫
```python

def crawler_github():
    """
    获取github 热榜
    :return:
    """
    url = 'https://github.com/trending'
    headers = {
        'Host': 'github.com',
        'Referer': 'https://github.com/explore'
    }
    response_html = requests.get(url, headers=headers, timeout=5)
    content_list = []
    if response_html:
        tree = etree.HTML(response_html.text)
        article_list = tree.xpath("//article[@class='Box-row']")
        for article in article_list:
            title = article.xpath('string(./h1/a)').strip()
            href = 'https://github.com/%s' % article.xpath('./h1/a/@href')[0]
            describe = article.xpath('string(./p)').strip()
          
            content_list.append({'title': '%s---%s' % (title, describe), 'href': href })
    return {'hot_name': 'GitHub',
            'type_name': '热榜',
            'crawler_name': sys._getframe().f_code.co_name,
            'content': content_list,
            }
```
## 路由配置
```python
# hot/urls.py
from django.urls import path
from . import views

app_name = 'hot'
urlpatterns = [
    # 分类页面
    path('hot', views.hot, name='hot'),
]
```
主路由配置
```python
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('hot/', include('hot.urls', namespace='hot')),  # 新闻热榜    ]   
```

# Celery定时任务配置
针对celery, 我们需要关心的主要是 celery.py ， settings.py ， tasks.py 和 start-celery.sh 。
## 建立celery
首先是celery.py，想让celery执行任务就必须实例化一个celery app，并把settings.py里的配置传入app：
```python
from __future__ import absolute_import
import os
from celery import Celery
from celery.schedules import crontab
from datetime import timedelta

# 设置django环境
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'Website.settings')
# 创建celery客户端,并起别名(没有实际意义)
app = Celery('Celery_Website')

# 加载配置:让客户端和worker知道broker的存在，
# - 'django.conf:settings'表示django,conf.settings也就是django项目的配置，celery会根据前面设置的环境变量自动查找并导入
# - namespace表示在settings.py中celery配置项的名字的统一前缀，这里是'CELERY_'，配置项的名字也需要大写
app.config_from_object('django.conf:settings', namespace='CELERY')
# 自动将异步任务注册到celery_app
# 提示:不需要找tasks.py 因为celery默认会去各个apps下面去找与tasks.py同名的文件
app.autodiscover_tasks()
# 配置broker的位置: 方便celery客户端向broker中发布任务,也为了worker从broker中取任务
broker_url = "redis://127.0.0.1/14"

# 更新配置信息，也可以在setting里面添加
app.conf.update(
    CELERYBEAT_SCHEDULE={
        '定时获取热榜': {
            'task': 'hot.tasks.run_crawler',  
            # 'schedule':  crontab(minute='*/1'),    # 定时任务
            'schedule':  timedelta(seconds=600),     # 周期性任务,每十分钟一次
            'args': (),
        }
    }
)
```
## 导入celery
配置就是这么简单，为了能在django里使用这个app，我们需要在Website/__init__.py中导入它：
```python
from __future__ import absolute_import, unicode_literals	
from .celery import app as celery_app

__all__ = ('celery_app',)
```
## 配置celery

任务配置完成后我们就要配置celery了，我们选择redis作为任务队列，强烈建议在生产环境中使用rabbitmq或者redis作为任务队列或结果缓存后端，而不应该使用关系型数据库：
```python
# setting.py
	
# redis
REDIS_PORT = 6379
REDIS_DB = 0
# 从环境变量中取得redis服务器地址
REDIS_HOST = os.environ.get('REDIS_ADDR', 'redis')
 
# celery settings
# 这两项必须设置，否则不能正常启动celery beat
CELERY_ENABLE_UTC = True
CELERY_TIMEZONE = TIME_ZONE
# 任务队列配置
CELERY_BROKER_URL = f'redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_DB}'
CELERY_ACCEPT_CONTENT = ['application/json', ]
CELERY_RESULT_BACKEND = f'redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_DB}'
CELERY_TASK_SERIALIZER = 'json'
```
## 设置定时任务
然后是我们的定时任务设置,前面我们其实已经将定时任务放入celery.py 里面了，当然也可以放在设置文件中：
```	
from celery.schedules import crontab
CELERY_BEAT_SCHEDULE={
    'fetch_news_every-1-hour': {
      'task': 'news.tasks.fetch_all_news',
      'schedule': crontab(minute=0, hour='*/1'),
    }
}
```
定时任务配置对象是一个dict，由任务名和配置项组成，主要配置想如下：

    task：任务函数所在的模块，模块路径得写全，否则找不到将无法运行该任务
    schedule：定时策略，一般使用 celery.schedules.crontab ，上面例子为每小时的0分执行一次任务，具体写法与linux的crontab类似可以参考文档说明
    args：是个元组，给出任务需要的参数，如果不需要参数也可以不写进配置，就像例子中的一样
    其余配置项较少用，可以参考文档

至此，配置celery beat的部分就结束了。

### 启动celery beat
配置完成后只需要启动celery了。

启动之前配置一下环境。不要用root运行celery！不要用root运行celery！不要用root运行celery！重要的事情说三遍。
```shell
# start-celery.sh：
export REDIS_ADDR=127.0.0.1
celery -A Website worker -l info -B -f /path/to/log
```
-A 表示app所在的目录，-B表示启动celery beat运行定时任务。

celery正常启动后就可以通过日志来查看任务是否正常运行了：

