#!/bin/bash

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

# Send failure reports to this address
mailto="stephen.hazleton@openbet.com"

# return value from build_image
build_status=0

# check to make sure the system is in a decent state to build, we might want to reboot
check_sar() {

	# not sure what's best to check for, commit seems a good starter - following is from man sar:
	# Percentage of memory needed for current workload in relation to the total amount of memory (RAM+swap). This number may be greater than 100% because the kernel usually overcommits memory.
	# I think at 100% commit we want to reboot?
	sar -r -s > /tmp/sar.out
	commit=`cat /tmp/sar.out | tail -n 1 | awk '{print $8}' | awk -F '.' '{print $1}'`

	if [ $commit -gt 100 ] ; then
		echo "Commit $commit is too high to attempt a build, you need to reboot the box."
		sendemail \
			-f serverops@ninehundred.com \
			-t $mailto \
			-m "Server Restart Required. See sar logs attached\n\n --NineHundred ServerOps" \
			-u "Shutit build not attempted - Server Restart Required" \
			-a /tmp/sar.out \
			-a $log
		build_status=0
		exit 1
	fi

	echo "sar check passed OK"
}

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
	log="/tmp/${image}_${today}.log"

	if [ -z "$inner_image" ] ; then
		com="./build.sh -p $build > $log"
	else
		com="./build.sh -p -i${inner_image} $build > $log"
	fi

	echo "building with $com"

	# check to see whether an image with this name already exists, if so don't build but return success (as we've already built..)
	exists=`sudo docker images | grep ${image}_${today} | awk -F "/" '{print $2}' | awk '{print $1}'`
	if [ ! -z "$exists" ] ; then
		echo "${image}_${today} already exists, not building"
		build_status=1
		return
	fi

	cd ~/whdock/shutit
	eval $com

	# we should have a pushed image now, if not we can't go any further with current
	success=`sudo docker images | grep ${image}_${today} | awk -F "/" '{print $2}' | awk '{print $1}'`

	# if the build was successul, we'll remove the day before yesterday's (keep previous just in case of stuff)
	if [ ! -z "${success}" ] ; then
		echo "$build build is successful - $success"

		old_image=`sudo docker images | grep ${image}_${stale} | awk -F "/" '{print $2}' | awk '{print $1}'`

		if [ ! -z "${old_image}" ] ; then
			echo "found an image to delete: $old_image"

			# clear out any containers which may be using the image
			sudo docker ps -a | grep $old_image | awk '{print $1}' | xargs sudo docker rm

			old_image_repo="${nh}:5000/${old_image}"
			sudo docker rmi $old_image_repo
			cd $repo_dir
			sudo rm -r $old_image
		fi

		build_status=1
		return
	else
		echo "$build build looks to have failed, check $log"
		sendemail \
			-f broken@shutit.com \
			-t $mailto \
			-m "Build failure. See logs attached\n\n --Broken Shutit" \
			-u "$build Build Failed" \
			-a /tmp/shutit.daily.log \
			-a $log
		build_status=0
		return
	fi
}

# check to see if the box is up to it before going ahead with the build
check_sar

build_image CURRENT hills_r${current_release}

if [ $build_status -eq 1 ] ; then
	echo "running data for CURRENT"
	build_image DATA_LOAD hills_r${current_release}_data hills_r${current_release}_${today}
fi

build_image NEXT hills_r${next_release}

if [ $build_status -eq 1 ] ; then
	echo "running data for NEXT"
	build_image DATA_LOAD hills_r${next_release}_data hills_r${next_release}_${today}
fi
