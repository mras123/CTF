FROM cs-ubuntu-systemd


COPY init/ /opt/init/
WORKDIR /opt/init

#the target directory for the cs-bootstrap scripts is symlinked to /etc/cs-bootstrap
COPY init/cs-bootstrap/ /opt/cs-bootstrap/etc/

#Copy the network config. We do not have to run netplan apply (nor can we, as systemd is not yet running),
#as this is done by systemd-networkd automatically on boot.
COPY --chown=root:root --chmod=600 init/netplan.yaml /etc/netplan/100-netcfg.yaml

#Install some packages, network access in the container is not needed
#During the build the host network is used
#(we are altering files in the image, the container is not started in its context yet).
#note that we can also install packages using cs-bootstrap scripts.
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    mysql-server \
    mysql-client
#bind mysql to all interfaces
RUN sed -i "/bind-address/c\bind-address=0.0.0.0" /etc/mysql/mysql.conf.d/mysqld.cnf
EXPOSE 3306/tcp

#cs-ubuntu-systemd will run systemd in the container, so we can interact with it like a proper VM.