/*** Example program for the Programmers Performance Workshop ***/
/*** curs1.ec                                      25/03/2003 ***/
#define default_database     "stores_demo"

main(argc, argv)
int argc;
char **argv;
{
/* Stop the program if there is an SQL error */
   EXEC SQL WHENEVER SQLERROR STOP;

/* Define variables */
   short int counter;

/* Define host variables */
   EXEC SQL BEGIN DECLARE SECTION;
      char *dbname;
   EXEC SQL END DECLARE SECTION;

/* Get the database name from 1st parameter */
   if (argc < 2)
      dbname=default_database;
   else
      dbname=argv[1];

/* Open the database */
   printf("Opening database: %s\n",dbname);
   EXEC SQL DATABASE :dbname;

/* Prepare a statement */
   printf("Preparing statement ...\n");
   EXEC SQL PREPARE stmt1 FROM 
      "select * from customer c, orders o where c.customer_num=o.customer_num";

/* Declare a cursor */
   printf("Declaring Cursor ...\n");
   EXEC SQL DECLARE cur1 CURSOR FOR stmt1;

/* Open a cursor */
   printf("Opening Cursor ...\n");
   EXEC SQL OPEN cur1;

/* Fetch (and count) rows within a loop until no more rows found */
   counter=0;
   while(SQLCODE!=SQLNOTFOUND)
   {
      printf("Fetching the next row ...\n");
      counter=counter+1; 
      EXEC SQL FETCH cur1;
   }
   counter=counter-1;

/* Print the count of rows and also the internal count in the SQLCA */
   printf("Counted %d rows, fetched %d rows \n", counter, sqlca.sqlerrd[2]);

/* Close the cursor */
   printf("Closing Cursor ...\n");
   EXEC SQL CLOSE cur1;

/* Free the cursor */
   printf("Freeing Cursor ...\n");
   EXEC SQL FREE cur1;
}
/*** End of curs1.ec ***/
