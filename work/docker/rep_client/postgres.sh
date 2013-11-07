#!/bin/sh

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

		echo "Creating database $db.." 
		createdb -E UTF8 -O openbet $db  -T 'template0'

		echo "CREATE ROLE dbpublish WITH LOGIN"                 | psql $db
		echo "ALTER USER dbpublish with SUPERUSER"              | psql $db
		echo "ALTER user dbpublish with password \"dbpublish\"" | psql $db
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
