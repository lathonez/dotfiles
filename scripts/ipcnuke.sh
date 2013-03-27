ipcs -m | grep shazleto | awk '{print $2}' | grep -vE "key|\-" | xargs -i ksh -c 'ipcrm -m "{}"'
ipcs -s | grep shazleto | awk '{print $2}' | grep -vE "key|\-" | xargs -i ksh -c 'ipcrm -s "{}"'
