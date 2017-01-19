## Zimbra on RHEL 7 Docker image

This repository contains different scripts to create RHEL 7 Zimbra docker image.

It tries to automate zimbra installation on Docker. If you get any errors be kind and share them so that i can improve on it.

## How to use files in this repo?

Below is the directory tree structure for the repo:

```bash
.
├── Dockerfile
├── etc
│   └── named
│       ├── db.domain
│       └── named.conf
├── Makefile
├── opt
│   ├── start.sh
│   └── zimbra-install
│       ├── zcs-rhel7.tgz
│       └── zimbra_install_keystrokes
├── README.md
├── run.sh
├── setup.sh
├── shell.sh
└── zimbra.repo
```

## Prereqs
First create use-defined docker network for zimbra. This will enable us to define an `ip address` for the container. On my setup, the bridge created is `zimbra_bridge`, network subnet is `192.168.2.0/24` using below command:

```
# docker network create -d bridge --subnet 192.168.2.0/24 zibra_bridge
```
Confirm the network is successfully created with:

```
# docker network ls

NETWORK ID          NAME                DRIVER
f16cc34759a8        none                null                
cd4f9b056c74        host                host                
6fdeb55834bf        bridge              bridge              
8c67bf16fc36        zimbra_bridge       bridge 
```

## Usage and Examples

`1.` First clone the repo:

```bash
git clone https://github.com/jmutai/zimbra-rhel7.git
```
`2`. Then cd to `zimbra-rhel7` directory

```
cd zimbra-rhel7
```
`3.` Download latest Zimbra Collaboration  software. I'll download Open Source edition here.

```
wget -O opt/zimbra-install/zcs-rhel7.tgz  https://files.zimbra.com/downloads/8.7.1_GA/zcs-8.7.1_GA_1670.RHEL7_64.20161025045328.tgz
```
`4.` Edit `Makefile` if you would like to change name of the base image to build next. Default name is `zimbra-rhel-base`

```
sed -i 's/^IMAGE=.*/IMAGE=new-image-name/g' Makefile 
```

`5.` Build zimbra base image - Will be the basis for spinning new container.

Before running `sudo make`, consider changing **hostname** on `setup.sh` file to match final hostname you'll use.

If you plan on using **CentOS 7** docker image, change `FROM` directive in `Dockerfile` to match `centos:latest`.

```
sed -i 's/^FROM .*$/FROM centos:latest/' Dockerfile
```
Default is `rhel7.3` from `registry.access.redhat.com`.

**If using Local repo**: On `opt/zimbra-install/zimbra_install_keystrokes` file, replace second line `y` with `n`. To look like below:

```
$ cat opt/zimbra-install/zimbra_install_keystrokes
y
n
y
y
y
n
y
y
y
y
y
y
y
```
Then edit `zimbra.repo` to point to correct base repo url.

It's now time to create zimbra base image:

```
sudo make
```

`6.` After successful build, Spin a container off the new zimbra base image, see below `run.sh` file for commands to use:

```bash
$ cat run.sh 

#!/bin/bash
CONT_NAME="zimbra"
CONT_DOMAIN="example.com"
CONT_S_HOSTNAME="mail"
CONT_L_HOSTNAME="mail.example.com"
CONT_BRIDGE="zimbra_bridge"
CONT_IP="192.168.2.2"
ZIMBRA_PASS="Password321"
docker run -d --privileged \
    --name "${CONT_NAME}" \
    --hostname zimbra.example.com \
    --net "${CONT_BRIDGE}" \
    --ip "${CONT_IP}" \
    -e TERM="xterm" \
    -e "container=docker" \
    -e PASSWORD="${ZIMBRA_PASS}" \
    -e HOSTNAME="${CONT_S_HOSTNAME}" \
    -e DOMAIN="${CONT_DOMAIN}" \
    -e CONTAINERIP="${CONT_IP}" \
    -e NAME="${CONT_NAME}" \
    -v /var/"${CONT_L_HOSTNAME}"/opt:/opt/zimbra  \
    -v /etc/localtime:/etc/localtime:ro \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    -v $(pwd)/zimbra.repo:/etc/yum.repos.d/zimbra.repo \
    -p 25:25 -p 80:80 -p 465:465 -p 587:587 \
    -p 110:110 -p 143:143 -p 993:993 -p 995:995 \
    -p 443:443 -p 8080:8080 -p 8443:8443 \
    -p 7071:7071 -p 9071:9071 \
    zimbra-rhel-base \
    /usr/sbin/init
```
Change local variables set on top to suite your environemnt. 

If you aren't using zimbra local repo remove the line `-v ./zimbra.repo:/etc/yum.repos.d/zimbra.repo`. It might be good idea to setup local repository if playing with docker for the first time; Will save you a lot of time if you screw things up. Visit link below for how to.

[How to Create Local Zimbra Repository](https://wiki.zimbra.com/wiki/Zimbra_Collaboration_repository) 

Spin new zimbra container:

```
sh ./run.sh
```
This will launch a container called `zimbra` in detached mode. We're detaching because the default command running is `/usr/sbin/init`, you cannot attach tty terminal.

`7.` Before starting zimbra installation, attach to `zimbra` container interactive terminal and execute `/bin/bash`.

```
docker exec -it zimbra /bin/bash
```
Alternatively you can just do:

```bash
sh ./shell.sh
```
Once you have active shell access. Start automated zimbra installation.

```
cd /opt
sh ./start.sh 
```

## Accessing Admin Console
The `start.sh` script will take care of everything and after a few minutes you can access Admin console and client console as below:

Admin Console: https://YOUR_HOST_IP:7071
Client console: https://YOUR_HOST_IP
