-----------------------------------------------------------------------------
-- Module: @(#)vpstat.sql	1.4     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	 Displays VP status like onstat -g sch
-----------------------------------------------------------------------------

database sysmaster;

select    vpid,
       txt[1,5] class,
       pid,
       usecs_user,
       usecs_sys,
       num_ready
from sysvplst a, flags_text b
where a.flags != 6
and  a.class = b.flags
and b.tabname = 'sysvplst';
