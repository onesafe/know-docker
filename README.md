# know-docker

## Linux namespace 实现了6种资源的隔离
* UTS  UTS namespace 提供了主机名和域名的隔离，这样每个容器就拥有独立的主机名和域名了，在网络上就可以被视为一个独立的节点，在容器中对 hostname 的命名不会对宿主机造成任何影响。

* IPC  IPC namespace 实现了进程间通信的隔离，包括常见的几种进程间通信机制，如信号量，消息队列和共享内存。

* PID  PID namespace 完成的是进程号的隔离

* Network  Network namespace 实现了网络资源的隔离，包括网络设备、IPv4 和 IPv6 协议栈，IP 路由表，防火墙，/proc/net 目录，/sys/class/net 目录，套接字等。

* Mount  mount namespace 通过隔离文件系统的挂载点来达到对文件系统的隔离。

* User  User namespace 主要隔离了安全相关的标识符和属性，包括用户 ID、用户组 ID、root 目录、key 以及特殊权限。

## 测试代码
`gcc -o all allnamespace.c`

## 使用ip命令和brctl命令模拟Docker的network namespace

### 安装brctl命令
```bash
# centos7
yum -y install bridge-utils

# ubuntu16.04
apt-get -y install bridge-utils
```

### 安装ip命令
```bash
# centos7
yum -y install iproute2

# ubuntu16.04
apt-get -y install iproute2
```

### 模拟脚本
`./simulateDockerNetNamespace.sh`

### 清除模拟环境
`./clearSimulateDockerNetNamespace.sh`
