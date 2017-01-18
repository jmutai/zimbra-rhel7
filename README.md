## Zimbra on RHEL 7 Docker image

This repo hosts all files needed to run Zimbra Collaborative Suite on RHEL 7 docker image.

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

First clone the repo:

```bash

