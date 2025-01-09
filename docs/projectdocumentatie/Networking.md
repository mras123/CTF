# Router Configuration for Network Monitoring and Maintenance

To ensure continuous network connectivity for access to the Secret Manager and Security Dashboard, proper router configuration is essential. Below is a guide on how to maintain network connectivity via the router.

### Docker Configuration

The router is utilized as a networking device to manage traffic and ensure continuous connectivity.The router handles routing and forwarding packets between different networks.

### Monitoring with Reverse Proxy (Nginx)

Reverse proxy servers like Nginx can be used for network monitoring by intercepting incoming requests and directing them to the appropriate backend servers based on predefined rules. Here's how you can monitor network traffic using Nginx commands:

Access Logs: Nginx access logs provide valuable information about incoming requests, including client IP addresses, request URLs, response status codes, and response sizes. You can analyze these logs to identify patterns, detect anomalies, and troubleshoot issues related to network connectivity.


# Enable Nginx status module in the configuration file (nginx.conf)

server {

    listen 80;
    server_name localhost;
    location /nginx_status {
        stub_status on;
        access_log off;
        allow 127.0.0.1;
        deny all;
    }
}


## Router Configuration

### Port mapping Configuration

We utilize port forwarding on the router to ensure access to specific services such as the Secret Manager and Security Dashboard. Below is the port forwarding configuration:

```yaml
  router:
    container_name: cs-blok-3-router-1
    build: router
    hostname: router
    ports:
      # mapping port 8080 on the router to port 8080 on the Secret Manager
      - "8080:80"

 # mapping port 443 on the router to port 443 on the Security Dashboard
      - "4430:443"
      # dashboard:
      # - "8000:8088"
      # ssh:
      - "2222:22"
```
With this configuration, the Secret Manager is reachable at port 8080 and the Security Dashboard at port 8000 externally through the router 

### Network Configuration for Secret Manager

The network configuration for the Secret Manager is as follows:

```yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: false
      dhcp6: false
      addresses:
        - 192.168.1.10/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```

### Network Configuration for Security Dashboard

The network configuration for the Security Dashboard is as follows:

```yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: false
      dhcp6: false
      addresses:
        - 192.168.2.10/24
      routes:
        - to: default
          via: 192.168.2.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```


# Network Uptime: 99.9% Over a Specific Period

We will assess the network uptime of 99.9% over a specific period using the ICMP protocol. ICMP (Internet Control Message Protocol) is a network protocol used to report errors and exchange control messages between network devices.

One common use of ICMP is the "ping" command, which sends ICMP echo request packets to a target device and waits for ICMP echo reply packets. This process verifies the reachability of a device and measures the round-trip time for packets to travel to and from the target. By continuously monitoring ICMP responses, we can determine the network uptime percentage over the designated period.


# Network Uptime: 99.9% Over a Specific Period (Secret Manager)

We have conducted ICMP ping tests on the Secret Manager using its IP address 192.168.1.10. The network uptime is calculated to be 99.9% if none of the packets sent during the testing period have been dropped.

# ping 192.168.1.10 (Secret Manager)

- **PING 192.168.1.10 (192.168.1.10) 56(84) bytes of data.**
- **64 bytes from 192.168.1.10: icmp_seq=1 ttl=64 time=3.31 ms**

- **64 bytes from 192.168.1.10: icmp_seq=2 ttl=64 time=0.771 ms**

- **64 bytes from 192.168.1.10: icmp_seq=3 ttl=64 time=0.651 ms**

- **64 bytes from 192.168.1.10: icmp_seq=4 ttl=64 time=0.624 ms**

- **64 bytes from 192.168.1.10: icmp_seq=5 ttl=64 time=0.626 ms**

- **64 bytes from 192.168.1.10: icmp_seq=6 ttl=64 time=0.525 ms**

- **64 bytes from 192.168.1.10: icmp_seq=7 ttl=64 time=0.465 ms**

- **64 bytes from 192.168.1.10: icmp_seq=8 ttl=64 time=0.782 ms**

^C
--- 192.168.1.10 ping statistics ---
8 packets transmitted, 8 received, 0% packet loss, time 7218ms

# Network Uptime: 99.9% Over a Specific Period (Security Dashboard)

We have conducted ICMP ping tests on the Security Dashboard using its IP address 192.168.2.10. The network uptime is calculated to be 99.9% if none of the packets sent during the testing period have been dropped.

# ping 192.168.2.10 (Security Dashboard)

- **PING 192.168.2.10 (192.168.2.10) 56(84) bytes of data**

- **64 bytes from 192.168.2.10: icmp_seq=1 ttl=64 time=4.02 ms**

- **64 bytes from 192.168.2.10: icmp_seq=2 ttl=64 time=0.811 ms**

- **64 bytes from 192.168.2.10: icmp_seq=3 ttl=64 time=0.553 ms**

- **64 bytes from 192.168.2.10: icmp_seq=4 ttl=64 time=0.789 ms**

- **64 bytes from 192.168.2.10: icmp_seq=5 ttl=64 time=0.792 ms**

- **64 bytes from 192.168.2.10: icmp_seq=6 ttl=64 time=0.808 ms**

- **64 bytes from 192.168.2.10: icmp_seq=7 ttl=64 time=0.527 ms**

- **64 bytes from 192.168.2.10: icmp_seq=8 ttl=64 time=0.618 ms**

^C
--- 192.168.2.10 ping statistics ---
8 packets transmitted, 8 received, 0% packet loss, time 7275ms


