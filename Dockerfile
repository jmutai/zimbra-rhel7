#!/usr/bin/bash
FROM registry.access.redhat.com/rhel7.3 
MAINTAINER Mutai Josphat <jmutai@kipepeosolutions.co.ke>

RUN set -ex
ADD ./setup.sh /
RUN chmod +x /setup.sh && /setup.sh

COPY ./etc/named/db.domain /var/named/db.domain
COPY ./etc/named/named.conf /etc/named.conf
COPY opt /opt/

VOLUME ["/opt/zimbra"]
WORKDIR /opt/zimbra

EXPOSE 22 25 465 587 110 143 993 995 80 443 8080 8443 7071

#CMD ["/bin/bash", "/opt/start.sh", "-d"]
