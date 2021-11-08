---
title: Django视频网站搭建--step4前端页面整合
categories: Django视频网站搭建
tags:
  - django
abbrlink: 1020996230
date: 2020-08-22 00:41:00
---
#前端页面整合
在本讲中，我们开始前端页面整合

在开发过程中，前端页面也很重要，本次内容简单的对前面三节内容的前端页面做一个简单的整合

尘归尘，土归土，内容整理之后会讲内容看的更加清晰

# 基础页面

基础页面包括，header base footer三个部分

## base页面

所有的页面都起始于这个页面
```html
{% load static %}
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="description" content="基于Django的视综合网站">
   <!-- 当前页面网站标题 -->
    <title>{% block title %}{% endblock %}</title>

    <!-- 引入semantic-ui文件        -->
    <link rel="stylesheet" href="{% static 'semantic-ui/semantic.min.css' %}">
    <link rel="stylesheet" type="text/css" href="{% static 'css/semantic.custom.css' %}">
    <link rel="stylesheet" type="text/css" href="{% static 'css/style.css' %}">
    {% block css %}{% endblock css %}
</head>
<body>

{% include "base/header.html" %}
<div class="ui container" id="v-content">
    {% block content %}
    {% endblock content %}
</div>

<<!-- 引入注脚 -->
{% include "base/footer.html" %}

<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="{% static 'semantic-ui/semantic.min.js' %}"></script>
{% block script %} {% endblock script %}
{% block modal %} {% endblock modal %}

</body>
</html>
```
这个页面可以分为几个部分
head 内容， 引入基础的设置，然后时页面标题， 必要的前端布局文件 其他的css文件
body 部分， 先是导入header 文件， 留下cotent内容，其他页面导入的部分，都放在这个地方

footer内容  必要的footer内容， 然后引入JavaScript内容，其他的script内容和modal内容



## header页面

header 页面放入 导航栏内容， 以及菜单栏内容
这里做个示范，后面会进行修改

```html
{% load static %}


 <div class="ui inverted menu">
        <div class="header item">Brand</div>
        <div class="active item">Home</div>
        <a class="item">Vitae</a>
        <div class="ui dropdown item" tabindex="0">
            Dropdown<i class="dropdown icon"></i>
            <div class="menu" tabindex="-1">
                <div class="item">Action</div>
                <div class="item">Another Action</div>
                <div class="item">Something else here</div>
                <div class="divider"></div>
                <div class="item">Separated Link</div>
                <div class="divider"></div>
                <div class="item">One more separated link</div>
            </div>
        </div>
        <div class="right menu">
            <a class="item">Login</a>
        </div>

     <div class="v-header-extra">
        {% include "base/menu.html" %}
     </div>
 </div>

```
## footer页面

footer页面一般放一些备案信息，网站名字，logo,相关链接等
```html
{% load static %}

<div class="ui vertical footer segment ">
    <div class="ui center aligned container">
        <div class="ui divider"></div>
<!--        <img src="{% static 'img/logo.png' %}" class="ui centered mini image">-->
        <div class="ui horizontal   small divided link list">
            <a class="item" href="#">自主开发博客综合网站公司</a>
            <a class="item" href="#">联系我们</a>
            <a class="item" href="#">京ICP证090287</a>

        </div>
    </div>
</div>
```


#分类页面

##用户界面

它在registration文件夹下
登录页面， 继承base文件夹的base内容，然后添加自己的内容
```html
{% extends "base/base.html" %}
{% load static %}
{% block title %} 登录 {% endblock title %}
{% block content %}

<body id="v-account-body">
<div class="ui middle aligned center aligned grid">
    <div class="column v-account">
        <h2 class="ui teal image header">
                登录账户
        </h2>
        <form class="ui large form" novalidate method="post" action="{% url 'userprofile:login' %}"
              enctype="multipart/form-data">
            {% csrf_token %}
            <div class="ui stacked segment">
                <div class="field">
                    <div class="ui left icon input">
                        <i class="user icon"></i>
                        {{form.username}}
                    </div>
                </div>
                <div class="field">
                    <div class="ui left icon input">
                        <i class="lock icon"></i>
                        {{form.password}}
                    </div>
                </div>
                <input type="hidden" name="next" value="{{ next }}"/>
                <button class="ui fluid large teal submit button" type="submit">登录</button>
            </div>

            {% include "base/form_errors.html" %}

        </form>

        <div class="ui message">
                还没有账号？<a href="{% url 'userprofile:signup' %}">注册</a>
        </div>
    </div>
</div>
</body>

{% endblock content %}
```

## 视频界面







