# Ping0Monitor

分布式 ping 检测计划，让你的小鸡发光发热！

本程序为 https://ping0.cc/ping 的安装脚本，运行此脚本之后，将会让小鸡加入ping0.cc的分布式检测网络。

本程序会安装一个主程序，安装过程中需要`wget`，安装完成后使用`systemd`守护主程序的运行。除此之外，不会安装其他依赖，不会修改文件，CPU占用极低，内存占用约10MB，平均每天总流量小于 1MB。

官方内容请参见：https://hostloc.com/thread-1149787-1-1.html 和 https://ping0.cc/Ip/join 




## 一键脚本如下
```
wget --no-check-certificate -O ping0.sh https://raw.githubusercontent.com/uselibrary/Ping0Monitor/main/install.sh && chmod +x ping0.sh && bash ping0.sh
```

### 1. 安装过程：

首先，运行上述一键脚本。

期间需要输入用户名，此处输入pa.ci为例，用户名最多为8个字符。如果直接回车，则默认用户名为`username`。脚本会自动停用并删除之前的旧版本，再安装新版本。

![install](https://raw.githubusercontent.com/uselibrary/Ping0Monitor/main/data/install.jpg)

### 2. 安装完成后的查看

安装完成后，在 https://ping0.cc/ping 中将会出现对应服务器和刚才输入的用户名，例子如下：

![list](https://raw.githubusercontent.com/uselibrary/Ping0Monitor/main/data/list.jpg)

程序的运行状态，可以使用以下命令查看：

```
systemctl status ping0.service
```



### 3. 如何修改用户名

最简单的方法是重装，再重装过程中输入新的用户名

此外，还可以修改`/etc/systemd/system/ping0.service`中的用户名称，即下述中的`username`名称。注意`username`之后还有个空格，不能丢失。

```
ExecStart=/usr/local/ping0/ping0 username 
```

修改完成后，执行以下命令：

```
systemctl daemon-reload
systemctl restart ping0.service
```



### 4. 删除ping0服务

如需要删除ping0的程序和相关服务，依次执行以下命令即可：

```
systemctl stop ping0.service
systemctl disable ping0.service
rm -rf /usr/local/ping0
rm -rf /etc/systemd/system/ping0.service
systemctl daemon-reload
```



### 5. 系统兼容性

此安装脚本理论上支持的系统如下：

- Debian
- Ubuntu
- RedHat及其衍生系列（如CentOS、AlmaLinux、Rocky Linux等）

此安装脚本理论上支持的CPU架构如下：

- x86-64/amd64 
- armv7l （即32位arm）
- aarch64（即64位arm）

此脚本已经在Debian 11 (amd 64位) 系统上测试通过。
