#!/bin/bash
cd $OPENBETRELEASE

CVSROOT=":pserver:shazleto@pserver:/cvsroot-openbet"

# OXi
cvs co -r R_shared2_27-0            OXi/shared
cvs co -r R_dbPublish3_31_WH_1-2    OXi/services/dbPublish
cvs co -r R_RT29669_repServer2_5-50 OXi/services/repServer
cvs co -r T_Support_WIL-18130_2     OXi/services/repClient

# shared code
cvs co -d shared_tcl -r B_WillHill_34_0_2 openbet/shared_tcl
cvs co -d shared_pkg -r B_WillHill_34_0_2 openbet/shared_pkg

# site management
cd /tmp
wget http://artifactory.ci01.openbet/artifactory/simple/openbet-tcl-release-local/com/openbet/ops/openbet-ops/1.2/openbet-ops-1.2-sources.tgz
tar -xzvf openbet-ops-1.2-sources.tgz
mv openbet-ops-1.2-sources/site_management $OPENBETRELEASE
rm -r /tmp/*
cd $OPENBETRELEASE

chmod +x $OPENBETRELEASE/site_management/obcontrol
chmod +x $OPENBETRELEASE/site_management/obmonitor
chmod +x $OPENBETRELEASE/site_management/obmanage


# configuration
CVSROOT=":pserver:shazleto@pserver:/cvsroot"
cvs co -d conf                  -r B_WillHill_34_0_2 willhill/conf/global_func.cfg
cvs co -d conf/OXi/oxirepserver -r B_WillHill_34_0_2 willhill/conf/OXi/oxirepserver 
cvs co -d conf/OXi/oxipubserver -r B_WillHill_34_0_2 willhill/conf/OXi/oxipubserver 
cvs co -d conf/postgres         -r B_WillHill_34_0_2 willhill/conf/postgres

# mkdirs
mkdir $OPENBETRELEASE/log

# links
ln -s $OPENBETRELEASE/setup/oxipub.cfg                       $base/OXi/services/dbPublish
ln -s $OPENBETRELEASE/OXi/services/repServer/schema-base.cfg $base/OXi/services/dbPublish
ln -s $OPENBETRELEASE/OXi/services/repServer/api-base.cfg    $base/OXi/services/dbPublish
ln -s $OPENBETRELEASE/OXi/shared/tcl                         $base/OXi/services/dbPublish/tcl/shared
ln -s $OPENBETRELEASE/shared_tcl                             $base/OXi/services/dbPublish/tcl
ln -s $OPENBETRELEASE/shared_pkg                             $base/OXi/services/dbPublish/tcl

ln -s $OPENBETRELEASE/setup/oxirep.cfg                       $base/OXi/services/repServer
ln -s $OPENBETRELEASE/OXi/shared/tcl                         $base/OXi/services/repServer/tcl/shared
ln -s $OPENBETRELEASE/shared_tcl                             $base/OXi/services/repServer/tcl
ln -s $OPENBETRELEASE/shared_pkg                             $base/OXi/services/repServer/tcl

# hacks
# see OPENBETRELEASEPUB-458?
sed -i 's/OXi::log::init      DEFAULT/OXi::log::init/g' $OPENBETRELEASE/OXi/services/repServer/tcl/init.tcl
