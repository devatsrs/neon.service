#!/bin/sh

#Centos 6.9
#service iptables stop

#Centos 7+
systemctl stop firewalld


/root/certbot-auto renew

#Centos 6.9
#service iptables start

#Centos 7+
systemctl start firewalld

#Given by Leandro
/var/lib/asterisk/agi-bin/applyGeoIPfirewall.sh
/var/lib/asterisk/agi-bin/applyFail2Ban.sh
