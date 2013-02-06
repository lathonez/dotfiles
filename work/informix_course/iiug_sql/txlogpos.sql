-----------------------------------------------------------------------------
-- Module: @(#)txlogpos.sql	1.2     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays users and position in logical logs.
--	This script is based on an undocumented sysmaster table systrans 
--	and may not work in all versions.  It was tested with 7.23.
-----------------------------------------------------------------------------

database sysmaster;

-- Some fields are commented out so the display will fit on 80 columns
select 
	t.username,
	t.sid,
	-- tx_id,
	-- tx_addr,
	-- tx_flags,
	-- tx_mutex,
	tx_logbeg,
	tx_loguniq,
	tx_logpos
	-- tx_lklist,
	-- tx_lkmutex,
	-- tx_owner,
	-- tx_wtlist,
	-- tx_ptlist,
	-- tx_nlocks,
	-- tx_lktout,
	-- tx_isolevel,
	-- tx_longtx,
	-- tx_coordinator,
	-- tx_nremotes
from 	systrans x, sysrstcb t
where	tx_owner = t.address
