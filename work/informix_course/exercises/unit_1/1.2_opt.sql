--select c.company, o.order_date, i.quantity, i.total_price
--	from customer c, orders o, items i
--	where c.customer_num = o.customer_num
--and (i.manu_code = 'HSK' or i.manu_code = 'HRO');
set explain on;
select
	c.company,
	o.order_date,
	-- not sure what we're supposed to be doing with this one
	i.item_num,
	i.quantity,
	i.total_price
from
	customer c,
	orders o,
	items i
where
	c.customer_num = o.customer_num and
	o.order_num = i.order_num and
	i.manu_code in ('HSK','HRO')
;
set explain off;
