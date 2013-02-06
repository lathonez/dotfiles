-----------------------------------------------------------------------------
-- Module: @(#)dblist.sql	1.4     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays database list,owner and logging status
-----------------------------------------------------------------------------

database sysmaster;

select
        dbinfo("DBSPACE",partnum) dbspace,
        name database,
        owner,
        is_logging,
        is_buff_log
from sysdatabases
order by dbspace, name;
