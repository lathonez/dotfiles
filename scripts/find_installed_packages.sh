zgrep -i Commandline /var/log/apt/*  | grep install | grep -v "\-y" | grep -v "\-\-no" | awk '{print $4}'
