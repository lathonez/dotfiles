interface="eth0"
giles="78:2B:CB:AF:80:FB"
phone="00:08:5D:74:DC:C4"
tatty="f0:de:f1:46:94:94"

# set which mac
mac=$giles

sudo ifconfig $interface down
sudo ifconfig $interface hw ether $mac
sudo ifconfig $interface up
