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
IMG_BASE=alpine-caddy


# Create Caddy S2I image
#
oc new-build https://github.com/BCDevOps/s2i-caddy.git --name="${IMG_NAME}"
