# Dockerfile

## Dockerfile
### How to build docker image
```
docker build --build-arg WORKDIR_PATH=<project_folder_name> -t my_image_name .

# Example: docker build --build-arg WORKDIR_PATH=/home/ftp_home/inrsteg -t my_image_name .
```

## How to use run.sh file

To create and run a Docker container using the `run.sh` file, follow these steps:

1. **Ensure Docker is installed**: Make sure Docker is installed and running on your machine. You can download Docker from [here](https://www.docker.com/get-started).

2. **Create the `run.sh` file**: Create a shell script file named `run.sh` with the following content:

    ```sh
    #!/bin/bash

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
    --volume <project_folder_name>:/workspace \
    --workdir /workspace \
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
    ```
    ⚠️ Replace `<project_folder_name>` with the path to the local directory you want to use as the working directory in the Docker container.

    This script does two things:
    - Creates a Docker container with the specified user name, container name, image, and port.
    - Sets up the container with necessary permissions and installs essential packages.
    - Attaches to the running container for interactive use.

3. **Make the `run.sh` file executable**: Run the following command to make the `run.sh` file executable:

    ```sh
    chmod +x run.sh
    ```

4. **Execute the `run.sh` file**: Run the script to build the Docker image and start the container:

    ```sh
    sh run.sh <USER_NAME> <CONTAINER_NAME> <IMAGE> <PORT>
    # 예: sh run.sh sojeong.song my-docker-container pytorch/pytorch 8080
    ```

5. **Verify the container is running**: You can verify that the container is running by using the following command:

    ```sh
    docker ps -a
    ```

    This command will list all running containers. You should see `my-docker-container` in the list.

6. **Run the `setup.sh` file**: To automatically install the necessary libraries and packages, you can use the `setup.sh` script. Execute the script with the following command:

    ```sh
    #!/bin/bash
    CONTAINER_NAME=$1

    echo "CONTAINER_NAME: $CONTAINER_NAME"

    # Install system packages
    docker exec -u 0 $CONTAINER_NAME bash -c "apt-get update -y"

    # Install python packages
    docker exec -u 0 $CONTAINER_NAME python3 -m pip install --no-cache-dir <package_name>
    docker exec -u 0 $CONTAINER_NAME pip install <package_name>
    ```
    This will ensure that all required libraries and packages are installed in the Docker container.