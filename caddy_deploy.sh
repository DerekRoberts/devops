#!/bin/bash
#
set -eu


# Default settings, change with environment variables
#
IMG_NAME="${IMG_NAME:-caddy-docker-s2i}"
APP_NAME="${APP_NAME:-caddy-static-page}"


# Verbose option
#
VERBOSE="${VERBOSE:-false}"
[ "${VERBOSE}" != "true" ]|| set -x


# Verify login
#
if( ! oc project )
then
	oc login || true
        echo "Paste this token into the command line"
        read -n 1 -p "Follow link? (y|n):" yORn
        echo

        # Open link if selected
        [ "${yORn}" != "y" ]&&[ "${yORn}" != "Y" ]|| \
                open https://console.pathfinder.gov.bc.ca:8443/oauth/token/request

        # Inform and exit
        echo
        echo "Exiting: not logged in"
        echo
        exit
fi


# Create Caddy S2I image
#
if( !( oc get bc; oc get is )| grep -o "${IMG_NAME}" )
then
	oc new-build https://github.com/BCDevOps/s2i-caddy.git --name="${IMG_NAME}"
else
	echo
	echo "Buildconfig or imagestream already exist, skipping creation"
	echo
	echo "View with:"
	echo " 'oc get bc' and"
	echo " 'oc get is'"
	echo
fi


# Create new app from S2I image and static repo
#
oc new-app caddy-docker-s2i~https://github.com/DerekRoberts/static-dump \
	--name="${APP_NAME}"
