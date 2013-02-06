-----------------------------------------------------------------------------
-- Module: @(#)lockwait.sql	1.2     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays Only locks with other users waiting on them.
-- 	This script uses the base tables used to create the view syslocks.
--  	This script was tested with OnLine 7.3. It may not work in all 
--	versions because the base tables may change with versions.
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
	sysrstcb f , sysscblst h  
where 	a.partnum = b.partnum
and 	a.owner = c.address
and 	c.owner = d.address
and 	a.wtlist = f.address
and	d.sid = g.sid
and 	e.tabname = 'syslcktab'
and 	e.flags = a.type
and	f.sid = h.sid
into temp A;

select 	dbsname, 
	tabname, 
	type[1,4], 
	owner, 
	ownername ,
	waitname
from A;
