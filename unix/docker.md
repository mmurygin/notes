# Docker

## Common

1. To use docker as non-root user add user to docker group:

    ```
    sudo usermod -aG docker <user_name>
    ```

2. Docker has a Client / Server architecture
    * Client takes user inputs and send them to the daemon
    * Daemon builds, runs and distributes containers
    * Client and daemon can run on the same host or on different hosts
    * Client: CLI or GUI (Kitematic)
    * Server: Docker Daemon (the same as Docker Engine)

3. Get the info about cotainer (including mounted volumes)

    ```
    docker inspect <container_name>
    ```

## Images

1. Images
    * Read only template used to create containers
    * Built by you or other Docker users
    * Stored in the Docker Hub or your local Registry

2. To show all available images

    ```
    docker images
    ```

3. To remove image use

    ```
    docker rmi [-f] <image_id or image_name:tag>

    ```
4. Get the info about image layers

    ```
    docker history <image_id or name>
    ```

## Containers
1. Containers
    * Isolated application platform
    * Contains everything needed to run your application
    * Based on one or more images

2. To run a container use:

    ```
    docker run [options] image [command] [args…]
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
    * **`docker ps`** - list all running containers
    * **`docker ps -a`** - list all containers (includes containers that are stopped)

6. To start stopped container use

    ```
    docker start <container ID>
    ```

7. To stop container use

    ```
    docker stop <container ID>
    ```
    [Difference between docker stop and docker kill](http://superuser.com/questions/756999/whats-the-difference-between-docker-stop-and-docker-kill)

8. To remove all containers:

    ```
    docker rm $(docker ps -a -q)
    ```

9. **`docker exec`**  - allows to execute command in a running container

    ```
    docker exec <container_id>  some_node_script.js
    ```

10. To get terminal access to the container use

    ```
    docker exec -i -t <container id> /bin/bash
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

## Volumes

1. A **Vollume** is a designated directory in a container, which is designed to persist data, independent of the containers’s lify cycle
    * Volume changes are excluded when updating an image
    * Persist when a container is deleted
    * Can be mapped to a host folder
    * Can be shared between containers

2. Used for
    * De-couple the data that is stored from the container which created the data
    * Good for sharing data between containers
        * it's possible to setup a data containers which has a volume you mount in other containers
    * Mounting folders from the host is good for testing purposes but generally not recommended for production use

3. Execute a new container and mount the folder /myvolume into its file system

    ```
    docker run -d -P -v /myvolume nginx:1.7
    ```

4. Execute a new container and map the /data/src folder from the host into /test/src folder in the container

    ```
    docker run -i -t -v /data/src:/test/src nginx:1.7
    ```

5. To specify Volume in Dockerfile use
    * VOLUME instruction creates a mount point
    * Cannot map volumes to host directories
    * Volumes are initialized when the container is executed
    * Can specify arguments JSON array or string
        * `VOLUME /myvol`
        * `VOLUME /firstfolder  /secondfolder`
        * `VOLUME [“myvol”, “myvol2”]`

6. To fully remove container with volume run

    ```
    docker rm -v container_id
    ```

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
