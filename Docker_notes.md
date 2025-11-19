Install Docker in Ubuntu Linux (20.04 LTS)

link: https://docs.docker.com/engine/install/ubuntu/

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

-------------------------------------------------------------------------------------------------

Docker file configuration:
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

-------------------------------------------------------------------------------------------------

Build a container:
    sudo docker build -t <tag name> <PATH>
        ex: sudo docker build -t tagname .  --> the "." is the address of the current directory

-------------------------------------------------------------------------------------------------

Check the list of images currently running:
    -   sudo docker images

Check the list of all containers:
    -   sudo docker ps -a

Stop a currently running container:
    -   docker stop <container_ID>

Remove the cointainer:
    -   sudo docker rm <container_ID>