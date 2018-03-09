#!/bin/bash
#
set -eu


# Build settings
#
IMG_NAME="${IMG_NAME:-caddy-docker-s2i}"
APP_NAME="${APP_NAME:-caddy-static-page}"
#
IMG_REPO="${IMG_REPO:-https://github.com/BCDevOps/s2i-caddy.git}"
MSG_REPO="${MSG_REPO:-https://github.com/DerekRoberts/static-dump}"


# Server settings
#
OC_SERVER="${OC_SERVER:-https://console.pathfinder.gov.bc.ca:8443}"


# Verbose option
#
VERBOSE="${VERBOSE:-false}"
[ "${VERBOSE}" != "true" ]|| set -x


# Show message if passed any params
#
if [ "${#}" -ne 0 ]
then
	echo
	echo "Deploy Caddy to allow maintenance or downtime messages."
	echo
	echo "Set variables to non-defaults at runtime.  E.g.:"
	echo " 'VERBOSE=true ./caddy_deploy.sh'"
	echo
	exit
fi


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
                open "${OC_SERVER}"/oauth/token/request

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
	oc new-build "${IMG_REPO}" --name="${IMG_NAME}"
else
	echo
	echo "Buildconfig or imagestream already exist"
	echo
	echo "View with:"
	echo " 'oc get bc' and"
	echo " 'oc get is'"
	echo
fi


# Create new app from S2I image and static repo
#
if( !( oc get bc; oc get is; oc get bc; oc get svc )| grep -o "${APP_NAME}" )
then
	oc new-app "${IMG_NAME}"~"${MSG_REPO}" --name="${APP_NAME}"
else
	echo
	echo "Buildconfig, imagestream, deploymentconfig or service already exist."
	echo
	echo "View with:"
	echo " 'oc get bc'"
	echo " 'oc get is'"
	echo " 'oc get dc' and"
	echo " 'oc get svc'"
	echo
fi


# Expose application (route)
#
if( !( oc get routes )| grep -o "${APP_NAME}" )
then
	oc expose svc/${APP_NAME}
else
	echo
	echo "Route already exists."
	echo
	echo "View with:"
	echo " 'oc get routes'"
	echo
fi
