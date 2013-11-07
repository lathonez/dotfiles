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


# database start
db_start() {
	# start db
	echo "Copying over config file $INSTALL_CONFIG"
	cp $INSTALL_CONFIG $DB_STORE/data/postgresql.conf
	echo "Starting postgres"
	$POSTGRES/pg_ctl -D$DB_STORE/data -l $DB_STORE/logfile start
	echo "postgres started"
}


# database shutdown
db_shutdown() {
	# shutdown db
	echo "Stopping progres in directory '$DB_STORE'"
	$POSTGRES/pg_ctl -D$DB_STORE/data -l $DB_STORE/logfile stop -m fast
	echo "postgres stopped"
}

# set up a startup procedure (of this script)
script_startup() {
	# Log we are starting up
	date=`date +"%Y-%m-%d %H:%M:%S"`
	echo "$date : Startup initiated..." >> $LOG_DIR/$LOG_FILE
	run=1
}
# set up a shutdown procedure (of this script)
script_shutdown() {
	# Log we are shutting down
	date=`date +"%Y-%m-%d %H:%M:%S"`
	echo "$date : Shutdown initiated..." >> $LOG_DIR/$LOG_FILE

	db_shutdown
	echo "$date : Postgres Shutdown!" >> $LOG_DIR/$LOG_FILE
	run=0
	# exit nicely
	exit 0
}

# initalise the postgres database
init_database() {
	echo "Creating postgres installation"
	export LC_ALL="en_US.UTF-8"

	# let's init our database
	$POSTGRES/initdb -D $DB_STORE/data/

	echo "Copying over config file $INSTALL_CONFIG"
	cp $INSTALL_CONFIG $DB_STORE/data/postgresql.conf

	db_start
	sleep 10
	for db in dbpublish dbpublish_gib dbpublish_uk; do
		createdb -E UTF8 -O openbet $db  -T 'template0'

		echo "CREATE ROLE dbPublish WITH LOGIN"     | psql $db
		echo "ALTER USER dbPublish with SUPERUSER"  | psql $db
		echo "CREATE LANGUAGE plpgsql"              | psql $db
	done;
	run=1
}

# delete the database directory and then reinitalise it
#- used for when database directory becomes full
init_rebuild() {
	db_shutdown
	echo "$date : Postgres Shutdown!" >> $LOG_DIR/$LOG_FILE

	rm -rf /database/dbpublish
	init_database
}

# capture signals which should cause shut down
# on HUP/INT/TERM, stop postgres then terminate
trap script_shutdown HUP INT TERM


# check if postgres is on the box
if [ -d "$POSTGRES" ]; then
	# check if the db is initialized
	if [ -d "$DB_STORE" ]; then
		OWNER=$(stat -c %U $DB_STORE)
		if [ "$OWNER" = "openbet" ]; then
			echo "100.i - startup in $DB_STORE"
			script_startup
		else
			echo "Current owner is not openbet (owner: $OWNER)" >> $LOG_DIR/$LOG_FILE
			exit 1
		fi
	else
		echo "current box ($BOX) doesnt have postgres initialized" >> $LOG_DIR/$LOG_FILE
		echo "108.i - startup in $DB_STORE"
		init_database
	fi
else
	echo "112.i - startup in $DB_STORE"
	echo "current box ($BOX) doesnt have postgres setup" >> $LOG_DIR/$LOG_FILE
	exit 1
fi


#

#
# Run the instance and restart if it goes down.
#
#while [ $run -gt 0 ]; do
#
#	date=`date +"%Y-%m-%d %H:%M:%S"`
#	if [ -f $DB_STORE/data/postmaster.pid ]; then
#		pid=`cat $DB_STORE/data/postmaster.pid | head -1`
#		echo "$date : Postgress  already running (pid = $pid)" >> $LOG_DIR/$LOG_FILE
#	else
#		db_start
#		sleep 5
#		pid=`cat $DB_STORE/data/postmaster.pid | head -1`
#		echo "$date : Starting Postgress (pid = $pid)" >> $LOG_DIR/$LOG_FILE
#	fi
#
#	# Poll check the process is still alive every 2 seconds
#	# this allows the trap to be serviced
#	while kill -0 $pid > /dev/null 2>&1; do
#		sleep 2
#	done
#
#	# Output that we have died
#	date=`date +"%Y-%m-%d %H:%M:%S"`
#	echo "$date : Postgres died!" >> $LOG_DIR/$LOG_FILE
#
#	# If dead due to shutdown, skip the sleep to speed things up
#	if [ $run -gt 0 ]; then
#		sleep 60
#		db_shutdown
#		echo "$date : Postgres Shutdown!" >> $LOG_DIR/$LOG_FILE
#	fi
#done

date=`date +"%Y-%m-%d %H:%M:%S"`
echo "$date : Shutdown complete." >> $LOG_DIR/$LOG_FILE


