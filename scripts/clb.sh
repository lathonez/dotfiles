#!/bin/bash
# grep build.conf for current live branch of something
usage="$0 <customer code (lower)> <module>"

if [ "$1" == "" -o "$2" == "" ]
then
	echo $usage;
	exit;
fi

cust=$1
module=$2

ssh r "grep $module /shared/prj/daily_build/support_${cust}*/build.conf | grep pserver"
