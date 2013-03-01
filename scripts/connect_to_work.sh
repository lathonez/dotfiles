#!/bin/bash
# $Id: OpenBetConnect.txt,v 1.1 2010/09/24 08:51:51 acollins Exp $
# $Header: /var/www/twiki/data/Main/Helpdesk/OpenBetConnect.txt,v 1.1 2010/09/24 08:51:51 acollins Exp $
#
# Generic script to connect to OpenBet network using SSH.

CONNECTUSER=shazleto
CONNETHOST=ssh.openbet.com

# Stuff for the DB01 tunnel
# /etc/services
db01_1150_port=1900
db01_1170_port=1902

# effectively which dev server to tunnel through
tunnel_port=10023

# we need to specify which key we're using as going back from root
key_file=/home/shazleto/.ssh/id_rsa

#
# connect to the VPN
#
function connect {
   CONNECTHOST=$1
   echo "attempting to connect to $CONNECTUSER@$CONNECTHOST..."
   ssh $CONNECTUSER@$CONNECTHOST -nfC \
      -L 10022:pluto.orbis:22 \
      -L 10023:rosalind.orbis:22 \
      -L 10024:titan.orbis:22 \
      -L 10025:dev01.orbis:22 \
      -L 25:smtp.orbis:25 \
      -L 465:smtp.orbis:465 \
      -L 389:ldap.openbet:389 \
      -L 636:ldap.openbet:636 \
      -L 8080:custproxy.orbis:8080 \
      -L 5222:jabber.openbet.openbet.com:5222 \
      -L 138:shared.orbis:138 \
      -L 139:shared.orbis:139 \
      -L 445:shared.orbis:445 \
      -L 8139:shared.orbis:8139 \
      -L 8445:shared.orbis:8445 \
      -L 3389:rhea.orbis:3389 \
      -L 3390:saturn.orbis:3389 \
      -L 2401:pserver.openbet:2401 \
      -o ServerAliveInterval=60 \
      -o ServerAliveCountMax=2 \
      keepalive
}

#
# Set up the laptop for working out of the office
#
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


#
# Setup the database server tunnel
#
function tunnel_db {

	# -f: background
	# -n: redirect dev null
	# -N: no command
	# -C: compression

	echo 'tunnelling to database server'
	ssh -i $key_file -p $tunnel_port $CONNECTUSER@localhost -f -nNC -L $db01_1150_port:db01:$db01_1150_port	
	ssh -i $key_file -p $tunnel_port $CONNECTUSER@localhost -f -nNC -L $db01_1170_port:db01:$db01_1170_port
}

# we are away from the office so setup the remote environment as a matter of course
# obviously we only need to do this once..
setup_remote_env
connect ssh.openbet.com
tunnel_db

