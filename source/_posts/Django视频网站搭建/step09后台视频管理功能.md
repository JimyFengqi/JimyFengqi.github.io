---
title: Django视频网站搭建--step09后台视频管理功能
categories: Django视频网站搭建
tags:
  - django
abbrlink: 1800145423
date: 2020-08-27 16:33:40
---
#后台视频管理功能
从本讲开始，我们开始视频管理功能的开发，视频管理包括

   * 视频上传
   * 视频列表
   * 视频编辑
   * 视频删除


这一讲非常重要，因为将学习到一些之前没有学过的技术，比如大文件上传技术。
##视频上传

我们先来实现视频的上传，视频的上传采用的是分块上传的策略，并用了分块上传类库：django_chunked_upload，使用该类库，再配合前端上传js库（jquery.fileupload.js），即可完美的实现文件的分块上传功能。
###路由设置
照例先编写添加视频的路由

添加视频，当然需要上传视频的页面，我们的页面是video_add路由来显示，通过urls .py中指定
```
# myadmin/urls.py
path('video_add/', views.AddVideoView.as_view(), name='video_add'),    #上传视频
path('chunked_upload/',  views.MyChunkedUploadView.as_view(), name='api_chunked_upload'),  # 上传接口
path('chunked_upload_complete/', views.MyChunkedUploadCompleteView.as_view(),name='api_chunked_upload_complete'),  # 上传视频完成接口

```
###添加视图
AddViewView仅仅用来显示上传页面，它的代码很简单
```python
class AddVideoView(SuperUserRequiredMixin, TemplateView):
    template_name = 'myadmin/video_add.html'
```
只是继承了TemplateView来显示myadmin/video_add.html
###前端
```
templates/myadmin/
├── base.html                       # 基础页面
├── login.html                      # 登录页面
├── video_add.html                  # 添加视频页面
├── video_edit.html                 # 编辑视频页面
├── video_list.html                 # 列表页面
├── video_list_modal.html           
├── video_publish.html              # 发布页面，跟编辑页面类似
└── video_publish_success.html      # 发布成功页面

```
myadmin/video_add.html中实现了上传视频的全过程，视频的上传采用的是分块上传的策略，

前端使用的是js上传库（jquery.fileupload.js），后端使用的是django_chunked_upload。

上传的逻辑是这样的：
- 前端先选择一个文件，通过jquery.fileupload.js中的$.fileupload()方法来上传文件；
- 后端接收到后分批返回已上传块的进度；
- 前端根据进度来更新界面；


由于上传前需要做一些校验的操作，代码较复杂，所以我们把上传的代码封装到了一个js中:static/js/myadmin/video_upload.js，
这些内容基本都是django_chunked_upload中的demo模板内容，主要的代码如下：
```javascript
$("#chunked_upload").fileupload({
  url: api_chunked_uplad,
  dataType: "json",
  maxChunkSize: 100000, // Chunks of 100 kB
  formData: form_data,
  add: function(e, data) { // Called before starting upload
    var fileSize = data.originalFiles[0]['size'];
    var type = data.originalFiles[0]['type'];

    if(fileSize > 100000000){
        alert('文件太大了，请上传100M以内的文件');
        return;
    }

    if(!type.startsWith("video/")){
        alert('视频格式不正确');
        return;
    }

    form_data.splice(1);
    calculate_md5(data.files[0], 100000);  // Again, chunks of 100 kB
    data.submit();

    $('#progress_label').on('click', false);
    $('#progress_layout').show()

  },
  chunkdone: function (e, data) { // Called after uploading each chunk
    if (form_data.length < 2) {
      form_data.push(
        {"name": "upload_id", "value": data.result.upload_id}
      );
    }
    var progress = parseInt(data.loaded / data.total * 100.0, 10);
    console.log(progress);
    if(progress > lastprogress){
        lastprogress = progress
        $('#upload_progress').progress({
            percent: progress
        });
    }
  },
  done: function (e, data) { // Called when the file has completely uploaded
    $.ajax({
      type: "POST",
      url: api_chunked_upload_complete,
      data: {
        csrfmiddlewaretoken: csrf,
        upload_id: data.result.upload_id,
        md5: md5
      },
      dataType: "json",
      success: function(data) {
        console.log(data)
        $('#upload_label').text('上传成功');
        $('#upload_progress').progress({
            percent: 100
        });
        $('#next_layout').show();
        $('#next').click(function(){
            window.location = '/myadmin/video_publish/' + data.video_id
        });
      }
    });
  },
});

```
在$.fileupload()方法中，有一个回调方法chunkdone()，该方法是用来更新进度的，告诉前端已经上传了多少字节。

另外还有一个回调方法done()，该方法表示上传完毕，前端可在里面做一些额外的事情。

上传完毕后，调用了一个接口api_chunked_upload_complete，来给后端发送一个回执：我已上传完毕。
###上传成功视图
api_chunked_upload和api_chunked_upload_complete的路由已经配好

在MyChunkedUploadCompleteView中，我们在利用Video模型创建了这条视频
```python
# myadmin/models.py
from chunked_upload.models import ChunkedUpload

# 上传视频模块用到的， 基本没改动和demo一样
MyChunkedUpload = ChunkedUpload
```
视图中使用它
```python
# myadmin/views.py
# 上传视频
class MyChunkedUploadView(ChunkedUploadView):
    model = MyChunkedUpload
    field_name = 'the_file'


class MyChunkedUploadCompleteView(ChunkedUploadCompleteView):
    model = MyChunkedUpload

    # 上传视频回调函数    
    def on_completion(self, uploaded_file, request):
        print('uploaded--->', uploaded_file.name)
    
    # 视频上传成功回调函数
    def get_response_data(self, chunked_upload, request):
        video = Video.objects.create(file=chunked_upload.file)
        return {'code': 0, 'video_id': video.id, 'msg': 'success'}

```
  
##视频发布

然后用户点击下一步，进入video_publish页面，开始发布前的资料填写
###视频发布路由设置
```python
video_publish的路由是
    path('video_publish/<int:pk>/', views.VideoPublishView.as_view(), name='video_publish'),  # 视频发布，后面可以拓展为视频审核成功后发布
    path('video_publish_success/', views.VideoPublishSuccessView.as_view(), name='video_publish_success'),  # 视频发布成功
```
###视频发布视图 
发布列表用到VideoPublishForm，因此需要创建
```python
# myadmin/forms.py
from django import forms
from video.models import Video


class VideoPublishForm(forms.ModelForm):
    title = forms.CharField(min_length=4, max_length=200, required=True,
                            error_messages={
                                  'min_length': '至少4个字符',
                                  'max_length': '不能多于200个字符',
                                  'required': '标题不能为空'},
                            widget=forms.TextInput(attrs={'placeholder': '请输入内容'}))
    desc = forms.CharField(min_length=4, max_length=200, required=True,
                           error_messages={
                              'min_length': '至少4个字符',
                              'max_length': '不能多于200个字符',
                              'required': '描述不能为空'
                           },
                           widget=forms.Textarea(attrs={'placeholder': '请输入内容'}))
    cover = forms.ImageField(required=True,
                             error_messages={
                                 'required': '封面不能为空'
                             },
                             widget=forms.FileInput(attrs={'class': 'n'}))
    status = forms.CharField(min_length=1, max_length=1, required=False,
                             widget=forms.HiddenInput(attrs={'value': '0'}))

    class Meta:
        model = Video
        fields = ['title', 'desc', 'status', 'cover', 'classification']
```
video_publish的视图类是VideoPublishView，它的代码如下
```python
class VideoPublishView(SuperUserRequiredMixin, generic.UpdateView):
    model = Video
    form_class = VideoPublishForm
    template_name = 'myadmin/video_publish.html'

    def get_context_data(self, **kwargs):
        context = super(VideoPublishView, self).get_context_data(**kwargs)
        clf_list = Classification.objects.all().values()
        clf_data = {'clf_list':clf_list}
        context.update(clf_data)
        return context

    def get_success_url(self):
        return reverse('myadmin:video_publish_success')
```
可以看到，对应的页面是myadmin/video_publish.html

要填写的视频资料有视频标题、描述、分类、封面，

其中分类是通过get_context_data()带过来的，

填写后，点击发布，django将通过UpdateView自动为你更新视频信息。并通过get_success_url跳转到成功页面myadmin:video_publish_success，它的路由是

通过 video_publish_success 调用 VideoPublishSuccessView。

对应VideoPublishSuccessView是
```python
class VideoPublishSuccessView(generic.TemplateView):
    template_name = 'myadmin/video_publish_success.html'
```
到此视频添加功能完成

##视频列表

视频列表的路由是
```python
path('video_list/', views.VideoListView.as_view(), name='video_list'),
```

对应的视图类是VideoListView
```python
class VideoListView(AdminUserRequiredMixin, generic.ListView):
    model = Video
    template_name = 'myadmin/video_list.html'
    context_object_name = 'video_list'
    paginate_by = 10
    q = ''

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super(VideoListView, self).get_context_data(**kwargs)
        paginator = context.get('paginator')
        page = context.get('page_obj')
        page_list = get_page_list(paginator, page)
        context['page_list'] = page_list
        context['q'] = self.q
        return context

    def get_queryset(self):
        self.q = self.request.GET.get("q", "")
        return Video.objects.get_search_list(self.q)
```

这里继承了ListView来显示视频列表，并通过get_queryset实现了搜索功能，通过get_context_data()实现了分页功能。
##视频编辑
页面中还有编辑和删除的功能。

编辑呢，是对单个视频对资料进行更新，删除即删除本条视频和视频文件。

我们先实现编辑功能，路由是
```python
path('video_edit/<int:pk>/', views.VideoEditView.as_view(), name='video_edit'),
```
对应对视图类是VideoEditView，这个视图类是需要传递主键的。
```python
class VideoEditView(SuperUserRequiredMixin, generic.UpdateView):
    model = Video
    form_class = VideoEditForm
    template_name = 'myadmin/video_edit.html'

    def get_context_data(self, **kwargs):
        context = super(VideoEditView, self).get_context_data(**kwargs)
        clf_list = Classification.objects.all().values()
        clf_data = {'clf_list':clf_list}
        context.update(clf_data)
        return context

    def get_success_url(self):
        messages.success(self.request, "保存成功")
        return reverse('myadmin:video_edit', kwargs={'pk': self.kwargs['pk']})
```    

其实编辑页面和发布页面很相似，都是继承UpdateView视图类，并在get_context_data()里面传递分类信息。

最终成功后通过messages.success(self.request, "保存成功")消息告之前端。
##视频删除

删除功能就更加简单了。路由是
```python
path('video_delete/', views.video_delete, name='video_delete'),
```
这里通过video_delete函数来实现，前端通过ajax（ajax代码位于static/js/myadmin/video_list.js）调用这个函数。
```python
@ajax_required
@require_http_methods(["POST"])
def video_delete(request):
    video_id = request.POST['video_id']
    instance = Video.objects.get(id=video_id)
    instance.delete()
    return JsonResponse({"code": 0, "msg": "success"})
```
获取该视频，然后instance.delete()删除之。

