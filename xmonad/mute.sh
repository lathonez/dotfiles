# need a good way of toggling three channels at the same time
# http://ubuntuforums.org/showthread.php?t=1796713

muted=`amixer get Master | grep -c "\[off\]"`

if [ $muted -gt 0 ]; then
	amixer set Master unmute
	amixer set Speaker unmute
	amixer set Headphone unmute
else
	amixer set Master mute
	amixer set Speaker mute
	amixer set Headphone mute
fi
