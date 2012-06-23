#!/bin/bash
profile_path="/home/lathonez/.mozilla-thunderbird/kl2fb1o4.default/Mail"
backup_path="/shared/trash/shazleto/mailbackup"
mail_name="mailbak.tar.gz"
prev_sync_name="prev_sync.tar.gz"
local_folders="Local Folders"

if ps ax | grep -v grep | grep thunderbird > /dev/null 
then
  echo 'Thunderbird is running, kill it..'
  exit 0
fi

echo 'Copying mail tar from titan..'
scp -P 10024 shazleto@localhost:${backup_path}/${mail_name} $profile_path

cd $profile_path

if ls | grep $prev_sync_name > /dev/null 
then
echo 'Removing previous sync backup..';
rm $prev_sync_name
fi

echo 'Backing up local folders..'
tar -cvzf $prev_sync_name "Local Folders"

echo 'Removing local folders..'
rm -rf $local_folders

echo 'Extracting backup..'
gzip -dc $mail_name | tar xf -

echo 'Removing tarball..'
rm $mail_name

echo '..sync complete!'
