#!/bin/sh

# $Id: timule_start.sh,v 1.1.4.2 2013/09/12 10:50:00 kdheena Exp $
# $Source: /cvsroot/willhill/scripts/timule/timule_start.sh,v $
# $Name: R_WillHill_33_1_14 $

TCLSH=/usr/bin/tclsh
TCL_XTN=tcl
LOG_DIR=$OPENBETLOGDIR/timule/
LOG_FILE=timule.out

while getopts c: o
do
	case $o in
		c) CONFIG=$OPTARG;;
	esac
done

cd $OPENBETRELEASE/products/timule/tcl

#
# Run the instance and restart if it goes down.
#
while :; do
    $TCLSH timule.${TCL_XTN} $CONFIG >> $LOG_DIR/$LOG_FILE 2>&1
    sleep 5
done
