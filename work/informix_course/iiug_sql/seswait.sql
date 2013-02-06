-----------------------------------------------------------------------------
-- Module: @(#)seswait.sql	1.2     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays session status 
-----------------------------------------------------------------------------

database sysmaster;

-- Some of the fields are commented out to display on a 80 column screen
select
	-- sid,
	username,
	-- pid,
	-- hostname,
	-- tty,
	-- l2date(connected),
	is_wlatch,
	is_wlock,
	is_wbuff,
	is_wckpt,
	-- is_wlogbuf,
	-- is_wtrans,
	-- is_monitor,
	is_incrit
	-- state
from 	syssessions
order by username
