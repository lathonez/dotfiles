-----------------------------------------------------------------------------
-- Module: @(#)dbsfree.sql	1.4     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays free space in all dbspaces like Unix "df -k " command
-----------------------------------------------------------------------------
-- Note:On some versions (e.g 7.3)  need to use the 7.2 version of
--	this script to correctly display the truncated dbspace name.
--	If the dbspace name is blank - use the 72 version.

database sysmaster;

select    name[1,8] dbspace,       -- name truncated to fit on one line
          sum(chksize) Pages_size, -- sum of all chuncks size pages
          sum(chksize) - sum(nfree) Pages_used,
          sum(nfree) Pages_free,   -- sum of all chunks free pages
          round ((sum(nfree)) / (sum(chksize)) * 100, 2) percent_free
from      sysdbspaces d, syschunks c
where     d.dbsnum = c.dbsnum
group by 1
order by 1;
