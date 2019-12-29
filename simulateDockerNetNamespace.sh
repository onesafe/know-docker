ip netns add container_ns1
ip netns add container_ns2

ip netns list
ls /var/run/netns

brctl addbr myDocker0
ip addr add 192.168.111.1/24 dev myDocker0
ip link set dev myDocker0 up

ip link add veth1 type veth peer name veth1peer
brctl addif myDocker0 veth1
ip link set veth1 up
ip link set veth1peer netns container_ns1
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


ip netns exec container_ns1 ping -c 3 192.168.111.9
ip netns exec container_ns2 ping -c 3 192.168.111.5

