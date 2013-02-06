select order_num, customer_num, ship_date, ship_weight
	from orders
	where ship_weight <= (select avg(ship_weight) from
		orders);

select order_num, customer_num, ship_date, ship_weight
	from orders
	where ship_weight > (select avg(ship_weight) from
		orders);

