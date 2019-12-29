#!/bin/bash

ip netns del container_ns1
ip netns del container_ns2
ip link set dev myDocker0 down
brctl delbr myDocker0
