# know-docker
理解docker的一些原理

UTS namespace 提供了主机名和域名的隔离，这样每个容器就拥有独立的主机名和域名了，在网络上就可以被视为一个独立的节点，在容器中对 hostname 的命名不会对宿主机造成任何影响。
`gcc -o uts uts.c`
