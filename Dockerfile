FROM pytorch/pytorch:latest
ARG WORKDIR_PATH=/project_folder
WORKDIR ${WORKDIR_PATH}

COPY requirements.txt ${WORKDIR_PATH}/requirements.txt
RUN pip install --no-cache-dir -r ${WORKDIR_PATH}/requirements.txt

RUN apt-get update && \
    apt-get install -y sudo zip tmux git
