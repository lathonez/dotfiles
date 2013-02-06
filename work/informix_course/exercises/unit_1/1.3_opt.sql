--select manu_code, manu_name
--	from manufact
--	where manu_code in (select manu_code from items where order_num > 1020);
set explain on;

select
	m.manu_code,
	m.manu_name
from
	manufact m,
	items i
where
	m.manu_code = i.manu_code and
	i.order_num > 1020
group by 1,2 order by 1
;
set explain off;
