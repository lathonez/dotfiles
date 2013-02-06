# Troubleshooting: Script on page 4-6
# Displays the locks for each session

for x in `onstat -u | tail +6 | grep -v concurrent | \
  grep -v "^$" | awk '{print $1}'`
do
  echo --------------------------------------------
  onstat -u | grep $x | \
    awk '{print "locks for session " $3 "- id " $4}'
  onstat -k | grep $x | \
    awk '{print "  table " $6 " - row " $7 " - type " $5}'
done

