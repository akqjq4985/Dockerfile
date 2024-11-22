#!/bin/bash
# usage: sh push.sh inrsteg inrsteg v1.0.0 "description for this version"
# 설정할 변수들
DOCKER_NAME=$1          # Docker 컨테이너 이름
WANTED_PACKAGE_NAME=$2 # 원하는 패키지 이름
TAG=$3                             # 태그
DESCRIPTION=$4       # 이미지 설명
GITHUB_USER_NAME="akqjq4985"  # GitHub 사용자 이름

# 이미지 커밋 (설명 추가)
docker commit --change "LABEL org.opencontainers.image.description='$DESCRIPTION'" $DOCKER_NAME $WANTED_PACKAGE_NAME:$TAG

# 이미지 태그 설정
docker tag $WANTED_PACKAGE_NAME:$TAG ghcr.io/$GITHUB_USER_NAME/$WANTED_PACKAGE_NAME:$TAG

# GitHub Container Registry로 푸시
docker push ghcr.io/$GITHUB_USER_NAME/$WANTED_PACKAGE_NAME:$TAG

echo "Docker image has been successfully committed, tagged, and pushed!"