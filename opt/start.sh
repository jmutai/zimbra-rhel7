#!/bin/sh

# Zimbra installation and configuration script

echo "Enabling and starting sshd service"
systemctl enable sshd
systemctl start sshd

echo "Starting and enabling rsyslog"
sleep 5
systemctl enable rsyslog
systemctl start rsyslog

echo "Generating some variables needed.."
sleep 5
RANDOMHAM=$(date +%s|sha256sum|base64|head -c 10)
RANDOMSPAM=$(date +%s|sha256sum|base64|head -c 10)
RANDOMVIRUS=$(date +%s|sha256sum|base64|head -c 10)

## Installing the DNS Server ##
echo "Configuring DNS Server"
sleep 3
mv /var/named/db.domain /var/named/db.$DOMAIN

sed -i 's/\$DOMAIN/'$DOMAIN'/g' \
  /var/named/db.$DOMAIN \
  /etc/named.conf

sed -i 's/\$HOSTNAME/'$HOSTNAME'/g' /var/named/db.$DOMAIN
sed -i 's/\$CONTAINERIP/'$CONTAINERIP'/g' /var/named/db.$DOMAIN

echo <<EOF > /etc/resolv.conf 
search $DOMAIN
nameserver 127.0.0.1
options ndots:0
EOF

echo "Restarting bind name server.."
sleep 3
sudo systemctl restart named 

## Install the Zimbra Collaboration ##

tar xzvf /opt/zimbra-install/zcs-rhel7.tgz  -C /opt/zimbra-install/

echo "Installing Zimbra Collaboration just the Software"
rm -rf /opt/zimbra-install/zcs-rhel7.tgz
cd /opt/zimbra-install/zcs-* && ./install.sh -s < /opt/zimbra-install/zimbra_install_keystrokes

# Create Config file
touch /opt/zimbra-install/zimbra_install_config
cat <<EOF >/opt/zimbra-install/zimbra_install_config
AVDOMAIN="$DOMAIN"
AVUSER="admin@$DOMAIN"
CREATEADMIN="admin@$DOMAIN"
CREATEDOMAIN="$DOMAIN"
CREATEADMINPASS="$PASSWORD"
DOCREATEADMIN="yes"
DOCREATEDOMAIN="yes"
DOTRAINSA="yes"
EXPANDMENU="no"
HOSTNAME="$HOSTNAME.$DOMAIN"
HTTPPORT="8080"
HTTPPROXY="TRUE"
HTTPPROXYPORT="80"
HTTPSPORT="8443"
HTTPSPROXYPORT="443"
IMAPPORT="7143"
IMAPPROXYPORT="143"
IMAPSSLPORT="7993"
IMAPSSLPROXYPORT="993"
INSTALL_WEBAPPS="service zimlet zimbra zimbraAdmin"
JAVAHOME="/opt/zimbra/common/lib/jvm/java"
LDAPAMAVISPASS="$PASSWORD"
LDAPPOSTPASS="$PASSWORD"
LDAPROOTPASS="$PASSWORD"
LDAPADMINPASS="$PASSWORD"
LDAPREPPASS="$PASSWORD"
LDAPBESSEARCHSET="set"
LDAPHOST="$HOSTNAME.$DOMAIN"
LDAPPORT="389"
LDAPREPLICATIONTYPE="master"
LDAPSERVERID="2"
MAILBOXDMEMORY="256"
MAILPROXY="TRUE"
MODE="https"
MYSQLMEMORYPERCENT="30"
POPPORT="7110"
POPPROXYPORT="110"
POPSSLPORT="7995"
POPSSLPROXYPORT="995"
PROXYMODE="https"
REMOVE="no"
RUNARCHIVING="no"
RUNAV="yes"
RUNCBPOLICYD="no"
RUNDKIM="yes"
RUNSA="yes"
RUNVMHA="no"
SERVICEWEBAPP="yes"
SMTPDEST="admin@$DOMAIN"
SMTPHOST="$HOSTNAME.$DOMAIN"
SMTPNOTIFY="yes"
SMTPSOURCE="admin@$DOMAIN"
SNMPNOTIFY="yes"
SNMPTRAPHOST="$HOSTNAME.$DOMAIN"
SPELLURL="http://$HOSTNAME.$DOMAIN:7780/aspell.php"
STARTSERVERS="yes"
SYSTEMMEMORY="1.0"
TRAINSAHAM="ham.$RANDOMHAM@$DOMAIN"
TRAINSASPAM="spam.$RANDOMSPAM@$DOMAIN"
UIWEBAPPS="yes"
UPGRADE="yes"
USESPELL="yes"
VERSIONUPDATECHECKS="TRUE"
VIRUSQUARANTINE="virus-quarantine.$RANDOMVIRUS@$DOMAIN"
ZIMBRA_REQ_SECURITY="yes"
ldap_bes_searcher_password="$PASSWORD"
ldap_dit_base_dn_config="cn=zimbra"
ldap_nginx_password="$PASSWORD"
mailboxd_directory="/opt/zimbra/mailboxd"
mailboxd_keystore="/opt/zimbra/mailboxd/etc/keystore"
mailboxd_keystore_password="$PASSWORD"
mailboxd_server="jetty"
mailboxd_truststore="/opt/zimbra/common/lib/jvm/java/jre/lib/security/cacerts"
mailboxd_truststore_password="changeit"
postfix_mail_owner="postfix"
postfix_setgid_group="postdrop"
ssl_default_digest="sha256"
zimbraDNSMasterIP="127.0.0.1"
zimbraDNSTCPUpstream="no"
zimbraDNSUseTCP="yes"
zimbraDNSUseUDP="yes"
zimbraFeatureBriefcasesEnabled="Enabled"
zimbraFeatureTasksEnabled="Enabled"
zimbraIPMode="ipv4"
zimbraMailProxy="TRUE"
zimbraMtaMyNetworks="127.0.0.0/8 [::1]/128 $CONTAINERIP/24 [fe80::]/64"
zimbraPrefTimeZoneId="Africa/Nairobi"
zimbraReverseProxyLookupTarget="TRUE"
zimbraVersionCheckNotificationEmail="admin@$DOMAIN"
zimbraVersionCheckNotificationEmailFrom="admin@$DOMAIN"
zimbraVersionCheckSendNotifications="TRUE"
zimbraWebProxy="TRUE"
zimbra_ldap_userdn="uid=zimbra,cn=admins,cn=zimbra"
zimbra_require_interprocess_security="1"
INSTALL_PACKAGES="zimbra-core zimbra-ldap zimbra-logger zimbra-mta zimbra-snmp zimbra-store zimbra-apache zimbra-spell zimbra-memcached zimbra-proxy "
EOF

echo "Installing Zimbra Collaboration injecting the configuration"
/opt/zimbra/libexec/zmsetup.pl -c /opt/zimbra-install/zimbra_install_config

echo "Now restarting zimbra"
sleep 5
su - zimbra -c 'zmcontrol restart'

if [ "$?" -eq 0 ]; then
    echo "Installation successful"
    echo ""
    echo "You can access now to your Zimbra Collaboration Server"
    echo "Admin Console: https://${HOSTNAME}.${DOMAIN}:7071"
    echo "Web Client: https://${HOSTNAME}.${DOMAIN}"
fi

