#!/bin/bash
#
set -eux


# Vars, incl. image name and base
#
IMG_NAME=caddy-docker-s2i
IMG_BASE=alpine-caddy


# Create Caddy S2I image
#
oc new-build https://github.com/BCDevOps/s2i-caddy.git --name="${IMG_NAME}"
