# `DOCKER CLI reference`

link : https://docs.docker.com/reference/cli/docker/
    

## Install Docker in Ubuntu Linux (20.04 LTS)
link : https://docs.docker.com/engine/install/ubuntu/

    <!-- Install using apt repository -->
    1)
        # Add Docker's official GPG key:
        sudo apt update
        sudo apt install ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        # Add the repository to Apt sources:
        sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
        Types: deb
        URIs: https://download.docker.com/linux/ubuntu
        Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
        Components: stable
        Signed-By: /etc/apt/keyrings/docker.asc
        EOF

        sudo apt update

        OR

        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        sudo apt-get update

    2)
        sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        Note:
            The Docker service starts automatically after installation. To verify that Docker is running, use:
                -   sudo systemctl status docker
            
            Some systems may have this behavior disabled and will require a manual start:
                -   sudo systemctl start docker
    
    3)
        Verify that the installation is successful by running the hello-world image:
            -   sudo docker run hello-world

<!-- ----------------------------------------------------------- -->


## `Docker file configuration`:
    FROM <OS><specific version>
        ex: FROM ubuntu:22.04

    RUN <Execute/install build commands.>
        ex: RUN pip3 install --no-cache-dir -r requirements.txt

    WORKDIR <change working directory>
        ex: WORKDIR /menudo

    COPY requirements.txt .
        ex: COPY requirements.txt

    EXPOSE <Describe which ports your application is listening on>
        ex: EXPOSE 5088

    CMD <Run the application using gunicorn>
        ex: CMD ["gunicorn", "--bind", "0.0.0.0:5088", "wsgi:app"]

<!-- --------------------------------------------------------------
-------------------------------------------------------------- -->

===================================================================
# `IMAGES`
-   __List of IMAGES currently running__
        
        docker images

-   __Remove images:__
    -   Normal way of removing:

            docker image rm <options> <image_ID>

    -   Remove images (forcefully):

            docker image rm -f <image_ID>
    
    -   Remove just "dangling" images:

            docker image prune

    -   Remove `ALL` images you're not using: 

            docker image prune -a

    -   Remove everything you're not currently using:

            docker system prune

===================================================================

# `CONTIANERS`

-   Build a container:
        
        docker build -t <tag name> <PATH>
    
    example:  
    
        docker build -t tagname . 

    The `.` is the address of the current directory  


-   List of all CONTAINERS:
        
        docker ps -a

-   Stop a currently running container:

        docker stop <container_ID>

-   Remove the container:
        
        docker rm <container_ID>

### Monitoring containers:
-   Process list of a container

        docker container top <container_id / container_name>

-   Details of a containers configuration

        docker container inspect <container_id / container_name>

-   Live performance stats for all containers

        docker container stats
    
    this is just to see if the containers are not reaching memory and network limits in a local environment  
    _Ctrl + C or Z to exit_

 
### Interacting inside the container:
-   Start a container interactively

        docker container run -it [COMMANDS] [ARGS] 

    its made up of 2 commands:  
    `-i`      :   interactive --->    keeps the session open to recieve terminal input  
    `-t`      :   pseudo-tty  --->    simulates a real terminal like what SSH does

    example:

        docker container run -it nginx bash

    `bash`  :   usage of the bash terminal


-   Execute a command in a running container

        docker container exec [OPTIONS] 

    example:

        docker container exec -it container_name bash 


### Start an existing container:

    docker container start -ai [container_id / container_name]


### Expose a port
this exposes the port to the outside

    docker container run -p 80:80 --name webhost -d nginx

`-p`  :   publish   --->    remember publishing is always in HOST:CONTAINER format

### Check exposed ports of a container

    docker container port [container_id / container_name]

### Remove a container after it stops running

    docker container run --rm [container_id / container_name]

`--rm`  :   Automatically remove the container and its associated anonymous volumes when it exits

===================================================================

#   `VOLUMES`
-   __Bind mount a volume__  
    this makes a `Named Volume`
    Example:

        docker  run  -v $(pwd):$(pwd) -w $(pwd) -i -t  ubuntu pwd

    The example above mounts the current directory into the container at the same path using the `-v` flag, sets it as the working directory, and then runs the `pwd` command inside the container.  

    As of Docker Engine version 23, you can use relative paths on the host.

        docker  run  -v ./content:/content -w /content -i -t  ubuntu pwd
    
    The example above mounts the `content` directory in the current directory into the container at the `/content` path using the `-v` flag, sets it as the working directory, and then runs the `pwd` command inside the container.

        docker run -v /doesnt/exist:/foo -w /foo -i -t ubuntu bash

    When the host directory of a bind-mounted volume doesn't exist, Docker automatically creates this directory on the host for you. In the example above, Docker creates the `/doesnt/exist` folder before starting your container.

-   __Upgrading/changing versions of images__
    Im using Postgres for this example. Lets say i have 2 versions of Postgres

        docker volume create psql
        docker run -d --name psql1 -e POSTGRES_PASSWORD=mypassword -v psql:/var/lib/postgresql/data postgres:15.1
        docker logs psql1
        docker stop psql1
        docker run -d --name psql2 -e POSTGRES_PASSWORD=mypassword -v psql:/var/lib/postgresql/data postgres:15.2
        docker logs psql2
        docker stop psql2



===================================================================

# `Shell Differences for Path Expansion`
With Docker CLI, you can always use a full file path on any OS, 
but often see people use a "parameter expansion" like `$(pwd)` which means ___"print working directory"___.

___Note___ :  Each shell may do this differently, so here's a cheat sheet for which OS and Shell your using.  
This isn't a Docker thing, it's a Shell thing.

-   for PowerShell  :   
        
        ${pwd}

-   for Command Prompt : 

        %cd%

-   Linux/macOS bash, sh, zsh, and Windows Docker Toolbox Quickstart Terminal : 

        $(pwd)

    ___Note___ : if you have spaces in your path, you'll usually need to quote the whole path in the docker command.



===================================================================

#   `Over all monitoring`
-   Disk space usage

        docker system df

===================================================================


# `Docker Networks: CLI management`
-   List existing networks

        docker network ls

-   Create a network  
    Spawns a new virtual network for you to attach containers to

        docker network create [options] [network_name] [container_id / container_name]

    example :   docker network create my_app_net container

-   Inspect a network 

        docker network inspect [network_name]

-   Attach a network to a existing container

        docker network connect [options] [network_name] [container_id / container_name to connect to]

    You could also connect the network as you are building a new container

        docker container run -d --name new_nginx --network my_app_net nginx

-   Detach a network from a container

        docker network disconnect [options] [network_name] [container_id / container_name to disconnect]

===================================================================








--------------------------------------------------------------------------------

================================================





#  `Docker credential helpers`
for securing credentials when logging in
    
github link and doc:    https://github.com/docker/docker-credential-helpers

***Note***  :   we are using `pass` as a credential helper for Ubuntu
    You can build the credential helpers using Docker:

Install emulators

    $ docker run --privileged --rm tonistiigi/binfmt --install all

Create builder

    $ docker buildx create --use

build credential helpers from remote repository and output to ./bin/build

    $ docker buildx bake "https://github.com/docker/docker-credential-helpers.git"

OR from local source

    $ git clone https://github.com/docker/docker-credential-helpers.git
    $ cd docker-credential-helpers
    $ docker buildx bake
    
Or if the toolchain is already installed on your machine:

-   1. Download the source.

            $ git clone https://github.com/docker/docker-credential-helpers.git
            $ cd docker-credential-helpers
        
-   2. Use `make` to build the program you want. That will leave an executable in the bin directory inside the repository.
            
            $ make pass

-   3. Put that binary in your $PATH, so Docker can find it.
            
            $ cp bin/build/docker-credential-pass /usr/local/bin/

*ChatGPT troubleshoot link* :   https://chatgpt.com/share/6925021e-93bc-800c-92c7-c2bf2578650d

=====================

## `Generate a gpg key` for Docker credential helper to use:

    gpg --full-generate-key

Check to see existing keys:

    gpg --list-secret-keys --keyid-format=long

***Notice something like this*** : Copy the part after the `/` that is the <KEY_ID>.

    sec   rsa3328/AD7D6092354E2BA1
>

=====================

## `Delete a gpg key`
> _NOTE_ : First you should not delete keys you do no longer use or need, but revoke them first (that is revoke them locally first, then send the revoked key to a keyserver ***(unless you are sure it never was on any keyserver)***).  
> _After_ having revoked you key that way, it is OK to delete it.

Get the public and secret keys with:

    gpg --list-key              #   public   
    gpg --list-secret-keys      #   secret

Example output:

    pub   rsa4096 2014-12-15 [C] [expires: 2027-07-15]
          EF54654SeaSALKOA7DE684E2C6E8793298290  
    uid           [ unknown] Lmao_Project_Dev_Team (signing key) <lmaoSampledataOrigin.com>  
    sub   rsa4096 2024-07-15 [S] [expires: 2026-10-26]

The ID is located below __pub__ and above __uid__

**Deleting the keys with**:
-   Secret
        
        gpg --delete-secret-key EF54654SeaSALKOA7DE684E2C6E8793298290

-   Public 

        gpg --delete-key EF54654SeaSALKOA7DE684E2C6E8793298290


_more info_ : https://stackoverflow.com/questions/73293254/how-to-delete-gpg-keys-no-longer-needed  


=====================

## `Initialize the password manager with the gpg key`
For Ubuntu we are using `pass`

    pass init <KEY_ID>

It should store the encrypted credentials in:

    ~/.password-store


=====================

## `Permission conflicts when running Docker`:
_src_ : https://stackoverflow.com/questions/48568172/docker-sock-permission-denied

if you forgot the user name:

    whoami

on the shell

    sudo usermod -aG docker $USER

needs to have `$USER` defined in your shell. This is often there by default, but you may need to set the value to your login id in some shells.

The current user can be added like so to avoid referencing non-existent users:

    sudo usermod -aG docker $(whoami)

Changing the groups of a user does not change existing logins, terminals, and shells that a user has open. To avoid performing a login again, you can simply run:

    newgrp docker

to get access to that group in your current shell.

Once you have done this, the user effectively has root access on the server, so only do this for users that are trusted with unrestricted sudo access.

_additional supporting info_ : https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user

