# get the core 0 temp
temp=`sensors | grep "Core 0" | awk '{print $3}' | egrep -o "[1-9][0-9]"`
echo ${temp}°C