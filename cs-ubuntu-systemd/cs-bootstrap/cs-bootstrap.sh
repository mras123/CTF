#!/bin/bash
#   ^-------- I'm a "shebang", I tell a shell what program to interpret this script with, in this case bash (Bourne Again SHell)
#             For this to work this script must be 'executable' (chmod +x init.sh)

# This script is run when the container is started, it is used to initialize the database
# This script is run as root, so you can install packages if needed

# run this script from the config directory
cd /etc/cs-bootstrap

if ! test -f /etc/cs-bootstrap/installed; then
  echo "Running cs-bootstrap.sh for the first time"

  source /etc/cs-bootstrap/runonce.sh


  # create a file to indicate that the script has been run
  touch /etc/cs-bootstrap/installed

fi

echo "Stuff that needs to be run every time"
source /etc/cs-bootstrap/runalways.sh







