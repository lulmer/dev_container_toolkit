# 🚀 Welcome to Python DevSpace 🌌🐍
 
## Overview
Embark on a journey of seamless Python development! Our containerized setup ensures every developer works in a harmonious, consistent environment, free from local machine constraints.
 
## Features
- 🛡️ Isolated Docker Containers
- 🐍 Python Ready
- 📦 Poetry for Easy Dependency Management
- 💻 Seamless VSCode Integration
- 🔄 Persistent Data Volumes
- 🎮 NVIDIA GPU Support

## Getting Started
0. **Check prerequisites**: Run the commands in the `Docker configuration check` Section
1. **Clone and Setup**: Clone this repo and dive into the `.devcontainer` folder.
    ```shell
    git clone https://github.com/lulmer/dev_container_toolkit.git .devcontainer

    ```

3. **Setup**: In the `.devcontainer` folder:
    ```shell
    ./setup.sh
    ```
    You will be prompted to adapt the `.template.env`: do it ! Choose your `CONTAINER_BASENAME`, `PYTHON_VERSION`, `CACHE_FOLDER` during this stage.

3. **Launch**: Fire up VSCode, and let Dev Containers bring your dev environment to life! (`F1`>`Dev Containers: Reopen in Container` if you are not prompted to do so)


## Prerequisites
- Docker and Docker Compose **proxy-configured** (see `Docker configuration check` Section)
- Visual Studio Code with Dev Containers extension
- [Optional => for GPU project] [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installing-with-apt)
  
## Usage
- Your development workspace is set at `/workspaces` inside the container.
- Effortlessly manage Python packages with Poetry in VSCode.
 
## Clean Up
- Run `F1`>`Dev Containers: Clean Up Dev Containers`
 
---
 
## Docker configuration check

- **Step 0: Check `docker compose` CLI**
    - Check version with `docker compose version`: it should be at least `v2.25.0`.
    - If the version is lower
    ```shell
    sudo apt-get install docker-compose-plugin
    ```
    - Check in VSCode settings that `dev.containers.dockerComposePath` is set to `docker compose` (and not `docker-compose`)
 
- **Step 1: Make sure you don't have the ubuntu image**
    ```shell
    docker image rm ubuntu
    ```
 
- **Step 2: Run the 3-in-1 Command**
    ```shell
    docker run --rm ubuntu apt-get update
    ```
 
    *Expected Output:*
    ```
    Unable to find image 'ubuntu:latest' locally
    latest: Pulling from library/ubuntu
    a48641193673: Pull complete
    Digest: sha256:6042500cf4b44023ea1894effe7890666b0c5c7871ed83a97c36c76ae560bb9b
    Status: Downloaded newer image for ubuntu:latest
    Get:1 http://archive.ubuntu.com/ubuntu jammy InRelease [270 kB]
    ...
    Fetched 28.9 MB in 3s (8614 kB/s)
    Reading package lists...
    ```
 
    *Potential Errors:*
    - Can't use the docker CLI:
        ```
        docker: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/create": dial unix /var/run/docker.sock: connect: permission denied.
        See 'docker run --help'.
        ```
        ➡️ The user is not in the `docker` group, follow [these steps](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).
 
    - Unable to pull images:
        ```
        Unable to find image 'ubuntu:latest' locally
        docker: Error response from daemon: Get "https://registry-1.docker.io/v2/": net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers).
        See 'docker run --help'.
        ```
        ➡️ The Docker daemon (proxy) is not configured correctly, follow [these steps](https://docs.docker.com/config/daemon/systemd/#httphttps-proxy) to edit the `/etc/systemd/system/docker.service.d` file
 
    - The container cannot access the Internet:
        ```
        Unable to find image 'ubuntu:latest' locally
        latest: Pulling from library/ubuntu
        a48641193673: Pull complete
        Digest: sha256:6042500cf4b44023ea1894effe7890666b0c5c7871ed83a97c36c76ae560bb9b
        Status: Downloaded newer image for ubuntu:latest
        Ign:1 http://archive.ubuntu.com/ubuntu jammy InRelease
        ...
        W: Some index files failed to download. They have been ignored, or old ones used instead.
        ```
        ➡️ The Docker client is not configured correctly, follow [these steps](https://docs.docker.com/network/proxy/#configure-the-docker-client) to create the `~/.docker/config.json` file
 
 
- **Final Step: Run this command to test NVIDIA GPU support**
    ```shell
    docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
    ```
 
    *Expected Output:*
    ```
    Wed Jan  3 11:20:44 2024
    +---------------------------------------------------------------------------------------+
    | NVIDIA-SMI 535.129.03             Driver Version: 535.129.03   CUDA Version: 12.2     |
    |-----------------------------------------+----------------------+----------------------+
    | GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
    |                                         |                      |               MIG M. |
    |=========================================+======================+======================|
    |   0  NVIDIA GeForce RTX 2080 Ti     Off | 00000000:01:00.0 Off |                  N/A |
    | 36%   41C    P0              26W / 300W |      0MiB / 11264MiB |      0%      Default |
    |                                         |                      |                  N/A |
    +-----------------------------------------+----------------------+----------------------+
   
    +---------------------------------------------------------------------------------------+
    | Processes:                                                                            |
    |  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
    |        ID   ID                                                             Usage      |
    |=======================================================================================|
    |  No running processes found                                                           |
    +---------------------------------------------------------------------------------------+
    ```
 
    *Potential Error:*
    ```
    docker: Error response from daemon: unknown or invalid runtime name: nvidia.
    See 'docker run --help'.
    ```
    ➡️ The Nvidia Container Toolkit is not installed, follow [these steps](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html). 
    
## Environment Installation Within The Container
Within the container, here is what you can do: 
### Poetry Installation 
```shell
make -C .devcontainer install
```

### Jupyter Install 
1. Run the following command to install Jupyter:

    ```shell
    make -C .devcontainer install_jupyter
    ```

2. After installing Jupyter, you can start a Jupyter notebook server and select the "Python (poetry)" kernel to use the project's environment.

### Full Installation (Jupyter+Poetry)
If you want to install both project dependencies and Jupyter, you can use the following command:

```shell
make -C .devcontainer install_all
```