#! /bin/bash

db="openbet"
xsys_sql="../sql/xsys_queue_size.sql"

monitor_xsys () {

	dbaccess $db $xsys_sql
}

monitor_xsys
