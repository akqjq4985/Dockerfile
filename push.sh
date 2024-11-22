#!/bin/bash
# usage: sh push.sh inrsteg inrsteg v1.0.0 "description for this version"

DOCKER_NAME=$1
WANTED_PACKAGE_NAME=$2
TAG=$3
DESCRIPTION=$4
GITHUB_USER_NAME="akqjq4985"

echo "DOCKER_NAME: $DOCKER_NAME"
echo "WANTED_PACKAGE_NAME: $WANTED_PACKAGE_NAME"
echo "TAG: $TAG"
echo "DESCRIPTION: $DESCRIPTION"

docker commit --change "LABEL org.opencontainers.image.description='$DESCRIPTION'" $DOCKER_NAME $WANTED_PACKAGE_NAME:$TAG
docker tag $WANTED_PACKAGE_NAME:$TAG ghcr.io/$GITHUB_USER_NAME/$WANTED_PACKAGE_NAME:$TAG
docker push ghcr.io/$GITHUB_USER_NAME/$WANTED_PACKAGE_NAME:$TAG
echo "Docker image has been successfully committed, tagged, and pushed!"