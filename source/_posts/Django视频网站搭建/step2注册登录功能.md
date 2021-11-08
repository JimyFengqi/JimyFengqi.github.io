---
title: Django视频网站搭建--step2注册登录功能
categories: Django视频网站搭建
tags:
  - django
abbrlink: 3402743585
date: 2020-08-21 17:35:46
---
#注册登录功能

用户注册登录是一个网站的基本功能，django对这部分进行了很好的封装，

我们只需要在django的基础上做些简单的修改就可以达到我们想要的效果。

在本讲中，我们会用到user中的用户授权方面的一些函数，还会对django中的user进行扩展，以及django中的form验证。

#创建users应用

django的设计哲学是，一个应用只提供一种功能，比如users应用只提供用户相关功能，comment应用只提供评论相关功能，

这能提高代码的重复利用率。

在django中，只需要下面一条命令，即可建立users应用

    python3 manage.py startapp userprofile

###建表

我们需要一个用户表，用来实现登录注册功能，虽然django已经自带来用户登录注册功能，也有相应的表，但是不符合中国人习惯，需要我们对user模型进行自定义。

实现自定义User模型最简单的方式就是继承AbstractBaseUser，AbstractBaseUser实现了User的核心功能，我们只需加一些额外的字段进行补充即可。

User模型原有的字段有：

    username
    password
    last_login
    is_superuser
    first_name
    last_name
    email
    is_staff
    is_active
    date_joined

这些都是最基本的字段，并不能满足我们的需求。

根据网站自身业务，我们又添加了下面的字段

    nickname(昵称)
    avatar(头像)
    mobile(手机号)
    gender(性别)
    subscribe(是否订阅)

我们只需在userprofile/models.py中写入代码
```python
from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    GENDER_CHOICES = (
        ('M', '男'),
        ('F', '女'),
    )
    nickname = models.CharField(blank=True, null=True, max_length=20)
    avatar = models.FileField(upload_to='avatar/')
    mobile = models.CharField(blank=True, null=True, unique=True, max_length=13)
    gender = models.CharField(max_length=1, choices=GENDER_CHOICES, blank=True, null=True)
    subscribe = models.BooleanField(default=False)

    class Meta:
        db_table = "tb_user"
```
    gender是性别字段，其中用到了choices=GENDER_CHOICES。这种方式常常用在下拉框或单多选框，例如 M对应男 F对应女。
##url配置

在userprofile文件夹下面，新建urls.py文件，写入登录、注册和退出的url信息。

app_name是命名空间，我们命名为‘users’。
```python
from django.urls import path
from . import views

app_name = 'userprofile'
urlpatterns = [
    path('login/', views.login, name='login'),
    path('signup/', views.signup, name='signup'),
    path('logout/', views.logout, name='logout'),
]
```
同时更改主路由表，即修改工程文件下的urls.py
```python
from django.contrib import admin
from django.urls import path, include


urlpatterns = [
    path('admin/', admin.site.urls),
    path('userprofile/', include('userprofile.urls')),
]
```

然后需要注册这个APP， 在admin.py 中添加信息如下
```python
from .models import User
admin.site.register(User)
```
同时将这个app注册到设置中，在setting文件中添加
```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'users',   # 添加users这个app
]
```

否则可能会报错
```
RuntimeError: Model class apps.users.models.
User doesn't declare an explicit app_label 
and isn't in an application in INSTALLED_APPS.
```
**同时，由于我们将要复写django自带的User类，需要添加配置信息到setting中**
```python
    AUTH_USER_MODEL = 'userprofile.User'
```
    让Django中自带的user不起作用即可
否则会出现如下错误：

    auth.User.groups: (fields.E304) Reverse accessor for 'User.groups' clashes
    with reverse accessor for 'UserProfile.groups'.

url路由配置好了，我们下面就开始写视图函数代码了
##注册表单

我们先来写注册函数，写注册，当然得有注册表单了，幸运的是，在django中，可以用代码来生成表单。

我们只需在userprofile下新建forms.py文件，然后写入注册表单的代码。
```python
from django import forms
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from .models import User


class UserLoginForm(AuthenticationForm):
    username = forms.CharField(min_length=4,max_length=30,
                               error_messages={
                                   'min_length': '用户名不少于4个字符',
                                   'max_length': '用户名不能多于30个字符',
                                   'required': '用户名不能为空',
                               },
                               widget=forms.TextInput(attrs={'placeholder': '请输入用户名'}))
    password = forms.CharField(min_length=8,max_length=30,
                               error_messages={
                                   'min_length': '密码不少于8个字符',
                                   'max_length': '密码不能多于30个字符',
                                   'required': '密码不能为空',
                               },
                               widget=forms.PasswordInput(attrs={'placeholder': '请输入密码'}))

    class Meta:
        model = User
        fields = ['username', 'password']

    error_messages = {'invalid_login': '用户名或密码错误', }


class SignUpForm(UserCreationForm):
    username = forms.CharField(min_length=4, max_length=30,
                               error_messages={
                                   'min_length': '用户名不少于4个字符',
                                   'max_length': '用户名不能多于30个字符',
                                   'required': '用户名不能为空',
                               },
                               widget=forms.TextInput(attrs={'placeholder': '请输入用户名'}))
    password1 = forms.CharField(min_length=8, max_length=30,
                                error_messages={
                                    'min_length': '密码不少于8个字符',
                                    'max_length': '密码不能多于30个字符',
                                    'required': '密码不能为空',
                                },
                                widget=forms.PasswordInput(attrs={'placeholder': '请输入密码'}))
    password2 = forms.CharField(min_length=8,max_length=30,
                                error_messages={
                                    'min_length': '密码不少于8个字符',
                                    'max_length': '密码不能多于30个字符',
                                    'required': '密码不能为空',
                                },
                                widget=forms.PasswordInput(attrs={'placeholder': '请确认密码'}))

    class Meta:
        model = User
        fields = ('username', 'password1', 'password2',)

    error_messages = {'password_mismatch': '两次密码不一致', }

```
   

我们的表单一共有三个字段：username、password1、password2，它们都是CharField类型，widget分别是TextInput和PasswordInput。

而且django是自带验证的，只需要我们配置好error_messages字典，当form验证的时候，就会显示我们自定义的错误信息。
有了注册表单后，就可以在前端模板和视图函数中使用它。
###注册视图
下面是注册视图函数。
```python
from django.contrib.auth import authenticate, login as auth_login, logout as auth_logout
from .forms import SignUpForm, UserLoginForm
from django.shortcuts import *


def signup(request):
    if request.method == 'POST':
        form = SignUpForm(request.POST)
        if form.is_valid():
            form.save()
            username = form.cleaned_data.get('username')
            raw_password1 = form.cleaned_data.get('password1')
            user = authenticate(username=username, password=raw_password1)
            auth_login(request, user)
            return redirect('home')
        else:
            print(form.errors)
    else:
        form = SignUpForm()
    return render(request, 'registration/signup.html', {'form': form})



def logout(request):
    auth_logout(request)
    return redirect('home')
```

在signup函数中，我们通过form = SignUpForm初始化一个表单，并在render函数中传递给模板。

注册模板文件写在了templates/registration/signup.html

关键代码是
```html
<form class="ui large form" novalidate method="post" action="{% url 'userprofile:signup' %}" enctype="multipart/form-data" >
            {% csrf_token %}
            <div class="ui stacked segment">
                <div class="field"> 
                    {{form.username}} 
                </div>
                <div class="field"> 
                    {{form.password1}} 
                </div>
                <div class="field"> 
                    {{form.password2}} 
                </div>
                <button class="ui submit button" type="submit">注册</button>
            </div>
            {% include "base/form_errors.html" %}
        </form>
```

form的action为
```html
{% url 'users:signup' %}
```
即在url.py中定义的signup函数。
通过post请求传递给signup，在signup中，通过如下四行代码来实现注册，并自动登录的。
```python
username = form.cleaned_data.get('username')
raw_password1 = form.cleaned_data.get('password1')
user = authenticate(username=username, password=raw_password1)
auth_login(request, user)
```
###登录函数

登录函数与注册函数的模式是一样的，都是先写form，写模板，最后写视图函数。
由于form和模板的代码和注册功能类似，这里就不贴了，大家可以上github查看。

重点讲一下login视图函数
```python

def login(request):
    if request.method == 'POST':
        next_url = request.POST.get('next', '/')
        form = UserLoginForm(request=request, data=request.POST)
        if form.is_valid():
            username = form.cleaned_data.get('username')
            password = form.cleaned_data.get('password')
            user = authenticate(username=username, password=password)
            if user is not None:
                auth_login(request, user)
                return redirect(next_url)
        else:
            print(form.errors)
    else:
        next_url = request.GET.get('next', '/')
        form = UserLoginForm()
    print(next_url)
    return render(request, 'registration/login.html', {'form': form, 'next': next_url})
```    

在login函数中，我们多了一个next_url变量，next对应的是登录后要跳转的url，

其实这是一种场景，假如你在购物网站买东西，最后付款的时候，会跳转到付款页，

假如你没有登录，网站会提示你登录，登录后，会再次跳转到付款页。

当然了，跳转到登录页的时候，需要你在url后追加next_url参数，

如 aaa. com/login/?next_url=bbb. com
这样用户登录后就会跳到bbb. com
###退出函数
```python
from django.contrib.auth import authenticate, login as auth_login, logout as auth_logout

def logout(request):
    auth_logout(request)
    return redirect('home')
```
退出功能，仅需要一行代码 auth_logout(request) 就ok了。

##其他
###静态文件的配置
需要的静态文件都存放到static这个文件夹下统一管理
包含三个方面css img  js 

在settings中添加如下
```python
STATIC_URL = '/static/'
STATICFILES_DIRS = (
    os.path.join(BASE_DIR, "static"),
)
```
使用的semantic-ui插件
Semantic UI

这是一个语义化的UI框架，界面做的比较好，风格和bootstrap有点像，比较适用于响应式开发。

这个插件里面有一些访问谷歌的内容，直接引用的话，国内网络可能有的内容访问不了，或者加载比较慢
https://cdn.bootcdn.net/ajax/libs/semantic-ui/2.4.1/semantic.min.css

所以最好还是从github上把这个插件下载下来，点击这里进入github https://github.com/Semantic-Org/Semantic-UI
直接把整个项目作为zip下载下来。

在dist文件夹中将semantic.min.js和semantic.min.css复制到文件夹中，这里文件夹的结构和上面的Element-UI差不多，新建一个semantic-ui文件夹放置。

```html
        <!-- 引入semantic-ui文件        -->
        <link rel="stylesheet" href="{% static 'semantic-ui/semantic.min.css' %}">
        <script src="{% static 'semantic-ui/semantic.min.js' %}"></script>
        <link rel="stylesheet" type="text/css" href="{% static 'css/semantic.custom.css' %}">
        <link rel="stylesheet" type="text/css" href="{% static 'css/style.css' %}">
```

###template文件的配置
所有视图文件即views文件统一放入templates文件夹下
将其添加到设置中
```python
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'templates')],  # 配置视图文件
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]
```