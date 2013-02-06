-----------------------------------------------------------------------------
-- Module: @(#)locks.sql	1.3     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays locks, users and tables using the base tables
--	used to create the view syslocks.  This script was tested with
--	OnLine 7.3. It may not work in all versions because the base
--	tables may change with versions.
-----------------------------------------------------------------------------

database sysmaster;

select 	dbsname,
	b.tabname,
	rowidr,
	keynum,
	e.txt	type,
	d.sid 	owner,
	g.username ownername,
	f.sid	waiter,
	h.username waitname
from 	syslcktab a,
	systabnames b,
	systxptab c,
	sysrstcb d,
	sysscblst g,
	flags_text e,
	outer ( sysrstcb f , sysscblst h  )
where 	a.partnum = b.partnum
and 	a.owner = c.address
and 	c.owner = d.address
and 	a.wtlist = f.address
and	d.sid = g.sid
and 	e.tabname = 'syslcktab'
and 	e.flags = a.type
and	f.sid = h.sid
into temp A;

-- Some fields are commented out to fit on an 80 column display
select 	dbsname,
	tabname,
	rowidr,
	-- keynum,
	type[1,4],
	owner,
	ownername 
	-- waiter,
	-- waitname
from A
order by dbsname, tabname, owner ;
