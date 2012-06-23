#!/bin/bash

# rsync thunderbird to titan

localdir="/space/.thunderbird"
hostdir="/shared/trash/shazleto/mailbackup/rsync"

# test to see if we are remote or local
echo "Testing connection.."
ssh -q -o "BatchMode=yes" titan "echo 2>&1" && host="titan" ssh_com="ssh" || host="localhost" ssh_com="ssh -p 10024"
echo "Using $ssh_com : $host for ssh.."

# copy to titan
echo "rsyncing.."
rsync -avz -e "$ssh_com" $localdir ${host}:${hostdir}

echo "complete!"
