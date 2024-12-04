#!/bin/bash
# usage: sh run.sh <USER_NAME> <CONTAINER_NAME> <IMAGE> <PORT>
# 예: sh run.sh sojeong.song diffusion pytorch/pytorch 8080

USER_NAME=$1
CONTAINER_NAME=$2
IMAGE=$3
PORT=$4

echo "USER_NAME: $USER_NAME"
echo "CONTAINER_NAME: $CONTAINER_NAME"
echo "IMAGE: $IMAGE"
echo "PORT: $PORT"

docker run -itd \
--user $(id -u):$(id -g) \
--volume /etc/passwd:/etc/passwd:ro \
--volume /etc/shadow:/etc/shadow:ro \
--volume /etc/group:/etc/group:ro \
--volume /etc/sudoers.d/:/etc/sudoers.d/ \
--volume /home/sojeong.song:/home/sojeong.song \
--workdir /home/sojeong.song \
--ipc=host \
--gpus all \
--name $CONTAINER_NAME \
-p $PORT:$PORT \
$IMAGE

if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Container $CONTAINER_NAME is running"
    docker exec -u 0 $CONTAINER_NAME bash -c "chown -R $(id -u):$(id -g) /workspace"
    docker container exec -u 0 $CONTAINER_NAME bash -c "DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y sudo -o Dpkg::Options::='--force-confnew' && \
    apt-get install -y zip && \
    apt-get install -y tmux && \
    apt-get install -y git -y"
    docker attach $CONTAINER_NAME
else
    echo "Failed to start container $CONTAINER_NAME"
fi
