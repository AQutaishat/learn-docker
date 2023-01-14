# Docker Commands

## Links
* Udemy course name: Docker for the Absolute Beginner - Hands On - DevOps
* Docker images list: https://hub.docker.com/search?q=&type=image
* CLI reference: https://docs.docker.com/engine/reference/run/
* compose reference: https://docs.docker.com/engine/reference/commandline/compose/
* voting app example reference: https://github.com/dockersamples/example-voting-app
* google docker registry: https://cloud.google.com/container-registry/
* play with docker: https://labs.play-with-docker.com/
* docker compose file reference: https://docs.docker.com/compose/compose-file/
* docker compose CLI reference: https://docs.docker.com/compose/reference/

&nbsp;

&nbsp;

&nbsp;

## CLI Commands
* (docker run) search for images locally if it did not find it pulls it then runs it.
* the container only lives while the task or process is running
* other than official images, the image format is :
  * your-name/mage-name


```bash
docker info
docker version
docker system df -v #see actual disk usage of docker, with -v show details
docker run [nginx] --rm # rm removes teh container when it stops
docker ps #list running containers
docker ps -a #list all containers not just running ones
docker stop [container-id-or-name] #stop container ** for id you can provide few first characters
docker start -a -i [container-id-or-name]
docker rm #remove container , it must be stopped
docker images #list of images 
docker rmi [image] #remove image which is not used , it can remove multi image , ids separated by space
docker pull [ubuntu] #only pull the image without running it
docker tag [src-image] [dest-image] #create reference to source image with other tag
docker run [image] [command to execute inside container] #create a container as instance of the image
docker run radis:4.0 #run using tag, if not specified it will be latest
docker run ubuntu sleep 5 #run sleep for 5 seconds command 
docker run --name blue-app ubuntu  # --name param give the container name 
docker run -it alpine bash #open shell to linux alpine image ** it attach as interactive mode it accepts user inputs 
docker run -d [image] #run in detach mode, the console is detached you can write commands
docker attach [container-id-or-name] #attach console to running container

docker exec [image-name] [command] #execute command on running container
docker exec ubuntu cat /etc/hosts #type list of hosts in running ubuntu machine+
docker cp [src-container-id]:[path] [target-container-id]:[path] #copy file from source to destination, if remove container id it will copy to or from local. containers must be running

docker run -p 8001:5000  -p 8002:5001 kodekloud/webapp #maps host port (8001) with container port (5000), and (8002) with (5001)
docker run -v d:/datadir:/var/lib/mysql mysql #map/mount host folder (d:/datadir) with container folder (/var/lib/mysql) to preserve data to host folder. this is old wya, use mount for new way
 docker run --mount type=bind,source=d:/datadir,target=/var/lib/mysql_mysql
 # same as previous command

docker volume create test-volume #create named volume, it can be used later with docker run -v or mount 
docker volume rm VOL_NAME #remove volume
docker volume ls #list volumes
docker volume inspect [volume] # display volume details


docker network create [--driver bridge] [-subnet 182.18.0,0/16] favorites-net #create network specify bridge as driver and specify subnet mask, to be used with docker run --network
docker network ls  #list networks

docker run -e APP_COLOR=green webapp-color #use -e to set environment variable, it override same environment variable inside dockerfile if used
docker run --enf-file ./.env my-image #load env variables from file called .env in format of (key=value), it is more secure, using env command line will be saved in the image history 
docker run --network favorites-net voting-app #run the container using favorites-net instead of bridge network. it does not create the network, you have to created it first 
docker run --link redis:redis voting-app #
docker inspect [container-id-or-name / image-name] #shows container details in json format
docker logs [container-id-or-name] #shows container output logs
docker history [image]
docker image prune -a #remove all images without any container (-a : Remove all locally stored images)
docker container prune #Remove all stopped containers
docker system prune -a #Remove all 
docker build . #build docker file (.dockerfile) and create an image
docker build -f [docker file path and name]  #build specific docker file
docker build  -t user-name/my-image:1.0.0 ubuntu #-t param give the image name and optional tag. latest is always the last image built
docker build -t image_name --build-arg DEFAULT_PORT=80 #--build-arg to pass arguments to docker file
docker compose build --no-cache #Build or rebuild services
docker compose up -d --build #build images then Create and start containers, -d for detached mode, --build: enforce rebuild images 
docker compose down -v #stop all services and remove containers and networks, -v to delete volumes when shutting down
docker compose run --rm npm init #useful in utility containers, run only one service (npm) and remove it when it is done, execute (init) command 
docker compose pause	#Pause services
docker compose images # list all images used by created containers
docker compose ps	#List containers
docker compose port	#Print the public port for a port binding.

docker login [optional-custom-repo] #login to docker cloud hub or a custom cloud or local serer
docker push [optional-custom-repo][image-name] #image name must be [custom-repo][user-name/image-name]
docker push localhost:5000/ubuntu

docker run -d -p 5000:5000 --restart=always --name my-registry registry:2 #run local docker registry on (localhost:5000) as custom repo
curl -X GET localhost:5000/v2/_catalog #To check the list of images pushed

docker run --cpu=.5 --memory=100m ubuntu #limit cpu and memory usage

```
&nbsp;

&nbsp;

&nbsp;

## Docker file
* file name: the run with dot will search for file with exact name (Dockerfile), to run file with different name use (docker run -f [file-name]
* **From**: the base image to build new image from, every image is based on OS image or an other image that is based on OS image. we can use **AS** keyword to give the new image a name
* **RUN**: execute command on the image
* **COPY**: copy file from host to inside the image, see (.dockerignore)
* **ADD**: same as copy, but older, but it accepts remote url. and extract tar files
* **ENTRYPOINT**: command to be executed after building the image, either in format of command line with spaces, or json array.
* **CMD**: command to be executed after building the image, either in format of command line with spaces, or json array. we can use ENTRYPOINT then CMD together in the same file but they both have to be in json format in that case
* **Arg and Env** :
* **.dockerignore** file: to ignore some files or folders when using (copy ) command in dockerfile. for example ignore (Dockerfile, .git, node_modules)

when executing the (Docker Run) command, we can pass a command to be executed after the image run. this command will be appended to **ENTRYPOINT** command but it will replace **CMD** command. dockerfile 

each command will create new image layer. the layers will be cached. each layer can not be modified, they are read only, when you run image docker creates writable layer for the container. the life of this layer is only when container is a live 

<span style="color:red">**multi stage builds** (from .. as ..mind, from , copy --from=...)</span>
  
#### <span style="color:green">**Docker file example**</span>
```dockerfile
FROM Ubuntu

ARG buildno=1.0.0 #receive argument value by docker run --build-arg , but the default is 1.0.0

RUN apt-get update && apt-get -y install python
RUN pip install flask flask-mysql
COPY . /opt/source-code

ENV PORT 80

EXPOSE $PORT


RUN echo "Build number: $buildno"

ENTRYPOINT flaskapp=/opt/source-code/app.py flask run
```
&nbsp;

&nbsp;

&nbsp;


## Docker compose
* **file name**: docker-compose.yml, or use (-f ) to specify custom file name
* **image**: the image to pull from, if (build) parameter is set. this will be the name of the built image
* **build**: in simple form, the folder where it contains the build context (dockerfile), or it can have details like the following 
  * **context**: either specify the folder where the context is or add context sub parameter, it contains either build path or git repo url to pull from. note that this path is where the docker file will be built. all copy commands will be related to this folder. you could consider make it only . if the docker file is inside a sub folder. then add the path to (dockerfile) property
  * **dockerfile**: specify docker file name in teh build path if the name was not (Dockerfile), it could have a path with the file name in case if the docker file inside a folder.
  * **command**: override the (cmd) keyword in teh docker file to execute some command
  * **args**: arguments to be passed to the dockerfile, to be used with (Args) keyword.
  * **labels**: Add metadata to the resulting image using Docker labels. You can use either an array or a dictionary. It’s recommended that you use reverse-DNS notation to prevent your labels from conflicting with those used by other software
* **container_name**: specify generated container name , if not used docker will use (folder name_ service name_ 1) as container name, although we can use service name for docker DNS. this is optional 
* **ports**: map host port with container port, equivalent to (docker run -p)
* **volumes**: mapped folders with the host to create preservable data folder and files. in the root of the compose file a (volumes) key should be exists with values are array of all networks mentioned in all services.equivalent to (docker run -v) or (docker run --mount) volumes can be pre-created.
* **networks**: custom network to expose the container to, it will create the network if not exists. on teh root of the compose file a (networks) key should exists. networks can be pre-created.
* **depends_on**: services should be run first before this service.
* **environment**: set parameters variables for the system inside the image , equivalent to (docker run -e)
* **env_file**: instead of using **environment** or -e, we can set env parameters in a file and use that file, it is more secure. 
* ```stdin_open: true```, ```tty: true```: equivalent to docker run -it 
* **entrypoint**: command to run after building the image, compose file can also have entry point
* **working_dir**: working directly can be also set in docker compose 


* **profiles**: defines a list of named profiles for the service to be enabled under, like (dev, production). When not set, the service is always enabled. the profile will bb passed when running (docker compose up ) with (--profile) parameter
* **restart**: no is the default restart policy, and it does not restart a container under any circumstance. When always is specified, the container always restarts. The on-failure policy restarts a container if the exit code indicates an on-failure error. unless-stopped always restarts a container, except when the container is stopped (manually or otherwise).
* the name of the service is the name of the container that you can use in connection strings, although the name in docker ps would be different. but you can still use service name to resolve DNS
  
#### <span style="color:green">**Compose file example**</span>
```yaml
version:3
services:
  vote:
    build: ./vote 
    container_name: vote-frontend
    # use python rather than gunicorn for local dev
    command: python app.py
    depends_on:
      - redis
    volumes:
     - ./vote:/app
    ports:
      - "5000:80"
    networks:
      - front-tier
      - back-tier

  result:
    build: ./result
    depends_on:
      - db
    volumes:
      - ./result:/app
    ports:
      - "5001:80"
      - "5858:5858"
    networks:
      - front-tier
      - back-tier

  worker:  
    image: worker:1.0
    build:
      context: ./worker #the docker file folder
      dockerfile: Dockerfile-alternate
      args:
        buildno: 1
      labels:
        com.example.description: "voting webapp"
        com.example.department: "voting"
        com.example.label-with-empty-value: ""
    depends_on:
      - redis
      - db
    networks:
      - back-tier
    stdin_open: true
    tty: true
  redis:
    image: redis:alpine
    volumes:
      - "./healthchecks:/healthchecks"
    networks:
      - back-tier

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: "postgres"
      POSTGRES_PASSWORD: "postgres"
    volumes:
      - "db-data:/var/lib/postgresql/data"
      - "./healthchecks:/healthchecks"
    networks:
      - back-tier
    entrypoint: ["some-entry-point"]

  # this service runs once to seed the database with votes
  # it won't run unless you specify the "seed" profile
  # docker compose --profile seed up -d
  seed:
    build: ./seed-data
    profiles: ["seed"]
    depends_on:
      - vote
    networks:
      - front-tier
    restart: "no"

#only named volumes should be specified here, they can be shared between services
volumes:
  db-data:

networks:
  front-tier:
  back-tier:
```

&nbsp;

&nbsp;

&nbsp;


## Docker Storage (Volumes)

*  when building an image, it is actually composed of layers, it will pull all its previous layers, . each layer adds to previous layer new file or folder. each layer can be shared with multiple images. it can not be modified, they are **read only** layers. 
*  when you run container docker **creates writable layer** for the container. the life of this layer is only when container is a live 
*  if you run a container, and modified already existing file, Docker copies teh file from the bottom read-only layer to the writable layer and the modified file will be in teh writable layer (copy-on-write).
*  when container stops and destroyed, writable will be deleted and the image is reset.
*  to create persistance data, map folder inside the image with host image 
*  we can create volume using, the volume or mount, it will be created inside ```(/var/libe/docker/volumes)```, note that if we used (docker run -v) with not existing volume, it will be automatically created.
   *  using pre-created volume  
      ```bash
      docker volume create data_volume
      ```
      then use it using (-v), the old way
       ```bash
       docker run -v data_volume:/var/lib/mysql_mysql 
      ```
    * using (mount), this is the new better way
      ```bash
      docker run --mount type=bind,source=/data/mysql,target=/var/lib/mysql_mysql
      ```
*  there are tow types of volume:
   *  **volume mounting**: binds volume with folder inside (volumes) folder
   *  **bind mounting**: provide complete path with (-v), it can bind with folder that exists any where in the host.
*  we can create volume by using volume or mount
   *  using volume (existing or not existing): ```bash docker run -v data_volume:/var/lib/mysql_mysql ```
   *  
* in linux, docker store files under the folder :  
```  
  /var/lib/docker
    aufs
    containers 
    image
    volumes 
```
* docker uses **storage drivers** depending on teh underlying OS, like (AUFS, ZFS, BTRFS, Device Mapper, Overlay, Overlay2)
* user read-only volumes when needed, add ```:ro``` after the volume binding
&nbsp;

&nbsp;

&nbsp;


## Docker Networking
*  docker creates 3 networks when installed
   *  bridge (default)
      *  private internal network, 
      *  containers can access each others using their internal IPs
      *  containers got internal IP address usually range (172.17.x.x), 
      *  to access containers map internal ports with host port
      *  
   *  host (```docker run --network=host```)
      *  associate the container with the host network. 
      *  internal ports immediately accessible without mapping
      *  you can not run multiple containers that expose same ports internally
      *  note: --network does not create newtork for you like volumes, you have to create network first
   *  none (```docker run --network=none```)
* create other internal networks than (bridge)
  * ``` docker network create --driver bridge -subnet 182.18.0,0/16 custom-isolation-network```
  * list networks: ``` docker network ls```
* containers can reach each other internally using their **names**, Docker has **Internal DNS** it always runs on IP (```127.0.0.11```).
* Docker uses network namespaces to isolate networks and virtual ethernet pairs to connects containers with each others
* to access host from inside docker machine, use ```host.docker.internal``` it translate to host IP
&nbsp;


&nbsp;

&nbsp;
## Docker for code development:
* you can use volume mapped to your code folder (current folder), but it must be absolute folder path. to compile your code inside container 
* Just a quick note: If you don't always want to copy and use the full path, you can use these shortcuts:
  * macOS / Linux: ```-v $(pwd):/app```
  * Windows: ```-v "%cd%":/app```
* to not override (node_modules) folder, we do anonymous mapping with it, docker rule is, most specific folder override the most generic, this way it will preserve internal file system for node_modules so it will not be erased when mapping all the folder with the code folder.
  * ``` -v /app/node_modules```
* add to docker file:
  ```dockerfile
      COPY package.json
      RUN npm install
      ```
* you can use docker for utility container like npm utility 

&nbsp;


&nbsp;

&nbsp;
## Notes
* to solve mount volumes performance problem on windows, use (wsl) file system, 
  * check : https://devblogs.microsoft.com/commandline/access-linux-filesystems-in-windows-and-wsl-2/
* docker compose must be installed separately in linux 
* in command line, volumes must be absolute not relative, and we must specify the network for multi-containers to interact together
  
* docker uses namespace technic to separate process id PID into workspaces. the same process will have different PID inside the container (PID=1) but it will have different PID in the host (PID=2273)



### Some Docker most used official Images
Ubuntu, alpine (small lightweight linux), busybox (super small linux), mysql, jenkins/jenkins,postgres, httpd, register:2 (docker registry), ngnix


&nbsp;

&nbsp;

&nbsp;

---
## Teaching subjects for lecture
* docker is easy.
* Docker VS Virtualization
* idea started with taking advantage or linux core multi instance and process workspace, the idea of isolation and containers , the idea to replicate the environment and reproduce it using easy scripts, it evolved to easy production. then to imaging development experience, which open the door to microservices. 
* containers are isolated workspaces
* What is docker, sharing kernel, on windows it uses wsl2 embedded linux core. previously it uses virtualization.

* Docker is for deployment only, no more missing configuration. the exact same environment, but we will learn to use it for development.
* docker used for two different things: development and deployment 
* Docker is most suitable for microservices

* what is docker images and containers
* container has writable layer which will be destroyed when stopped
* draw (DOCKER HUB ==> base image + docker file ==> new image ==> run ==> container)
* docker hub repos, public and private

* Download docker desktop
* startup containers : 
  * hello-word, 
  * ubuntu exec bash
  * docker run busybox echo "hello from busybox"
* docker images tag rule, account name / image name : version, precede with repo url 
* 

* docker compose up / down

* Notes:
  *  run command is actually pull if not exist then run
  * when building an image, it is actually composed of layers, it will pull all its previous layers, . each layer can not be modified, they are read only. when you run image docker creates writable layer for the container. the life of this layer is only when container is a live 


* VS code has docker client
  * VS can debug with docker
  * VS code can connect to remote compiler or maybe code in docker image
    * https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers
    * https://code.visualstudio.com/docs/devcontainers/containers#_create-a-devcontainerjson-file

* connect to ec2 instance
  * sudo amazon-linux-extras install docker
  * use putty
  * local, cloud unmanned server (EC2), cloud ECS (managed, you give it image and it manage it), kubernetes



```dockerfile
FROM Ubuntu

RUN apt-get update && apt-get -y install python
RUN pip install flask flask-mysql
COPY . /opt/source-code

ENTRYPOINT flaskapp=/opt/source-code/app.py flask run
```
