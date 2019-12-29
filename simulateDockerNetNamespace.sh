#!/bin/bash

# 创建两个network namespace
ip netns add container_ns1
ip netns add container_ns2

ip netns list
ls /var/run/netns

# 创建myDocker0网桥
brctl addbr myDocker0
ip addr add 192.168.111.1/24 dev myDocker0
ip link set dev myDocker0 up


# 创建虚拟网卡对，一端塞到myDocker0网桥，另一端塞给network namespace container_ns1
ip link add veth1 type veth peer name veth1peer
brctl addif myDocker0 veth1
ip link set veth1 up
ip link set veth1peer netns container_ns1
# 改名eth0，设置IP和默认路由
ip netns exec container_ns1 ip link set veth1peer name eth0
ip netns exec container_ns1 ip link set eth0 up
ip netns exec container_ns1 ip addr add 192.168.111.5/24 dev eth0
ip netns exec container_ns1 ip route add default via 192.168.111.5

ip link add veth2 type veth peer name veth2peer
brctl addif myDocker0 veth2
ip link set veth2 up
ip link set veth2peer netns container_ns2
ip netns exec container_ns2 ip link set veth2peer name eth0
ip netns exec container_ns2 ip link set eth0 up
ip netns exec container_ns2 ip addr add 192.168.111.9/24 dev eth0
ip netns exec container_ns2 ip route add default via 192.168.111.9


# 两个container分别ping对方
ip netns exec container_ns1 ping -c 3 192.168.111.9
ip netns exec container_ns2 ping -c 3 192.168.111.5

