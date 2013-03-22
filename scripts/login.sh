#!/bin/bash
# bunch of stuff to do on login

# on login we should assume we are in the office.
# the tunnel script will do remote if necessary
function office_env {

	# sort hosts
	echo 'linking hosts'
	cd ~/shaz_utils/hosts
	rm current
	ln -s hosts_office current

	#sort ssh
	echo 'linking ssh'
	cd ~/.ssh
	rm config
	ln -s ~/shaz_utils/ssh/ssh_office config
}

office_env
