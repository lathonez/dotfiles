#!/bin/bash

# execute the connections.sh script on the liveserv boxes

boxes="sc1 sc2 sc3 sc4"
cmd="nice -n 19 ~/gn/connections.sh"
log="../log/liveserv.log"
interval="300"

while true
do
	for box in $boxes
	do
		ssh $box $cmd >> $log
		echo "" >> $log
	done

	sleep $interval
done
