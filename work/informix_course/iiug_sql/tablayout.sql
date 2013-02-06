-----------------------------------------------------------------------------
-- Module: @(#)tablayout.sql	1.4     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays tables and extents
-----------------------------------------------------------------------------

database sysmaster;

select dbinfo( "DBSPACE" , pe_partnum ) dbspace,
     dbsname[1,10],
     tabname,
     pe_phys   start,
     pe_size size
from      sysptnext, outer systabnames
where     pe_partnum = partnum
order by dbspace, start;

