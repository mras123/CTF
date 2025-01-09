#!/bin/sh
#   ^-------- I'm a "shebang", I tell the shell what program to interpret this script with, in this case sh (shell)
#             For this to work this script must be 'executable'

# This script is copied to your docker image once and is run every time you start the container.
# if you make changes to this file in your repo, you need to recreate your docker image
# (docker compose --build) for them to take effect.

# "ip" is the default network tool in linux, it is used to configure network interfaces and routing tables.
# the following adds a default route to the routing table, so that all traffic not on the local network will be sent to our router

# FIXME: network interfaces in docker are non-deterministic, so we shouldn't hardcode eth0, .. here
#    ^------ FIXME is a comment that is used to mark something that needs to be fixed, it is used to find problems in the code by searching for FIXME
#            in this case it does not mean that the code is broken, but that it is not optimal, it also does not mean you have to fix it :)

# variables
EXT_IFACE="eth0"
DMZ_IFACE="eth3"
BLOK1_IFACE="eth1"
BLOK2_IFACE="eth2"
BLOK1_WEB="192.168.1.10"
BLOK2_WEB="192.168.2.10"
PROXY_IP="10.0.1.2"
ROUTER_IP="10.0.1.3"


# blok 1
/sbin/ip address add 192.168.1.1/24 dev $BLOK1_IFACE
# blok 2
/sbin/ip address add 192.168.2.1/24 dev $BLOK2_IFACE
# we only add 30 addresses to the third block, because we only need 1 for the reverse proxy and 1 for the router
/sbin/ip address add 10.0.1.1/27 dev $DMZ_IFACE

# add NAT on all interfaces to allow internet access via eth0
/sbin/sysctl -w net.ipv4.ip_forward=1

/sbin/iptables -t nat -A POSTROUTING -o $EXT_IFACE -j MASQUERADE

/sbin/iptables -A FORWARD -i eth0 -o eth3 -m state --state RELATED,ESTABLISHED -j ACCEPT


# traffic from reverse proxy
/sbin/iptables -A FORWARD -i eth3 -o eth0 -j ACCEPT
/sbin/iptables -A FORWARD -i eth3 -o eth1 -j ACCEPT
/sbin/iptables -A FORWARD -i eth3 -o eth2 -j ACCEPT

# traffic from webservers
/sbin/iptables -A FORWARD -i eth1 -o eth3 -j ACCEPT
/sbin/iptables -A FORWARD -i eth2 -o eth3 -j ACCEPT

# accept traffic to eth2 from outside
/sbin/iptables -A FORWARD -i eth0 -o eth2 -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i eth2 -o eth0 -j ACCEPT

# accept traffic to eth1 from outside
/sbin/iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

# route to reverse proxy
/sbin/iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination $PROXY_IP:80
/sbin/iptables -A FORWARD -p tcp -d $PROXY_IP --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT


/sbin/iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to-destination $PROXY_IP:443
/sbin/iptables -A FORWARD -p tcp -d $PROXY_IP --dport 443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# allow icmp traffic to router
/sbin/iptables -t nat -A PREROUTING -i eth0 -p icmp -j DNAT --to-destination $ROUTER_IP
/sbin/iptables -A FORWARD -p icmp -d $ROUTER_IP -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# allow ssh traffic to router
/sbin/iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 22 -j DNAT --to-destination $ROUTER_IP
/sbin/iptables -A FORWARD -p tcp -d $ROUTER_IP --dport 22 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT



