#include <stdlib.h>
#include <sqlhdr.h>
#include <sqliapi.h>
static const char _Cn2[] = "cur1";
static const char _Cn1[] = "stmt1";
#line 1 "curs1.ec"
/*** Example program for the Programmers Performance Workshop ***/
/*** curs1.ec                                      25/03/2003 ***/
#define default_database     "stores_demo"

main(argc, argv)
int argc;
char **argv;
{
/* Stop the program if there is an SQL error */
/*
 *    EXEC SQL WHENEVER SQLERROR STOP;
 */
#line 10 "curs1.ec"

/* Define variables */
   short int counter;

/* Define host variables */
/*
 *    EXEC SQL BEGIN DECLARE SECTION;
 */
#line 16 "curs1.ec"
#line 17 "curs1.ec"
  char *dbname;
/*
 *    EXEC SQL END DECLARE SECTION;
 */
#line 18 "curs1.ec"


/* Get the database name from 1st parameter */
   if (argc < 2)
      dbname=default_database;
   else
      dbname=argv[1];

/* Open the database */
   printf("Opening database: %s\n",dbname);
/*
 *    EXEC SQL DATABASE :dbname;
 */
#line 28 "curs1.ec"
  {
#line 28 "curs1.ec"
  sqli_db_open(dbname, 0);
#line 28 "curs1.ec"
  { if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 28 "curs1.ec"
}

/* Prepare a statement */
   printf("Preparing statement ...\n");
/*
 *    EXEC SQL PREPARE stmt1 FROM
 *       "select * from customer c, orders o where c.customer_num=o.customer_num";
 */
#line 32 "curs1.ec"
{
#line 33 "curs1.ec"
sqli_prep(ESQLINTVERSION, _Cn1, "select * from customer c, orders o where c.customer_num=o.customer_num",(ifx_literal_t *)0, (ifx_namelist_t *)0, 2, 0, 0 ); 
#line 33 "curs1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 33 "curs1.ec"
}

/* Declare a cursor */
   printf("Declaring Cursor ...\n");
/*
 *    EXEC SQL DECLARE cur1 CURSOR FOR stmt1;
 */
#line 37 "curs1.ec"
{
#line 37 "curs1.ec"
sqli_curs_decl_dynm(ESQLINTVERSION, sqli_curs_locate(ESQLINTVERSION, _Cn2, 512), _Cn2, sqli_curs_locate(ESQLINTVERSION, _Cn1, 513), 0, 0);
#line 37 "curs1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 37 "curs1.ec"
}

/* Open a cursor */
   printf("Opening Cursor ...\n");
/*
 *    EXEC SQL OPEN cur1;
 */
#line 41 "curs1.ec"
{
#line 41 "curs1.ec"
sqli_curs_open(ESQLINTVERSION, sqli_curs_locate(ESQLINTVERSION, _Cn2, 768), (ifx_sqlda_t *)0, (char *)0, (struct value *)0, 0, 0);
#line 41 "curs1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 41 "curs1.ec"
}

/* Fetch (and count) rows within a loop until no more rows found */
   counter=0;
   while(SQLCODE!=SQLNOTFOUND)
   {
      printf("Fetching the next row ...\n");
      counter=counter+1;
/*
 *       EXEC SQL FETCH cur1;
 */
#line 49 "curs1.ec"
{
#line 49 "curs1.ec"
static _FetchSpec _FS0 = { 0, 1, 0 };
sqli_curs_fetch(ESQLINTVERSION, sqli_curs_locate(ESQLINTVERSION, _Cn2, 768), (ifx_sqlda_t *)0, (ifx_sqlda_t *)0, (char *)0, &_FS0);
#line 49 "curs1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 49 "curs1.ec"
}
   }
   counter=counter-1;

/* Print the count of rows and also the internal count in the SQLCA */
   printf("Counted %d rows, fetched %d rows \n", counter, sqlca.sqlerrd[2]);

/* Close the cursor */
   printf("Closing Cursor ...\n");
/*
 *    EXEC SQL CLOSE cur1;
 */
#line 58 "curs1.ec"
{
#line 58 "curs1.ec"
sqli_curs_close(ESQLINTVERSION, sqli_curs_locate(ESQLINTVERSION, _Cn2, 768));
#line 58 "curs1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 58 "curs1.ec"
}

/* Free the cursor */
   printf("Freeing Cursor ...\n");
/*
 *    EXEC SQL FREE cur1;
 */
#line 62 "curs1.ec"
{
#line 62 "curs1.ec"
  sqli_curs_free(ESQLINTVERSION, sqli_curs_locate(ESQLINTVERSION, _Cn2, 770));
#line 62 "curs1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 62 "curs1.ec"
}
}
/*** End of curs1.ec ***/

#line 64 "curs1.ec"
