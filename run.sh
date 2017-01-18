#!/bin/bash
local CONT_NAME="zimbra-rhel7"
local CONT_DOMAIN="example.com"
local CONT_S_HOSTNAME="mail"
local CONT_BRIDGE="zimbra_bridge"
local CONT_IP="192.168.10.2"
local CONT_L_HOSTNAME="mail.example.com"
local ZIMBRA_PASS="Password321"

docker run -d --privileged \
    --name "${CONT_NAME}" \
    --hostname "${CONT_L_HOSTNAME}" \
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
    -v ./zimbra.repo:/etc/yum.repos.d/zimbra.repo \
    -p 25:25 -p 80:80 -p 465:465 -p 587:587 \
    -p 110:110 -p 143:143 -p 993:993 -p 995:995 \
    -p 443:443 -p 8080:8080 -p 8443:8443 \
    -p 7071:7071 -p 9071:9071 \
    zimbra-rhel-base \
    /usr/sbin/init

