#!/usr/bin/env bash

clear
echo "    ################################################"
echo "    #                                              #"
echo "    #              ping0.cc分布式检测计划           #"
echo "    #                 https://ping0.cc             #"
echo "    #                  Version 0.1                 #"
echo "    ################################################"

# powered by https://pa.ci

# 检查是否为root用户
if [ $(id -u) != "0" ]; then
    echo "错误: 必须使用root权限执行此脚本!"
    exit 1
fi

# 检查是否安装过，若有则删除
if [ -f /usr/local/ping0/ping0 ]; then
    echo "检测到已安装过ping0，正在删除..."
    systemctl stop ping0.service
    systemctl disable ping0.service
    rm -rf /usr/local/ping0
    rm -rf /etc/systemd/system/ping0.service
    systemctl daemon-reload
    echo "删除完成!"
fi


# 检查系统是否为RedHat系列或者Debian系列，如果不是则退出
if [ -f /etc/redhat-release ]; then
    OS=CentOS
    PM=yum
elif [ ! -z "`cat /etc/issue | grep bian`" ]; then
    OS=Debian
    PM=apt-get
elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ]; then
    OS=Ubuntu
    PM=apt-get
else
    echo "不支持的操作系统!"
    exit 1
fi


# 安装依赖 "wget"
if [ "$PM" = "yum" ]; then
    yum install -y wget
else
    apt-get install -y wget
fi

# 使用 "arch" 命令检查系统架构，x86_64、arm32或arm64
if [ `arch` = "x86_64" ]; then
    ARCH=x86_64
elif [ `arch` = "armv7l" ]; then
    ARCH=arm32
elif [ `arch` = "aarch64" ]; then
    ARCH=arm64
else
    echo "不支持的系统架构!"
    exit 1
fi

# 新建目录 /usr/local/ping0，并使用wget下载安装文件
mkdir -p /usr/local/ping0
# x86_64: https://ping0.cc/data/ping0
# arm32: https://ping0.cc/data/ping0-arm
# arm64: https://ping0.cc/data/ping0-arm64
if [ "$ARCH" = "x86_64" ]; then
    wget --no-check-certificate -qO- https://ping0.cc/data/ping0 > /usr/local/ping0/ping0
elif [ "$ARCH" = "arm32" ]; then
    wget --no-check-certificate -qO- https://ping0.cc/data/ping0-arm > /usr/local/ping0/ping0
elif [ "$ARCH" = "arm64" ]; then
    wget --no-check-certificate -qO- https://ping0.cc/data/ping0-arm64 > /usr/local/ping0/ping0
fi

echo "主文件安装完成!"

# 给安装文件添加执行权限
chmod +x /usr/local/ping0/ping0

# 下载systemd管理文件到/etc/systemd/system/ping0.service
wget --no-check-certificate -qO- /etc/systemd/system/ping0.service https://raw.githubusercontent.com/uselibrary/Ping0Monitor/main/ping0.service

# 要求用户输入用户名
read -p "请输入用户名: " USERNAME
# 如果用户名为空，则使用ping0作为用户名
# 将ping0.service中的用户名替换为用户输入的用户名
if [ "$USERNAME" != "" ]; then
    sed -i "s/username/$USERNAME/g" /etc/systemd/system/ping0.service
fi

# 启用systemd管理，并启用ping0服务
systemctl daemon-reload
systemctl enable ping0.service
systemctl start ping0.service

