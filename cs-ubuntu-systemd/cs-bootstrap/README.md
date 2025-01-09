# cs-bootstrap

This script is used to bootstrap a new machine. It is run by systemd on every boot. It will check if it has run before, and if not, it will run `/etc/cs-bootstrap/runonce.sh`  This is where you can put scripts that should run when the machine is created. After that it will run `/etc/cs-bootstrap/runalways.sh` which is where you can put scripts that should run on every boot.

You should not have to alter this script, but if you do, you will have to rebuild the cs-ubuntu-systemd docker image.