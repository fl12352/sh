#! /bin/bash
 
#风铃的云崽一键
#2025.4.6
 
 
if [ $EUID -ne 0 ]; then
    echo "请先输入sudo su root 切换成root权限"
    exit
fi
 
echo "开始安装和更新相关环境依赖"
apt update
apt-get install -y sudo
apt-get install -y curl
apt list --upgradable
apt upgrade -y
apt autoremove -y
apt install wget -y
apt install git -y
 
#安装nodejs
echo "开始安装nodejs"
#/dev/null相当于一个黑洞，任何输出信息都会直接丢失，此处表示将标准输出(1) 以及标准错误输出(2)都重定向到null中去，即不输出
#若type有输出，则exit code 为0
if ! type node >/dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - #curl的-s表示不输出错误和进度信息，-L表示让http请求跟随服务器的重定向
    sudo apt install -y nodejs
else
    echo "nodejs已安装"
fi
echo "安装nodejs完成"
 
#若没有npm则安装npm
if ! type npm >/dev/null 2>&1; then
    apt install npm -y
    echo 'npm安装成功'
else
    echo 'npm已安装'
fi
 
#安装并运行redis
echo "开始安装redis"
apt install redis -y
echo "redis安装完成"
 
#安装chromium浏览器
echo "开始安装chromium浏览器"
sudo apt install -y chromium
echo "安装chromium完成"
 
#安装中文字体
echo "开始安装中文字体"
sudo apt install ttf-wqy-zenhei
echo "安装中文字体完成"
 
#克隆云崽本体
echo "开始克隆TRSS-Yunzai"
if [ ! -d "Yunzai/" ]; then #如果不存在Yunzai-Bot文件夹,-d表示是否存在文件夹
    git clone --depth 1 https://gitee.com/TimeRainStarSky/Yunzai
    if [ ! -d "Yunzai/" ]; then
        echo "克隆失败"
        exit 0
    else
        echo "克隆完成"
    fi
else
    echo "TRSS-Yunzai已安装"
fi
 
cd Yunzai/
echo "开始安装依赖"
npm config set registry https://registry.npmmirror.com/
npm i -g pnpm
pnpm config set registry https://registry.npmmirror.com/
pnpm i
echo "安装依赖完成"
echo "云崽本体安装完成"
 
echo "安装ffmpeg转码工具"
apt install ffmpeg -y
echo "脚本结束，恭喜你部署完成！"
