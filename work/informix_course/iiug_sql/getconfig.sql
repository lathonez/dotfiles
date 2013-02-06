-----------------------------------------------------------------------------
-- Module: @(#)getconfig.sql	1.3     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	displays effective configuration paramaters
-----------------------------------------------------------------------------

database sysmaster;

select 	cf_name parameter, 
	cf_effective[1,58] effective_value
from 	sysconfig
