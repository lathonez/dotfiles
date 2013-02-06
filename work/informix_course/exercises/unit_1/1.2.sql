set explain on;
select c.company, o.order_date, i.quantity, i.total_price
	from customer c, orders o, items i
	where c.customer_num = o.customer_num
		and (i
.manu_code = 'HSK' or i.manu_code = 'HRO');

set explain off;
