#!/bin/bash

cd ../logs

current=`date +"%H:%M:%S"`
ntail="5"

for perf in `ls *perf* | egrep -v "rep|xsys|livepublish"`;
do 
	echo "| $current $perf - Monitoring Request Times |"
	echo " Max   |  Ave  | Calls |  Pct  | Request"
	egrep "request::handle|process_req" $perf | tail -n $ntail | sed 's/request::handle//g' | sed 's/process_request//g' | awk '{printf "%.2f\t%.2f\t%.0f\t%0.f%\t%s\n",$3,$4,$5,$6,$1}';
	echo ""
done
