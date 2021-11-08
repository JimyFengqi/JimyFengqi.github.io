---
title: Django综合篇之网站地图sitemap
categories: Django全网站搭建
tags:
  - django
abbrlink: 3352256493
date: 2020-12-08 17:11:50
---
#  功能
网站地图是根据网站的结构、框架、内容，生成的导航网页，是一个网站所有链接的容器。很多网站的连接层次比较深，蜘蛛很难抓取到，网站地图可以方便搜索引擎或者网络蜘蛛抓取网站页面，了解网站的架构，为网络蜘蛛指路，增加网站内容页面的收录概率。网站地图一般存放在域名根目录下并命名为sitemap
一个典型的sitemap，其内容片段如下：

```html
该 XML 文件并未包含任何关联的样式信息。文档树显示如下。 
<urlset>
	<url>
		<loc>http://example.com/blog/read/?blogid=63</loc>
		<lastmod>2020-12-01</lastmod>
		<changefreq>weekly</changefreq>
		<priority>0.5</priority>
	</url>
	<url>
		<loc>http://example.com/blog/read/?blogid=61</loc>
		<lastmod>2020-12-01</lastmod>
		<changefreq>weekly</changefreq>
		<priority>0.5</priority>
	</url>
<urlset>
```
Django自带了一个高级的生成网站地图的框架，我们可以很容易地创建出XML格式的网站地图。创建网站地图，只需编写一个Sitemap类，并在URLconf中编写对应的访问路由。
# 安装
安装sitemap框架的步骤如下：
 1. 在INSTALLED_APPS设置中添加
 ```python
 INSTALLED_APPS =[
  'django.contrib.sitemaps' 
  'django.contrib.site' 
  ]
  SITE_ID = 1         # 设置当前站点
 ```
 添加这两个app, 加入SITE_ID = 1来制定当前的站点。
 然后登陆Django后台，修改SITE为你Django网站的域名和名称
 执行数据迁移
```shell
 python manage.py migrate
 ```
# 添加sitemap功能
## （1）创建sitemap

创建sitemap.py.内容类似下面的代码：
```python

from django.contrib.sitemaps import Sitemap
from .models import Blog, Tag, Category
from user.models import UserInfo
from django.urls import reverse

# 静态内容加入地图
class StaticViewSitemap(Sitemap):
    priority = 0.5
    changefreq = 'daily'

    def items(self):
        return ['blog:haystack', 'blog:about', 'blog:archives', ]

    def location(self, item):
        return reverse(item)


class BlogSitemap(Sitemap):
    changefreq = "weekly"
    priority = 0.5
    # protocol = 'https'

    def items(self):
        return Blog.objects.all()

    def lastmod(self, obj):
        return obj.modified_time

    def location(self, obj):
        return '/blog/read/?blogid={}'.format(obj.id)


class CategorySiteMap(Sitemap):
    changefreq = "Weekly"
    priority = "0.6"

    def items(self):
        return Category.objects.all()

    def lastmod(self, obj):
        return obj.created_time

    # 在model里面定义过get_absolute_url方法后,此方法可以省略
    def location(self, obj):
        return '/blog/get_categories/?category_name={}'.format(obj.name)


class TagSiteMap(Sitemap):
    changefreq = "Weekly"
    priority = "0.3"

    def items(self):
        return Tag.objects.all()

    def lastmod(self, obj):
        return obj.created_time

    def location(self, obj):
        return '/blog/get_tags/?tag_id={}'.format(obj.id)


class UserSiteMap(Sitemap):
    changefreq = "Weekly"
    priority = "0.3"

    def items(self):
        return UserInfo.objects.all()

    def lastmod(self, obj):
        return obj.date_joined

    def location(self, obj):
        return '/user/profile/?userid={}'.format(obj.id)

```
## （2）url路由配置

url.py中加入:
```python

from blog.blog_sitemap import BlogSitemap, CategorySiteMap, TagSiteMap, UserSiteMap, StaticViewSitemap
from django.contrib.sitemaps.views import sitemap

sitemaps = {

    'blog': BlogSitemap,
    'Category': CategorySiteMap,
    'Tag': TagSiteMap,
    'User': UserSiteMap,
    'static': StaticViewSitemap
}

url(r'^sitemap\.xml$', sitemap, {'sitemaps': sitemaps},
        name='sitemap'),
```
至此，全部完成，运行你的django程序，浏览器输入:

http://127.0.0.1:8000/sitemap.xml

就可以看见已经成功生成了，然后就可以提交这个地址给搜索引擎。

#  Sitemap类详解
**class Sitemap[source]**

     Sitemap类可以定义以下方法/属性：
**1.  items[source]**

    必须定义。返回对象列表的方法。

框架不关心对象的类型，重要的是这些对象将被传递给location()，lastmod()，changefreq()和priority()方法。
**2. location[source]**

	可选。 其值可以是一个方法或属性。

如果是一个方法, 它应该为items()返回的对象的绝对路径.

如果它是一个属性，它的值应该是一个字符串，表示items()返回的每个对象的绝对路径。

上面所说的“绝对路径”表示不包含协议和域名的URL。 例子：

 - 正确：'/foo/bar/' 
 - 错误：'example.com/foo/bar/'
 - 错误：'https://example.com/foo/bar/'

如果未提供location，框架将调用items()**返回的每个对象上的get_absolute_url()方法**。


该属性最终反映到HTML页面上的标签。
**3. lastmod**

	可选。 一个方法或属性。表示当前条目最后的修改时间。
**4. changefreq**

	可选。 一个方法或属性。表示当前条目修改的频率。

changefreq的允许值为：

		'always'  'hourly'  'daily'  'weekly'  'monthly'  'yearly' 'never'

  

**5. priority**

	可选。表示当前条目在网站中的权重系数，优先级。

示例值：0.4，1.0。 页面的默认优先级为0.5，最高为1.0。
**6. protocol**

	可选的。定义网站地图中的网址的协议（‘http’或’https’）。
**7. limit**

	可选的。定义网站地图的每个网页上包含的最大超级链接数。
**8. i18n**

	可选的。一个boolean属性，定义是否应使用所有语言生成此网站地图。默认值为False。
# 通知Google

当你的sitemap变化的时候，你会想通知Google，以便让它知道对你的站点进行重新索引。 框架就提供了这样的一个函数： 
```python
django.contrib.sitemaps.ping_google()
```
ping_google() 有一个可选的参数 sitemap_url ，它应该是你的站点地图的URL绝对地址

如果不能够确定你的sitemap URL, ping_google() 会引发 django.contrib.sitemaps.SitemapNotFound 异常。

我们可以通过模型中的 save() 方法来调用 ping_google() ：
```python	
from django.contrib.sitemaps import ping_google
 
class Entry(models.Model):
  # ...
  def save(self, *args, **kwargs):
    super(Entry, self).save(*args, **kwargs)
    try:
      ping_google()
    except Exception:
      # Bare 'except' because we could get a variety
      # of HTTP-related exceptions.
      pass
```
一个更有效的解决方案是用 cron 脚本或任务调度表来调用 ping_google() ，该方法使用Http直接请求Google服务器，从而减少每次调用 save() 时占用的网络带宽。	

