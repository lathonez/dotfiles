-----------------------------------------------------------------------------
-- Module: @(#)chkio.sql	1.4     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays chunk IO status
-----------------------------------------------------------------------------

database sysmaster;

select
     name[1,16] dbspace, -- truncated to fit 80 char screen line
     chknum,
     "P" type,		-- Primary 
     reads,
     writes,
     pagesread,
     pageswritten
from syschktab c, sysdbstab d
where     c.dbsnum = d.dbsnum
union all
select
     name[1,16]     dbspace,
     chknum,
     "M"    type,	-- Mirror
     reads,
     writes,
     pagesread,
     pageswritten
from sysmchktab c, sysdbstab d
where     c.dbsnum = d.dbsnum
order by 1,2,3;
