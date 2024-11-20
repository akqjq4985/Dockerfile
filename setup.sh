#!/bin/bash
# usage: sh setup.sh <CONTAINER_NAME>
# Example: sh setup.sh inrsteg
CONTAINER_NAME=$1

echo "CONTAINER_NAME: $CONTAINER_NAME"

# Install system packages
docker exec -u 0 $CONTAINER_NAME bash -c "apt-get update -y"

# Install python packages
docker exec -u 0 $CONTAINER_NAME python3 -m pip install --no-cache-dir <package_name>
docker exec -u 0 $CONTAINER_NAME pip install <package_name>