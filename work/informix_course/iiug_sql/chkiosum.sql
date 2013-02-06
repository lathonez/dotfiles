-----------------------------------------------------------------------------
-- Module: @(#)chkiosum.sql	1.4     Date: 97/07/18
-- Author: Lester B. Knutsen  Email: lester@advancedatatools.com
--         Advanced DataTools Corporation
-- Discription:	Displays chunk IO percent of total IO ordered by chunk
--		with highest percent of reads
-----------------------------------------------------------------------------

database sysmaster;

-- Collect chuck IO stats into temp table A
select
     name dbspace,
     chknum,
     "P" chktype,
     reads,
     writes,
     pagesread,
     pageswritten
from syschktab c, sysdbstab d
where     c.dbsnum = d.dbsnum
union all
select
     name dbspace,
     chknum,
     "M" chktype,
     reads,
     writes,
     pagesread,
     pageswritten
from sysmchktab c, sysdbstab d
where     c.dbsnum = d.dbsnum
into temp A;

-- Collect total IO stats into temp table B
select
     sum(reads) total_reads,
     sum(writes) total_writes,
     sum(pagesread) total_pgreads,
     sum(pageswritten) total_pgwrites
from A
into temp B;

-- Report showing each chunks percent of total IO
select
     dbspace,
     chknum,
     chktype,
     reads,
     writes,
     pagesread,
     pageswritten,
     round((reads/total_reads) *100, 2) percent_reads,
     round((writes/total_writes) *100, 2) percent_writes,
     round((pagesread/total_pgreads) *100, 2) percent_pg_reads,
     round((pageswritten/total_pgwrites) *100, 2) percent_pg_writes
from A, B
order by percent_pg_reads desc ; -- order by percentof total reads
