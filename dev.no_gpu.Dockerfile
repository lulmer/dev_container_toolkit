# Use the Python base image
ARG PYTHON_VERSION
ARG DEBIAN_DISTRIB
FROM mcr.microsoft.com/devcontainers/python:${PYTHON_VERSION}-${DEBIAN_DISTRIB} AS dev-base

# Can be usefull to not have a timeout when doing apt update since thoses sources
# could be missing from the whitelist
RUN rm -rf /etc/apt/sources.list.d/yarn.list

# In case you need to install packages 
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends your_favorite_package

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
