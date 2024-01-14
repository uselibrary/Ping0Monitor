#!/usr/bin/env bash

clear
echo "    ################################################"
echo "    #                                              #"
echo "    #              ping0.cc分布式检测计划           #"
echo "    #                 https://ping0.cc             #"
echo "    #                  Version 0.3                 #"
echo "    #            Powered by https://pa.ci          #"
echo "    ################################################"

# January 13, 2024

function uninstall()
{
    echo "卸载流程开始！"
    systemctl stop ping0.service
    systemctl disable ping0.service
    rm -rf /usr/local/ping0
    rm -rf /etc/systemd/system/ping0.service
    systemctl daemon-reload
    echo "卸载流程结束!"
}

function install_wget()
{
    if [ ! -x wget ];then
        echo "成功探测到所需的 wget 指令！"
        return 0
    fi
    echo "没有探测到所需的 wget 指令，尝试自动安装 wget 软件包..."

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
        echo "sorry！脚本不支持自动为你的操作系统安装wget！"
        echo "请手动安装 wget！"
        exit 1
    fi

    # 安装依赖 "wget"
    if [ "$PM" = "yum" ]; then
        yum install -y wget
    else
        apt-get install -y wget
    fi

}
DownloadURL=null
function getDownloadURL()
{
    # 使用 "arch" 命令检查系统架构，x86_64、arm32或arm64
    # 部分设备上可能没有 arch 这个指令，这里改用等效的 uname -m
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            # x86_64: 
            DownloadURL=https://ping0.cc/data/ping0;;
        armv7l)
            #arm32:
            DownloadURL=https://ping0.cc/data/ping0-arm;;
        armv6l)
            # arm32:
            DownloadURL=https://ping0.cc/data/ping0-arm;;
        arm64)
            # arm64:
            DownloadURL=https://ping0.cc/data/ping0-arm64;;
        *)
            echo "sorry！安装脚本还不支持你的系统架构!"
            exit 1;;
    esac

}

function install()
{
    echo "安装流程即将开始..."

    install_wget
    getDownloadURL
    if [ "$DownloadURL" = null ]; then
        echo "获取下载链接失败!"
        exit 1
    fi
    
    echo "安装流程开始！"
    # 新建目录 /usr/local/ping0，并使用wget下载安装文件
    mkdir -p /usr/local/ping0

    echo "正在下载主程序..."

    wget -qO- $DownloadURL > /usr/local/ping0/ping0

    # 给安装文件添加执行权限
    chmod +x /usr/local/ping0/ping0

    echo "主程序安装完毕! 开始配置 ping0 systemd 单元文件！"

    echo "
[Unit]
Description=Ping0 Monitor Service
Documentation=https://ping0.cc/ping
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/ping0/ping0 username 
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/ping0.service

    # 要求用户输入用户名
    read -p "请输入贡献者名: " USERNAME
    # 如果用户名为空，则使用ping0作为用户名
    # 将ping0.service中的用户名替换为用户输入的用户名
    if [ "$USERNAME" != "" ]; then
        sed -i "s/username/$USERNAME/g" /etc/systemd/system/ping0.service
    fi

    # 启用systemd管理，并启用ping0服务
    systemctl daemon-reload
    systemctl enable ping0.service
    systemctl start ping0.service

    echo "ping0 systemd 单元文件配置完毕！已启动ping0服务！"
    echo "安装流程结束！"
}

# 检查是否为root用户
if [ $(id -u) != "0" ]; then
    echo "错误: 需要使用root权限执行此脚本!"
    exit 1
fi

echo "欢迎来到 ping0 维护脚本！"
# 检查是否安装过，若有则提供卸载重装选项，没有则提供安装选项
if [ -f /usr/local/ping0/ping0 ]; then
    echo "探测到系统中已存在ping0，如何处理？"
    echo "1.卸载ping0  2.重装最新版ping0  3.退出脚本"
    read -p "请选择：" choice
    case $choice in
        1)
            uninstall
            ;;
        2)
            echo "重新安装ping0..."
            uninstall
            install
            ;;
        3)
            exit 0
            ;;
        *)
            echo "输入错误!"
            ;;
    esac
else
    echo "请选择你要进行的操作："
    echo "1.安装ping0  2.退出脚本"
    read -p "请选择：" choice
    case $choice in
        1)
            install
            ;;
        2)
            exit 0
            ;;
        *)
            echo "输入错误!"
            ;;
    esac
fi


