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
	ln -s $OPENBETRELEASE/OXi/oxirepserver/schema-base.cfg            $OPENBETRELEASE/OXi/oxipubserver
	ln -s $OPENBETRELEASE/OXi/oxirepserver/api-base.cfg               $OPENBETRELEASE/OXi/oxipubserver
	ln -s $OPENBETRELEASE/shared_tcl_liveserv                         $OPENBETRELEASE/shared_tcl/push
	ln -s $OPENBETRELEASE/ovs/shared_tcl                              $OPENBETRELEASE/shared_tcl/ovs
	ln -s $OPENBETRELEASE/cnj_verification/tcl                        $OPENBETRELEASE/shared_tcl/cnj
	ln -s $OPENBETRELEASE/admin/admin_mkt_props.cfg                   $OPENBETRELEASE/stl_engine
	ln -s $OPENBETRELEASE/conf/games/fog/game_server/fog_base.cfg     $OPENBETRELEASE/games/fog/admin/fog-base.cfg

	# cust
	ln -s $OPENBETRELEASE/shared_tcl                                  $OPENBETRELEASE/cust/tcl
	ln -s $OPENBETRELEASE/shared_pkg                                  $OPENBETRELEASE/cust/tcl
	ln -s $OPENBETRELEASE/products/shared_core                        $OPENBETRELEASE/cust/tcl
	ln -s $OPENBETRELEASE/willhill_shared                             $OPENBETRELEASE/cust/tcl
	ln -s $OPENBETRELEASE/content_manager/lib/tcl                     $OPENBETRELEASE/cust/tcl/cms_lib
	ln -s $OPENBETRELEASE/games/fog/admin/tcl                         $OPENBETRELEASE/cust/tcl/igf
	ln -s $OPENBETRELEASE/content_manager/lib/html                    $OPENBETRELEASE/cust/html/cms_lib
	ln -s $OPENBETRELEASE/cust/static                                 $OPENBETRELEASE/cust/html/cust_static
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
	find $OPENBETRELEASE -name *.cfg* | xargs grep "include /opt/openbet/current" | awk -F ':' '{print $1}' | sort -u | xargs sed -i 's|include /opt/openbet/current|include '"$OPENBETRELEASE"'|'
}

checkout
site_management
hacks
links
mkdirs
$OB/setup/postgres.sh small
apache
rewrite_env_config
