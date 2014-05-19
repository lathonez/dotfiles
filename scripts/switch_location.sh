#!/bin/bash

location=$1

print_usage() {
	echo "Usage: $0 location (OFFICE|REMOTE)"
	exit 1
}

if [ -z "$location" ]; then
	print_usage
fi

check_location() {

	case "$location" in
		OFFICE)
			proc=office
			;;
		REMOTE)
			proc=remote
			;;
		*)
		    echo "Incorrect location supplied"
		    print_usage
	esac
}

office() {
	cd ~/utils/ssh
	rm current
	ln -s ssh.x220.office current

	cd ~/utils/hosts
	rm current
	ln -s hosts.x220.office current
}

remote() {
	cd ~/utils/ssh
	rm current
	ln -s ssh.x220 current

	cd ~/utils/hosts
	rm current
	ln -s hosts.x220 current
}

check_location
$proc
