-----------------------------------------------------------------------------
-- Module: @(#)syssql.sql	1.2     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays users SQL statement
-----------------------------------------------------------------------------

database sysmaster;

select 	username,
	sqx_sessionid,
	sqx_conbno,
	sqx_sqlstatement
from syssqexplain, sysscblst
where 	sqx_sessionid = sid
order by sqx_sessionid,sqx_conbno
