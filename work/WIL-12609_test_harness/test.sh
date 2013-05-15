#!/bin/bash

# config
username="Administrator"
password="1ncharge"
event_id=""
oxifeed_url=""
database="willhill_dev@db01_1170"
start_delay="120"
cashout_price=""

# how long to wait between messages (seconds)
# how long in the future should the event be (seconds)
xml_dir="xml"

print_usage() {
	echo " "
	echo "Usage: $0 [-up] [oxifeed_url]"
	echo "  -u : admin username, default esaunder"
	echo "  -p : admin password, default esander01"
	echo " "
	echo "Example: $0 -uAdmininstrator -p1ncharge https://titan.orbis/oxifeed_test"
	echo " "
}

# read options in from the command line
while getopts ":u:p:" o;
do
	case $o in
		u)  username=$OPTARG;;
		p)  password=$OPTARG;;
		/?)
			print_usage;
			exit 1;;
	esac
done

# grab the ev_id and url from standard args
eval "oxifeed_url=\$$OPTIND"

# sanity
if [ "$oxifeed_url" = "" ]
then
	print_usage;
	exit;
fi


# set some other conf variables based on the config above
gen_config() {

	# prefix of the incident id
	external_id=`date +%s%N | cut -b1-13`

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
	sed -i "s/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}/$start_time/g" xml/setup.xml
	sed -i "s/-[0-9]*<\/externalId/-$external_id\<\/externalId/g" xml/*.xml
}


# curl an xml file at the configured url (filename passed as arg0)
send_xml() {

	echo " "
	echo "|======================== send_xml ========================|"
	echo " "
	echo "sending $xml_dir/$1 to $oxifeed_url"
	echo " "
	cat $xml_dir/$1
	echo " "
	echo "----------------------------------------------------------------"
	echo " "
	curl -d "@$xml_dir/$1" --insecure --header "Content-Type: text/xml; charset=utf-8" $oxifeed_url 2>/dev/null | tee xml/tmp_resp.xml
	echo " "
	echo "|==============================================================|"
	echo " "
}


# type
# ev_oc_id
get_price() {

	type=$1
	ev_oc_id=$2
	res=`echo "select ${type}_num, ${type}_den from tevoc where ev_oc_id = 110" | dbaccess $database 2> /dev/null | egrep "[1-9]" | awk '{print $1"/"$2}'`
}


# get openbet ids from response xml
# (event|market|selection)
get_ids() {

	str=""

	list=`grep -A1 "\<${1}Id\>" xml/tmp_resp.xml | grep openbetId | awk -F ">" '{print $2}' | awk -F "<" '{print $1}'`

	for id in $ids
	do
		if [ "$str" == "" ]
		then
			str=$id
		else
			str="$str $id"
		fi
	done

}


# insert a new event and market we can use to test, set the id's we've created to globals for use later
setup_event() {

	echo " "
	echo "Setting up event $event_id"

	send_xml setup.xml

	get_ids event
	event_id=$ids
	get_ids market
	market_ids=$ids

	echo "Set up event_id: $event_id with markets: $market_ids"
}


main_test() {

	# test insert cases
	send_xml insert.xml

	get_ids selection
	selection_id=$ids
}

gen_config
set_xml
setup_event
main_test
