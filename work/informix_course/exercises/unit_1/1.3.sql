set explain on;
select manu_code, manu_name
	from manufact
	where manu_code in (select manu_code from items where order_num > 1020);
set explain off;
