#!/bin/bash
# mkdirs

mkdirs() {
	# we need a logdir for site_management, but the others will create themselves
	mkdir -p $OPENBETLOGDIR/site_management
}

checkout() {

	cd $OPENBETRELEASE

	CVSROOT=":pserver:shazleto@pserver:/cvsroot-openbet"

	# OXi
	cvs co -r R_shared2_27-0            OXi/shared
	cvs co -r R_dbPublish3_31_WH_1-2    OXi/oxipubserver
	cvs co -r R_RT29669_repServer2_5-50 OXi/oxirepserver
	cvs co -r T_Support_WIL-18130_2     OXi/services/repClient

	# shared code
	cvs co -d shared_tcl -r B_WillHill_34_0_2 openbet/shared_tcl
	cvs co -d shared_pkg -r B_WillHill_34_0_2 openbet/shared_pkg

	# configuration
	CVSROOT=":pserver:shazleto@pserver:/cvsroot"
	cvs co -d conf                  -r B_WillHill_34_0_2 willhill/conf/global_func.cfg
	cvs co -d conf/OXi/oxirepserver -r B_WillHill_34_0_2 willhill/conf/OXi/oxirepserver 
	cvs co -d conf/OXi/oxipubserver -r B_WillHill_34_0_2 willhill/conf/OXi/oxipubserver 
	cvs co -d conf/postgres         -r B_WillHill_34_0_2 willhill/conf/postgres
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
	# links
	ln -s $OPENBETRELEASE/OXi/oxirepserver/schema-base.cfg $OPENBETRELEASE/OXi/oxipubserver
	ln -s $OPENBETRELEASE/OXi/oxirepserver/api-base.cfg    $OPENBETRELEASE/OXi/oxipubserver
	ln -s $OPENBETRELEASE/shared_tcl_liveserv              $OPENBETRELEASE/shared_tcl/push
	ln -s $OPENBETRELEASE/ovs/shared_tcl                   $OPENBETRELEASE/shared_tcl/ovs
	ln -s $OPENBETRELEASE/cnj_verification/tcl             $OPENBETRELEASE/shared_tcl/cnj
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

site_management
hacks
links
mkdirs
$OB/setup/postgres.sh small
apache
