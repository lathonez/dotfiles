#!/bin/bash

# config
username="esaunder"
password="esaunder01"
event_id=""
bir_market_id=""
oxifeed_url=""
# how long to wait between messages (seconds)
delay="20"
# how long in the future should the event be (seconds)
start_delay="120"
xml_dir="xml"

print_usage() {
	echo " "
	echo "Usage: $0 [-upd] [event_id] [pri_mkt_id] [oxifeed_url]"
	echo "  -u : admin username, default esaunder"
	echo "  -p : admin password, default esander01"
	echo "  -d : delay between messages in seconds, default 20"
	echo "  -s : seconds until the start time default 120"
	echo " "
	echo "Example: $0 -uAdmininstrator -p1ncharge -d20 -s500 1234567 72324567 https://titan.orbis/oxifeed_test"
	echo " "
}

# read options in from the command line
while getopts ":u:p:d:s:" o;
do
	case $o in
		u)  username=$OPTARG;;
		p)  password=$OPTARG;;
		d)  delay=$OPTARG;;
		s)  start_delay=$OPTARG;;
		/?)
			print_usage;
			exit 1;;
	esac
done

# grab the ev_id and url from standard args
eval "event_id=\$$OPTIND"
eval "bir_market_id=\$$(expr $OPTIND + 1)"
eval "oxifeed_url=\$$(expr $OPTIND + 2)"

# sanity
if [ "$event_id" = "" -o "$bir_market_id" = "" -o "$oxifeed_url" = "" ]
then
	print_usage;
	exit;
fi


# set some other conf variables based on the config above
gen_config() {

	# prefix of the incident id
	incident_id=$event_id"_"

	# generate a timestamp for today, it's just the current date plus the timezone offset, apparently
	timestamp=`date '+%Y-%m-%d'`
	offset="+00:00"

	# set the start time in our event to the configured value
	start_time=`date --date "now $start_delay seconds" '+%Y-%m-%d %H:%M:%S'`

	if [ `date +"%Z"` = "BST" ]
	then
		offset="+01:00"
	fi
}


# search and replace the xml according to the config
set_xml() {

	sed -i "s/password=\"[a-zA-Z0-9]*\"/password=\"$password\"/g" xml/*.xml
	sed -i "s/username=\"[a-zA-Z0-9]*\"/username=\"$username\"/g" xml/*.xml
	sed -i "s/event id=\"[0-9]*\"/event id=\"$event_id\"/g" xml/*.xml
	sed -i "s/incident id=\"[0-9]*_/incident id=\"$incident_id/g" xml/*.xml
	sed -i "s/deletion id=\"[0-9]*_/deletion id=\"$incident_id/g" xml/*.xml
	sed -i "s/+0[0-9]:00/$offset/g" xml/*.xml
	sed -i "s/<openbetId>[0-9]*/<openbetId>$event_id/g" xml/off.xml
	sed -i "s/<openbetId>[0-9]*/<openbetId>$event_id/g" xml/on.xml
	sed -i "s/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}/$start_time/g" xml/on.xml
	sed -i "s/<openbetId>[0-9]*/<openbetId>$bir_market_id/g" xml/bir_market*.xml
}


# curl an xml file at the configured url (filename passed as arg0)
send_com_xml() {

	echo " "
	echo "|======================== send_com_xml ========================|"
	echo " "
	echo "sending $xml_dir/$1 to $oxifeed_url"
	echo " "
	cat $xml_dir/$1
	echo " "
	echo "----------------------------------------------------------------"
	echo " "
	curl -d "@$xml_dir/$1" --insecure --header "Content-Type: text/xml; charset=utf-8" $oxifeed_url
	echo " "
	echo "|==============================================================|"
	echo " "
}


# set the event is_off to no, suspend and hide the primary BIR market, reset the start time
setup_game(){

	echo " "
	echo "Setting up event $event_id"

	send_com_xml on.xml
	send_com_xml bir_market_disabled.xml

	start_delay_grace=`expr $start_delay - 3`

	# wait for the event to start, allow a few seconds grac
	echo "Waiting $start_delay_grace seconds for the start time to come round -- refresh your browser now"
	sleep $start_delay_grace
}


# step through the commentary for our event
play_game() {

	echo " "
	echo "Starting to play game for event $event_id on $oxifeed_url.."
	echo " "

	# register and lineup -- not much point delaying after this
	send_com_xml reg.xml
	send_com_xml free_text.xml

	# set isoff, activate the primary bir market, and start the first half
	send_com_xml off.xml
	send_com_xml bir_market.xml
	send_com_xml 1h_start.xml

	# we need to wait extra long here 'cause of the random ajax
	sleep 60

	# first half corner
	send_com_xml 1h_corner.xml
	sleep $delay

	# first half away goal
	send_com_xml 1h_away_goal.xml
	sleep $delay

	# first half home goal
	send_com_xml 1h_home_goal.xml
	sleep $delay

	# end first half -- need to spoof the time
	send_com_xml 1h_stop_adj.xml
	send_com_xml 1h_stop.xml
	sleep $delay

	# start second half
	send_com_xml 2h_start.xml
	sleep $delay

	# second half corner
	send_com_xml 2h_corner.xml
	sleep $delay

	# second half home goal
	send_com_xml 2h_home_goal.xml
	sleep $delay

	# second half away goal
	send_com_xml 2h_away_goal.xml
	sleep $delay

	# second half away goal (will be deleted next)
	send_com_xml 2h_away_goal_to_be_deleted.xml
	sleep $delay

	# delete the goal
	send_com_xml delete.xml
	sleep $delay

	# end second half (full time) -- need to spoof the time
	send_com_xml 2h_stop_adj.xml
	send_com_xml 2h_stop.xml

	echo " "
	echo "Finished playing game for event $event_id on $oxifeed_url"
	echo " "
}


print_delete() {

	echo "Run the following SQL to clear the commentary for another run: "
	echo " "
	echo "delete from tcomclockstate where ev_id = $event_id;"
	echo "delete from tcomclockstate_aud where ev_id = $event_id;"
	echo "delete from tcomsummary where ev_id = $event_id;"
	echo "delete from tcomincident where ev_id = $event_id;"
	echo " "
}

gen_config
set_xml
setup_game
play_game
print_delete
