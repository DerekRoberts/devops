#!/bin/bash
#
set -eux


# Prevent SSH timeouts
#
TARGET="/etc/ssh/ssh_config"
CONFIG="ServerAliveInterval 60"
if( ! grep --quiet ${CONFIG} ${TARGET} )
then
    echo "    ${CONFIG}" | sudo tee -a ${TARGET}
fi


# Insync GPG key and source file
#
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
echo "deb http://apt.insynchq.com/ubuntu xenial non-free contrib" |\
    sudo tee /etc/apt/sources.list.d/insync.list


# Google Chrome key and source file
#
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub |\
    sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" |\
    sudo tee /etc/apt/sources.list.d/google-chrome.list


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
  git \
  google-chrome-stable \
  insync \
  linux-headers-generic \
  linux-headers-$( uname -r ) \
  make \
  unattended-upgrades \ 
  vagrant \
  virtualbox \
  vlc


# Set Git Push Default (suppress messages) and User Details
#
git config --global push.default simple
git config --global user.email "Derek.Roberts@gmail.com"
git config --global user.name "Derek Roberts"


# Automatic Security Upgrades
#
sudo dpkg-reconfigure --priority=low unattended-upgrades


# +Automatic Recommended Upgrades
#
sudo sed -i -e '/${distro_id}.*updates/s/^\/\///' /etc/apt/apt.conf.d/50unattended-upgrades


# +Automatic Weekly Autoclean
#
sudo sed -i '/APT::Periodic::AutocleanInterval/s/"0"/"7"/' /etc/apt/apt.conf.d/10periodic


# Download and kick off Dropbox installer
#
wget -O /tmp/dbdl.deb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb"
sudo dpkg -i /tmp/dbdl.deb
rm /tmp/dbdl.deb
/usr/bin/dropbox start -i



# Global Shortcuts from file
#
wget -qO ~/.config/kglobalshortcutsrc "https://raw.githubusercontent.com/DerekRoberts/devops/master/kde/kglobalshortcutsrc"


# Cleanup
#
sudo apt install -f
sudo apt autoremove -y
sudo update-grub


# Bash
#
if( ! grep --quiet "~/Dropbox/Repos" ~/.bashrc )
then
  ( \
    echo ""; \
    echo "# Directory Shortcuts"; \
    echo "#"; \
    echo "alias dev='cd ~/Dropbox/Repos'"; \
  ) | tee -a ~/.bashrc
fi
