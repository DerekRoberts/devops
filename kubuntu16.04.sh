#!/bin/bash
#
set -eux


# Insync GPG key and source file
#
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
echo "deb http://apt.insynchq.com/ubuntu xenial non-free contrib" | sudo tee /etc/apt/sources.list.d/insync.list


# Atom.io PPA
#
sudo add-apt-repository -y ppa:webupd8team/atom


# Packaes
#
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt install -y \
  atom \
  audacity \
  build-essential \
  comix \
  insync \
  linux-headers-generic \
  linux-headers-$( uname -r ) \
  vlc


# Dropbox
#
[ -s ~/.dropbox-dist/dropbox-lnx.x86_64*/dropbox ]|| \
  ( cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - )


# Cleanup
#
sudo apt-get install -f
sudo apt-get autoremove -y
sudo update-grub
