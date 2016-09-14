#!/bin/bash
#
# Endpoint deployment kick-off script


# Halt on errors or uninitialized variables
#
set -e -o nounset


# Install make and git
#
sudo apt-get install make git -y


# Directories and Endpoint repo
#
sudo mkdir -p /hdc/
sudo chown $( whoami ):$( whoami ) /hdc/
git clone https://github.com/hdcbc/endpoint /hdc/endpoint


# Start scripts in repo
#
cd /hdc/endpoint
make hdc
