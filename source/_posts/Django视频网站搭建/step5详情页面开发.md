---
title: Django视频网站搭建--step5详情页面开发
categories: Django视频网站搭建
tags:
  - django
abbrlink: 2386286241
date: 2020-11-17 18:05:47
---
#详情页面开发
在本讲中，我们开始详情页功能的开发.

详情页就是对单个视频进行播放并展示视频的相关信息，比如视频标题、描述、评论信息、相关推荐等。

我们将会学习到通用视图类DetailView的使用、评论动态加载、以及如何通过ajax实现喜欢和收藏功能，并通过一段段很酷的代码来说明这些功能。

#整体功能

- 1.详情页功能。
- 2.对单个视频进行展示，包括标题、描述、观看次数
- 3.点赞和收藏功能。
- 4.评论功能，通过上拉网页即可分页加载评论列表，用户还能添加评论。
- 5.侧栏推荐视频列表，推荐逻辑为推荐观看次数最多的视频。
- 6.list页面点击某个视频或者其标题跳转到详情页。

我们把详情页分为4个小的业务模块来开发，分别是：视频详情显示、喜欢和收藏功能、评论功能、推荐功能。下面我们分别对这四个功能模块进行开发讲解。
##视频详情显示

上一讲中，我们已经建立了video模型，所以不必再新建模型，我们就在video模型的基础上进行扩展。

上一讲，我们创建的字段有

    title       视频标题。数据类型是charField，最大长度为max_length=100，允许为空null=True
    desc        视频描述。数据类型是charField，最大长度为max_length=255，允许为空null=True
    file        视频文件地址。数据类型是fileField。其中存的是视频文件的地址，在之后的视频管理中我们将会对视频的上传进行具体的讲解。
    cover       视频封面。数据类型是ImageField。存储目录为upload_to=‘cover/’，允许为空null=True
    status      视频状态。是一个选择状态，用choices设置多选元祖。
    created_time 创建时间。数据类型是DateTimeField 。设置自动生成时间auto_now_add=True

这些字段目前是不够用的，我们再加几个字段，需要加**观察次数、喜欢的用户、收藏的用户**。

video模型扩展后如下
```python
class Video(models.Model):
    STATUS_CHOICES = (
        ('0', '发布中'),
        ('1', '未发布'),
    )
    title = models.CharField(max_length=100,blank=True, null=True)
    desc = models.CharField(max_length=255,blank=True, null=True)
    classification = models.ForeignKey(Classification, on_delete=models.CASCADE, null=True)
    file = models.FileField(max_length=255)
    cover = models.ImageField(upload_to='cover/',blank=True, null=True)
    status = models.CharField(max_length=1 ,choices=STATUS_CHOICES, blank=True, null=True)
    view_count = models.IntegerField(default=0, blank=True)
    liked = models.ManyToManyField(settings.AUTH_USER_MODEL,
                                   blank=True, related_name="liked_videos")
    collected = models.ManyToManyField(settings.AUTH_USER_MODEL,
                                   blank=True, related_name="collected_videos")
    created_time = models.DateTimeField(auto_now_add=True, blank=True, max_length=20)
```
新增了3个字段

    view_count 观看次数。数据类型是IntegerField，默认是0
    liked 喜欢的用户。数据类型是ManyToManyField，这是一种多对多的关系，
                    表示一个视频可以被多个用户喜欢，一个用户也可以喜欢多个视频。
                    记得设置用户表为settings.AUTH_USER_MODEL
    collected 收藏的用户。数据类型是ManyToManyField，这是一种多对多的关系，
                        表示一个视频可以被多个用户收藏，一个用户也可以收藏多个视频。
                        设置用户表为settings.AUTH_USER_MODEL

    更多关于ManyToManyField的使用介绍，可以查询django官网的介绍。

下面就是详情展示阶段，我们先配置好详情页的路由信息，在video/urls.py中追加detail的路由信息。
```python
video/urls.py

app_name = 'video'
urlpatterns = [
    path('index', views.IndexView.as_view(), name='index'),
    path('search/', views.SearchListView.as_view(), name='search'),
    path('detail/<int:pk>/', views.VideoDetailView.as_view(), name='detail'),
]
```
    path('detail/<int:pk>/', views.VideoDetailView.as_view(), name='detail')
即表示详情信息，注意每条视频都是有自己的主键的，所以设置路径匹配为detail/<int:pk>/,其中<int:pk>表示主键，

这是django中表示主键的一种方法。这样我们就可以在浏览器输入127.0.0.1:8000/video/detail/xxx来访问详情了。

如何显示详情呢，django为我们提供了DetailView。

urls.py中设置的视图类是VideoDetailView，我们让VideoDetailView继承DetailView即可。
```python
class VideoDetailView(generic.DetailView):
    model = Video
    template_name = 'video/detail.html' 
```

看起来超级简单，django就是如此的酷，只需要我们配置几行代码，就能实现很强大的功能。

这里我们配置model为Video模型，模板为video/detail.html，其它的工作都不用管，全都交给django去干

模板文件位于templates/video/detail.html，它的代码比较简单，这里就不贴了。

##观看次数
观看次数的展示，本质上就是数据库里的一个自增字段，每次观看的时候，view_count自动加1。

对于这个小需求，我们需要做两件事情，首先这video模型里面，添加一个次数自增函数，命名为increase_view_count，这很简单，如下所示：
```python
    def increase_view_count(self):
        self.view_count += 1
        self.save(update_fields=['view_count'])
```
然后，还需要我们在VideoDetailView视图类里面调用到这个函数。这个时候get_object()派上用场了。

因为每次调用DetailView的时候，django都会回调get_object()这个函数。

因此我们可以把increase_view_count()放到get_object()里面执行。完美的代码如下
```python
class VideoDetailView(generic.DetailView):
    model = Video
    template_name = 'video/detail.html'

    def get_object(self, queryset=None):
        obj = super().get_object()
        obj.increase_view_count()  # 通过调用Video中的increase_view_count 获取观看次数
        return obj
```
##点赞收藏功能
目前为止，我们就能在详情页看到标题、描述、观看次数、收藏次数、喜欢次数。

虽然可以显示收藏人数、喜欢人数。但是目前还没实现点击喜欢/收藏的功能。下面我们来实现。


收藏和点赞是一组动作，因此可以用ajax来实现：用户点击后调用后端接口，接口返回json数据，前端显示结果。

既然需要接口，那我们先添加喜欢/收藏接口的路由，在video/urls.py追加代码如下
```python
path('like/', views.like, name='like'),
path('collect/', views.collect, name='collect'),
```
 
由于两个功能实现非常类似，限于篇幅，这里只说明一下功能。

我们先写like函数：
```python
@ajax_required
@require_http_methods(["POST"])
def like(request):
    if not request.user.is_authenticated:
        return JsonResponse({"code": 1, "msg": "请先登录"})
    video_id = request.POST['video_id']
    video = Video.objects.get(pk=video_id)
    user = request.user
    video.switch_like(user)
    return JsonResponse({"code": 0, "likes": video.count_likers(), "user_liked": video.user_liked(user)})
```

首先判断用户是否登录，如果登录了则调用switch_like(user)来实现喜欢或不喜欢功能，最后返回json。

注意这里添加了两个注解@ajax_required和@require_http_methods(["POST"])，分别验证request必须是ajax和post请求。
这两个装饰器ajax_required是由自己的helper实现的，目的是加载ajax
```python
utils/video_helpers.py

from django.http import HttpResponseBadRequest
def ajax_required(f):
    """Not a mixin, but a nice decorator to validate than a request is AJAX"""
    def wrap(request, *args, **kwargs):
        if not request.is_ajax():
            return HttpResponseBadRequest()

        return f(request, *args, **kwargs)

    wrap.__doc__ = f.__doc__
    wrap.__name__ = f.__name__
    return wrap
```
require_http_methods方法则是自带的，要求请求的方式是POST.

switch_like()函数则写在了video/model.py里面
```python
    # 用户已经点击过喜欢了，就移除，没点击就添加
    def switch_like(self, user):
        if user in self.liked.all():
            self.liked.remove(user)
        else:
            self.liked.add(user)

    # 统计喜欢人数
    def count_likers(self):
        return self.liked.count()

    # 判断用户是否喜欢
    def user_liked(self, user):
        if user in self.liked.all():
            return 0
        else:
            return 1
```
所有的后端工作都准备好了，我们再把视线转向前端。前端主要是写ajax代码。

由于ajax代码量较大，我们封装到一个单独的js文件中 ==> static/js/detail.js

在detail.js中，我们先实现点赞的ajax调用：
```javascript
static/js/detail.js

$(function () {

    // 写入csrf
    $.getScript("/static/js/csrftoken.js");

    // 喜欢
    $("#like").click(function(){
      var video_id = $("#like").attr("video-id");
      $.ajax({
            url: '/video/like/',
            data: {
                video_id: video_id,
                'csrf_token': csrftoken
            },
            type: 'POST',
            dataType: 'json',
            success: function (data) {
                var code = data.code
                if(code == 0){
                    var likes = data.likes
                    var user_liked = data.user_liked
                    $('#like-count').text(likes)
                    if(user_liked == 0){
                        $('#like').removeClass("grey").addClass("red")
                    }else{
                        $('#like').removeClass("red").addClass("grey")
                    }
                }else{
                    var msg = data.msg
                    alert(msg)
                }

            },
            error: function(data){
              alert("点赞失败")
            }
        });
    });
```
  

上述代码中，关键代码是$.ajax()函数，我们传入了参数：video_id和csrftoken。

其中csrftoken可通过/static/js/csrftoken.js生成。

在success回调中，通过判断user_liked的值来确定自己是否喜欢过，然后改变模板中相应的css。

##推荐功能

每个网站都有自己的推荐功能，且都有自己的推荐逻辑。这里的推荐逻辑是根据访问次数最高的n个视频来降序排序，然后推荐给用户的。

实现起来非常容易，我们知道详情页实现用的是VideoDetailView，我们可以在get_context_data()中把推荐内容传递给前端模板。

只需要我们改写VideoDetailView的get_context_date()函数。
```python
    def get_context_data(self, **kwargs):
        context = super(VideoDetailView, self).get_context_data(**kwargs)
        recommend_list = Video.objects.get_recommend_list()
        context['recommend_list'] = recommend_list
        return context
```
改写后，我们添加了一行

    recommend_list = Video.objects.get_recommend_list()

我们把获取推荐列表的函数get_recommend_list()封装到了Video模型里面。
在Video/models.py里面,我们追加代码:
```python
class VideoQuerySet(models.query.QuerySet):
    def get_recommend_list(self):
        return self.filter(status=0).order_by('-view_count')[:4]
```
关键是self.filter(status=0).order_by('-view_count')[:4]，通过order_by把view_count降序排序，并选取前4条数据。

注意此处我们用了VideoQuerySet查询器，需要我们在Video下面添加一行依赖。表示用VideoQuerySet作为Video的查询管理器。
```python
    objects = VideoQuerySet.as_manager()
```

当模板拿到数据后，即可渲染显示。这里我们将推荐侧栏的代码封装到templates/video/recommend.html里面。
```html
# templates/video/recommend.html
{% load thumbnail %}
<span class="video-side-title">推荐列表</span>
<div class="ui unstackable divided items">
    {% for item in recommend_list %}
    <div class="item">
        <div class="ui tiny image">
            {% thumbnail item.cover "300x200" crop="center" as im %}
            <img class="ui image" src="{{ im.url }}">
            {% empty %}
            {% endthumbnail %}
        </div>
        <div class="middle aligned content">
            <a class=" header-title" href="{% url 'video:detail' item.pk %}">{{ item.title }}</a>
            <div class="meta">
                <span class="description">{{ item.view_count }}次观看</span>
            </div>
        </div>
    </div>
    {% empty %}
    <h3>暂无推荐</h3>
    {% endfor %}

</div>
```
并在detail.html中将它包含进来

    {% include "video/recommend.html" %}

##评论功能

评论区位于详情页下侧，显示效果如下。共分为两个部分：评论form和评论列表。

评论功能是一个独立的模块，该功能通用性较高，在其他很多网站中都有评论功能，

为了避免以后开发其他网站时重复造轮子，我们建立一个新的应用，命名为comment
```shell script
    python3 manage.py startapp comment
```
接下来，我们创建comment模型
```python
# 位于comment/models.py

class Comment(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    nickname = models.CharField(max_length=30,blank=True, null=True)
    avatar = models.CharField(max_length=100,blank=True, null=True)
    video = models.ForeignKey(Video, on_delete=models.CASCADE)
    content = models.CharField(max_length=100)
    timestamp = models.DateTimeField(auto_now_add=True) 

    class Meta:
        db_table = "v_comment"
```
    user 用户。数据类型是ForeignKey，外键是settings.AUTH_USER_MODEL，并设置为级联删除on_delete=models.CASCADE
    nickname 用户昵称。数据类型是CharField。
    avatar 头像。数据类型是CharField。
    video 对应的视频。数据类型是ForeignKey，对应Video模型，级联删除 on_delete=models.CASCADE
    content 评论内容。 数据类型是CharField。
    timestamp 评论时间。 数据类型是DateTimeField。

有了模型之后，我们就可以专心写业务代码了，首先在comment下建立路由文件urls.py。并写入代码:
```python
from django.urls import path
from . import views

app_name = 'comment'
urlpatterns = [
    path('submit_comment/<int:pk>',views.submit_comment, name='submit_comment'),
    path('get_comments/', views.get_comments, name='get_comments'),
]
```
我们配置了两条路由信息：评论提交 和 获取评论。

提交评论，需要一个form，我们把form放到video/forms.py
```python
from django import forms
from comment.models import Comment

class CommentForm(forms.ModelForm):
    content = forms.CharField(error_messages={'required': '不能为空',},
        widget=forms.Textarea(attrs = {'placeholder': '请输入评论内容' })
    )

    class Meta:
        model = Comment
        fields = ['content']
```
   
然后在video/views.py的VideoDetailView下添加form的相关代码。
```python
class VideoDetailView(generic.DetailView):
    model = Video
    template_name = 'video/detail.html'

    def get_object(self, queryset=None):
        obj = super().get_object()
        obj.increase_view_count()
        return obj

    def get_context_data(self, **kwargs):
        context = super(VideoDetailView, self).get_context_data(**kwargs)
        form = CommentForm() 
        context['form'] = form 
        return context
```
在get_context_data()函数里面，我们把form传递给模板。

同样的，提交评论也是异步的，我们用ajax实现，我们打开static/js/detail.js，写入
```javascript
    // 提交评论
    var frm = $('#comment_form')
    frm.submit(function () {
        $.ajax({
            type: frm.attr('method'),
            url: frm.attr('action'),
            dataType:'json',
            data: frm.serialize(),
            success: function (data) {
                var code = data.code
                var msg = data.msg
                if(code == 0){
                    $('#id_content').val("")
                    $('.comment-list').prepend(data.html);
                    $('#comment-result').text("评论成功")
                    $('.info').show().delay(2000).fadeOut(800)
                }else{
                    $('#comment-result').text(msg)
                    $('.info').show().delay(2000).fadeOut(800);
                }
            },
            error: function(data) {
            }
        });
        return false;
    });
```
评论通过ajax提交后，我们在submit_comment()中就能接收到这个请求。处理如下
```python
def submit_comment(request,pk):
    video = get_object_or_404(Video, pk = pk)
    form = CommentForm(data=request.POST)

    if form.is_valid():
        new_comment = form.save(commit=False)
        new_comment.user = request.user
        new_comment.nickname = request.user.nickname
        new_comment.avatar = request.user.avatar
        new_comment.video = video
        new_comment.save()

        data = dict()
        data['nickname'] = request.user.nickname
        data['avatar'] = request.user.avatar
        data['timestamp'] = datetime.fromtimestamp(datetime.now().timestamp())
        data['content'] = new_comment.content

        comments = list()
        comments.append(data)

        html = render_to_string(
            "comment/comment_single.html", {"comments": comments})

        return JsonResponse({"code":0,"html": html})
    return JsonResponse({"code":1,'msg':'评论失败!'})
```
  
在接收函数中，通过form自带的验证函数来保存记录，然后将这条记录返回到前端模板。

下面我们开始评论列表的开发。

评论列表部分，我们使用了的是上拉动态加载的方案，即当页面拉到最下侧时，js加载代码会自动的获取下一页的数据并显示出来。

前端部分，我们使用了一种基于js的开源加载插件。基于这个插件，可以很容易实现网页的上拉动态加载效果。

它使用超级简单，仅需要调用$(’.comments’).dropload({})即可。我们把调用的代码封装在static/js/load_comments.js里面。

完整的调用代码如下：
```
$(function(){
    // 页数
    var page = 0;
    // 每页展示15个
    var page_size = 15;

    // dropload
    $('.comments').dropload({
        scrollArea : window,
        loadDownFn : function(me){
            page++;

            $.ajax({
                type: 'GET',
                url: comments_url,
                data:{
                     video_id: video_id,
                     page: page,
                     page_size: page_size
                },
                dataType: 'json',
                success: function(data){
                    var code = data.code
                    var count = data.comment_count
                    if(code == 0){
                        $('#id_comment_label').text(count + "条评论");
                        $('.comment-list').append(data.html);
                        me.resetload();
                    }else{
                        me.lock();
                        me.noData();
                        me.resetload();
                    }
                },
                error: function(xhr, type){
                    me.resetload();
                }
            });
        }
    });
});
```
   
不用过多的解释，这段代码已经非常非常清晰了，本质还是ajax的接口请求调用，调用后返回结果更新前端网页内容。

我们看到ajax调用的接口是get_comments，我们继续来实现它，它位于comment/views.py中。
代码如下所示，当获取到page和page_size后，使用paginator对象来实现分页。最后通过render_to_string将html传递给模板。
```python
comment/view.py
def get_comments(request):
    if not request.is_ajax():
        return HttpResponseBadRequest()
    page = request.GET.get('page')
    page_size = request.GET.get('page_size')
    video_id = request.GET.get('video_id')
    video = get_object_or_404(Video, pk=video_id)
    comments = video.comment_set.order_by('-timestamp').all()
    comment_count = len(comments)

    paginator = Paginator(comments, page_size)
    try:
        rows = paginator.page(page)
    except PageNotAnInteger:
        rows = paginator.page(1)
    except EmptyPage:
        rows = []

    if len(rows) > 0:
        code = 0
        html = render_to_string(
            "comment/comment_single.html", {"comments": rows})
    else:
        code = 1
        html = ""

    return JsonResponse({
        "code":code,
        "html": html,
        "comment_count": comment_count
    })
```

##列表页面跳转
在首页里面已经加载了视频内容，现在还没有点击挑战到详情页，现在加上
```html
 <div class="ui card">
            <a class="image" href="{% url 'video:detail' item.pk %}" >
                {% thumbnail item.cover "300x200" crp="center" as im %}
                <img class="ui image" src="{{ im.url }}">
                {% empty %}
                {% endthumbnail %}
                <i class="large play icon v-play-icon"></i>
            </a>
            <div class="content">
                <a class="header" href="{% url 'video:detail' item.pk %}">{{ item.title }}</a>
                <div class="meta">
                    <span class="date">发布于{{ item.created_time|time_since}}</span>
                </div>
                <div class="description">
                    {{ item.view_count}}次观看
                </div>
            </div>
```
和recommend页面一样，通过 video:detail 方法组合调用detail方法，访问到详情页面