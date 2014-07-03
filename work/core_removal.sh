target="/space/work/cvs_src/WHL/conf"
files="/tmp/core_removal.files"
removes="/tmp/core_removal.removes"

# find existing config files to modify
echo "..finding config files"
find $target -name *.cfg > $files
nfiles=`wc -l $files`
echo "..analysing $nfiles config files"

# replace bad existing config names with the new ones
echo "..replacing core_gibux_cde"
cat $files | xargs sed -i '/\!include/ s/core_gibux2[0-9][0-9].cfg/core_gibux_cde.cfg/'
echo "..replacing core_gibux_noncde"
cat $files | xargs sed -i '/\!include/ s/core_gibux5[0-9][0-9].cfg/core_gibux_noncde.cfg/'
echo "..replacing core_canux_cde_perf_common"
cat $files | xargs sed -i '/\!include/ s/core_canux2[0-9][0-9].cfg/core_canux_cde_perf_common.cfg/'
echo "..replacing core_canux_noncde_perf_common"
cat $files | xargs sed -i '/\!include/ s/core_canux5[0-9][0-9].cfg/core_canux_noncde_perf_common.cfg/'
echo "..replacing core_pocux_common"
cat $files | xargs sed -i '/\!include/ s/core_pocux1[0-9][0-9].cfg/core_pocux_common.cfg/'
echo "..replacing core_brsux_perf_common"
cat $files | xargs sed -i '/\!include/ s/core_brsux09[6,8,9].cfg/core_brsux_perf_common.cfg/'
echo "..replacing core-dr"
cat $files | xargs sed -i '/\!include/ s/core_brsux09[1,3,5,7].cfg/core-dr.cfg/'
echo "..replacing core_pp1ux9NN_on_common"
cat $files | xargs sed -i '/\!include/ s/core_pp1ux9[0-9][0-9].cfg/core_pp1ux9NN_on_common.cfg/'
echo "..replacing core_pp2ux9NN_on_common"
cat $files | xargs sed -i '/\!include/ s/core_pp2ux9[0-9][0-9].cfg/core_pp2ux9NN_on_common.cfg/'
echo "..replacing core_pp3ux9NN_on_common"
cat $files | xargs sed -i '/\!include/ s/core_pp3ux9[0-9][0-9].cfg/core_pp3ux9NN_on_common.cfg/'
echo "..replacing core_pp1ux2NN_off_common"
cat $files | xargs sed -i '/\!include/ s/core_pp1ux2[0-9][0-9].cfg/core_pp1ux2NN_off_cde.cfg/'
echo "..replacing core_pp2ux2NN_off_common"
cat $files | xargs sed -i '/\!include/ s/core_pp2ux2[0-9][0-9].cfg/core_pp2ux2NN_off_cde.cfg/'
echo "..replacing core_pp3ux2NN_off_common"
cat $files | xargs sed -i '/\!include/ s/core_pp3ux2[0-9][0-9].cfg/core_pp3ux2NN_off_cde.cfg/'
echo "..replacing core_pp1ux_5NN_off_noncde"
cat $files | xargs sed -i '/\!include/ s/core_pp1ux5[0-9][0-9].cfg/core_pp1ux5NN_off_nocde.cfg/'
echo "..replacing core_pp2ux_5NN_off_noncde"
cat $files | xargs sed -i '/\!include/ s/core_pp2ux5[0-9][0-9].cfg/core_pp2ux5NN_off_nocde.cfg/'
echo "..replacing core_pp3ux_5NN_off_noncde"
cat $files | xargs sed -i '/\!include/ s/core_pp3ux5[0-9][0-9].cfg/core_pp3ux5NN_off_nocde.cfg/'
echo "..replacing core-office_gibux_common"
cat $files | xargs sed -i '/\!include/ s/core-office_gibux[0-9][0-9][0-9].cfg/core-office_gibux_common.cfg/'

configs=(\
	"core_gibux2[0-9][0-9].cfg" \
	"core_gibux5[0-9][0-9].cfg" \
	"core_canux2[0-9][0-9].cfg" \
	"core_canux5[0-9][0-9].cfg" \
	"core_pocux1[0-9][0-9].cfg" \
	"core_brsux09[6,8,9].cfg" \
	"core_brsux09[1,3,5,7].cfg" \
	"core_pp1ux9[0-9][0-9].cfg" \
	"core_pp2ux9[0-9][0-9].cfg" \
	"core_pp3ux9[0-9][0-9].cfg" \
	"core_pp1ux2[0-9][0-9].cfg" \
	"core_pp2ux2[0-9][0-9].cfg" \
	"core_pp3ux2[0-9][0-9].cfg" \
	"core_pp1ux5[0-9][0-9].cfg" \
	"core_pp2ux5[0-9][0-9].cfg" \
	"core_pp3ux5[0-9][0-9].cfg" \
	"core-office_gibux[0-9][0-9][0-9].cfg" \
	)

# generate list of files to remove
for config in ${configs[@]}
do
	echo "..searching for remaining instances of $config"
	num=`grep -rns $config $target | grep -v "Header" | grep -v "Entries" | grep -v "Id" | grep -v "Source" | wc -l`
	if [ "$num" -gt "0" ]
	then
		echo "WARNING - found $num instances of $config - run: [ grep -rns $config $target | grep -v \"Header\" | grep -v \"Entries\" | grep -v \"Id\" | grep -v \"Source\" ]"
	fi
done

# switch to cvs dir so removes work
cd $target
echo "..finding config files to remove"
for config in ${configs[@]}
do
	find . -name $config >> $removes
done

echo "..scheduled `wc -l $removes` config files for removal"

echo "..checking files scheduled for removal for anything that shouldn't be there"
# check to make sure each file we're going to remove has nothing in it!
for config in `cat $removes`
do
	num=`grep -v "Header" $config | grep -v "include" | tr '\n' '\0' | wc -l`
	if [ "$num" -gt "0" ]
	then
		echo "WARNING - found something interesting in $config - run: [ cat $config ]"
	fi
done

echo "../removing `wc -l $removes` files"

cat $removes | xargs rm
cat $removes | xargs cvs rm

echo "..cleaning up"
rm -rf /tmp/core_removal*
