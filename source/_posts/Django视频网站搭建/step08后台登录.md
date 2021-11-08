---
title: Django视频网站搭建--step08后台登录
categories: Django视频网站搭建
tags:
  - django
abbrlink: 2648619932
date: 2020-08-25 17:41:41
---
#后台登录功能
从本讲起，我们会介绍后台管理系统的开发，后台管理

主要是对数据库中的数据进行增、删、改、查的操作，满足网站管理员对网站的管理与维护的需求。

其实，django自带的也有一个后台管理系统（/admin），但是自带的后台非常简陋，

无论是界面，还是功能上，都无法满足用户的需求，因此，需要自己开发了一套后台管理系统。
##创建新的app
后台管理属于一个单独的模块，我们创建一个新的应用，命名为myadmin
```shell script
python3 manage.py startapp myadmin
```
之后的功能都是基于myadmin来实现的。

因为前面我们已经创建了user模块，所以此处的登录功能是基于之前的user模块来实现的。
##添加路由
首先在myadmin/urls.py中添加登录和登出的路由
```python
from django.urls import path
from . import views

app_name = 'myadmin'
urlpatterns = [
    path('login/', views.login, name='login'),
    path('logout/', views.logout, name='logout'),
]
```

我们来写login函数
```python
from django.shortcuts import *
from django.contrib.auth import authenticate, login as auth_login, logout as auth_logout
# 复用userprofile中的UserLoginForm
from userprofile.forms import UserLoginForm

def login(request):
    if request.method == 'POST':
        form = UserLoginForm(request=request, data=request.POST)
        if form.is_valid():
            username = form.cleaned_data.get('username')
            password = form.cleaned_data.get('password')
            user = authenticate(username=username, password=password)

            if user is not None and user.is_staff:
                auth_login(request, user)
                return redirect('myadmin:index')
            else:
                form.add_error('', '请输入管理员账号')
    else:
        form = UserLoginForm()
    return render(request, 'myadmin/login.html', {'form': form})
```
首先这里复用了之前创建的 表单UserLoginForm
这里我们使用了user模型中的一个字段is_staff，用它来表示是否是管理员，
所以通过if user is not None and user.is_staff来判断管理员，如果是管理员，则auth_login登录并redirect跳转到主页。

下面我们来实现logout函数
```python
def logout(request):
    auth_logout(request)
    return redirect('myadmin:login')
```
登出后，直接跳转到login页面。
