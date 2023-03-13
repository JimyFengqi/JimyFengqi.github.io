# 个人博客

> This is my [personal blog](https://JimyFengqi.github.io/) repository.
基于Nodejs 18.14.0
本主题时基于hexo-theme-bamboo dev分支 2.6.9版本修改而来

## 搭建方法

### 安装Nodejs

 登录Nodejs [官网](https://nodejs.org/en/)，下载对应的版本

 下载完成之后，按提示安装完成

 打开CMD.exe, 输入 node -v 检查是否正常安装完成

 ```sh
 >node -v
 v18.14.0
 ```

### 安装Hexo

安装完Nodejs，就可以用npm命令直接安装hexo了。
在命令行执行 npm instal hexo-cli -g 即可

## Hexo博客初体验

只需一条指令即可

```sh
npm install hexo-cli
hexo init blog
cd blog
npm install
hexo server
```

然后打开 [localhost:4000](http://localhost:4000/)即可看到博客创建成功了。

# 发布相关

## 通过【travis-ci】网站发布

这个的前提是travis-ci依然可用， 一般它仅有一个月左右的免费使用时间
之后就可能需要付费， 暂时没研究怎么一直免费的方法

发布的时候选择的自动发布
关键是脚本文件 `.trails.yml`, 这个文件会关联网站 [travis-ci](https://www.travis-ci.com/)

每个单独的库都有单独的job

针对这个代码库， 有一些特殊的配置
主要是最后发布的时候使用的推送命令，里面使用隐私保护账号密码
这里是两种方式：
一种是token认证方式 ，一种是账号密码的方式
```
git push --force --quiet "https://${GH_TOKEN}@${GITHUB_HEXOREF}" master:master
git push --force --quiet "https://${GITEE_USER}:${GITEE_PASSWORD}@${GITEE_HEXOREF}" master:master
```

|变量名字|  解释|
| :------: | :------: |
|GH_TOKEN|github中生成的 密码token, 一般会有过期时间， 隔一段时间需要自己更新一下|    
|GITEE_USER|gitee的账号 |
|GITEE_PASSWORD|gitee的密码 |

## 自己写脚本发布

参考文件 `auto_deploy.sh` 文件
本质就是自己构建生成要发布的文件
然后把远程分支的git历史记录拉下来
最后再重新发布