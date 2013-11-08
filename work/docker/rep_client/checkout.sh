#!/bin/bash

base="/opt/openbet/rep_client"

cd $base

CVSROOT=":pserver:shazleto@pserver:/cvsroot-openbet"

# OXi
cvs co -r R_shared2_27-0            OXi/shared
cvs co -r R_dbPublish3_31_WH_1-2    OXi/services/dbPublish
cvs co -r R_RT29669_repServer2_5-50 OXi/services/repServer
cvs co -r T_Support_WIL-18130_2     OXi/services/repClient

# shared code
cvs co -d shared_tcl -r B_WillHill_34_0_2 openbet/shared_tcl
cvs co -d shared_pkg -r B_WillHill_34_0_2 openbet/shared_pkg

# configuration
CVSROOT=":pserver:shazleto@pserver:/cvsroot"
cvs co -d conf                  -r B_WillHill_34_0_2 willhill/conf/global_func.cfg
cvs co -d conf/OXi/oxipubserver -r B_WillHill_34_0_2 willhill/conf/OXi/oxipubserver 
cvs co -d conf/postgres         -r B_WillHill_34_0_2 willhill/conf/postgres

# mkdirs
mkdir $base/log

# links
ln -s $base/setup/oxipub.cfg                       $base/OXi/services/dbPublish
ln -s $base/OXi/services/repServer/schema-base.cfg $base/OXi/services/dbPublish
ln -s $base/OXi/services/repServer/api-base.cfg    $base/OXi/services/dbPublish
ln -s $base/OXi/shared/tcl                         $base/OXi/services/dbPublish/tcl/shared
ln -s $base/shared_tcl                             $base/OXi/services/dbPublish/tcl
ln -s $base/shared_pkg                             $base/OXi/services/dbPublish/tcl

ln -s $base/setup/oxipub.cfg                       $base/OXi/services/repServer
ln -s $base/OXi/shared/tcl                         $base/OXi/services/repServer/tcl/shared
ln -s $base/shared_tcl                             $base/OXi/services/repServer/tcl
ln -s $base/shared_pkg                             $base/Oxi/services/repServer/tcl

