#!/bin/bash

# ANSI颜色代码
GREEN='\033[0;32m'  # 绿色
YELLOW='\033[1;33m' # 黄色
RED='\033[0;31m'    # 红色
NC='\033[0m'        # 恢复默认颜色

# ===================== 系统检测 =====================
echo -e "${YELLOW}====== 系统检测 ======${NC}"

# 显示当前时间
echo -e "${GREEN}当前时间: $(date '+%Y-%m-%d %H:%M:%S %Z')${NC}"

# 检测系统信息
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo -e "${GREEN}操作系统: ${PRETTY_NAME}${NC}"
    echo -e "${GREEN}系统架构: $(uname -m)${NC}"
    echo -e "${GREEN}内核版本: $(uname -r)${NC}"
else
    echo -e "${RED}警告: 无法检测操作系统信息${NC}"
fi

# 检测是否为root用户
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}错误: 请使用root用户或sudo运行此脚本${NC}"
    exit 1
fi

# 检测内存和磁盘空间
echo -e "${GREEN}内存信息:${NC}"
free -h
echo -e "${GREEN}磁盘空间:${NC}"
df -h /

# 等待3秒让用户查看系统信息
echo -e "${YELLOW}5秒后开始安装...${NC}"
sleep 5

# 更新软件包列表
echo -e "${GREEN}更新软件包列表...${NC}"
sudo apt update

# 安装Git（检测是否已安装）
if ! command -v git &> /dev/null; then
    echo -e "${GREEN}安装Git...${NC}"
    sudo apt install -y git
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Git安装成功！${NC}"
    else
        echo -e "${GREEN}Git安装失败，请检查错误信息。${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Git 已安装，跳过。${NC}"
fi

# 安装Node.js（检测是否已安装）
if ! command -v node &> /dev/null; then
    echo -e "${GREEN}安装Node.js...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
    sudo apt update
    sudo apt install -y nodejs
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Node.js安装成功！${NC}"
        echo -e "${GREEN}Node 版本: $(node --version)${NC}"
        echo -e "${GREEN}npm 版本: $(npm --version)${NC}"
        
        # 安装pnpm（检测是否已安装）
        if ! command -v pnpm &> /dev/null; then
            echo -e "${GREEN}使用npm安装pnpm...${NC}"
            sudo npm install -g pnpm
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}pnpm安装成功！${NC}"
                echo -e "${GREEN}pnpm 版本: $(pnpm --version)${NC}"
            else
                echo -e "${GREEN}pnpm安装失败，请检查错误信息。${NC}"
                exit 1
            fi
        else
            echo -e "${GREEN}pnpm 已安装，跳过。${NC}"
        fi
    else
        echo -e "${GREEN}Node.js安装失败，请检查错误信息。${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Node.js 已安装，跳过。${NC}"
    # 即使Node.js已安装，也检查pnpm
    if ! command -v pnpm &> /dev/null; then
        echo -e "${GREEN}使用npm安装pnpm...${NC}"
        sudo npm install -g pnpm
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}pnpm安装成功！${NC}"
            echo -e "${GREEN}pnpm 版本: $(pnpm --version)${NC}"
        else
            echo -e "${GREEN}pnpm安装失败，请检查错误信息。${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}pnpm 已安装，跳过。${NC}"
    fi
fi

# 安装Redis（检测是否已安装）
if ! command -v redis-server &> /dev/null; then
    echo -e "${GREEN}安装Redis...${NC}"
    sudo apt install -y redis-server
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Redis安装成功！${NC}"
        echo -e "${GREEN}启动Redis服务...${NC}"
        sudo systemctl enable redis-server
        sudo systemctl start redis-server
        echo -e "${GREEN}Redis运行状态: $(sudo systemctl is-active redis-server)${NC}"
    else
        echo -e "${GREEN}Redis安装失败，请检查错误信息。${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Redis 已安装，跳过。${NC}"
fi

# 安装Google Chrome（检测是否已安装）
if ! command -v google-chrome &> /dev/null; then
    echo -e "${GREEN}安装Google Chrome...${NC}"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
    sudo apt install -y /tmp/chrome.deb
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Google Chrome安装成功！${NC}"
        rm /tmp/chrome.deb
    else
        echo -e "${GREEN}Google Chrome安装失败，请检查错误信息。${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Google Chrome 已安装，跳过。${NC}"
fi

# 安装Google Noto CJK字体（检测是否已安装）
if ! dpkg -l | grep -q fonts-noto-cjk; then
    echo -e "${GREEN}安装Google Noto CJK字体...${NC}"
    sudo apt install -y fonts-noto-cjk
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Google Noto CJK字体安装成功！${NC}"
    else
        echo -e "${GREEN}Google Noto CJK字体安装失败，请检查错误信息。${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Google Noto CJK字体 已安装，跳过。${NC}"
fi

# 克隆Yunzai仓库
echo -e "${GREEN}克隆Yunzai仓库...${NC}"
if [ ! -d "Yunzai" ]; then
    git clone --depth 1 https://gitee.com/TimeRainStarSky/Yunzai
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Yunzai仓库克隆成功！${NC}"
        
        # 进入Yunzai目录并安装依赖
        echo -e "${GREEN}进入Yunzai目录安装依赖...${NC}"
        cd Yunzai && pnpm install
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}依赖安装成功！${NC}"
        else
            echo -e "${GREEN}依赖安装失败，请检查错误信息。${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}Yunzai仓库克隆失败，请检查错误信息。${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Yunzai目录已存在，跳过克隆。${NC}"
    # 如果目录已存在，也尝试安装依赖
    echo -e "${GREEN}进入已有Yunzai目录安装依赖...${NC}"
    cd Yunzai && pnpm install
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}依赖安装成功！${NC}"
    else
        echo -e "${GREEN}依赖安装失败，请检查错误信息。${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}安装完成！自行node app${NC}"
