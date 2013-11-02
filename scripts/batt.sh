#!/bin/sh

str=`acpi -b`
batt_state=${str#Batt*:\ }
batt_state=${batt_state%%,*}
batt_level=${str#Batt*,\ }
batt_level=${batt_level%\%*}

time=${str#*\%,\ }

test1=`echo "$batt_level >= 80" | bc`
test2=`echo "$batt_level >= 60" | bc`
test3=`echo "$batt_level >= 40" | bc`
test4=`echo "$batt_level >= 20" | bc`
test5=`echo "$batt_level >= 10" | bc`

testfull=`echo "$batt_level > 99" | bc`

if [ $testfull -eq 1 ]; then
	op="Charged"
else
	if [ "$batt_state" = "Unknown" ]; then
		op= "$batt_level% - $time"
	else
		op="$batt_state $batt_level% - $time"
	fi
fi

if [ "$test1" -eq "1" ]; then
	#grey
	col="b9b6b6"
elif [ "$test2" -eq "1" ]; then
	#blue
	col="3399cc"
elif [ "$test3" -eq "1" ]; then
	#green
	col="00aa55"
elif [ "$test4" -eq "1" ]; then
	#amber
	col="ff3300"
elif [ "$test5" -eq "1" ]; then
	#pink
	col="ff0000"
else
	#red
	col="ff0000"
fi

echo "<fc=#${col}>${op}</fc>"
