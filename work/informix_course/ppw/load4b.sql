SET PDQPRIORITY 100;
SET EXPLAIN ON;
INSERT INTO customer4 SELECT 0, fname, lname, company, address1, address2,
   city, state, zipcode, phone FROM customer3;
