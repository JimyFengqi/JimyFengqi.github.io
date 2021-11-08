---
title: Django视频网站搭建--step12后台用户管理功能
categories: Django视频网站搭建
tags:
  - django
abbrlink: 1717413175
date: 2020-08-27 18:46:01
---
#后台用户管理功能
用户管理功能,跟其他功能也类似，增删改查


##路由设置
先在urls.py下添加相关的路由
```python
path('user_add/', views.UserAddView.as_view(), name='user_add'),
path('user_list/', views.UserListView.as_view(), name='user_list'),
path('user_edit/<int:pk>',views.UserEditView.as_view(), name='user_edit'),
path('user_delete/', views.user_delete, name='user_delete'),
```
#用户添加
添加用户前需要创建一个表单来存贮用户相关的数据
```python
class UserAddForm(forms.ModelForm):
    username = forms.CharField(min_length=4,
                               max_length=30,
                               error_messages={
                                   'min_length': '用户名不少于4个字符',
                                   'max_length': '用户名不能多于30个字符',
                                   'required': '用户名不能为空',
                               },
                               widget=forms.TextInput(attrs={'placeholder': '请输入用户名'}))
    password = forms.CharField(min_length=4,
                               max_length=30,
                               error_messages={
                                   'min_length': '密码不少于4个字符',
                                   'max_length': '密码不能多于30个字符',
                                   'required': '密码不能为空',
                               },
                               widget=forms.PasswordInput(attrs={'placeholder': '请输入密码'}))

    class Meta:
        model = User
        fields = ['username', 'password', 'is_staff']
```
主要是用户名和密码，is_staff元素
用户添加的视图类是UserAddView
```python
class UserAddView(SuperUserRequiredMixin, generic.View):
    def get(self, request):
        form = UserAddForm()
        return render(self.request, 'myadmin/user_add.html', {'form': form})

    def post(self, request):
        form = UserAddForm(data=request.POST)
        if form.is_valid():
            user = form.save(commit=False)
            password = form.cleaned_data.get('password')
            user.set_password(password)
            user.save()
            return render(self.request, 'myadmin/user_add_success.html')
        return render(self.request, 'myadmin/user_add.html', {'form': form})
```
  
这是一个普通的视图类，通过get()和post()来完成用户添加的功能，get里面负责页面的展示，post里面负责逻辑处理。

在get中，初始化form为UserAddForm，因为添加的用户是有类别的，所以在UserAddForm中应用了is_staff字段来表示管理员。

在post中，我们通过user.set_password(password)来设置新密码。user.save()来保存记录到数据库。

保存成功后会跳转到myadmin/user_add_success.html页面。

##用户列表

用户添加成功后，当你点击用户列表，即可看到用户列表数据。

使用的是UserListView视图类，该类是继承自ListView通用视图类的。因此 只需要我们添加实现列表功能。UserListView代码如下
```python
class UserListView(AdminUserRequiredMixin, generic.ListView):
    model = User
    template_name = 'myadmin/user_list.html'
    context_object_name = 'user_list'
    paginate_by = 10
    q = ''

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super(UserListView, self).get_context_data(**kwargs)
        paginator = context.get('paginator')
        page = context.get('page_obj')
        page_list = get_page_list(paginator, page)
        context['page_list'] = page_list
        context['q'] = self.q
        return context

    def get_queryset(self):
        self.q = self.request.GET.get("q", "")
        return User.objects.filter(username__contains=self.q).order_by('-date_joined')
```
跟之前一样，通过ListView展现数据。

我们知道ListView是有多个回调函数的，这里就是通过get_context_data()和get_queryset()回调函数来实现列表中的功能的。

在get_context_data()中实现了列表分页功能，在get_queryset()中实现了搜索功能。

##用户编辑
当你点击编辑按钮的时候，即可进入编辑页面。
编辑页面也需要创建一个表单来存贮它的数据
```python
def username_validate(value):
    if value == "admin":
        raise ValidationError('不能编辑超级管理员')


class UserEditForm(forms.ModelForm):
    username = forms.CharField(min_length=4,
                               max_length=30,
                               required=True,
                               validators=[username_validate],
                               error_messages={
                                  'min_length': '至少4个字符',
                                  'max_length': '不能多于30个字符',
                                  'required': '用户名不能为空'
                               },
                               widget=forms.TextInput(attrs={'placeholder': '请输入用户名'}))

    class Meta:
        model = User
        fields = ['username', 'is_staff']

```
对应的视图设置如下：
```python
class UserEditView(SuperUserRequiredMixin, generic.UpdateView):
    model = User
    form_class = UserEditForm
    template_name = 'myadmin/user_edit.html'

    def get_success_url(self):
        messages.success(self.request, "保存成功")
        return reverse('myadmin:user_edit', kwargs={'pk': self.kwargs['pk']})
```

同样是继承自UpdateView，仅需要配置好model、form_class、template_name即可

##用户删除

当你点击删除按钮的时候，会弹出确认框让你删除。然后网站通过ajax调用user_delete来实现真正的删除操作，其中，ajax代码位于static/js/myadmin/user_list.js

真正的删除函数是user_delete，下面是它的真面目
```python
@ajax_required
@require_http_methods(["POST"])
def user_delete(request): 
    user_id = request.POST['user_id']
    instance = User.objects.get(id=user_id) 
    instance.delete()
    return JsonResponse({"code": 0, "msg": "success"})

```
首先获取到当前用户的实例，然后通过 instance.delete()删除.

##前端页面
照例需要修改base.html文件
```html
                <a class="item" href="{% url 'myadmin:user_list' %}" id="user_list">用户列表</a>
                <a class="item" href="{% url 'myadmin:user_add' %}" id="user_add">添加用户</a>
```
其他需要添加的文件如下
```
	新文件：   static/js/myadmin/user_list.js
	修改：     templates/myadmin/base.html
	新文件：   templates/myadmin/user_add.html
	新文件：   templates/myadmin/user_add_success.html
	新文件：   templates/myadmin/user_edit.html
	新文件：   templates/myadmin/user_list.html
	新文件：   templates/myadmin/user_list_modal.html


```