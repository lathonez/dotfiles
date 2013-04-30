select
	first 1
    count(*),
    extend(cr_date,year to minute)
from
    tbet
where
    cr_date between '2011-09-24 12:00:00' and '2011-09-24 17:00:00'
group by 2
order by 1 desc;
