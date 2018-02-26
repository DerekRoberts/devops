#!/bin/bash
#
set -eux


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
PACKAGES="atom google-chrome iterm2 minishift skype-for-business"
for p in $PACKAGES
do
	brew cask list $p || brew cask install $p
done


# Configure git
#
git config --global --get push.default || \
	git config --global push.default simple
git config --global --get user.email && \
	git config --global --get user.name || \
	git config --global --edit
git config --global --get core.autocrlf || \
	git config --global core.autocrlf input


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
