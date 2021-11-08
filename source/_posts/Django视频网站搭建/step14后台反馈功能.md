---
title: Django视频网站搭建--step14后台反馈功能
categories: Django视频网站搭建
tags:
  - django
abbrlink: 1586862056
date: 2020-08-28 16:41:31
---
#后天反馈功能
用户反馈管理功能，是对前端用户反馈的问题进行展示，并可实现删除功能。

它可以实时的跟踪到用户对网站的各种意见和吐槽，开发者能及时修缮网站功能或者修改网站bug。

##路由设置
反馈管理包括反馈列表和反馈删除，它们的路由是
```python
path('feedback_list/', views.FeedbackListView.as_view(), name='feedback_list'),
path('feedback_delete/', views.feedback_delete, name='feedback_delete'),
```
分别表示反馈列表和反馈删除功能。
修改myadmin/base.html
```html
                <a class="item" href="{% url 'myadmin:feedback_list' %}" id="feedback_list">用户反馈</a>
```
##视图设置
列表是由FeedbackListView负责来展示，代码如下
```python
class FeedbackListView(AdminUserRequiredMixin, generic.ListView):
    model = Feedback            # 复用之前userprofile中定义的模型
    template_name = 'myadmin/feedback_list.html'
    context_object_name = 'feedback_list'
    paginate_by = 10            # 每页10条
    q = ''

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super(FeedbackListView, self).get_context_data(**kwargs)
        paginator = context.get('paginator')
        page = context.get('page_obj')
        page_list = get_page_list(paginator, page)
        context['page_list'] = page_list
        context['q'] = self.q
        return context

    def get_queryset(self):
        self.q = self.request.GET.get("q", "")
        return Feedback.objects.filter(content__contains=self.q).order_by('-timestamp') # 根据内容查询按时间排序
```
同样是继承自ListView通用视图，同样是配置了model、template、分页。

在get_context_data()函数中，传递了分页数据；在get_queryset()中，传递了搜索数据。

当你删除一条的时候，会触发相应的ajax代码，ajax位于static/js/myadmin/feedback_list.js，

ajax最终的幕后黑手是feedback_delete接口，它位于myadmin/views.py，
```python
@ajax_required
@require_http_methods(["POST"])
def feedback_delete(request): 
    feedback_id = request.POST['feedback_id']
    instance = Feedback.objects.get(id=feedback_id)
    instance.delete()
    return JsonResponse({"code": 0, "msg": "success"})

```
获取到 feedback 实例后，通过instance.delete()删除

## 其他
反馈建议展示页面有个小bug，字数过长的时候，显示有点问题，会看不到后面的删除按钮