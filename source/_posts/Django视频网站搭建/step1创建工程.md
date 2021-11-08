---
title: Django视频网站搭建--step1创建工程
categories: Django视频网站搭建
tags:
  - django
abbrlink: 707041426
date: 2020-08-05 10:38:23
---
#基于django的视频点播网站开发
##项目介绍
本文将会对该项目进行一个简单的介绍，包括项目名称、项目背景、项目功能、技术栈等等。

项目名称: **基于django的视频点播网站开发**

###项目背景

视频点播网站，搭建一个视频点播网站，练习学习一下django技术，学以致用。
项目功能

###项目功能
本项目分为前台和后台

前台功能

    视频列表展示
    视频播放详情
    详情评论
    个人中心

后台功能

    视频管理
    评论管理
    用户管理
    反馈管理
    
本讲中，主要搭建开发环境。我们会依次安装python、pip、django、mysql和其他的一些必要类库。
##安装python

安装 Python 非常简单，去 Python 官方网站 找到 Python3 的下载地址，根据你的系统选择32位或者64位的安装包，下载好后双击安装即可。

安装完毕后，在命令行输入 python -v ，如果输出了 Python 的版本号，说明 Python 已安装成功。

    $ python3 -V
    Python 3.8.0
安装pip

如果已经安装了python3， 那么pip3一般会自动的被安装。
##安装django
安装django非常简单，一条命令搞定。

    pip3 install django
##安装mysql
由于该项目使用的是mysql数据库，所以需要安装mysql。

如果你使用的是Windows或macOS系统，那么可以去 MySQL官网 直接下载安装包，一步步安装即可。
安装过程中会提示创建输账号和密码，一定要记得创建哦～。

ubuntu下使用命令apt-get install mysql-server安装mysql

    sudo apt-get install mysql-server
Mysql5.7这个版本，安装过程中不会提示输入密码的，它的的root密码在/etc/mysql/debian.cnf这个文件里面
使用sudo cat /etc/mysql/debian.cnf命令打开，你大概会看到如下内容，其中就包括Mysql的默认登陆名与密码

    [client]
    host     = localhost
    user     = debian-sys-maint
    password = Ah5gE7mWH1OxO9Gw
    socket   = /var/run/mysqld/mysqld.sock
    [mysql_upgrade]
    host     = localhost
    user     = debian-sys-maint
    password = Ah5gE7mWH1OxO9Gw
    socket   = /var/run/mysqld/mysqld.sock

1.使用 mysql -u用户名 -p密码进行登陆，

    mysql -udebian-sys-maint -p

2、修改root用户密码

    show databases；
    use mysql;
    update user set authentication_string=PASSWORD("密码") where user='root';
    update user set plugin="mysql_native_password";
    flush privileges;
    quit;

注:由于mysql5.7没有password字段，密码存储在authentication_string字段中

3、重新启动Mysql

    /etc/init.d/mysql restart

4、再次使用root用户登陆
安装完毕后，可使用mysql -V查看mysql版本号。

    mysql -V
    mysql  Ver 14.14 Distrib 5.7.31, for Linux (x86_64) using  EditLine wrapper

然登录创建新的数据库，命名为video

    root -u root -p
    CREATE DATABASE video CHARACTER SET utf8;


##安装PyCharm

PyCharm 是一款功能强大的 Python 编辑器，具有跨平台性。 我们项目所有功能的开发都是在pycharm上面完成的。

到PyCharm官网下载PyCharm安装包。
选择对应系统（Windows/Mac）的版本下载。一般学习用直接安装社区版本即可足够用。

下载之后，双击点下一步安装即可。
##其他安装

另外，下面这些是项目开发过程中会用到的类库，放到了requirements.txt里面

    django==3.0.8
    pillow==5.3.0 （图片显示）

可以使用pip3直接安装

    pip3 install -r requiredments.txt
##创建Django工程

一切就绪，我们创建django工程，仅需要一行命令

    django-admin startproject videoproject

创建之后，可使用pycharm打开videoproject文件夹，查看文件结构

pycharm是很强大的，有自带的命令行工具（Terminal），版本控制工具（Version Control）。

###启动项目
打开Terminal，输入

    python3 manage.py runserver

在之后的开发中，我们会经常用到该命令行来调试程序。

命令行输出
    
    Starting development server at http://127.0.0.1:8000/
    Quit the server with CONTROL-C.

然后在浏览器地址栏输入http://127.0.0.1:8000/ 即可看到django默认首页了。

###项目配置

项目的配置文件位于videoproject/videoproject/settings.py
配置编码

首先需要配置的是文字编码格式，django默认的编码是英语格式，我们把它改成中文格式，需要修改下面几个变量的值。

    LANGUAGE_CODE = 'zh-hans'  # 中文编码
    TIME_ZONE = 'Asia/Shanghai'  # 国际时区改为中国时区
    USE_I18N = True  # 指定Django的翻译系统是否开启。如果设置为False，Django会做一些优化，不去加载翻译机制
    
    USE_L10N = True  # 用于决定是否开启数据本地化。如果此设置为True，例如Django将使用当前语言环境的格式显示数字和日期。
    
    USE_TZ = True    # 用来指定是否使用指定的时区(TIME_ZONE)的时间。若为True, 则Django会使用内建的时区的时间；否则, Django将会使用本地的时间


配置static

然后还需要配置资源文件目录，用于存储CSS、Javascript、Images等文件。这里我们设置目录为/static/

    STATIC_URL = '/static/'
    STATICFILES_DIRS = (
    os.path.join(BASE_DIR, "static"),
    )
配置数据库

然后还需要配置数据库信息，django默认使用的是sqlite数据库，我们修改为mysql数据库。找到DATABASES节点，修改为如下代码。其中，NAME为数据库名，USER为mysql的用户名，PASSWORD为密码，HOSY为127.0.0.1，PORT为3306

    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.mysql',
            'NAME': 'video',
            'USER': 'root',
            'PASSWORD': '123456',
            'HOST':'127.0.0.1',
            'PORT':'3306',
        }
    }

配置好数据库之后，还需要在videoproject/videoproject/__init__.py安装mysql驱动，只需要写入代码：
    
    import pymysql
    pymysql.install_as_MySQLdb()

上面代码运行的前提是你电脑上已经安装了PyMySQL类库。

最后可再次运行工程，检查配置是否正确。
