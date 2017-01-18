## Zimbra on RHEL 7 Docker image

This repository contains different Zimbra scripts to create RHEL 7 Zimbra Collaboration docker image.

Kindly note that this is a work in progess. If you get any errors be kind and share them so that i can improve on it.

## How to use files in this repo?

Below is the directory tree structure for the repo:

```bash
tree
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
├── ZimbraEasyInstall
└── zimbra.repo
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
`3.` Then download latest Zimbra Collaboration  software. I'll download Open Source edition here.

```
wget -O opt/zimbra-install/zcs-rhel7.tgz  https://files.zimbra.com/downloads/8.7.1_GA/zcs-8.7.1_GA_1670.RHEL7_64.20161025045328.tgz
```
`4.` Edit `Makefile` if you would like to change name of the base image to build next.

```
$ cat  Makefile 

IMAGE=zimbra-rhel-base

.PHONY: all build

all: build

build:
    docker build --rm -t $(IMAGE) .
```
`5.` Build base image which is image with zimbra preqs packages.

Before running `sudo make`, consider changing hostname on `setup.sh` file to match final hostname you'll use.

If you plan on using `CentOS 7` docker image, change `FROM` directive in `Dockerfile` to match `centos:latest`. Default is `rhel7.3` from `registry.access.redhat.com`.

```
sudo make
```
