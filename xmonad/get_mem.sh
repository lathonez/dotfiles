# get the percentage of free memory
medium=59
high=79
freemem=`free | grep Mem | awk '{print $3/$2 * 100.0}' | awk -F '.' '{print $1}'`

rtn=$freemem

if [ $temp -gt $medium ]; then
	rtn="<fc=#FFFF00>${freemem}</fc>"
fi

if [ $temp -gt $high ]; then
	rtn="<fc=#FF0000>${freemem}</fc>"
fi

echo ${rtn}%