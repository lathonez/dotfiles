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

# eth0 tunnel commands
eth0_csutproxy=""
eth0_proxy=""
eth0_jabber=""

# tunnel through ros
tunnel_host="r"

# will we tunnel into the database server?
do_tunnel_db=0

# will we set up the remote environment?
do_setup_env=0

# do we want to bind (some) of the tunnels to eth0?
do_eth0_bind=0

print_usage()  {
	echo " "
	echo "Usage: $0 [-edr] [username] [hostname]"
	echo "  -e : setup the remote environment (swap hosts, ssh config etc)"
	echo "  -d : tunnel into the database server"
	echo "  -r : bind certain tunnels to eth0 too"
	echo " "
}

while getopts ":der" o;
do
	case $o in
		d)  do_tunnel_db=1;;
		e)  do_setup_env=1;;
		r)  do_bind_eth0=1;;
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
		-L 8081:proxy.openbet:8080 \
		-L 5222:jabber.openbet.openbet.com:5222 \
		-L 138:shared.openbet:138 \
		-L 139:shared.openbet:139 \
		-L 445:shared.openbet:445 \
		-L 8139:shared.openbet:8139 \
		-L 8445:shared.openbet:8445 \
		-L 2401:pserver.openbet:2401 \
		$eth0_custproxy \
		$eth0_proxy \
		$eth0_jabber \
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


#
# Set up certain tunnels to also bind to eth0
#
function bind_eth0 {

	# first we need to work out what the ip is
	eth0_ip=`ifconfig | /bin/grep -A1 eth0 | /bin/grep inet | awk -F : '{print $2}' | awk '{print $1}'`

	# overwrite the eth0 tunnel commands set to "" above (eth0 ports are prefixed with 1)
	eth0_custproxy="-L $eth0_ip:18080:custproxy.openbet:8080"
	eth0_proxy="-L $eth0_ip:18081:proxy.openbet:8080"
	eth0_jabber="-L $eth0_ip:15222:jabber.openbet.openbet.com:5222"
}

if [ "$do_bind_eth0" = "1" ]
then
	bind_eth0
fi

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

