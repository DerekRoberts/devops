#!/bin/bash


# Halt conditions, verbosity and field separator
#
set -euo pipefail
[ "${VERBOSE:-false}" != true ]|| set -x
IFS=$'\n\t'


# Ensure bash shell script exists and store its checksum
#
BASHSS=~/.bash_profile
touch "${BASHSS}"
BASHSS_CHECKSUM=$( md5 -q "${BASHSS}" )


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
PACKAGES=(
	"git"
	"wget"
)
for p in ${PACKAGES[@]}
do
	brew list $p || brew install $p
done


# Brew cask install packages
#
PACKAGES=(
	"atom"
	"delayedlauncher"
	"google-chrome"
	"iterm2"
	"skype-for-business"
)
for p in ${PACKAGES[@]}
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


# Install minishift
#
DL_FIND="$( find ~/Downloads -maxdepth 1 -name 'cdk-*-minishift-darwin-amd64' )"
if( ! which minishift )
then
	if( [ -z "${DL_FIND}" ] );
	then
		tput bel
		echo
		echo "Please download Red Hat's Minishift!  A window will open shortly."
		echo
		echo "Place cdk-* in ~/Downloads and this script will move it."
		echo
		sleep 5
		open https://developers.redhat.com/download-manager/file/cdk-3.3.0-1-minishift-darwin-amd64
	fi
	while ( ! which minishift );
	do
	        echo
		find ~/Downloads -maxdepth 1 -name 'cdk-*-minishift-darwin-amd64' -exec chmod +x '{}' \; -exec mv '{}' /usr/local/bin/minishift \;
	        sleep 10
	done
fi


# Install minishift CDK components
#
[ -d ~/.minishift ]|| \
	minishift setup-cdk


# Set minishift hypervisor to virtualbox
#
[ "$( minishift config get vm-driver )" == "virtualbox" ] || \
	minishift config set vm-driver virtualbox


# Put alias to oc in path
#
[ -f /usr/local/bin/oc ]||
	ln -s ~/.minishift/cache/oc/v3.7.14/darwin/oc /usr/local/bin/oc


# Set Red Hat Developer username and password (to dl container images)
#
if([ -z "${MINISHIFT_USERNAME+x}" ]||[ -z "${MINISHIFT_PASSWORD+x}" ])
then
	echo
	read -p "Red Hat Username: " MINISHIFT_USERNAME
	while [ true ]
	do
		echo
		read -s -p "Red Hat Password: " MINISHIFT_PASSWORD
		echo
		read -s -p "Confirm Password: " CONFIRM_PW
		echo
		[ "${MINISHIFT_PASSWORD}" != "${CONFIRM_PW}" ]|| \
			break
		echo "Passwords do not match.  Please try again."
	done
fi


# Minishift variables
#
if( ! grep --quiet 'export MINISHIFT_USERNAME=' "${BASHSS}" || \
	! grep --quiet "export MINISHIFT_PASSWORD=" "${BASHSS}" )
then
	echo
	echo "Add the following to ${BASHSS}?"
	echo "Red Hat Username: ${MINISHIFT_USERNAME}"
	echo "Red Hat Password: <hidden>"
	echo
	read -n 1 -p "(y|n):" yORn
	echo
        if([ "${yORn}" == "y" ]||[ "${yORn}" == "Y" ])
	then
		(
			echo ;
			echo "# OpenShift variables";
			echo "#";
			echo "export MINISHIFT_USERNAME=${MINISHIFT_USERNAME}";
			echo "export MINISHIFT_PASSWORD=${MINISHIFT_PASSWORD}";
		) >> "${BASHSS}"
	fi
fi


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
                echo "alias ll='ls -l'"
        ) >> "${BASHSS}"


# Recommend sourcing ~/.bash_profile if the file has changed
#
if [ "${BASHSS_CHECKSUM}" != $( md5 -q "${BASHSS}" ) ]
then
	echo
	echo "Warning: ~/.bash_profile has changed!  To source it type:"
	echo
	echo "source ~/.bash_profile "
fi
echo
