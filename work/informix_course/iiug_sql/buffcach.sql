-----------------------------------------------------------------------------
-- Module: @(#)buffcach.sql	1.3     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays % of reads and writes from buffers
-----------------------------------------------------------------------------

database sysmaster;

select 	dr.value dskreads,
	br.value bufreads,
	round ((( 1 - ( dr.value / br.value )) *100 ), 2) cached
from sysprofile dr, sysprofile br
where dr.name = "dskreads"
and   br.name = "bufreads";

select 	dw.value dskwrites,
	bw.value bufwrites,
	round ((( 1 - ( dw.value / bw.value )) *100 ), 2) cached
from sysprofile dw, sysprofile bw
where dw.name = "dskwrites"
and   bw.name = "bufwrites"
