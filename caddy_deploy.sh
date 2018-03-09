#!/bin/bash
#
set -eu


# Verbose option
#
[ ! -z "${VERBOSE+x}" ]&&[ "${VERBOSE}" == true ]&& \
	set -x


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


# Vars, incl. image name and base
#
IMG_NAME=caddy-docker-s2i
GET_BC=$( oc get bc "${IMG_NAME}" | grep -o "${IMG_NAME}" )
GET_IS=$( oc get is "${IMG_NAME}" | grep -o "${IMG_NAME}" )


# Create Caddy S2I image
#
echo
if [ ! -z "${GET_BC}" ] && [ ! -z "${GET_IS}" ]
then
	echo "Buildconfig or imagestream already exist, skipping creation"
	echo
	echo "View with:"
	echo " 'oc get bc' and"
	echo " 'oc get is'"
else
	oc new-build https://github.com/BCDevOps/s2i-caddy.git --name="${IMG_NAME}"
fi


# Create new app from S2I image and static repo
#
APP_NAME=caddy-static-page
oc new-app caddy-docker-s2i~https://github.com/DerekRoberts/static-dump \
	--name="${APP_NAME}"
