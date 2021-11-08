---
title: Django视频网站搭建--step16后台邮件管理
categories: Django视频网站搭建
tags:
  - django
abbrlink: 482180152
date: 2020-08-28 18:56:46
---
#邮件管理功能

订阅功能已经实现了：当用户订阅开启订阅功能后，网站会通过后台给用户发送网站最新的一些动向。
但是有时候需要关闭推送功能，比如网站邮件做一些调整之类的。

因此需要灵活的设置发送邮件功能。

本节来实现这个功能
###路由设置

我们先来写订阅推送的路由，
```python
    # -----------------------设置----------------------------
    path('setting/<int:pk>/', views.SettingView.as_view(), name='setting'),
```
同时修改myadmin/base.html文件
```html
                <div class="ui divider"></div>
                <a class="item" href="{% url 'myadmin:setting' 1 %}" id="setting">设置</a>
```

将路由设置为 SettingView
## 视图设置
 SettingView 的代码
```python
# 需admin手动添加1条记录
class SettingView(SuperUserRequiredMixin, generic.UpdateView):
    model = Setting
    form_class = SettingForm
    template_name = 'myadmin/setting.html'

    def get_success_url(self):
        messages.success(self.request, "保存成功")
        return reverse('myadmin:setting', kwargs={'pk': self.kwargs['pk']})
```

这是一个更新视图类，功能和前面的user、video的 update方法类似

使用model和form_class 向前端传递更新数据
##模型表单的创建
这里模板Setting和表单SettingForm需要重新创建
```python
# myadmin/models.py
class Setting(models.Model):
    switch_mail = models.BooleanField(default=False)

    class Meta:
        db_table = "v_setting"
```
创建一个模型只有一个布尔型字段，决定是否开启邮件服务

```python
class SettingForm(forms.ModelForm):

    class Meta:
        model = Setting
        fields = ['switch_mail']

```
表单内容也很简单

## 注册添加数据
表单创建完毕需要进行数据迁移
```
python3 manage.py makemigrations
python3 manage.py migrate
```
但是现在表单中没有数据，所以两种方法，
   - 一个直接进行数据库操作，在这个表中插入一条数据
   - 将模型Settings添加注册到admin后台，通过自带的后台手动添加
如果添加到admin后台，不要忘了修改admin文件
```python
# myadmin/admin.py
from django.contrib import admin
from myadmin.models import Setting


admin.site.register(Setting)
```
##前端文件
现在添加前端文件，就能看到这个功能了,这是一个单选框，保存成功页面简单的提示一下
```html
{% extends 'myadmin/base.html' %}
{% load static %}
{% load thumbnail %}

{% block content %}

<div class="ui grid">
    <div class="row">
        <h3>网站设置</h3>
    </div>
    <div class="ui divider"></div>
    <div class="row">
        <div class="v-form-wrap">

            <form class="ui form" novalidate method="post" action="{% url 'myadmin:setting' 1 %}"
                  enctype="multipart/form-data" role="form">
                {% csrf_token %}
                <div class="field">
                    <div class="ui checkbox">
                      {{form.switch_mail}}
                      <label>开启邮件服务</label>
                    </div>
                </div>

                <button class="ui primary button" type="submit">保存</button>

                {% include "base/form_errors.html" %}
                {% include "base/form_messages.html" %}

            </form>


        </div>
    </div>
</div>

{% endblock content %}

```
##修改发送邮件逻辑
前端基本功能实现了，下面实现本节的核心功能

前端点击已经能实现数据的更新了，现在需要讲这个数据利用起来
```python
# 订阅推送功能
class SubscribeView(SuperUserRequiredMixin, generic.View):
    ......
    def post(self, request):
        if not request.user.is_superuser:
        .....
        # 分组,两个一组，分别发送邮件
        email_list = [email_list[i:i + 2] for i in range(0, len(email_list), 2)]
        switch_mail_flag = Setting.objects.get(id=1).switch_mail   # 获取是否发送邮件标志位
        if email_list:
            for to_list in email_list:
                try:
                    if switch_mail_flag:
                        print("send email to %s" % to_list)
                        send_html_email(subject, html_message, to_list)
                    else:
                        return JsonResponse({"code": 1, "msg": "邮件服务未开启"})  # 通知前端服务未开启
                except smtplib.SMTPException as e:
                ......

```
在发送邮件前，获取switch_mail这个值，根据它的值决定是否发送邮件

如果服务未开启，通知前端