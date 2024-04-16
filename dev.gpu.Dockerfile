# Use the Python base image
ARG PYTHON_VERSION
ARG DEBIAN_DISTRIB
FROM mcr.microsoft.com/devcontainers/python:${PYTHON_VERSION}-${DEBIAN_DISTRIB} AS dev-base

# From Ubuntu -> Debian. Let's pray...
COPY --from=nvcr.io/nvidia/cuda:12.2.2-devel-ubuntu22.04 /usr/local/cuda /usr/local/cuda
COPY --from=nvcr.io/nvidia/cuda:12.2.2-devel-ubuntu22.04 /usr/local/cuda-12 /usr/local/cuda-12
COPY --from=nvcr.io/nvidia/cuda:12.2.2-devel-ubuntu22.04 /usr/local/cuda-12.2 /usr/local/cuda-12.2

# Set the environment variables for CUDA
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV CUDA_HOME="/usr/local/cuda-12.2"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"
ENV NCCL_SOCKET_IFNAME=eth0

RUN rm -rf /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libaio-dev \
    openssh-server \
    tmux \
    pdsh 

USER vscode

# Define the version of Poetry to install
# Define the directory of python virtual environment
ARG PYTHON_VIRTUALENV_HOME=/home/vscode/py-env \
    POETRY_VERSION

ENV POETRY_VIRTUALENVS_IN_PROJECT=false \
    POETRY_NO_INTERACTION=true 

# Create a Python virtual environment for Poetry and install it
RUN python3 -m venv ${PYTHON_VIRTUALENV_HOME} && \
    $PYTHON_VIRTUALENV_HOME/bin/pip install --upgrade pip && \
    $PYTHON_VIRTUALENV_HOME/bin/pip install poetry==${POETRY_VERSION}

ENV PATH="$PYTHON_VIRTUALENV_HOME/bin:$PATH" \
    VIRTUAL_ENV=$PYTHON_VIRTUALENV_HOME

# Setup for bash
RUN poetry completions bash >> /home/vscode/.bash_completion && \
    echo "export PATH=$PYTHON_VIRTUALENV_HOME/bin:$PATH" >> ~/.bashrc

# Persist bash history
RUN echo "export PROMPT_COMMAND='history -a' && export HISTFILE=/workspaces/.devcontainer/.bash_history" >> ~/.bashrc

RUN mkdir -p $HOME/.ssh

# Set the working directory for the app
WORKDIR /workspaces/


# For production
# COPY .. .
# RUN poetry install
# ENTRYPOINT python main.py

CMD ["sleep", "infinity"]
