hexo clean
hexo generate
# 仅仅下载 .git 文件目录，加上参数 --no-checkout, 下载指定分支， 加上参数 -b {分支名字}
git clone --no-checkout -b master git@gitee.com:JimyFengqi/JimyFengqi.gitee.io.git .deploy_git
mv .deploy_git/.git/ ./public/
cd ./public
git add .
git commit -m "Auto update docs by auto_deploy script"
git push --force --quiet git@github.com:JimyFengqi/JimyFengqi.github.io.git master:master
git push --force --quiet git@gitee.com:JimyFengqi/JimyFengqi.gitee.io.git master:master
rf .deploy_git/ -rf