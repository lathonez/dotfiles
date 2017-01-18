# this is needed to run nm-applet on ubuntu 16.04.

# one starts which doesn't work
killall nm-applet

# run it with dbus to get it into the notification area
dbus-launch nm-applet
