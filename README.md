# **SIFT-REMnux**
SIFT and REMnux Docker based on Ubuntu 20.04 LTS 

## **Build Docker**

**To build the docker using the dockerfile, run the following commands:**

```bash
## Clone the repo
git clone https://github.com/digitalsleuth/sift-remnux.git

## Change to the directory
cd sift-remnux

## Build the docker
docker build -t sift-remnux .

## Run the docker - port 33 will be the port mapped to port 22 inside the docker
docker run -d -p 33:22 --cap-add SYS_ADMIN --cap-add MKNOD --device=/dev/fuse:/dev/fuse -h sift-remnux sift-remnux

## SSH into the docker
ssh -X forensics@$(hostname -I | awk '{print $1}') -p 33

```
**You can also interact with the docker using the following command:**
```bash
docker exec -it sift-remnux /bin/bash
```

**If you need or want access to a mapped folder, you can use the following command:**
```bash
mkdir {pwd}/files

docker run -d -p 33:22 -v {pwd}/files:/home/forensics sift-remnux
```

## **Running in Docker-Compose**

**To run the docker in docker-compose, use the following commands:**

```bash
## Clone the repo
git clone https://github.com/digitalsleuth/sift-remnux.git

## Change to the directory
cd sift-remnux

## Customize the docker-compose file
The docker-compose.yaml file contains everything you need to get started, so editing is not necessary. However, you can customise anything there including hostname, ipv4 address, and volume mappings.

## Run the docker-compose
docker-compose up -d
```

Using ssh via MobaXterm or PuTTY (or any SSH client that supports X11 forwarding) is recommend for GUI functionality.
