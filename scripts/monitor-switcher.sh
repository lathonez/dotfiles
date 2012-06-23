#!/bin/bash
echo "Enter the primary display from the following:"			# prompt for the display
xrandr --prop | grep "[^dis]connected" | cut --delimiter=" " -f1	# query connected monitors
 
read choice								# read the users's choice of monitor
 
xrandr $choice --primary
