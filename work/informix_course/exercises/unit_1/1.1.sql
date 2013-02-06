set explain on;
select * from customer
	where state = 'CA'
	into temp cust_temp;
select zipcode[1,3] zone, count(*)
	from cust_temp
	group by 1;
set explain off;
