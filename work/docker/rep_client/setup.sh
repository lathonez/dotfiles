#!/bin/bash
# mkdirs

mkdirs() {
	# we need a logdir for site_management, but the others will create themselves
	mkdir -p $OPENBETLOGDIR/site_management
}

# random stuff we may be missing from the release
checkout() {

	cd $OPENBETRELEASE

	CVSROOT=":pserver:shazleto@pserver:/cvsroot"
	cvs co -d games/fog/admin -r R_FOG_ORBISGAMESPACKAGE31_0_12 games/fog/admin 
	cvs co -d conf/games/fog/game_server willhill/conf/games/fog/game_server/fog_base.cfg
}

site_management() {
	# remove if it exsits already
	rm -rf $OPENBETRELEASE/site_management
	mkdir /tmp/ops; cd /tmp/ops
	wget http://artifactory.ci01.openbet/artifactory/simple/openbet-tcl-release-local/com/openbet/ops/openbet-ops/1.2/openbet-ops-1.2-sources.tgz
	tar -xzvf openbet-ops-1.2-sources.tgz
	mv site_management $OPENBETRELEASE
	cd $OPENBETRELEASE
	rm -rf /tmp/ops
	chmod +x $OPENBETRELEASE/site_management/obcontrol
	chmod +x $OPENBETRELEASE/site_management/obmonitor
	chmod +x $OPENBETRELEASE/site_management/obmanage
}

links() {
	ln -s $OPENBETRELEASE/conf/games/fog/game_server/fog_base.cfg     $OPENBETRELEASE/games/fog/admin/fog-base.cfg
}

hacks() {
	# hacks
	# see OPENBETRELEASEPUB-458?
	sed -i 's/OXi::log::init      DEFAULT/OXi::log::init/g' $OPENBETRELEASE/OXi/oxirepserver/tcl/init.tcl
}

apache() {
	cp $OB/setup/conf/apache.conf /etc/apache2/user_settings/openbet.conf
	sudo apache2ctl graceful
}

rewrite_env_config() {
	echo "re-writing the environment configs"
	find $OPENBETRELEASE -name *.cfg* | xargs grep "include /opt/openbet/current" | awk -F ':' '{print $1}' | sort -u | xargs sed -i 's|include /opt/openbet/current|include '"$OPENBETRELEASE"'|'
	echo "..done"
}

static() {
	cd /var/www
	tar -xzvf $OPENBETRELEASE/webserver/*OpenbetStatic.tgz
	cd /var/www/static
	tar -xzvf $OPENBETRELEASE/webserver/*OpenBetTelebet_v2_static.tgz
	chmod -R 755 /var/www/static
	echo "..done chmod"
}

checkout
site_management
hacks
links
mkdirs
$OB/setup/postgres.sh small
apache
rewrite_env_config
static
