CREATE TABLE customer1 
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
    phone CHAR(18),
    PRIMARY KEY (customer_num) 
  ) 
  LOCK MODE ROW;

CREATE INDEX zip1_ix ON customer1 (zipcode);
CREATE INDEX name1_ix ON customer1 (lname,fname);

CREATE TABLE customer2 
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
    phone CHAR(18),
    PRIMARY KEY (customer_num) 
  )
  LOCK MODE ROW; 

CREATE INDEX zip2_ix ON customer2 (zipcode);
CREATE INDEX name2_ix ON customer2 (lname,fname);

