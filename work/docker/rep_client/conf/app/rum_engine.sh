#!/bin/sh

# $Id: rum_engine_brsux156_gib.sh,v 1.1 2011/02/21 11:17:53 wtawfik Exp $

TCLSH=/usr/bin/tclsh
TCL_XTN=tcl
CONFIG=$OB/setup/conf/app/rum_engine.cfg
LOG_DIR=$OPENBETLOGDIR/rum_engine
LOG_FILE=rum_engine.out

cd $OPENBETRELEASE/rum_engine

#
# Run the instance and restart if it goes down.
#
while :; do
    $TCLSH tcl/liab_rum_engine.${TCL_XTN} $CONFIG  0 >> $LOG_DIR/$LOG_FILE 2>&1
    sleep 5
done
