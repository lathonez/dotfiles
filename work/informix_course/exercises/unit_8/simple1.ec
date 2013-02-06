/*** Example program for the Programmers Performance Workshop ***/
/*** simple1.ec                                    25/03/2003 ***/
#define default_database      "stores_demo"

main(argc, argv)
int  argc;
char **argv;
{
/* Stop the program if there is an SQL eror */
   EXEC SQL WHENEVER SQLERROR STOP;

/* Define variables */
   int fetchcount;
   char dummy[2];

/* Define host variables */
   EXEC SQL BEGIN DECLARE SECTION;
      char *dbname;
      char fname[15];
      char lname[15];
   EXEC SQL END DECLARE SECTION;

/* Get the database name from the 1st parameter */
   if (argc < 2)
      dbname=default_database;
   else
      dbname=argv[1];

/* Open the database */
   printf("\n\nsimple1 ESQL program running.\n\n");
   printf("     EXEC SQL DATABASE %s;", dbname);

   EXEC SQL DATABASE :dbname;

   printf( "\n\nDatabase selected. Press <return> to continue.  ");
   gets(dummy);

/* Create the customer4 table */
   printf("\n\n   EXEC SQL CREATE TABLE customer4 (");
   printf("\n      customer_num SERIAL NOT NULL,");
   printf("\n      fname CHAR(15),");
   printf("\n      lname CHAR(15),");
   printf("\n      company CHAR(20),");
   printf("\n      address1 CHAR(20),");
   printf("\n      address2 CHAR(20),");
   printf("\n      city CHAR(15),");
   printf("\n      state CHAR(2),");
   printf("\n      zipcode CHAR(5),");
   printf("\n      phone CHAR(18),");
   printf("\n      PRIMARY KEY (customer_num)");
   printf("\n   ) FRAGMENT BY ROUND ROBIN IN dbspace1, dbspace2, dbspace3");
   printf("\n     EXTENT SIZE 64 NEXT SIZE 32;"); 

   EXEC SQL CREATE TABLE customer4 (
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
   ) FRAGMENT BY ROUND ROBIN IN dbspace1, dbspace2, dbspace3
     EXTENT SIZE 64 NEXT SIZE 32;

   printf("\n\ncustomer4 table created. Press <return> to continue.");
   gets(dummy);

/* Create indexes on the customer4 table */
   printf("\n\n   EXEC SQL CREATE INDEX zip4_ix ON customer4 (zipcode);");
   printf("\n      IN dbspace1;");
   printf("\n   EXEC SQL CREATE INDEX name4_ix ON customer4 (lname, fname);");
   printf("\n      IN dbspace3;");

   EXEC SQL CREATE INDEX zip4_ix ON customer4 (zipcode) IN dbspace1;
   EXEC SQL CREATE INDEX name4_ix ON customer4 (lname,fname) IN dbspace3;

   printf("\n\nIndexes created. Press <return> to continue.");
   gets(dummy);

/* Insert data into customer4 */
   printf("\n\n   EXEC SQL INSERT INTO customer4");
   printf("\n      SELECT 0, fname, lname, company, address1, address2");
   printf("\n         city, state, zipcode, phone");
   printf("\n      FROM customer3;");
   printf("\n\nPlease wait...");

   EXEC SQL INSERT INTO customer4 
      SELECT 0, fname, lname, company, address1, address2, city, state, 
         zipcode, phone
      FROM customer3; 

   printf("\n\nRows inserted. Press <return> to continue.");
   gets(dummy);

/* Declare select cursor */
   printf("\n\n   DECLARE democursor CURSOR FOR");
   printf("\n      SELECT fname, lname");
   printf("\n         INTO :fname, :lname");
   printf("\n         FROM customer4");
   printf("\n         WHERE lname < \"C\""); 

   EXEC SQL DECLARE democursor CURSOR FOR
      SELECT fname, lname
      INTO :fname, :lname
      FROM customer4
      WHERE lname < "C";

/* Open the select cursor */
   printf("\n\n   EXEC SQL OPEN democursor;");

   EXEC SQL OPEN democursor;

   printf("\n\nCursor declared and opened. Press <return> to continue.");
   gets(dummy);

/* Fetching rows */
   printf("\n\n   fetchcount=0;");
   printf("\n   for (;;)");
   printf("\n     {");
   printf("\n      EXEC SQL FETCH democursor;");
   printf("\n      if (sqlca.sqlcode != 0)");
   printf("\n         {");
   printf("\n         printf(\"SQLCODE = %%d\", sqlca.sqlcode);");
   printf("\n         break;");
   printf("\n         }");
   printf("\n      printf(\"%%s %%s\", fname, lname);");
   printf("\n      fetchcount++;");
   printf("\n      }");
   printf("\n\nPress <return> to proceed with fetch.");
   gets(dummy);

   fetchcount=0;
   for (;;)
   {
      EXEC SQL FETCH democursor;
   /* If unsuccessful, break out of loop */
      if (sqlca.sqlcode != 0)
      {
         printf("\nSQLCODE = %d", sqlca.sqlcode);
         break;
      }

   /* Show alternative way of testing for unsuccessful fetch */
   /*    if (strncmp(SQLSTATE, "00", 2) != 0)                */
   /*    break;                                              */

   printf("    %s %s\n",fname, lname);
   fetchcount++;
   }

   printf("\n\nFetch complete.");
   printf("\n%d rows fetched. Press <return> to continue.", fetchcount);
   gets(dummy);

/* Close and free the cusor */
   printf("\n\n   EXEC SQL CLOSE democursor;");
   printf("\n   EXEC SQL FREE democursor;");

   EXEC SQL CLOSE democursor;
   EXEC SQL FREE democursor;

   printf("\n\nCursor closed and freed. Press <return> to continue.");
   gets(dummy);

/* Delete customer4 rows */
   printf("\n\n   EXEC SQL DELETE FROM customer4;");
   printf("\n\nPlease wait...");

   EXEC SQL DELETE FROM customer4;

   printf("\n\nAll rows deleted from customer4. Press <return> to continue.");
   gets(dummy);

/* Drop the customer4 table */
   printf("\n\n   EXEC SQL DROP TABLE customer4;");

   EXEC SQL DROP TABLE customer4;

   printf("\n\ncustomer4 dropped. Press <return> to continue.");
   gets(dummy);

/* End of the program */
   printf("\nsimple1 program is finished.\n\n");
}
/*** End of simple1.ec ***/
