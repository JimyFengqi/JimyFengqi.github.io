---
title: Django视频网站搭建--step11后台评论功能
categories: Django视频网站搭建
tags:
  - django
abbrlink: 2136671276
date: 2020-08-27 18:12:01
---
#后台评论功能
本讲中来讲评论管理功能，数据库中的每一条是来自用户的评价，

因此后台中的评论管理只有评论列表和评论删除功能，没有增加评论和编辑评论。
##路由设置
照例我们先添加评论管理的相关路由
```python
# myadmin/urls.py
    # ----------------------评论管理----------------------------
    path('comment_list/', views.CommentListView.as_view(), name='comment_list'),
    path('comment_delete/', views.comment_delete, name='comment_delete'),
```
只添加列表和删除功能
##视图设置
首先是评论列表的展示，我们通过CommentListView视图类来实现，该类依然是继承ListView来实现的。代码如下
```python
class CommentListView(AdminUserRequiredMixin, generic.ListView):
    model = Comment
    template_name = 'myadmin/comment_list.html'
    context_object_name = 'comment_list'
    paginate_by = 10
    q = ''

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super(CommentListView, self).get_context_data(**kwargs)
        paginator = context.get('paginator')
        page = context.get('page_obj')
        page_list = get_page_list(paginator, page)
        context['page_list'] = page_list
        context['q'] = self.q
        return context

    def get_queryset(self):
        self.q = self.request.GET.get("q", "")
        return Comment.objects.filter(content__contains=self.q).order_by('-timestamp')
```
通过继承ListView来实现评论列表的展示，通过get_context_data()来实现分页功能，通过get_queryset()来实现搜索功能。

下面我们继续实现删除功能，该功能比较简单，只需要通过ajax将video_id传给删除接口即可，

ajax的代码位于static/js/myadmin/comment_list.js，
```javascript
// 写入csrf
$.getScript("/static/js/csrftoken.js");

$('.comment-delete').click(function(){
      var tr = $(this).closest("tr");
      var comment_id = $(tr).attr("comment-id");
        $('.ui.tiny.modal.delete')
        .modal({
          closable  : true,
          onDeny    : function(){
            return true;
          },
          onApprove : function() {

            $.ajax({
                url: api_comment_delete,
                data: {
                    'comment_id':comment_id,
                    'csrf_token': csrftoken
                },
                type: 'POST',
                dataType: 'json',
                success: function (data) {
                    console.log(data);
                     var code = data.code
                     var msg = data.msg
                     if(code == 0){
                        window.location.reload();
                     }else{
                        alert(msg);
                     }
                },
                error: function(data){
                  alert("error"+data)
                }
            });

          }
        })
        .modal('show');
});

```
删除评论的接口是api_comment_delete，最终会调用到comment_delete，代码如下
```python
@ajax_required
@require_http_methods(["POST"])
def comment_delete(request): 
    comment_id = request.POST['comment_id']
    instance = Comment.objects.get(id=comment_id)
    instance.delete()
    return JsonResponse({"code": 0, "msg": "success"})
```
逻辑还算清晰，即先拿到评论的id，然后获取到该条评论，最后instance.delete()删除

##前端设置
先看一下需要修改的文件
```
	修改：     templates/myadmin/base.html
	新文件：   templates/myadmin/comment_list.html
	新文件：   templates/myadmin/comment_list_modal.html
```
其中base.html文件需要将评论地址添加进去,实现跳转
```html
                <a class="item" href="{% url 'myadmin:comment_list' %}" id="comment_list">评论列表</a>
```
comment_list.html文件为新添加的文件，大体布局跟video_list.html类似
```html
{% extends 'myadmin/base.html' %}
{% load static %}
{% load video_tag %}
{% block content %}

<div class="ui grid">
    <div class="row">
        <h3 class="ui header six wide column">评论列表</h3>
        <div class="v-title-extra ten wide column">
            <div class="ui action input v-admin-search">
                <input type="text" placeholder="Search..."  value="{{q}}" id="v-search">
                <button class="ui small button" id="search">搜索</button>
            </div>
        </div>
    </div>
    <div class="ui divider"></div>
    <div class="row">
        <table class="ui unstackable single line striped selectable table"  >
            <thead>
            <tr><th>#id</th><th>用户</th><th>昵称</th><th>视频名字</th><th>评论内容</th></th><th>评论时间</th><th>操作</th></tr>
            </thead>
            <tbody class="video-list">

            {% for item in comment_list %}
            <tr comment-id="{{item.id}}">
                <td> {{item.user_id}}</td>
                <td> {{item.user.username}}</td>
                <td> {{item.nickname}}</td>
                <td> {{item.video.title}}</td>
                <td> {{ item.content | comment_slice }} </td>
                <td> {{item.timestamp|date:'Y-m-d H:i'}}</td>
                <td>
                    <a class="ui button comment-delete">删除</a>
                </td>
            </tr>
            {% empty %}
            <h3>暂时没有评论</h3>
            {% endfor %}

            </tbody>
            <tfoot>
            <tr>
                <th colspan="6">
                    {% include 'myadmin/page_nav.html' %}
                </th>
            </tr>
            </tfoot>
        </table>
    </div>
</div>


{% endblock content %}

{% block modal %}
{% include "myadmin/comment_list_modal.html" %}
{% endblock modal %}

{% block script %}
<script>
    var search_url = "{% url 'myadmin:comment_list' %}"
    var api_comment_delete = "{% url 'myadmin:comment_delete' %}"
</script>
<script src="{% static 'js/myadmin/comment_list.js' %}"></script>
{% endblock script %}
```
小功能，它调用了自定义标签 video_tag，使用这个里面的函数时需要的时候需要提前注册
在设置中添加libraries
```python
# videoproject/settings.py
TEMPLATES = [
    {
         ...
        'OPTIONS': {
            'context_processors': [
                ...
            ],
            'libraries': {
                'my_customs_tag': 'video.templatetags.video_tag'
            },
```
自定义的标签文件，先注册，然后添加自己想用的函数.

这里仅仅是添加一个函数，处理评论在页面显示过长的问题, 超过50个字直接截断
```python
from django import template
register = template.Library()


# 分词
@register.filter
def comment_slice(comment):
    return comment[:50]+'...'

```
