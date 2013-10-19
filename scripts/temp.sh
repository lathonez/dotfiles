#!/bin/sh

str=`sensors`
new_txt=`echo $str | awk '{print $6}'`
disp_txt=`echo $new_txt | sed 's/.\(.*\)/\1/'`

temp=`echo $new_txt | sed 's/.\(.*\)../\1/'`

test1=`echo "$temp < 40" | bc`
test2=`echo "$temp < 60" | bc`
test3=`echo "$temp < 80" | bc`
test4=`echo "$temp < 95" | bc`

if [ "$test1" -eq "1" ]; then
	col="3399cc"
elif [ "$test2" -eq "1" ]; then
	col="00aa55"
elif [ "$test3" -eq "1" ]; then
	col="ff3300"
elif [ "$test4" -eq "1" ]; then
	col="ff0000"
else
	col="ff0000"
	disp_txt="${disp_txt} - MELTING - SHUTDOWN"
fi

echo "<fc=#${col}>${disp_txt}</fc>"
