FROM cs-ubuntu-systemd


COPY init/ /opt/init/
WORKDIR /opt/init

# the target directory for the cs-bootstrap scripts is symlinked to /etc/cs-bootstrap
# COPY init/cs-bootstrap/ /opt/cs-bootstrap/etc/

# Copy the network config. We do not have to run `netplan apply` (nor can we, as systemd is not yet running), 
# as this is done by systemd-networkd automatically on boot.
COPY --chown=root:root --chmod=600 init/netplan.yaml /etc/netplan/100-netcfg.yaml


RUN apt-get update && apt-get install -y nginx \ 
    traceroute

EXPOSE 443 80 8088 22
