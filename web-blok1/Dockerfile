FROM cs-ubuntu-systemd

COPY init/ /opt/init/
WORKDIR /opt/init

# the target directory for the cs-bootstrap scripts is symlinked to /etc/cs-bootstrap
COPY init/cs-bootstrap/ /opt/cs-bootstrap/etc/

# Copy the network config. We do not have to run `netplan apply` (nor can we, as systemd is not yet running), 
# as this is done by systemd-networkd automatically on boot.
COPY --chown=root:root --chmod=600 init/netplan.yaml /etc/netplan/100-netcfg.yaml

# Install some packages, network access in the container is not needed 
# During the build the host network is used 
# (we are altering files in the image, the container is not started in its context yet). 
# note that we can also install packages using cs-bootstrap scripts.
RUN apt-get update && apt-get install -y \
    python3-dev \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-pip \
    python3-setuptools \
    python3-venv \
    && apt-get clean
ENV FLASK_APP=secretsapp
ENV FLASK_RUN_HOST=0.0.0.0
EXPOSE 80
