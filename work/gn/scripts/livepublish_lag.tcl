#!/usr/bin/tclsh

# Expects line in following format:
# 12/06-15:00:00 1

global MESSAGE_INFO

proc print_output_to_terminal {} {
	global MESSAGE_INFO
	foreach min $MESSAGE_INFO(minutes) {
		puts "$min - Average Lag: $MESSAGE_INFO($min,avg_lag), Messages Processed: $MESSAGE_INFO($min,msg_count)"
	}
}

# ====== START =======

# if we've been given a log file, use that instead of stdin
if { [llength $argv] } {
	set fn [lindex $argv 0]
	set fp [open $fn r]
} else {
	set fp stdin
}

set MESSAGE_INFO(minutes) [list]
set MESSAGE_INFO(total_messages) 0
set current_msg_time -1

set message_format "%s | Messages Processed: %5d | HWM: %02d"

while {![eof $fp]} {
	set line [gets $fp]

	# Parse the date and lag from the raw line.
	# date_parsed and lag_parsed are 1 or 0.
	# hour, min and lag are the values we're interested in
	set date_parsed [regexp {([0-9]{2}):([0-9]{2})} $line msg_time hour min]
	set lag_parsed  [regexp {Published ([0-9]+) message\(s\) \(([0-9]+)s since} $line string msg_count lag]

	# Update the information for this minute interval
	if {$date_parsed && $lag_parsed} {

		set msg_time "$hour:$min"
	
		# Have we seen this minute interval before?	
		if {[lsearch $MESSAGE_INFO(minutes) $msg_time] == -1} {
			lappend MESSAGE_INFO(minutes) $msg_time

			# Print out info for previous minute if it exists
			if {$current_msg_time != -1} {
				puts [format $message_format $current_msg_time $MESSAGE_INFO($current_msg_time,msg_count) $MESSAGE_INFO($current_msg_time,lag_hwm)]
			}
			set current_msg_time $msg_time
		}

		# If the count exists, recalc average and incr msg count
		if {[info exists MESSAGE_INFO($msg_time,msg_count)]} {
			
			incr MESSAGE_INFO($msg_time,msg_count) $msg_count
			incr MESSAGE_INFO($msg_time,total_lag) $lag


			# Is there a new high water mark for lag?
			if {$lag > $MESSAGE_INFO($msg_time,lag_hwm)} {
				set MESSAGE_INFO($msg_time,lag_hwm) $lag
			}
			
			# recalc average lag
			if {$MESSAGE_INFO($msg_time,total_lag) > 0} {
				set avg_lag [expr ($MESSAGE_INFO($msg_time,total_lag) * 1.0) / ($MESSAGE_INFO($msg_time,msg_count) * 1.0)]
			} else {
				set avg_lag 0
			}
			set MESSAGE_INFO($msg_time,avg_lag) $avg_lag

		} else {
			# Otherwise initialise this minute interval

			set MESSAGE_INFO($msg_time,total_lag) $lag
			set MESSAGE_INFO($msg_time,avg_lag) $lag
			set MESSAGE_INFO($msg_time,msg_count) $msg_count
			set MESSAGE_INFO($msg_time,lag_hwm) 0
		}
		incr MESSAGE_INFO(total_messages) $msg_count
	}
}
puts "Total messages: $MESSAGE_INFO(total_messages)"

