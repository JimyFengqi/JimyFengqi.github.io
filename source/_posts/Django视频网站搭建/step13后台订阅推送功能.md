---
title: Django视频网站搭建--step13后台订阅推送功能
categories: Django视频网站搭建
tags:
  - django
abbrlink: 254395507
date: 2020-08-28 16:19:08
---
#订阅邮件推送功能
本讲我们会讲到一些关于发邮件的技术。

订阅功能是一个很常见的功能，当用户订阅某个网站后，网站会通过后台给用户发送网站最新的一些动向，一般是通过邮件来发送的。

当你阅读完本节内容，会对发邮件的流程有一个大概的了解。
## 配置相关参数

发送邮件是需要配置相关参数的，且每个邮件服务商都有自己的配置值，笔者使用的是163邮箱，在settings.py追加如下配置
```python
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'

# 邮件配置
EMAIL_USE_SSL = True
EMAIL_HOST = 'smtp.163.com'
EMAIL_PORT = 465
EMAIL_HOST_USER = ''        # 163邮箱可用
EMAIL_HOST_PASSWORD = ''    # 邮箱密码
```
一定要记得配置 EMAIL_BACKEND， 因为django默认配置的是一种模拟发邮件的 BackEnd ，并不能使用，故要替换。
###路由设置

我们先来写订阅推送的路由，
```python
path('subscribe/', views.SubscribeView.as_view(), name='subscribe'),
```
同时修改myadmin/base.html文件
```html
                <a class="item" href="{% url 'myadmin:subscribe' %}" id="subscribe">订阅通知</a>
```

将路由设置为 SubscribeView
## 视图设置
 SubscribeView 的代码
```python

# 订阅推送功能
class SubscribeView(SuperUserRequiredMixin, generic.View):
    def get(self, request):
        video_list = Video.objects.get_published_list()
        return render(request, "myadmin/subscribe.html", {'video_list': video_list})

    def post(self, request):
        if not request.user.is_superuser:
            return JsonResponse({"code": 1, "msg": "无权限"})
        video_id = request.POST['video_id']
        video = Video.objects.get(id=video_id)      # 通过主键获取到视频的当前实例
        subject = video.title
        context = {'video': video, 'site_url': settings.SITE_URL}                          # 使用SITE_URL构建网址
        html_message = render_to_string('myadmin/mail_template.html', context)
        email_list = User.objects.filter(subscribe=True).values_list('email', flat=True)  # 获取到所有订阅用户的email地址到email_list
        # 分组,两个一组，分别发送邮件
        email_list = [email_list[i:i + 2] for i in range(0, len(email_list), 2)]

        if email_list:
            for to_list in email_list:
                try:
                    send_html_email(subject, html_message, to_list)
                except smtplib.SMTPException as e:
                    logger.error(e)
                    return JsonResponse({"code": 1, "msg": "发送失败"})
            return JsonResponse({"code": 0, "msg": "success"})
        else:
            return JsonResponse({"code": 1, "msg": "邮件列表为空"})
```

这是一个普通的视图类，功能是由get和post共同来完成的。

get中设置了要显示的模板文件myadmin/subscribe.html

当我们要给用户发送邮件的时候，需要先选择要推送的视频。然后点击通知订阅用户，即可触发ajax发送代码

，ajax代码位于static/js/myadmin/send_mail.js，里面最终调用的是SubscribeView中的post方法，

post方法中，我们先通过主键获取到视频的当前实例，并且还获取到所有订阅用户的email地址放到email_list中，

最后调用send_html_email将邮件发送出去，send_html_email封装在video_helpers.py，它的具体代码是
```python
def send_html_email(subject, html_message, to_list):
    plain_message = strip_tags(html_message)
    from_email = settings.EMAIL_HOST_USER
    send_mail(subject, plain_message, from_email, to_list, html_message=html_message)


def send_email(subject, content, to_list):
    try:
        message = (subject, content, settings.EMAIL_HOST_USER, to_list)
        send_mass_mail((message,))
    except smtplib.SMTPException :
        print("--> send fail")
        return HttpResponse("fail")
    else:
        print("--> send success")
        return HttpResponse("success")
```

从代码可以看出，程序最终调用的是django自带的 send_mass_mail 函数，该函数封装了发送邮件的细节。

当然还可以使用 send_mail 函数，send_mail每次发邮件都会建立一个连接，发多封邮件时建立多个连接。

而 send_mass_mail 是建立单个连接发送多封邮件，所以一次性发送多封邮件时 send_mass_mail 要优于 send_mail。