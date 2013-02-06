CREATE TABLE customer4
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
    dbspace1, dbspace2, dbspace3
   EXTENT SIZE 256 NEXT SIZE 64;

CREATE UNIQUE INDEX cust_num4_ix ON customer4 (customer_num)
   IN dbspace2;

ALTER TABLE customer4 ADD CONSTRAINT PRIMARY KEY (customer_num);

CREATE INDEX zip4_ix ON customer4 (zipcode)
   IN dbspace1;

CREATE INDEX name4_ix ON customer4 (lname,fname)
   IN dbspace3;
