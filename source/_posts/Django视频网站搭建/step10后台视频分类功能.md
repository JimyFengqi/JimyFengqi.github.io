---
title: Django视频网站搭建--step10后台视频分类功能
categories: Django视频网站搭建
tags:
  - django
abbrlink: 3593128665
date: 2020-08-27 16:33:40
---
#视频分类
视频分类的功能，主要包括以下内容
   * 分类列表
   * 添加分类
   * 修改分类
   * 删除分类

分类管理功能包括分类的增删改查。
###路由设置
增删改查的路由是
```python
path('classification_add/', views.ClassificationAddView.as_view(), name='classification_add'),
path('classification_list/', views.ClassificationListView.as_view(), name='classification_list'),
path('classification_edit/<int:pk>/', views.ClassificationEditView.as_view(), name='classification_edit'),
path('classification_delete/', views.classification_delete, name='classification_delete'),
```
###添加分类
先来看分类添加的功能

分类添加是通过ClassificationAddView视图类来实现的，代码如下
```python
class ClassificationAddView(SuperUserRequiredMixin, generic.View):
    def get(self, request):
        form = ClassificationAddForm()
        return render(self.request, 'myadmin/classification_add.html', {'form': form})

    def post(self, request):
        form = ClassificationAddForm(data=request.POST)
        if form.is_valid():
            form.save(commit=True)
            return render(self.request, 'myadmin/classification_add_success.html')
        return render(self.request, 'myadmin/classification_add.html', {'form': form})
```
此处是通过get和post一同来实现的，get()负责展示界面，post()负责逻辑判断。

在post()中，直接调用form.save来保存记录，然后跳转到成功页myadmin/classification_add_success.html。
###查看分类列表
然后点击视频列表，即可查看列表，视频列表的视图类是ClassificationListView，即
```python
class ClassificationListView(AdminUserRequiredMixin, generic.ListView):
    model = Classification
    template_name = 'myadmin/classification_list.html'
    context_object_name = 'classification_list'
    paginate_by = 10
    q = ''

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super(ClassificationListView, self).get_context_data(**kwargs)
        paginator = context.get('paginator')
        page = context.get('page_obj')
        page_list = get_page_list(paginator, page)
        context['page_list'] = page_list
        context['q'] = self.q
        return context

    def get_queryset(self):
        self.q = self.request.GET.get("q", "")
        return Classification.objects.filter(title__contains=self.q)
```
继承ListView来显示列表，通过get_queryset()来实现搜索功能，通过get_context_data()来实现分页功能，通过template_name来指定模板

接着来实现编辑和删除功能。

编辑对应的视图类是ClassificationEditView，它的实现超级简单，继承UpdateView即可。
```python
class ClassificationEditView(SuperUserRequiredMixin, generic.UpdateView):
    model = Classification
    form_class = ClassificationEditForm
    template_name = 'myadmin/classification_edit.html'

    def get_success_url(self):
        messages.success(self.request, "保存成功")
        return reverse('myadmin:classification_edit', kwargs={'pk': self.kwargs['pk']})
```
 
编辑页面和添加页面很相似
###删除功能
最后是删除功能，是通过ajax来实现的，ajax代码位于static/js/myadmin/classification_list.js，
在ajax中，通过调用删除接口classification_delete来实现删除功能，

接口classification_delete的代码：
```python
@ajax_required
@require_http_methods(["POST"])
def classification_delete(request):
    classification_id = request.POST['classification_id']
    instance = Classification.objects.get(id=classification_id)
    instance.delete()
    return JsonResponse({"code": 0, "msg": "success"})
```

