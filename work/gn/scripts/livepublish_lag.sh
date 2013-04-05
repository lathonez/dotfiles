#! /bin/bash

app_logdir="/opt/openbet/log/livepublish"

cd $app_logdir

ls -lt $app_logdir | grep -v total | head -n1 | awk '{print $9}' | xargs cat | grep "Published" | /openbet_store/users/shazleto/gn/scripts/livepublish_lag.tcl
