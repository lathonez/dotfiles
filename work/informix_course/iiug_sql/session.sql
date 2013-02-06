-----------------------------------------------------------------------------
-- Module: @(#)session.sql	1.2     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays short list of user sessions
-----------------------------------------------------------------------------

database sysmaster;

select 	sid,
	username,
	pid,
	hostname,
	l2date(connected) startdate
from 	syssessions
