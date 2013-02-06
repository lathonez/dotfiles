CREATE TABLE customer3
  (
    customer_num SERIAL NOT NULL,
    fname CHAR(15),
    lname CHAR(15),
    company CHAR(20),
    address1 CHAR(20),
    address2 CHAR(20),
    city CHAR(15),
    state CHAR(2),
    zipcode CHAR(5),
    phone CHAR(18)
  ) 
   FRAGMENT BY ROUND ROBIN IN 
    dbspace1, dbspace2
   EXTENT SIZE 256 NEXT SIZE 64;

CREATE UNIQUE INDEX cust_num3_ix ON customer3(customer_num)
   IN dbspace3;

ALTER TABLE customer3 ADD CONSTRAINT PRIMARY KEY (customer_num);

CREATE INDEX zip3_ix ON customer3 (zipcode)
   IN dbspace3;

CREATE INDEX name3_ix ON customer3 (lname,fname)
   IN dbspace3;

