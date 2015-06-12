interface="wlan0"
mac="10:0B:A9:2F:16:50"

sudo service network-manager stop
sudo ifconfig $interface down
sudo ifconfig $interface hw ether $mac
sudo ifconfig $interface up
sudo service network-manager start
