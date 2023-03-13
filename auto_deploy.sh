hexo clean
hexo generate
git clone -b master git@gitee.com:JimyFengqi/JimyFengqi.gitee.io.git .deploy_git
mv .deploy_git/.git/ ./public/
cd ./public
git add .
git commit -m "Auto update docs by auto_deploy script"
git push --force --quiet git@github.com:JimyFengqi/JimyFengqi.github.io.git master:master
git push --force --quiet git@gitee.com:JimyFengqi/JimyFengqi.gitee.io.git master:master