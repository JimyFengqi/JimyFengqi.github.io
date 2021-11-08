---
title: Django视频网站搭建--step06个人中心功能
categories: Django视频网站搭建
tags:
  - django
abbrlink: 1427529209
date: 2020-11-17 18:04:22
---
#个人中心功能
从本讲起，我们开始个人中心功能的开发。个人中心里面包括以下几个部分
- 个人资料
- 修改密码
- 订阅设置
- 意见反馈

通过这部分的开发，我们将会接触到更多django的用法。

##整体功能

个人中心模块是对用户的信息进行展示并可以编辑。

其中个人资料、修改密码、订阅设置是对用户信息的编辑，反馈建议是属于创建新数据。
##个人资料

这里主要是对个人资料进行编辑，先显示用户原有的信息，

然后用户即可对其进行修改并保存，对于编辑功能，django有自己的解决方案，

即通过通用视图类UpdateView对模型进行更改。关于Update的介绍，同学们可查阅官网介绍

因为前面已经建立过user模型，所以这里就不用再次建立了，我们直接使用之前的user模型即可。
###建立form
首先需要新建一张form来存放个人信息，它和userprofile中的User model差不多，但这里时一个form
```python
#userprofile/forms.py
from django import forms
from .models import User


# 头像大小，这里只是限制图片大小，后面可以直接修改其大小
def avatar_file_size(value):
    limit = 2 * 1024 * 1024
    if value.size > limit:
        raise ValidationError('头像文件太大了，请限制在2M之内')


class ProfileForm(forms.ModelForm):
    nickname = forms.CharField(min_length=1,
                               max_length=20,
                               required=False,
                               error_messages={
                                   'min_length': '昵称至少4个字符',
                                   'min_length': '昵称不能多于20个字符', },
                               widget=forms.TextInput())
    avatar = forms.ImageField(required=False, validators=[avatar_file_size],
                              widget=forms.FileInput(attrs={'class': 'n'}))
    email = forms.EmailField(required=False,
                             error_messages={
                                 'invalid': '请输入有效的Email地址',
                             },
                             widget=forms.EmailInput())
    gender = forms.CharField(min_length=1,max_length=1,required=False,
                             widget=forms.HiddenInput())

    mobile = forms.CharField(min_length=11,max_length=11,required=False,
                             error_messages={
                                 'min_length': '请输入11位手机号',
                                 'max_length': '请输入11位手机号',
                             },
                             widget=forms.NumberInput())

    class Meta:
        model = User
        fields = ['nickname', 'avatar', 'email', 'gender', 'mobile']
```
这里对头像图片做了一个限制,主要时限制其尺寸，目前先这样限制，后面有时间会把这里修改一下，直接把上传的图片进行缩放或者放大，弄成统一尺寸

其他各个字段也有对应的限制规则

##更新路由表

其次我们做的就是在users/urls.py中添加个人资料的路由，
```python
# users/urls.py
path('profile/<int:pk>/', views.ProfileView.as_view(), name='profile'),
```

可以看到，这里我们需要传一个int参数做为主键，并传递给视图类ProfileView。
###更新视图
下面我们转向ProfileView，它的写法超级简单
```python
from django.contrib.auth.mixins import LoginRequiredMixin
from utils.video_helpers import AuthorRequiredMixin
from django.views import generic
from django.shortcuts import *
from django.contrib import messages

class ProfileView(LoginRequiredMixin,AuthorRequiredMixin, generic.UpdateView):
    model = User
    form_class = ProfileForm
    template_name = 'users/profile.html'

    def get_success_url(self):
        messages.success(self.request, "保存成功")
        return reverse('userprofile:profile', kwargs={'pk': self.request.user.pk})
```
这里继承了UpdateView来实现更新操作，和DetailView类似，我们这里也设置了model和template_name 还有form_class。

当更新成功后，django会回调get_success_url来将结果告诉模板，因此我们可以在get_success_url里面做一些定制的工作，我们可以传一些自己的参数。

简单的几行代码，就实现了个人资料的更新，再次彰显了django框架的强大。

可以看到我们还继承了LoginRequiredMixin和AuthorRequiredMixin两个类，这两个类属于公共类，

其中LoginRequiredMixin的用途是：只允许登录的用户访问该视图类，

AuthorRequiredMixin的用途是：只允许用户自己查看自己的个人资料，别人是无法查看的。

其中AuthorRequiredMixin的代码位于videoproject/utils/helpers.py。

```python
from django.core.exceptions import PermissionDenied

# 只允许用户自己查看自己的个人资料，别人是无法查看的
class AuthorRequiredMixin(View):
    def dispatch(self, request, *args, **kwargs):
        obj = self.get_object()
        if obj != self.request.user:
            raise PermissionDenied

        return super().dispatch(request, *args, **kwargs)
    
```
前端代码最后统一再讲

##修改密码

同样的，修改密码也是属于更新操作。

模型当然是用user模型，不必再建。
###更新路由
我们先添加路由
```python
path('change_password/', views.change_password, name='change_password'),
```
###添加form
新增一个改密码的表单
```python
# userprofile/forms.py
from django.contrib.auth.forms import PasswordChangeForm

# 改密码
class ChangePwdForm(PasswordChangeForm):
    old_password = forms.CharField(error_messages={'required': '不能为空', },
                                   widget=forms.PasswordInput(attrs={'placeholder': '请输入旧密码'}))
    new_password1 = forms.CharField(error_messages={'required': '不能为空', },
                                    widget=forms.PasswordInput(attrs={'placeholder': '请输入新密码'}))
    new_password2 = forms.CharField(error_messages={'required': '不能为空', },
                                    widget=forms.PasswordInput(attrs={'placeholder': '请输入确认密码'}))
```
###添加视图函数
修改密码比较特殊，需要对密码进行特殊处理，因此我们通过视图函数change_password来手写代码
```python
# userprofile/views.py
from django.contrib.auth import update_session_auth_hash
from .forms import ChangePwdForm
from django.shortcuts import *
from django.contrib import messages

# 修改密码
def change_password(request):
    if request.method == 'POST':
        form = ChangePwdForm(request.user, request.POST)
        if form.is_valid():
            user = form.save(commit=False)
            if not user.is_staff and not user.is_superuser:
                user.save()
                update_session_auth_hash(request, user)  # 更新session 非常重要！
                messages.success(request, '修改成功')
                return redirect('userprofile:change_password')
            else:
                messages.warning(request, '无权修改管理员密码')
                return redirect('userprofile:change_password')
        else:
            print(form.errors)
    else:
        form = ChangePwdForm(request.user)
    return render(request,
                  'registration/change_password.html',
                  {'form': form})
```
当拿到form之后，通过验证form合法性，然后调用user.save()来保存修改。
然后通过update_session_auth_hash来更新session, 密码更改之后一定要更新会话。

这样就实现了修改密码功能。

##订阅设置

很多网站都有订阅设置功能，当用户订阅了网站内容之后，网站有了新内容，向订阅用户推送相关内容。
###添加表单
订阅功能也需要添加表单
```python
# userprofile/forms.py
class SubscribeForm(forms.ModelForm):
    class Meta:
        model = User
        fields = ['subscribe']
```
###路由设置
我们先在users/urls.py下添加订阅功能的路由
```python
path('subscribe/<int:pk>/', views.SubscribeView.as_view(), name='subscribe'),
```
我们设置的订阅视图类为SubscribeView，因为订阅的功能和修改个人资料功能类似，也是属于更新操作，所以同样是使用UpdateView来更新。
###添加视图
```python
# userprofile/views.py
class SubscribeView(LoginRequiredMixin,AuthorRequiredMixin, generic.UpdateView):
    model = User
    form_class = SubscribeForm
    template_name = 'users/subscribe.html'

    def get_success_url(self):
        messages.success(self.request, "保存成功")
        return reverse('userprofile:subscribe', kwargs={'pk': self.request.user.pk})
```
订阅功能实现和Profile的实现有点类似
##反馈与建议
###添加model
这里我们需要在users/models.py下新建一个反馈表，命名为Feedback，
```python
class Feedback(models.Model):
    contact = models.CharField(blank=True, null=True, max_length=20)
    content = models.CharField(blank=True, null=True, max_length=200)
    timestamp = models.DateTimeField(auto_now_add=True, null=True)

    class Meta:
        db_table = "v_feedback"
```
该表一共有3个字段，分别是

    contact 联系方式
    content 内容
    timestamp 时间

###添加表单
写完model之后，还需要添加表单类
```python
# userprofile/forms.py
class FeedbackForm(forms.ModelForm):
    content = forms.CharField(min_length=4,
                              max_length=200,
                              error_messages={
                                   'min_length': '至少4个字符',
                                   'max_length': '不能多于200个字符',
                                   'required': '内容不能为空'},
                              widget=forms.Textarea(attrs={'placeholder': '请输入内容'}))
    contact = forms.CharField(required=False,
                              widget=forms.TextInput(attrs={'placeholder': '请输入联系方式'}))

    class Meta:
        model = Feedback
        fields = ['content', 'contact']
```
写完model之后，我们就能写业务代码了。
###设置路由
先添加路由
```python
path('feedback/', views.FeedbackView.as_view(), name='feedback'),
```

我们设置路由指向FeedbackView视图类。
###视图业务
我们直接贴出FeedbackView的代码
```python
# userprofile/views.py
from ratelimit.decorators import ratelimit
from django.contrib.auth.mixins import LoginRequiredMixin
from django.views import generic

class FeedbackView(LoginRequiredMixin, generic.CreateView):

    model = Feedback
    form_class = FeedbackForm
    template_name = 'users/feedback.html'

    @ratelimit(key='ip', rate='2/m')
    def post(self, request, *args, **kwargs):
        was_limited = getattr(request, 'limited', False)
        if was_limited:
            messages.warning(self.request, "操作太频繁了，请1分钟后再试")
            return render(request, 'userprofile/feedback.html', {'form': FeedbackForm()})
        return super().post(request, *args, **kwargs)

    def get_success_url(self):
        messages.success(self.request, "提交成功")
        return reverse('userprofile:feedback')

```

我们看到这个地方继承的是CreateView类，该类属于新建通用视图类。只要我们配置好model、form_class、template_name，django就自动为我们创建记录。

另外，我们还使用了一种限流量的技术：ratelimit。这是一个第三方类库，通过使用他，可以防止恶意提交数据。它使用超级简单，只需要配置好key和rate即可，key代表业务，rate代表速率，这里我们设置key为ip，即限制ip地址，rate为’2/m’，表示每分钟限制请求2次。超过2次就提示用户操作频繁。

这样我们就完美的实现了用户反馈。

##前端业务
前端主要修改或添加这些内容
```
── base
│   ├── base.html
│   ├── header.html
│   ├── left_nav.html
│   ├── menu.html
│   └── page_nav.html
├── registration
|   └── change_password.html
└── ── users
    ├── feedback.html
    ├── profile.html
    └── subscribe.html

```
从base里面就有加载header,header 加载menu,而menu页面就是加载个人信息的页面
```html
{% if user.is_authenticated %}
<div class="ui inline dropdown" id="v-header-avatar" style="">
    <div class="" style="display:inline-block;font-weight:bold;">
        {% thumbnail user.avatar "200x200" crop="center" as im %}
        <img class="ui avatar image" src="{{ im.url }}">
        {% empty %}
        <img class="ui avatar image" src="{% static 'img/img_default_avatar.png' %}">
        {% endthumbnail %}
        {{ user.username }}
    </div>
    <i class="dropdown icon"></i>
    <div class="menu">
        <div class="item" onclick="window.location='{% url 'userprofile:profile' user.pk %}';">
            <i class="user icon"></i>
            <span>个人资料</span>
        </div>
        <div class="item" onclick="window.location='{% url 'userprofile:profile' user.pk %}';">
            <i class="bookmark icon"></i>
            <span>我的收藏</span>
        </div>
        <div class="item" onclick="window.location='{% url 'userprofile:profile' user.pk %}';">
            <i class="heart icon"></i>
            <span>我的喜欢</span>
        </div>
        <div class="item" onclick="window.location='{% url 'userprofile:logout' %}';">
            <i class="sign-out icon"></i>
            <span>退出</span>
        </div>
    </div>
</div>
{% else %}
<a class="ui tiny secondary basic button" id="v-header-login" href="{% url 'userprofile:login' %}?next={{ request.path }}">登录</a>
{% endif %}
```
如果用户登录的话，就能看到用户头像，点击显示下拉菜单，里面有个人资料，(我的收藏，我的喜欢, 这两个功能后面实现) 退出功能
用户没登录的话，就显示登录2字
点击个人资料能跳转到新的页面
```html
{% extends 'base/base.html' %}
{% load static %}
{% load thumbnail %}
{% block content %}


<div class="v-settings">
    <div class="ui two column grid ">
        <div class="four wide column">
            {% include "base/left_nav.html" %}
        </div>
        <div class="twelve wide column">
            <div class="v-settings-content">

                <form class="ui form" novalidate method="post" action="{% url 'userprofile:profile' form.instance.pk %}"
                      enctype="multipart/form-data" role="form">
                    {% csrf_token %}
                    <div class="sixteen wide inline field v-form-field">
                        <label>头像</label>
                        <div class="v-inline-middle">
                            <label for="id_avatar">
                                {% thumbnail user.avatar "200x200" crop="center" as im %}
                                  <img class="ui mini circular image" src="{{ im.url }}">
                                {% empty %}
                                <img class="ui mini circular  image" src="{% static 'img/img_default_avatar.png' %}">
                                {% endthumbnail %}
                            </label>
                            {{form.avatar}}
                            <span id="file_is_choose" class="n">文件已选择</span>

                        </div>
                    </div>

                    <div class="sixteen wide inline field v-form-field">
                        <label>昵称</label>
                        {{form.nickname}}
                    </div>

                    <div class="sixteen wide inline field v-form-field">
                        <label>Email</label>
                        {{form.email}}
                    </div>

                    <div class="sixteen wide inline field v-form-field">
                        <label>手机号</label>
                        {{form.mobile}}
                    </div>

                    <div class="sixteen wide inline field v-form-field">
                        <label>性别</label>
                        <div class="ui selection  dropdown">
                            {{form.gender}}
                            <i class="dropdown icon"></i>
                            <div class="default text">请选择</div>
                            <div class="menu">
                                <div class="item" data-value="M">男</div>
                                <div class="item" data-value="F">女</div>
                            </div>
                        </div>
                    </div>

                    <button class="ui primary button" type="submit">保存</button>

                    {% include "base/form_errors.html" %}
                    {% include "base/form_messages.html" %}

                </form>
            </div>
        </div>

    </div>
</div>

{% endblock content %}

{% block script %}
<script type="text/javascript">

$(function(){

    $('.ui .dropdown').dropdown();

    $("#id_avatar").change(function(){
        $("#file_is_choose").show()
    });

});

</script>
<script src="{% static 'js/left_nav.js' %}"></script>
{% endblock script %}

```
这个页面有几点注意

   - 1.继承base页面
   - 2.包含 `{% include "base/left_nav.html" %}`，即把菜单单独拿出来，点击跳转,
       通过最下面的`<script src="{% static 'js/left_nav.js' %}"></script>`加载新的页面
   - 3.性别选择这里通过调用下来菜单选择，下拉菜单的调用是通过js实现的

然后其他几个页面类似
##其他
订阅设置可能需要设置邮箱，这里就没设置，后面再完善
