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
git@github.com:jmutai/zimbra-rhel7.git
```
`.2`. Then cd to `zimbra-rhel7` directory

```
cd zimbra-rhel7
```
`3.` Then download latest Zimbra Collaboration  software. I'll download Open Source edition here.

```
wget -O opt/zimbra-install/zcs-rhel7.tgz  https://files.zimbra.com/downloads/8.7.1_GA/zcs-8.7.1_GA_1670.RHEL7_64.20161025045328.tgz
```

