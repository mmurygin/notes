# Docker

## Table of Content
- [Install](#install)
- [Common](#common)
- [Running Container](#running-container)
- [Containers](#containers)
- [Networks](#networks)
- [Images](#images)
- [Creating new images](#creating-new-images)
- [Dockerfile](#dockerfile)
- [Volumes](#volumes)
- [Share Containers](#share-containers)
- [Containers networking](#containers-networking)
- [Docker Compose](#docker-compose)
- [Resources](#resources)

## Install
1. Install Docker

    ```bash
    curl -fsSL get.docker.com | sh
    ```

1. To use docker as non-root user add user to docker group:

    ```
    sudo usermod -aG docker $(whoami)
    ```

## Common
1. Docker has a Client / Server architecture
    * Client takes user inputs and send them to the daemon
    * Daemon builds, runs and distributes containers
    * Client and daemon can run on the same host or on different hosts
    * Client: CLI or GUI (Kitematic)
    * Server: Docker Daemon (the same as Docker Engine)
1. Docker container it's just one or many processes inside linux.

## Running Container
1. Docker engine looks for that image locally in image cache, doesn't find anything
1. Then look in remote image repository (defaults to Docker Hub)
1. Downloads the latest version (by default)
1. Creates new container based on that image and prepares to start
1. Gives it a virtual IP on a private network inside docker engine
1. If `--publish` is specified then engine opens port on a host and forward to port in container
1. Starts container by using the CMD in the image Dockerfile

## Monitoring Container
1. **`docker container top container_name`** - process list in one container
1. **`docker container inspect container_name`** - details of one container config. Shows how container was run.
1. **`docker container stats container_name`** - performance stats for all containers.
1. **`docker container port container_name`**

## Containers
1. Containers
    * Isolated application platform
    * Contains everything needed to run your application
    * Based on one or more images

2. To run a container use:

    ```
    docker container run [options] image [command] [args…]
    ```

    * **`-i`** flag tells docker to connect to STDIN in the container

    * **`-t`** flag specifies to get a pseudo-terminal (to run terminal we need to put command `/bin/bash`)

        * Run a container and bush inside it

        ```
        docker run -it image bash
        ```

    * **`-d`** flag tells docker to run container in the background (detached mode) or as a daemon

    * **`-w`**  set the current working directory (inside container) for conatiner process

3. To exit container shell without the container shut down user **CTRL+P+Q**

4. Containers can be specified using their ID or name

5. To list containers:
    * **`docker container ls`** - list all running containers
    * **`docker container ls -a`** - list all containers (includes containers that are stopped)

6. To start stopped container use

    ```
    docker container start <container ID>
    ```

7. To stop container use

    ```
    docker container stop <container ID>
    ```
    [Difference between docker stop and docker kill](http://superuser.com/questions/756999/whats-the-difference-between-docker-stop-and-docker-kill)

8. To remove all containers:

    ```
    docker container rm $(docker ps -a -q)
    ```

9. **`docker container exec`**  - allows to execute command in a running container

    ```
    docker exec container_id  some_node_script.js
    ```

10. To get terminal access to the container use

    ```
    docker container exec -i -t container_id bash
    ```

## Networks
1. Each container connected to a private virtual network "bridge"
1. Each virtual network routes through NAT firewall on host IP
1. All containers on a virtual network can talk to each other without `--publish`
1. **`docker network ls`** - show networks
1. **`docker network inspect`** - inspect a network
1. **`docker network create --driver`** - create a network
1. **`docker network connect`** - attach a network to container
1. **`docker network disconnect`** - deatach a network from container
1. **Docker DNS** - Docker daemon has a build-in DNS server that containers use by default
1. **DNS Default Names** - docker defaults the hostname to the contianer's name, but we can set aliases.
    ```bash
    docker container run --net-alias nginx-alias nginx
    ```
1. Default bridge network doesn't have a build-in _DNS_ server.


## Images
1. Images
    * Read only template used to create containers
    * Built by you or other Docker users
    * Stored in the Docker Hub or your local Registry

2. To show all available images

    ```
    docker image ls
    ```

3. To remove image use

    ```
    docker image rm [-f] <image_id or image_name:tag>

    ```
4. Get the info about image layers

    ```
    docker image history <image_id or name>
    ```

## Creating new images
1. Docker commit - saves changes in a container as a new image

    ```
    docker commit [options] [container ID] [repository:tag]
    ```

    * Repository name should be based on username/application
    * Can reference the container with container name instead of ID

        ```
        docker commit 9283498234c5 max/myapplication:1.0
        ```

2. **Dockerfile** - is a configuration file that contains instructions for building a Docker image

3. **Best Practise**: Each run instruction creates a new file layer in docker container and after each run there is a commit to container. If you want to avoid this multilayer behaviour use **`&&`** syntax

    ```
    RUN apt-get update && apt-get install -y curl vim openjdk-7-jdk
    ```

4. To build a docker container use:
    * Syntax:

        ```
        docker build [options] path
        ```
    * Common option to tag the build

        ```
        docker build -t [repository:tag] path
        ```

    * **path** - build context. All other paths are relative to this one. Should contain Dockerfile.

## Dockerfile

1. **Dockerfile** - is a configuration file that contains instrutions for building a Docker image

2. **FROM** -  instruction specifies what the base image should be

3. **RUN** - instruction specifies a command to execute

4. **CMD** - defines a default command to execute when a container is created.

    * Performs no action during the image build

    * Can only be specified once in a Dockerfile

    * Can be overridden at run time

    * You can use **Shell** and  **EXEC** form

        * `CMD ping 127.0.0.1 -c 30` - shell format

        * `CMD [“ping”, “127.0.0.1”, “-c”, “30”]` - exec format

5. **ENTRYPOINT** - defines the command that will run when a container is executed
    * We can not overide this command at runtime

    * Run time arguments and CMD instruction are passed as parametrs to the ENTRYPOINT instruction

    * Shell and EXEC form

    * EXEC form preffered as shell form cannot accept arguments at run time

        ```
        ENTRYPOINT [“ping”]
        docker run <container> 127.0.0.1 -c 30
        ```

    * Container essentially runs as an executable

6. **MAINTAINER** - declare the container maintainer

7. **COPY** -  copy some files into the container

8. **WORKDIR** - defines the currently working directory inside a container. If it doesn’t exit then follder will be created.

9. **ENV** - sets the environment variable

## Share Containers

1. At first we need to login to our docker account

    ```
    docker login
    ```

2. You image should have the name in the following template:

    ```
    <docker_user_name>/<image_name>:<tag>
    ```

3. To create a new image tag from existed image use

    ```
    docker tag <old_tag> <new_tag>
    ```

4. To push image to docker hub use:

    ```
    docker push <username>/<image_name>:<tag>
    ```

## Volumes

1. A **Vollume** is a designated directory in a container, which is designed to persist data, independent of the containers’s lify cycle
    * Volume changes are excluded when updating an image
    * Persist when a container is deleted
    * Can be mapped to a host folder
    * Can be shared between containers

1. Used for
    * De-couple the data that is stored from the container which created the data
    * Good for sharing data between containers
        * it's possible to setup a data containers which has a volume you mount in other containers
    * Mounting folders from the host is good for testing purposes but generally not recommended for production use

1. List all volumes

    ```bash
    docker volume ls
    ```

1. If there is a `VOLUME` command in _Dockerfile_ then when container starts the docker engine creates a volume on a host and mount it to a volume directory in a container.
    * when we run mysql docker engine creates volume for directory `/var/lib/mysql`

    ```bash
    $ docker image inspect --format='{{range $key, $value := .ContainerConfig.Volumes}}{{$key}}{{end}}' mysql:5.6
    /var/lib/mysql
    ```

    * we should delete such volumes manually


1. Run a new container and mount the folder /container-volume inside it's file system to some directory in host

    ```
    docker run  -v /container-volume nginx:1.7
    ```

1. Run a new container and map the /data/src folder from the host into /test/src folder in the container

    ```
    docker run -v /data/src:/test/src nginx:1.7
    ```

1. Run new container and map directory `/var/lib/mysql` to some _named_ volume

    ```bash
    docker run -v mysql-volume:/var/lib/mysql
    ```

1. To specify Volume in Dockerfile use
    * VOLUME instruction creates a mount point
    * Cannot map volumes to host directories
    * Volumes are initialized when the container is executed
    * Can specify arguments JSON array or string
        * `VOLUME /myvol`
        * `VOLUME /firstfolder  /secondfolder`
        * `VOLUME [“myvol”, “myvol2”]`

1. To fully remove container with volume run

    ```
    docker rm -v container_id
    ```


## Docker Compose

1. Manages the whole application lifecycle:
    * Start, stop and rebuild services
    * View the status of running services
    * Stream the log output of running services

2. **dockercompose.yml** - allows to define the following containers parametrs
    * build (context, workdir)
    * environment
    * image
    * networks
    * ports
    * volumes
3. Docker compose command
    * **`docker-compose build`** - build or rebuild all services defined in docker-compose.yml
    * **`docker-compose build mongo`** - build or rebuild mongo service
    * **`docker-compose up`** - creates and starts all services
    * **`docker-comose up --no-deps node`** - do not recreate services than node depends on
    * **`docker-compose down`** - stops and removes all containers
    * **`docker-compose down --rmi all --volumes`** - remove containers, images, volumes
    * **`docker-compose start`** - starts all services
    * **`docker-compose stop`** - stops all containers
    * **`docker-compose rm`** - removes stopped containers
    * **`docker-compose logs`** - get services logs
4. You can pass multile files to `docker-compose`. In this case every next file will override corresponding settings in previous.

    ```bash
    docker-compose -f docker-compose.yml -f docker-compose.admin.yml run backup_db
    ```

## Resources
1. [Mike Coleman: Docker for Virtualization Admin](https://github.com/mikegcoleman/docker101/blob/master/Docker_eBook_Jan_2017.pdf)
1. [Cgroups, namespaces, and beyond: what are containers made from?](https://www.youtube.com/watch?v=sK5i-N34im8&feature=youtu.be&list=PLBmVKD7o3L8v7Kl_XXh3KaJl9Qw2lyuFl)
1. [--format](https://docs.docker.com/engine/admin/formatting/)
