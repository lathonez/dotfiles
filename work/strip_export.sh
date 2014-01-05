set -e

if [ $# -ne 1 ]; then
    echo "Need a db directory"
    exit 1
fi

# Go to my export directory
cd "$1"
if [ $(find . -maxdepth 1 -name '*.sql' | wc -l) -ne 1 ]; then
    echo "Couldn't identify load script"
    exit 1
fi

LOAD_FILE=$(basename $(find . -maxdepth 1 -name '*.sql'))

echo "Starting processing"

echo "Deleting synonyms"
# Delete synonyms (used for archiving) - they contain ‘absolute’ references
# to other dbs so fail to load. They can always be regenerated with mk-archive
sed -i '/.*create synonym.*/d' $LOAD_FILE # Actually delete

echo "Deleting stored procs"
# Delete all stored procs - when tables are altered stored procs params are not
# rechecked so loading them may fail e.g. if their default values are invalid.
# WH reload all stored procs on each release so not inserting them here isn’t an issue,
# other people may need to more carefully consider their approach.
# The below multiline sed will delete everything between the first ‘create procedure’ and
# last ‘end procedure;’ in the sql file (inclusive)
sed -n '1h;1!H;${;g;s/create procedure.*end procedure;//g;p;}' \
    $LOAD_FILE > $LOAD_FILE.noprocs
mv $LOAD_FILE.noprocs $LOAD_FILE

echo "Deleting stored proc grants"
# Delete all stored proc grants (as we don’t have the stored procs any more), but also
# grants on table insert execute delete, connect, dba permissions. Possibly shouldn’t
# remove all these, but will do for now. Can always readd.
sed -i '/^grant.*/d' $LOAD_FILE # Actually delete

echo "Deleting triggers"
# Delete all triggers as they probably execute stored procs we no longer have. Can
# recreate with mk-audit.
# The below multiline sed will delete each instance of ‘create trigger’ to the first
# following semicolon and hope that you don’t have semicolons as strings in your
# triggers.
sed -n '1h;1!H;${;g;s/create trigger[^;]*;//g;p;}' $LOAD_FILE > $LOAD_FILE.notrigs
mv $LOAD_FILE.notrigs $LOAD_FILE

echo "Emptying audit tables"
# Going to empty everything from audit tables here. You may want to skip this step.
# Three phase process to:
# - Mark all the tables as having 0 rows and note the files to empty
# - Empty the files
# - Remove the notes on files from the sql script
sed -n '1h;1!H;${;g;s/\({ TABLE "openbet"\.[a-z]*_aud[^}]*}[^{]*{ unload file name = \([^}]*\) number of rows =\) [0-9]* }/\1 0 }\n###TO_EMPTY \2/g;p;}' \
    $LOAD_FILE > $LOAD_FILE.emptyaudit
grep '###TO_EMPTY' $LOAD_FILE.emptyaudit | awk '{print $2}' | xargs truncate --size=0
sed -i '/^###TO_EMPTY.*$/d' $LOAD_FILE.emptyaudit
mv $LOAD_FILE.emptyaudit $LOAD_FILE

echo "Emptying tOXiMsg"
# You can do the above to empty any tables you want to. Here I’m going empty toximsg
sed -n '1h;1!H;${;g;s/\({ TABLE "openbet"\.toximsg[^}]*}[^{]*{ unload file name = \([^}]*\) number of rows =\) [0-9]* }/\1 0 }\n###TO_EMPTY \2/g;p;}' \
    $LOAD_FILE > $LOAD_FILE.notoximsg
grep '###TO_EMPTY' $LOAD_FILE.notoximsg | awk '{print $2}' | xargs truncate --size=0
sed -i '/^###TO_EMPTY.*$/d' $LOAD_FILE.notoximsg
mv $LOAD_FILE.notoximsg $LOAD_FILE

echo "Finished processing"
