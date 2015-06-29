<<<<<<< HEAD
interface="wlan0"
mac="10:0B:A9:2F:16:50"

sudo service network-manager stop
sudo ifconfig $interface down
sudo ifconfig $interface hw ether $mac
sudo ifconfig $interface up
sudo service network-manager start
=======
interface="eth0"
giles="78:2B:CB:AF:80:FB"
phone="00:08:5D:74:DC:C4"
tatty="f0:de:f1:46:94:94"

# set which mac
mac=$giles

sudo ifconfig $interface down
sudo ifconfig $interface hw ether $mac
sudo ifconfig $interface up
>>>>>>> c8d3988fade082a5a6e12929385ce9f31c4a1299
