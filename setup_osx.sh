#!/bin/bash
#
set -eu


# Verbose option
#
[ ! -z "${VERBOSE+x}" ]&&[ "${VERBOSE}" == true ]&& \
	set -x


# Install Oracle JDK
#
which java ||( \
	tput bel
	echo
	echo "Please install Oracle's JDK!  A window will open shortly."
	echo
	sleep 5
	open http://www.oracle.com/technetwork/java/javase/downloads/index.html
)


# Install Homebrew
#
which brew || \
	/usr/bin/ruby -e "$( curl -fsSL \
	https://raw.githubusercontent.com/Homebrew/install/master/install )"


# Brew install packages
#
PACKAGES="git wget"
for p in $PACKAGES
do
	brew list $p || brew install $p
done


# Brew cask install packages
#
PACKAGES="atom google-chrome iterm2 skype-for-business vagrant virtualbox"
for p in $PACKAGES
do
	brew cask list $p || brew cask install $p
done


# Configure git
#
[ "$( git config --global --get push.default )" == "simple" ] || \
	git config --global push.default simple
[ "$( git config --global --get core.autocrlf)" == "input" ] || \
	git config --global core.autocrlf input
[ "$( git config --global --get user.email )" ] && \
	[ "( git config --global --get user.name)" ] || \
	git config --global --edit


# Prevent ssh timeouts
#
TARGET="/etc/ssh/ssh_config"
CONFIG="ServerAliveInterval 60"
grep --quiet "${CONFIG}" "${TARGET}" || \
	echo "	${CONFIG}" | sudo tee -a ${TARGET}


# Ensure bash shell script exists
#
BASHSS=~/.bash_profile
touch "${BASHSS}"


# Customize/shorten bash prompt
#
grep --quiet 'export PS1' "${BASHSS}" || \
	(
		echo ;
		echo "# Bash prompt";
		echo "#";
		echo 'export PS1="\u@\h:\W$ "'
	) >> "${BASHSS}"


# Aliases
#
grep --quiet 'alias dev=' "${BASHSS}" || \
        (
                echo ;
                echo "# Aliases";
                echo "#";
                echo "alias dev='cd /Users/derobert/Google\ Drive/Repos'";
                echo "alias ll='ls -l'"
        ) >> "${BASHSS}"


# Install minishift
#
( which minishift )||( \
	tput bel
	echo
	echo "Please download Red Hat's Minishift!  A window will open shortly."
	echo
	echo "Place cdk-* in ~/Downloads and grant this script access to move it."
	echo
	sleep 5
	open https://developers.redhat.com/download-manager/file/cdk-3.3.0-1-minishift-darwin-amd64
)
while ( ! which minishift );
do
        echo
	find ~/Downloads -maxdepth 1 -name 'cdk-*' -exec mv '{}' /usr/local/bin/minishift \;
	sudo chmod +x /usr/local/bin/minishift
        sleep 60
done


# Set minishift hypervisor to virtualbox
#
[ "$( minishift config get vm-driver )" == "virtualbox" ] || \
	minishift config set vm-driver virtualbox
