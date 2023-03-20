# Ping0Monitor

分布式 ping 检测计划，让你的小鸡发光发热！

本程序为 https://ping0.cc/ping 的安装脚本，运行此脚本之后，将会让小鸡加入ping0.cc的分布式检测网络。

本程序会安装一个主程序，安装过程中需要`wget`，安装完成后使用`systemd`守护主程序的运行。除此之外，不会安装其他依赖，不会修改文件，CPU占用极低，内存占用约10MB，平均每天总流量小于 1MB。

官方内容请参见：https://hostloc.com/thread-1149787-1-1.html 




## 一键脚本如下
```
wget --no-check-certificate -O ping0.sh https://raw.githubusercontent.com/uselibrary/Ping0Monitor/main/install.sh && chmod +x ping0.sh && bash ping0.sh
```

### 安装过程如下：

![install](https://raw.githubusercontent.com/uselibrary/Ping0Monitor/main/data/install.jpg)







如需要删除ping0的程序和相关服务，依次执行以下命令即可：

```
systemctl stop ping0.service
systemctl disable ping0.service
rm -rf /usr/local/ping0
rm -rf /etc/systemd/system/ping0.service
systemctl daemon-reload
```

