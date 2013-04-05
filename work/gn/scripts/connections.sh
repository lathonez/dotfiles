#!/bin/bash

# ports
flash_ports=':843|:2156'
con_flash_ports=':2156'
http_ports=':80|:http'

# dump netstat once
netstat -an > netstat.out
tot_flash=`egrep $flash_ports netstat.out | wc -l`
con_flash=`egrep $con_flash_ports netstat.out | wc -l`
tot_http=`egrep $http_ports netstat.out | wc -l`
con_http=`egrep $http_ports netstat.out | grep -v 'TIME_WAIT' | wc -l`
tot_con=`cat netstat.out | wc -l`
dead_flash=$(($tot_flash - $con_flash))
dead_http=$(($tot_http - $con_http))

current=`date +"%H:%M:%S"`
logstr="$current $HOSTNAME"
echo "$logstr | Total Connections: $tot_con"
echo "$logstr | Flash Connections: $tot_flash ($con_flash established / $dead_flash dead)"
echo "$logstr | HTTP Connections:  $tot_http ($con_http established / $dead_http dead)"
