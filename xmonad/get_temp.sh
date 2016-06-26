# get the core 0 temp
medium=59
high=79
temp=`sensors | grep "Core 0" | awk '{print $3}' | egrep -o "[1-9][0-9]"`

rtn=$temp

if [ $temp -gt $medium ]; then
	rtn="<fc=#FFFF00>${temp}</fc>"
fi

if [ $temp -gt $high ]; then
	rtn="<fc=#FF0000>${temp}</fc>"
fi

echo ${rtn}°
