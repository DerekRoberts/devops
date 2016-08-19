#!/bin/bash
#
# Exit on errors or unitialized variables
#
set -e -o nounset


# Vagrant SSH starts in the Vagrant (synchronized) folder
#
if (! grep --quiet 'cd /vagrant/' /home/ubuntu/.bashrc )
then
  (
    echo
    echo
    echo '# Start in Vagrant (sync) directory'
    echo '#'
    echo 'cd /vagrant/'
  ) | tee -a /home/ubuntu/.bashrc
fi


# Update clock (skews when VM put to sleep)
#
if (! grep --quiet 'ca.pool.ntp.org' /home/ubuntu/.bashrc )
then
  (
    echo
    echo
    echo '# Fix for Vagrant clock skew'
    echo '#'
    echo "sudo ntpdate ca.pool.ntp.org"
  ) | tee -a /home/ubuntu/.bashrc
fi


# Update and install packages
#
apt-get update
apt-get upgrade -y
apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  lynx \
  nmap \
  ntpdate \
  virtualbox-guest-utils
apt-get autoremove -y


# NodeJS
#
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
apt-get install -y nodejs
