FROM ubuntu:latest

# this is needed to prevent asking for user input
ARG DEBIAN_FRONTEND=noninteractive

# unminimize the ubuntu image to get a more complete system
# the | and yes are needed to prevent asking for user input
# the | is the 'pipe operator', it pipes the output of the command
# on the left to the input of the command on the right
RUN yes | unminimize

# Apt is the 'package manager' for Ubuntu and Debian Linux distributions
RUN apt-get update ; \
    apt-get install -y systemd \
      systemd-sysv \
      iproute2 \
      udev \
      netplan.io \
      iputils-ping \
      vim \
      curl \
      git \
      gnupg \
      wget \
      curl \
      lsof \
      sudo ;\
    apt-get clean ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ; \
    cd /lib/systemd/system/sysinit.target.wants/ ; \
    ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 ; \
    rm -f /lib/systemd/system/multi-user.target.wants/* ; \
    rm -f /etc/systemd/system/*.wants/* ; \
    rm -f /lib/systemd/system/local-fs.target.wants/* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* ; \
    rm -f /lib/systemd/system/basic.target.wants/* ; \
    rm -f /lib/systemd/system/anaconda.target.wants/* ; \
    rm -f /lib/systemd/system/plymouth* ; \
    rm -f /etc/machine-id ; \
    rm -f /var/lib/dbus/machine-id ; \
    rm -f /lib/systemd/system/systemd-update-utmp*


VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

# Copy the bootstrap script
# Neat trick to run our cs-bootstrap after everything else, see: http://www.mauras.ch/systemd-run-it-last.html
COPY --chown=root:root cs-bootstrap/systemd/installed.target /etc/systemd/system/installed.target
COPY --chown=root:root cs-bootstrap/systemd/bootstrap.service /etc/systemd/system/cs-bootstrap.service
COPY --chown=root:root --chmod=550 cs-bootstrap/cs-bootstrap.sh /opt/cs-bootstrap/cs-bootstrap.sh

RUN ln -sf /etc/systemd/system/installed.target /etc/systemd/system/default.target

RUN mkdir -p /opt/cs-bootstrap/etc
RUN ln -sf /opt/cs-bootstrap/etc /etc/cs-bootstrap

# enable networking support at boot
RUN systemctl enable systemd-networkd.service
RUN systemctl enable cs-bootstrap.service



CMD ["/lib/systemd/systemd"]
