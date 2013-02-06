-----------------------------------------------------------------------------
-- Module: @(#)dbsfree72.sql	1.5     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	display free dbspace like Unix "df -k " command
-----------------------------------------------------------------------------
-- Note: This is the 7.2 vesrion of this script modified to correctly
--      correctly display the truncated dbspace name

database sysmaster;

select    d.dbsnum,
	name dbspace,       -- name truncated to fit on one line
	sum(chksize) Pages_size, -- sum of all chuncks size pages
	sum(chksize) - sum(nfree) Pages_used,
	sum(nfree) Pages_free,   -- sum of all chunks free pages
	round ((sum(nfree)) / (sum(chksize)) * 100, 2) percent_free
from	sysdbspaces d, syschunks c
where	d.dbsnum = c.dbsnum
and 	d.is_blobspace = 0	
group by 1, 2
order by 1
into temp A;

select 	dbspace[1,8], pages_size, pages_used, pages_free, percent_free
from A;
