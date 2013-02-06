-----------------------------------------------------------------------------
-- Module: @(#)tabprof.sql	1.4     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays table IO performance
-----------------------------------------------------------------------------

database sysmaster;

-- Some of the fields are commented out so the display will fit on 
-- a 80 column screen

select
     dbsname,
     tabname,
     isreads,
     bufreads,
     pagreads
     -- uncomment the following to show writes
     -- iswrites,
     -- bufwrites,
     -- pagwrites
     -- uncomment the following to show locks
     -- lockreqs,
     -- lockwts,
     -- deadlks
from sysptprof
order by isreads desc; -- change this sort to whatever you need to monitor.
