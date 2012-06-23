#!/bin/bash

# zip up thunderbird and copy it to titan

mailname="mailbak_$(date '+%F')"
maildir="/space/mailback"
maildest="/shared/trash/shazleto/mailbackup"

# we will keep one old backup here just incase something goes awry
echo "Moving old backup out the way.."
mv ${maildir}/mailbak* ${maildir}/oldbak.tar.bz2

# now we have moved the old backup out the way create a new one
echo "Compressing thunderbird.."
tar -jcvpf ${maildir}/${mailname}.tar.bz2 /space/.thunderbird
chmod 700 ${maildir}/${mailname}.tar.bz2

# test to see if we are remote or local
echo "Testing connection.."
ssh -q -o "BatchMode=yes" titan "echo 2>&1" host="titan"  scp_com="scp" || host="localhost" scp_com="scp -P 10024"
echo "Using $scp_com : $host to scp.."

# copy to titan
echo "Copying mail tar.."
${scp_com} ${maildir}/${mailname}.tar.bz2 ${host}:${maildest}

echo "Backup complete!"
