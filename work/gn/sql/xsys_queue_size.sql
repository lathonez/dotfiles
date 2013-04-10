set isolation to dirty read;

!echo "`date '+%Y-%m-%d %H:%M:%S'` | XSYS Queue: Unprocessed rows"
select
	count(*)
from
	txsyssyncqueue
where
	processed = 'N';

!echo "`date '+%Y-%m-%d %H:%M:%S'` | XSYS Queue: Unprocessed rows per System"
select
	count(q.sync_id),
	q.system_id ,
	h.name
from
	txsyssyncqueue q,
	txsyshost h
where
	q.processed = 'N' and
	q.system_id = h.system_id
group by 2,3

