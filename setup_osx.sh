#!/bin/bash
#
set -eux


# Install Homebrew
#
which brew || \
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


# Install packages
#
PACKAGES="git ssh wget"
for p in $PACKAGES
do
	which $p || brew install $p
done
