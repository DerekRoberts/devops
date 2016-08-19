#!/bin/bash
#
# Exit on errors or unitialized variables
#
set -e -o nounset


# Bug fix - ubuntu-xenial 16.04 hostname missing
# https://bugs.launchpad.net/ubuntu/+source/livecd-rootfs/+bug/1561250
#
if (! grep --quiet '127.0.1.1 ubuntu-xenial' /etc/hosts )
then
  (
    echo
    echo '# Bug fix - ubuntu-xenial 16.04 hostname missing'
    echo '127.0.1.1 ubuntu-xenial'
  ) | tee -a /etc/hosts
fi


# Start synchronized folder (/vagrant/)
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


# Update clock (can skew when VM put to sleep)
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
