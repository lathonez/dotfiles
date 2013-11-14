#!/bin/bash

# $1 image id / name
# $2 command

if [ "$1" = "" ]
then
	echo "usage drun 2df8d7b0325b ?/root/start.sh?"
	exit 1
fi

if [ "$2" = "" ]
then
	cmd=/root/start.sh
else
	cmd=$2
fi

sudo docker run -privileged -h=test1 -p 40000:22 -p 50000:80 -t -i $1 $cmd
