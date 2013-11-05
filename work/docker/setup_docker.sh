#!/bin/bash

# See docker notes for where this comes from

if [ `whoami` != "root" ]
then
	echo You must be root to run this
	exit
fi
# Install - see docker installation for latest instructions and/or instructions
# for your version of the kernel, which may differ.
if [ `dpkg -l | grep lxc-docker | wc -l` = "0" ]
then
	# Add the PPA sources to your apt sources list.
	sudo apt-get install python-software-properties && sudo add-apt-repository ppa:dotcloud/lxc-docker
	# Update your sources
	sudo apt-get update
	# Install, you will see another warning that the package cannot be authenticated. Confirm install.
	sudo apt-get install lxc-docker
fi

echo "Set ip forwarding on"
sysctl -w net.ipv4.ip_forward=1

# This iptables stuff was got when 
# See docker_setup.txt for notes on what I had to do the first time to get this working.
echo "restoring iptables"
iptables-restore < iptables.`hostname`

echo "In the office? (y/n)"
read a
if [ $a = "y" ]
then
	echo "replacing resolv.conf"
	echo "domain openbet" > /etc/resolv.conf
	echo "search openbet" >> /etc/resolv.conf
	echo "nameserver cbc05e760451" >> /etc/resolv.conf
	echo "nameserver 10.194.0.154" >> /etc/resolv.conf
	echo "nameserver 10.194.0.232" >> /etc/resolv.conf
fi

echo "Upping ulimit on open files for informix build (not necessarily required for informix users)"
ulimit -n 1048576

echo "You should now be able to run docker"
echo "If you're in the OpenBet network, you should use the -dns 10.194.0.232 -dns 10.194.0.154 -dns 10.194.0.155 arguments"

echo "restart docker service"
service docker stop
ps -ef | grep docker..d | grep -v grep | awk '{print $2}' | xargs kill
docker -d &

