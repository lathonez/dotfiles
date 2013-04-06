#!/bin/bash

cd ../logs

current=`date +"%H:%M:%S"`
ntail="5"

for perf in `ls *perf* | grep -v xsys`;
do 
	echo "| $current $perf - Monitoring Query Times|"
	echo " Max   |  Ave  | Calls |  Pct  | Query"
	grep PRIMARY $perf | tail -n $ntail | sed 's/PRIMARY//g' | awk '{printf "%.2f\t%.2f\t%.0f\t%0.f%\t%.45s\n",$3,$4,$5,$6,$1}';
	echo ""
done
