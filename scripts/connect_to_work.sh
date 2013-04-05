#!/bin/bash
# $Id: OpenBetConnect.txt,v 1.1 2010/09/24 08:51:51 acollins Exp $
# $Header: /var/www/twiki/data/Main/Helpdesk/OpenBetConnect.txt,v 1.1 2010/09/24 08:51:51 acollins Exp $
#
# Generic script to connect to OpenBet network using SSH.

user=""
host=""

# Stuff for the DB01 tunnel
# /etc/services
db01_1150_port=1900
db01_1170_port=1902

# tunnel through ros
tunnel_host="r"

# will we tunnel into the database server?
do_tunnel_db=0

# will we set up the remote environment?
do_setup_env=0

print_usage()  {
	echo " "
	echo "Usage: $0 [-ed] [username] [hostname]"
	echo "  -e : setup the remote environment (swap hosts, ssh config etc)"
	echo "  -d : tunnel into the database server"
	echo " "
}

while getopts ":de" o;
do
	case $o in
		d)  do_tunnel_db=1;;
		e)  do_setup_env=1;;
		\?)
			print_usage;
			exit 1;;
	esac
done

# get the username and host from after input args
eval "user=\$$OPTIND"
eval "host=\$$(expr $OPTIND + 1)"

#sanity
if [ "$user" = "" -o "$host" = "" ]
then
	print_usage;
	exit;
fi

#
# connect to the VPN
#
function connect {

	echo "attempting to connect to $user@$host.."

	# need sudo for the reserved ports
	sudo ssh $user@$host -nfC \
		-L 10022:pluto.openbet:22 \
		-L 10023:rosalind.openbet:22 \
		-L 10024:titan.openbet:22 \
		-L 10025:dev01.openbet:22 \
		-L 25:smtp.openbet:25 \
		-L 465:smtp.openbet:465 \
		-L 389:ldap.openbet:389 \
		-L 636:ldap.openbet:636 \
		-L 8080:custproxy.openbet:8080 \
		-L 5222:jabber.openbet.openbet.com:5222 \
		-L 138:shared.openbet:138 \
		-L 139:shared.openbet:139 \
		-L 445:shared.openbet:445 \
		-L 8139:shared.openbet:8139 \
		-L 8445:shared.openbet:8445 \
		-L 2401:pserver.openbet:2401 \
		-o ServerAliveInterval=60 \
		-o ServerAliveCountMax=2 \
		keepalive
}

#
# Set up the laptop for working out of the office
#
function setup_env {

	# sortout hosts file
	echo 'linking hosts'
	cd ~/shaz_utils/hosts
	rm current
	ln -s hosts_remote current

	#sort ssh_config
	echo 'linking ssh config'
	cd ~/.ssh
	rm config
	ln -s ~/shaz_utils/ssh/ssh_remote config
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
	ssh $user@$tunnel_host -f -nNC -L $db01_1150_port:db01:$db01_1150_port
	ssh $user@$tunnel_host -f -nNC -L $db01_1170_port:db01:$db01_1170_port
}

if [ "$do_setup_env" = "1" ]
then
	setup_env;
fi

# tunnel
connect

if [ "$do_tunnel_db" = "1" ]
then
	tunnel_db;
fi

