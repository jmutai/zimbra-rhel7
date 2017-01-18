#!/usr/bin/bash
export DOMAIN="zimbra.example.com"
# Create directories for persistent storage
mkdir -p /var/$DOMAIN/opt

# Install packages needed
yum -y install bash-completion \
bind \
bind-utils \
glibc \
hostname \
iproute \
iputils \
libaio \
libstdc++.so.6 \
nmap-ncat \
ntp \
net-tools \
openssh-clients \
perl \
perl-core \
sqlite \
sudo \
sysstat \
unzip \
vim \
wget 

