-----------------------------------------------------------------------------
-- Module: @(#)keyprofile.sql	1.2     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays key server profile/perfomance statatics
-----------------------------------------------------------------------------

database sysmaster;

select * from sysprofile
where name in ( 
	"ovlock", 
	"ovuser", 
	"ovtrans", 
	"latchwts", 
	"buffwts", 
	"lockwts",
	"ckptwts",
	"deadlks", 
	"lktouts",
	"fgwrites",
	"lruwrites",
	"chunkwrites" )
