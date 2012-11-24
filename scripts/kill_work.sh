ps -ef | egrep "ssh\.openbet\.com|redir" | grep -v grep |  awk '{print $2,$3}' | xargs sudo kill -9
