#!/bin/sh

# ============================================================================
# $Header: /cvsroot/willhill/scripts/postgres/postgres.sh,v 1.6.52.2 2013/10/10 15:00:37 kdheena Exp $
# $Name: B_WillHill_34_0_2 $
#
# (C) 2011 OpenBet Technologies Ltd. All rights reserved.
# ============================================================================

# set up environment variables
export PATH=/opt/informix/10.0/bin:/opt/informix/10.0/bin:/opt/openbet/bin:/opt/openbet/current/openbet_utils:/opt/openbet/control:/opt/openbet/current/bin:/opt/openbet/appserv/bin:/opt/informix/10.0/bin:/opt/openbet/release/tcl/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/opt/openbet/postgres/bin:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/perf/bin:/root/bin:/usr/local/ardenta
export LD_LIBRARY_PATH=/opt/openbet/current/lib:/opt/informix/10.0/lib:/opt/informix/10.0/lib/esql:/opt/openbet/appserv/lib:/opt/openbet/release/tcl/lib:/lib:/usr/lib:/usr/local/lib:/opt/openbet/release/postgres/lib:/opt/openbet/release/openssl-1.0.0a/lib:/opt/openbet/release/openssl-0.9.8b/lib/:/usr/local/postgresql/lib
export INFORMIXDIR=/opt/informix/10.0
export INFORMIXSERVER=openbet_tcp

# set up postgres variables
BOX=$(hostname)
DB_STORE='/database/dbpublish'
POSTGRES='/usr/lib/postgresql/9.1/bin'
APP='/opt/openbet/rep_client'

LOG_DIR=/opt/openbet/rep_client/log
LOG_FILE=postgres.log_out.`date +"%Y%m%d_%H"`

# initalise the postgres database
init_database() {

	echo "Creating postgres installation"
	export LC_ALL="en_US.UTF-8"

	# let's init our database
	$POSTGRES/initdb -D $DB_STORE/data/

	echo "Copying over config file $INSTALL_CONFIG"
	cp $INSTALL_CONFIG $DB_STORE/data/postgresql.conf

	for db in dbpublish; do
		createdb -E UTF8 -O openbet $db  -T 'template0'

		echo "CREATE ROLE dbPublish WITH LOGIN"     | psql $db
		echo "ALTER USER dbPublish with SUPERUSER"  | psql $db
		echo "CREATE LANGUAGE plpgsql"              | psql $db
	done;
}

if [ $1 ]
then
	INSTALL_CONFIG=$APP/conf/postgres/postgresql_$1.conf

	if [ -e "$INSTALL_CONFIG" ]
	then
		echo "found config $INSTALL_CONFIG"
	else
		echo "failed to locate config $INSTALL_CONFIG"
		exit 2
	fi
else
	echo "please specify installtion server size [small|medium|large]"
	exit 2
fi

# validate LOG_DIR exists
if [ ! -d $LOG_DIR ]; then
	# directory does not exist - create it
	mkdir $LOG_DIR
	if [ $? -ne 0 ]; then
		echo "Error - unable to create directory '$LOG_DIR'"
		exit 2
	fi
fi

init_database
