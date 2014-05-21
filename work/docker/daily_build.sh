#!/bin/bash

nh="ninehundred.brentford.openbet.com"

# releases
current_release="38"
next_release="39"

# define some dates
today=`date +"%Y%m%d"`
stale=`date +"%Y%m%d" -d "2 days ago"`

# new images
new_current_image="hills_r${current_release}_${today}"
new_next_image="hills_r${next_release}_${today}"

# logfiles
current_log="/tmp/shutit.daily.current.${today}.log"
next_log="/tmp/shutit.daily.next.${today}.log"

# repodir
repo_dir="/srv/registry/repositories/library"

# Send failure reports to this address
mailto="stephen.hazleton@openbet.com"

# return value from build_image
build_status=0

build_image() {

	success=""
	old_image=""
	old_image_repo=""
	build_status=0

	# CURRENT/NEXT/DATA..
	build=$1
	# Image we're looking for without the data (e.g. hills_r38 or hills_r38_data)
	image=$2
	inner_image=$3

	if [ -z "$inner_image" ] ; then
		log="/tmp/${image}_${today}.log"
		com="./build.sh -p $build > $log"
	else
		log="/tmp/${image}_${inner_image}_${today}.log"
		com="./build.sh -p -i${inner_image} $build > $log"
	fi

	echo "building with $com"

	cd ~/whdock/shutit
	eval $com

	# we should have a pushed image now, if not we can't go any further with current
	success=`sudo docker images | grep ${image}_${today} | awk -F "/" '{print $2}' | awk '{print $1}'`

	# if the build was successul, we'll remove the day before yesterday's (keep previous just in case of stuff)
	if [ -z "${success}" ] ; then
		echo "$build build looks to have failed, check $log"
		sendemail \
			-f broken@shutit.com \
			-t $mailto \
			-m "Build failure. See logs attached\n\n --Broken Shutit" \
			-u "$build Build Failed" \
			-a /tmp/shutit.daily.log \
			-a $log
		build_status=0
	else
		echo "$build build looks successful - $success"

		old_image=`sudo docker images | grep ${image}_${stale} | awk -F "/" '{print $2}' | awk '{print $1}'`

		if [ -z "${old_image}" ] ; then
			echo "no image to delete, maybe manual cleanup is required"
		else
			echo "found an image to delete: $old_image"

			# clear out any containers which may be using the image
			sudo docker ps -a | grep $old_image | awk '{print $1}' | xargs sudo docker rm

			old_image_repo="${nh}:5000/${old_image}"
			sudo docker rmi $old_image_repo
			cd $repo_dir
			sudo rm -r $old_image
		fi
		build_status=1
	fi
}

build_image CURRENT hills_r${current_release}

if [ $build_success -eq 1 ] ; then
	echo "running data for CURRENT"
	build_image DATA_LOAD hills_r${current_release}
fi

# exit for testing
build_image NEXT hills_r${next_release}

if [ $build_sucess -eq 1 ] ; then
	echo "running data for NEXT"
	build_image DATA_LOAD hills_r${next_release}
fi

