#!/bin/bash

interval=60
logdir="/openbet_store/users/shazleto/gn/logs"
logfile=""
app=""

# how many lines should we use in perf.pl?
# this should be roughly how many lines your app logs in 2 minutes when it's busy
# cust-slp (for example) this is 120k
perf_tail="120000"

print_usage() {
	echo " "
	echo "Usage: $0 [-nld] [app_name]"
	echo "  -n : interval in seconds, default 60"
	echo "  -l : output logfile, default app_name.host.{type}.log"
	echo "  -d : output logdir, default shazleto gn dir"
	echo "  -t : how many lines of the logs should we tail for perf.pl. default 120k based on cust_slp"
	echo " "
}

while getopts ":n:l:d:t:" o;
do
	case $o in
		n)  interval=$OPTARG;;
		l)  logfile=$OPTARG;;
		d)  logdir=$OPTARG;;
		t)  perf_tail=$OPTARG;;
		\?)
			print_usage;
			exit 1;;
	esac
done

# grab the app from the standard args
eval "app=\$$OPTIND"

# if we weren't passed in a logfile, set the default from app
if [ "$logfile" = "" ]
then
	logfile="$app.$HOSTNAME"
fi

#sanity
if [ "$app" = "" -o "$logfile" = "" ]
then
	print_usage;
	exit;
fi

log() {
	current=`date +"%H:%M:%S"`
	logstr="$current | $app AS monitor |"
	echo "$logstr $1" >> "$logdir/$logfile.log"
}

check() {
	log "checking.."
	ob_control check $app 2>> "$logdir/$logfile.log" >> "$logdir/$logfile.check.log"
}

cache() {
	log "caching.."
	ob_control ot_cache $app 2>> "$logdir/$logfile.log" >> "$logdir/$logfile.cache.log"
}

perf() {
	log "perfing last $perf_tail lines.."

	# grab the current config for the app from ob_control
	app_log=`ob_control cfg $app | grep log | awk '{print $4}'`

	# we need to log some stuff out in the perf as we don't get the time it was run
	current=`date +"%H:%M:%S"`
	echo "" >> "$logdir/$logfile.perf.log"
	echo "| $current perf.pl -k run, for last $perf_tail lines of $app_log |" >> "$logdir/$logfile.perf.log" 
	echo "" >> "$logdir/$logfile.perf.log"

	tail -n $perf_tail $app_log | perf.pl -k 2>> "$logdir/$logfile.log" >> "$logdir/$logfile.perf.log"
}

# monitor stuff
while true
do
	check
	cache
	perf
	log "sleeping for $interval.."
	sleep $interval
done
