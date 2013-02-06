--select * from customer
--	where state = 'CA'
--	into temp cust_temp;
--select zipcode[1,3] zone, count(*)
--	from cust_temp
--	group by 1;

set explain on;
select
	c.zipcode[1,3],
	count(*)
from
	customer c
where
	state = 'CA'
group by 1;
set explain off;
