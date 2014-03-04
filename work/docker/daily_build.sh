#!/bin/bash

# lon1 url
lon1="lon1vtp32.int.openbet.com"
nh="ninehundred.brentford.openbet.com"

# releases
current_release="r36"
next_release="r37"

# logfiles
current_log="/tmp/shutit.daily.current.log"
next_log="/tmp/shutit.daily.next.log"

# define some dates
today=`date +"%Y%m%d"`
delete=`date +"%Y%m%d" -d "2 days ago"`

cd ~/shutit

# build current live
#python shutit_main.py --image_tag ninehundred.brentford.openbet.com:5000/r36_template_2014-02-07 --shutit_module_path ../shutit_modules/openbet/:../shutit_modules/openbet/hills > $current_log

# we should have a pushed image now, if not we can't go any further with current
success=`sudo docker images | grep hills_${current_release}_${today} | awk -F "/" '{print $2}' | awk '{print $1}'`

# if the build was successul, we'll remove the day before yesterday's (keep previous just in case of stuff)
if [ "x${success}" != "x" ]
then

	echo "current live build looks successful - $success"

	if [ "x${deletable}" != "x" ]
	then
		echo "found an image to delete: $to_delete"
	#sudo docker rmi $to_delete
	else
		echo "no image to delete, maybe manual cleanup is required"
	fi

	# push the to lon1
	tag_cmd="sudo docker tag ${nh}:5000/${success} ${lon1}:5000/${success}"
	echo "Tagging with: $tag_cmd"
	$tag_cmd

	push_cmd="sudo docker push ${lon1}:5000/${success}"
	echo "Pushing with: $push_cmd"
	$push_cmd

	untag_cmd="sudo docker rmi ${lon1}:5000/${success}"
	echo "Untagging with: $untag_cmd"
	$untag_cmd
else
	echo "current live build looks to have failed, check $current_log"
fi



