-----------------------------------------------------------------------------
-- Module: @(#)chkflist.sql	1.4     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays free space within a chunk
-----------------------------------------------------------------------------

database sysmaster;

select
     name dbspace,  -- dbspace name 
     f.chknum,      -- chunk number
     f.extnum,      -- extent number of free space
     f.start,       -- starting address of free space
     f.leng free_pages   -- length of free space
from      sysdbspaces d, syschunks c, syschfree f
where d.dbsnum = c.dbsnum
and   c.chknum = f.chknum
order by dbspace, chknum, extnum
