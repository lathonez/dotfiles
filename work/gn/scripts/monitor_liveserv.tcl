# Monitor number of liveserv connections.
# Prints hostname,time,num_connections every minute.

# Config
set liveserv_ports_re "(80|843|2156)"

set hostname [exec hostname]

set cmd ""
# all tcp connections, don't lookup hostnames
append cmd {netstat -n -a -t}
# only want the "Local Address" and "State" columns
append cmd {| awk '{ printf("%s,%s\n",$4,$6) }'}
# only want established connections to the LiveServ ports
append cmd "| egrep -c ':${liveserv_ports_re},ESTABLISHED'"
# ignore return code
append cmd "|| true"

set last_time_to_min "none"
while {1} {
	set now [clock seconds]
	set time_to_min [clock format $now -format "%Y-%m-%dT%H:%M"]
	if {![string equal $time_to_min $last_time_to_min]} {
		set count UNKNOWN
		if {[catch {
				set count [exec sh -c $cmd]
		} msg]} {
			puts stderr $msg
		}
		puts "$hostname,$time_to_min,$count"
		set last_time_to_min $time_to_min
	}
	after 30000
}

