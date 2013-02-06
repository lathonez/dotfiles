-- returns first and last name of customers in customer
drop procedure sel_cust;

create procedure sel_cust()
	returning char(15), char(15)

	define v_fname like customer.fname;
	define v_lname like customer.lname;
	define v_rows int;

	-- let's debug stuff
	set debug file to 'sel_cust.trace';
	trace on;
	trace 'debugging sel_cust:';

	foreach
		select
			fname,
			lname
		into
			v_fname,
			v_lname
		from
			customer

		return v_fname, v_lname
			with resume;
	end foreach;

	let v_rows = dbinfo("sqlca.sqlerrd2");

	trace 'processed ' || v_rows || ' rows';
	
	trace off;

end procedure;
	
