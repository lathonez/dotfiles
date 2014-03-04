#!/bin/bash

# $1 image id / name
# $2 command

if [ "$1" = "" ]
then
	echo "usage drun 2df8d7b0325b ?command?"
	exit 1
fi

g=`which grep`

# this is filth, cant think of a better way of doing it for now - hostname would be preferably, but then we have to use custproxy for the DNS, which may break SSL
host_ipa=`ifconfig | $g -A1 eth | $g inet | $g -v inet6 | awk -F ':' '{print $2}' | awk '{print $1}'`

#host_ipa="localhost"
username=`whoami`
conthost="test1"
ssh_port=50010
web_port=50011
ssl_port=50012

if [ "$2" = "" ]
then
	cmd="/root/start_hills.sh $username $host_ipa $web_port $ssl_port"
else
	cmd=$2
fi

sudo docker run -privileged -h $conthost -p $ssh_port:22 -p $web_port:80 -p $ssl_port:443 -t -i $1 $cmd
