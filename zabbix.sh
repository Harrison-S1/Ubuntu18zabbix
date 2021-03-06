#!/bin/bash
         #allow port for zabbix
         sudo ufw allow 10050/tcp

         # update the distro
         sudo apt-get update && sudo apt-get dist-upgrade -y

         #add the zabbix repo
         sudo wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-3+bionic_all.deb
         sudo dpkg -i zabbix-release_4.0-3+bionic_all.deb
         sudo apt update

         #install the zabbix agent
         sudo apt install zabbix-agent zabbix-sender

         #generate key
         sudo openssl rand -hex 64 > /etc/zabbix/database.psk

         #append to the zabbix config
         printf "#GENERAL PARAMETERS\nPidFile=/var/run/zabbix/zabbix_agentd.pid\n\n#Option: LogFile\nLogFile=/var/log/zabbix/zabbix_agentd.log\n\n#Option: LogFileSize\nLogFileSize=0\n\n#Passive checks related\nServer=ZABBIXSERVER.COM\n\n#Active checks related\nServerActive=ZABBIXSERVER.COM\n\nHostnameItem=system.hostname\n\n#Option: Include\nInclude=/etc/zabbix/zabbix_agentd.d/*.conf\n\n# TLS-RELATED PARAMETERS\nTLSConnect=psk\n\n#Option: TLSAccept\nTLSAccept=psk\n\n#Option: TLSPSKFile\nTLSPSKFile=/etc/zabbix/database.psk\n\n# Option: TLSPSKIdentity\n" > /etc/zabbix/zabbix_agentd.conf

         #take the hostname of the machine and use it as the identity
         echo "TLSPSKIdentity="$HOSTNAME >> /etc/zabbix/zabbix_agentd.conf

         #show firewall status
         sudo ufw status

         #restart zabbix agent
         sudo systemctl restart zabbix-agent

         #print to screen when completed
         echo "Zabbix install completed" && cat /etc/zabbix/database.psk

~                                                                                                                                                                                             
~                                                                                                       
