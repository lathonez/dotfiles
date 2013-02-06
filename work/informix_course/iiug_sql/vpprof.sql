-----------------------------------------------------------------------------
-- Module: @(#)vpprof.sql	1.2     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays VP status
-----------------------------------------------------------------------------

database sysmaster;

select
	vpid,
	pid,
	txt[1,5] class,
	round( usecs_user, 2) usercpu,
	round( usecs_sys, 2)  syscpu
from 	sysvplst a, flags_text b
where 	a.class = b.flags
and   	b.tabname = "sysvplst"
