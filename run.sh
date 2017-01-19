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
    -v /var/"${CONT_L_HOSTNAME}"/zimbra:/opt/zimbra  \
    -v /etc/localtime:/etc/localtime:ro \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    -v $(pwd)/zimbra.repo:/etc/yum.repos.d/zimbra.repo \
    -p 25:25 -p 80:80 -p 465:465 -p 587:587 \
    -p 110:110 -p 143:143 -p 993:993 -p 995:995 \
    -p 443:443 -p 8080:8080 -p 8443:8443 \
    -p 7071:7071 -p 9071:9071 \
    zimbra-rhel-base \
    /usr/sbin/init
