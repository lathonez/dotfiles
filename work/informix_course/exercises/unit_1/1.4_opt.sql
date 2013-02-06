--select order_num, customer_num, ship_date, ship_weight
--	from orders
--	where ship_weight <= (select avg(ship_weight) from
--		orders);

--select order_num, customer_num, ship_date, ship_weight
--	from orders
--	where ship_weight > (select avg(ship_weight) from
--		orders);

-- put the average weight into the temp table so we only need to do the work once
select
	AVG(o.ship_weight) as avg_ship_weight
from
	orders o
into
	temp avg_orders with no log;

-- less than or equal to the average
select
	o.order_num,
	o.customer_num,
	o.ship_date,
	o.ship_weight
from
	orders o,
	avg_orders a
where
	o.ship_weight <= a.avg_ship_weight;

-- above average	
select
	o.order_num,
	o.customer_num,
	o.ship_date,
	o.ship_weight
from
	orders o,
	avg_orders a
where
	o.ship_weight > a.avg_ship_weight;
