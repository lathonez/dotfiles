#!/bin/bash

# See docker notes for where this comes from

#
# Hack to be putin ninehunred boot script
#

echo "Set ip forwarding on"
sysctl -w net.ipv4.ip_forward=1

# This iptables stuff was got when 
# See docker_setup.txt for notes on what I had to do the first time to get this working.
echo "restoring iptables"
iptables-restore < iptables.`hostname`

echo "replacing resolv.conf"
echo "domain openbet" > /etc/resolv.conf
echo "search openbet" >> /etc/resolv.conf
echo "nameserver cbc05e760451" >> /etc/resolv.conf
echo "nameserver 10.194.0.154" >> /etc/resolv.conf
echo "nameserver 10.194.0.232" >> /etc/resolv.conf

echo "Upping ulimit on open files for informix build (not necessarily required for informix users)"
ulimit -n 1048576

echo "You should now be able to run docker"
echo "If you're in the OpenBet network, you should use the -dns 10.194.0.232 -dns 10.194.0.154 -dns 10.194.0.155 arguments"

echo "restart docker service"
service docker start

echo "restarting registry"
docker ps -a | grep registry | awk '{print $1}' | xargs docker kill
docker ps -a | grep registry | awk '{print $1}' | xargs docker start
