#!/bin/bash
#
# Endpoint deployment kick-off script


# Halt on errors or uninitialized variables and show steps
#
set -eu


# Install make and git
#
sudo apt-get install make git -y


# Directories and Endpoint repo
#
sudo mkdir -p /hdc/
sudo chown $( whoami ):$( whoami ) /hdc/
if [ ! -d /hdc/endpoint ]
then
    git clone https://github.com/hdcbc/endpoint /hdc/endpoint
else
    cd /hdc/endpoint
    git -C /hdc/endpoint pull
fi


# Start scripts in repo
#
cd /hdc/endpoint


# Provide direction
#
echo
echo
echo "Repository cloned to /hdc/endpoint"
echo
echo "Type one of the following to setup"
echo
echo "make"
echo "  - base install"
echo
echo "make hdc"
echo "  - HDC managed install"
echo
