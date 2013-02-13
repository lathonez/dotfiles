#!/bin/bash
# $Id: OpenBetConnect.txt,v 1.1 2010/09/24 08:51:51 acollins Exp $
# $Header: /var/www/twiki/data/Main/Helpdesk/OpenBetConnect.txt,v 1.1 2010/09/24 08:51:51 acollins Exp $
#
# Generic script to connect to OpenBet network using SSH.

# Set-up for zimbra users, if you are not on zimbra, than just change zimbra to mail.
MAILHOST=mail.openbet
# Change this if your local user is not the same as OpenBet user.
CONNECTUSER=shazleto

#
# DB01 Tunnel :
#
# 35149:titan.orbis:9002 is to tunnel to db01. This requires another tunnel set up on titan as follows:
#
# ssh -L 10.194.0.41:35149:127.0.0.1:35148 localhost
# ssh -L 127.0.0.1:35148:10.194.0.141:1900 localhost
#
function connect {
   CONNECTHOST=$1
   echo "attempting to connect to $CONNECTUSER@$CONNECTHOST..."
   ssh $CONNECTUSER@$CONNECTHOST -nNC \
      -L 10022:pluto.orbis:22 \
      -L 10023:rosalind.orbis:22 \
      -L 10024:titan.orbis:22 \
      -L 10025:dev01.orbis:22 \
      -L 25:smtp.orbis:25 \
      -L 465:smtp.orbis:465 \
      -L 389:ldap.openbet:389 \
      -L 636:ldap.openbet:636 \
      -L 8080:custproxy.orbis:8080 \
      -L 5222:jabber.openbet.com:5222 \
      -L 110:$MAILHOST:110 \
      -L 143:$MAILHOST:143 \
      -L 993:$MAILHOST:993 \
      -L 995:$MAILHOST:995 \
      -L 138:shared.orbis:138 \
      -L 139:shared.orbis:139 \
      -L 445:shared.orbis:445 \
      -L 8139:shared.orbis:8139 \
      -L 8445:shared.orbis:8445 \
      -L 1526:sadr.orbis:1526 \
      -L 1541:sadr.orbis:1541 \
      -L 3389:rhea.orbis:3389 \
      -L 3390:saturn.orbis:3389 \
      -L 9000:sadr.orbis:9000 \
      -L 2401:pserver.openbet:2401 \
      -o ServerAliveInterval=60 \
      -o ServerAliveCountMax=2 \
      keepalive
}

function setup_remote_env {

	# sortout hosts file
	echo 'linking hosts'
	cd ~/shaz_utils/hosts
	rm current
	ln -s hosts_remote current

	# sort bash
	echo 'linking bashrc'
	cd
	rm .bashrc
	ln -s shaz_utils/bash/bash_remote .bashrc
	source ~/.bashrc

	#sort screen
	#echo 'linking screen'
	#cd ~
	#rm .screenrc
	#ln -s scripts/screen/screen_remote .screenrc

	#sort ssh_config
	echo 'linking ssh config'
	cd ~/.ssh
	rm config
	ln -s ~/shaz_utils/ssh/ssh_remote config

	#sort sqlhosts
	#echo 'linking sql hosts'
	#cd /opt/informix/etc
	#rm sqlhosts
	#ln -s ~/shaz_utils/informix/sqlhosts.remote sqlhosts
}

# we are away from the office so setup the remote environment as a matter of course
# obviously we only need to do this once..
setup_remote_env

while [ 1 ]; do
   connect vpn.openbet.com
   echo "Disconnected - we are waiting for 1 seconds."
   sleep 1
done
