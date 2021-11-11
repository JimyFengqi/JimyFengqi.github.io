---
title: Django综合篇之自定义Command生成初始数据
categories: Django全网站搭建
tags:
  - django
top: true
swiper: true
abbrlink: 1557037206
date: 2020-08-17 14:43:43
---
#Django--自定义 Command 命令
Django 对于命令的添加有一套规范，你可以为每个app 指定命令。

通俗一点讲，比如在使用manage.py文件执行命令的时候，可以自定制自己的命令，来实现命令的扩充。

##commands的创建

    1.在app内创建一个management的python目录
    
    2.在management目录里面创建commands的python文件夹
    
    3.在commands文件夹下创建任意py文件

此时py文件名就是你的自定制命令，可以使用下面方式执行
```shell script
python manage.py 命令名
```
Django的Command命令是要放在一个app的management/commands目录下的。

请确保management和management/commands目录内都包含__init__.py文件

  首先对于文件名没什么要求，内部需要定义一个Command类并继承BaseCommand类或其子类。

它必须定义一个Command类并扩展自BaseCommand或其子类。

    其中help是command功能作用简介，
    handle函数是主处理程序，
    add_arguments函数是用来接收可选参数的
```python
from django.core.management.base import BaseCommand, CommandError
from article.models import ArticlePost  自己的

class Command(BaseCommand):
    help = 'Closes the specified article_id'

    def add_arguments(self, parser):
        parser.add_argument('article_id', nargs='+', type=int)

    def handle(self, *args, **options):
        for article_id in options['article_id']:
            try:
                article = ArticlePost.objects.get(pk=article_id)
            except Poll.DoesNotExist:
                raise CommandError('article "%s" does not exist' % article_id)

            poll.opened = False
            poll.save()

            self.stdout.write('Successfully closed article "%s"' % article_id)
```
可选参数

可使用add_argument（）方法：
```python
# -*- coding: utf-8 -*-
# __author__ = 'dandy'
from django.core.management.base import BaseCommand

class Command(BaseCommand):

    def add_arguments(self, parser):
        parser.add_argument('aaa', nargs='+', type=int)
        parser.add_argument('--delete',
                            action='store_true',
                            dest='delete',
                            default=False,
                            help='Delete poll instead of closing it')

    def handle(self, *args, **options):
        print('test')
        print(args, options)
```
options里面直接取参数就可以了。
方法
返回django版本号：BaseCommand.get_version() 
命令的真正逻辑。子类必须实现这个方法。：BaseCommand.handle()

##将本地内容最为初始数据写入文章

最主要的就是获取本地文章列表
```python
        current_article_dir = os.path.join(BASE_DIR, 'md')	# 通过BASE_DIR 找到存贮文章的目录
        print(current_article_dir)
        article_lists = subprocess.getstatusoutput('ls %s' % current_article_dir)[1].split('\n')  #通过subprocess 命令得到当前目录下的内容
```

最终实现：
```python
import os
import subprocess

from myblog.settings import BASE_DIR
from article.models import ArticlePost
from django.contrib.auth import get_user_model
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    help = 'create blog data'

    def handle(self, *args, **options):
        user = get_user_model().objects.get_or_create(
            email='test@test.com', username='测试用户', password='test123456')[0]

        current_article_dir = os.path.join(BASE_DIR, 'md')
        print(current_article_dir)
        article_lists = subprocess.getstatusoutput('ls %s' % current_article_dir)[1].split('\n')

        for i in article_lists:
            title = os.path.splitext(i)[0]
            f_flag = open(os.path.join(current_article_dir, i), 'r')
            body = f_flag.read()
            f_flag.close()
            article = ArticlePost.objects.get_or_create(
                title=title,
                body=body,
                author=user)[0]
            article.save()
        self.stdout.write(self.style.SUCCESS('create blog data \n'))

```


