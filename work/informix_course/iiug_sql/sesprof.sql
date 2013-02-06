-----------------------------------------------------------------------------
-- Module: @(#)sesprof.sql	1.2     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays user session profile info.
-----------------------------------------------------------------------------

database sysmaster;

-- Most of the following columns are commented out so this will
-- display on a 80 column screen. 

select 	username,
	syssesprof.sid,
	lockreqs,
	-- locksheld,
	-- lockwts,
	-- deadlks,
	-- lktouts,
	-- logrecs,
	-- isreads,
	-- iswrites,
	-- isrewrites,
	-- isdeletes,
	-- iscommits,
	-- isrollbacks,
	-- longtxs,
	bufreads,
	bufwrites
	-- seqscans,
	-- pagreads,
	-- pagwrites,
	-- total_sorts,
	-- dsksorts,
	-- max_sortdiskspace,
	-- logspused,
	-- maxlogsp
from 	syssesprof, syssessions
where 	syssesprof.sid = syssessions.sid
order by bufreads desc
