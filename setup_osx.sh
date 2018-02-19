#!/bin/bash
#
set -eux


# Install Homebrew
#
which brew || \
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


# Brew install packages
#
PACKAGES="git ssh wget"
for p in $PACKAGES
do
	which $p || brew install $p
done


# Brew cask install packages
#
PACKAGES="atom google-chrome minishift"
for p in $PACKAGES
do
	which $p || brew cask install $p
done


# Configure git
#
git config --global --get push.default ||
	git config --global push.default simple
git config --global --get user.email &&
	git config --global --get user.name ||
	git config --global --edit


# Prevent ssh timeouts
#
TARGET="/etc/ssh/ssh_config"
CONFIG="ServerAliveInterval 60"
grep --quiet "${CONFIG}" "${TARGET}" ||
	echo "	${CONFIG}" | sudo tee -a ${TARGET}


# Ensure bash shell script exists
#
BASHSS=~/.bash_profile
touch "${BASHSS}"


# Customize/shorten bash prompt
#
grep --quiet 'export PS1' "${BASHSS}" ||
	(
		echo ;
		echo "# Bash prompt";
		echo "#";
		echo 'export PS1="\u@\h:\W$ "'
	) >> "${BASHSS}"


# Aliases
#
grep --quiet 'alias l=' "${BASHSS}" ||
        (
                echo ;
                echo "# Aliases";
                echo "#";
                echo "alias dev='cd /Users/derobert/Google\ Drive/Repos'";
                echo "alias ll='ls -l'"
        ) >> "${BASHSS}"
