#!/bin/bash

# lon1 url
lon1="lon1vtp32.int.openbet.com"
nh="ninehundred.brentford.openbet.com"

# releases
current_release="38"
next_release="39"

# define some dates
today=`date +"%Y%m%d"`
stale=`date +"%Y%m%d" -d "2 days ago"`

# logfiles
current_log="/tmp/shutit.daily.current.${today}.log"
next_log="/tmp/shutit.daily.next.${today}.log"

# repodir
repo_dir="/srv/registry/repositories/library"
mailto="stephen.hazleton@openbet.com"

# build current live
#python shutit_main.py --image_tag ninehundred.brentford.openbet.com:5000/r37_template_2014-02-28 --config ../shutit_modules/openbet/hills/configs/current_daily_build.cnf --shutit_module_path ../shutit_modules/openbet/:../shutit_modules/openbet/hills > $current_log
cd ~/whdock/shutit
./build.sh -p CURRENT > $current_log

# we should have a pushed image now, if not we can't go any further with current
success=`sudo docker images | grep hills_r${current_release}_${today} | awk -F "/" '{print $2}' | awk '{print $1}'`

# if the build was successul, we'll remove the day before yesterday's (keep previous just in case of stuff)
if [ "x${success}" != "x" ]
then

	echo "current live build looks successful - $success"

	old_image=`sudo docker images | grep hills_r${current_release}_${stale} | awk -F "/" '{print $2}' | awk '{print $1}'`

	if [ "x${old_image}" != "x" ]
	then
		echo "found an image to delete: $old_image"

		# clear out any containers which may be using the image
		sudo docker ps -a | grep $old_image | awk '{print $1}' | xargs sudo docker rm

		old_image_repo="${nh}:5000/${old_image}"
		sudo docker rmi $old_image_repo
		cd $repo_dir
		sudo rm -r $old_image
	else
		echo "no image to delete, maybe manual cleanup is required"
	fi

	# push to lon1
	#tag_cmd="sudo docker tag ${nh}:5000/${success} ${lon1}:5000/${success}"
	#echo "Tagging with: $tag_cmd"
	#$tag_cmd

	#push_cmd="sudo docker push ${lon1}:5000/${success}"
	#echo "Pushing with: $push_cmd"
	#$push_cmd

	#untag_cmd="sudo docker rmi ${lon1}:5000/${success}"
	#echo "Untagging with: $untag_cmd"
	#$untag_cmd
else
	echo "current live build looks to have failed, check $current_log"
	echo "Build failure. See log attached" | mail -s "CURRENT_LIVE_BRANCHES Build Failed" -a $current_log $mailto
fi

old_image=""
old_image_repo=""

cd ~/whdock/shutit
# build next live
./build.sh -p NEXT > $next_log

# we should have a pushed image now, if not we can't go any further with current
success=`sudo docker images | grep hills_r${next_release}_${today} | awk -F "/" '{print $2}' | awk '{print $1}'`

# if the build was successul, we'll remove the day before yesterday's (keep previous just in case of stuff)
if [ "x${success}" != "x" ]
then

	echo "current live build looks successful - $success"

	old_image=`sudo docker images | grep hills_r${next_release}_${stale} | awk -F "/" '{print $2}' | awk '{print $1}'`

	if [ "x${old_image}" != "x" ]
	then
		echo "found an image to delete: $old_image"

		# clear out any containers which may be using the image
		sudo docker ps -a | grep $old_image | awk '{print $1}' | xargs sudo docker rm

		old_image_repo="${nh}:5000/${old_image}"
		sudo docker rmi $old_image_repo
		cd $repo_dir
		sudo rm -r $old_image
	else
		echo "no image to delete, maybe manual cleanup is required"
	fi
else
	echo "next live build looks to have failed, check $next_log"
	echo "Build failure. See log attached" | mail -s "NEXT_LIVE_BRANCHES Build Failed" -a $next_log $mailto
fi
