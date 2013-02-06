#include <stdlib.h>
#include <sqlhdr.h>
#include <sqliapi.h>
static const char _Cn1[] = "democursor";
#line 1 "simple1.ec"
/*** Example program for the Programmers Performance Workshop ***/
/*** simple1.ec                                    25/03/2003 ***/
#define default_database      "stores_demo"

main(argc, argv)
int  argc;
char **argv;
{
/* Stop the program if there is an SQL eror */
/*
 *    EXEC SQL WHENEVER SQLERROR STOP;
 */
#line 10 "simple1.ec"

/* Define variables */
   int fetchcount;
   char dummy[2];

/* Define host variables */
/*
 *    EXEC SQL BEGIN DECLARE SECTION;
 */
#line 17 "simple1.ec"
#line 18 "simple1.ec"
  char *dbname;
  char fname[15];
  char lname[15];
/*
 *    EXEC SQL END DECLARE SECTION;
 */
#line 21 "simple1.ec"


/* Get the database name from the 1st parameter */
   if (argc < 2)
      dbname=default_database;
   else
      dbname=argv[1];

/* Open the database */
   printf("\n\nsimple1 ESQL program running.\n\n");
   printf("     EXEC SQL DATABASE %s;", dbname);

/*
 *    EXEC SQL DATABASE :dbname;
 */
#line 33 "simple1.ec"
  {
#line 33 "simple1.ec"
  sqli_db_open(dbname, 0);
#line 33 "simple1.ec"
  { if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 33 "simple1.ec"
}

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

/*
 *    EXEC SQL CREATE TABLE customer4 (
 *       customer_num SERIAL NOT NULL,
 *       fname CHAR(15),
 *       lname CHAR(15),
 *       company CHAR(20),
 *       address1 CHAR(20),
 *       address2 CHAR(20),
 *       city CHAR(15),
 *       state CHAR(2),
 *       zipcode CHAR(5),
 *       phone CHAR(18),
 *       PRIMARY KEY (customer_num)
 *    ) FRAGMENT BY ROUND ROBIN IN dbspace1, dbspace2, dbspace3
 *      EXTENT SIZE 64 NEXT SIZE 32;
 */
#line 54 "simple1.ec"
{
#line 67 "simple1.ec"
static const char *sqlcmdtxt[] =
#line 67 "simple1.ec"
  {
#line 67 "simple1.ec"
  "CREATE TABLE customer4 ( customer_num SERIAL NOT NULL , fname CHAR ( 15 ) , lname CHAR ( 15 ) , company CHAR ( 20 ) , address1 CHAR ( 20 ) , address2 CHAR ( 20 ) , city CHAR ( 15 ) , state CHAR ( 2 ) , zipcode CHAR ( 5 ) , phone CHAR ( 18 ) , PRIMARY KEY ( customer_num ) ) FRAGMENT BY ROUND ROBIN IN dbspace1 , dbspace2 , dbspace3 EXTENT SIZE 64 NEXT SIZE 32",
  0
  };
#line 67 "simple1.ec"
static ifx_statement_t _SQ0 = {0};
#line 67 "simple1.ec"
sqli_stmt(ESQLINTVERSION, &_SQ0, sqlcmdtxt, 0, (ifx_sqlvar_t *)0, (struct value *)0, (ifx_literal_t *)0, (ifx_namelist_t *)0, (ifx_cursor_t *)0, -1, 0, 0);
#line 67 "simple1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 67 "simple1.ec"
}

   printf("\n\ncustomer4 table created. Press <return> to continue.");
   gets(dummy);

/* Create indexes on the customer4 table */
   printf("\n\n   EXEC SQL CREATE INDEX zip4_ix ON customer4 (zipcode);");
   printf("\n      IN dbspace1;");
   printf("\n   EXEC SQL CREATE INDEX name4_ix ON customer4 (lname, fname);");
   printf("\n      IN dbspace3;");

/*
 *    EXEC SQL CREATE INDEX zip4_ix ON customer4 (zipcode) IN dbspace1;
 */
#line 78 "simple1.ec"
{
#line 78 "simple1.ec"
static const char *sqlcmdtxt[] =
#line 78 "simple1.ec"
{
#line 78 "simple1.ec"
"CREATE INDEX zip4_ix ON customer4 ( zipcode ) IN dbspace1",
0
};
#line 78 "simple1.ec"
static ifx_statement_t _SQ0 = {0};
#line 78 "simple1.ec"
sqli_stmt(ESQLINTVERSION, &_SQ0, sqlcmdtxt, 0, (ifx_sqlvar_t *)0, (struct value *)0, (ifx_literal_t *)0, (ifx_namelist_t *)0, (ifx_cursor_t *)0, -1, 0, 0);
#line 78 "simple1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 78 "simple1.ec"
}
/*
 *    EXEC SQL CREATE INDEX name4_ix ON customer4 (lname,fname) IN dbspace3;
 */
#line 79 "simple1.ec"
{
#line 79 "simple1.ec"
static const char *sqlcmdtxt[] =
#line 79 "simple1.ec"
{
#line 79 "simple1.ec"
"CREATE INDEX name4_ix ON customer4 ( lname , fname ) IN dbspace3",
0
};
#line 79 "simple1.ec"
static ifx_statement_t _SQ0 = {0};
#line 79 "simple1.ec"
sqli_stmt(ESQLINTVERSION, &_SQ0, sqlcmdtxt, 0, (ifx_sqlvar_t *)0, (struct value *)0, (ifx_literal_t *)0, (ifx_namelist_t *)0, (ifx_cursor_t *)0, -1, 0, 0);
#line 79 "simple1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 79 "simple1.ec"
}

   printf("\n\nIndexes created. Press <return> to continue.");
   gets(dummy);

/* Insert data into customer4 */
   printf("\n\n   EXEC SQL INSERT INTO customer4");
   printf("\n      SELECT 0, fname, lname, company, address1, address2");
   printf("\n         city, state, zipcode, phone");
   printf("\n      FROM customer3;");
   printf("\n\nPlease wait...");

/*
 *    EXEC SQL INSERT INTO customer4
 *       SELECT 0, fname, lname, company, address1, address2, city, state,
 *          zipcode, phone
 *       FROM customer3;
 */
#line 91 "simple1.ec"
{
#line 94 "simple1.ec"
static const char *sqlcmdtxt[] =
#line 94 "simple1.ec"
{
#line 94 "simple1.ec"
"INSERT INTO customer4 SELECT 0 , fname , lname , company , address1 , address2 , city , state , zipcode , phone FROM customer3",
0
};
#line 94 "simple1.ec"
static ifx_statement_t _SQ0 = {0};
#line 94 "simple1.ec"
sqli_stmt(ESQLINTVERSION, &_SQ0, sqlcmdtxt, 0, (ifx_sqlvar_t *)0, (struct value *)0, (ifx_literal_t *)0, (ifx_namelist_t *)0, (ifx_cursor_t *)0, 6, 0, 0);
#line 94 "simple1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 94 "simple1.ec"
}

   printf("\n\nRows inserted. Press <return> to continue.");
   gets(dummy);

/* Declare select cursor */
   printf("\n\n   DECLARE democursor CURSOR FOR");
   printf("\n      SELECT fname, lname");
   printf("\n         INTO :fname, :lname");
   printf("\n         FROM customer4");
   printf("\n         WHERE lname < \"C\"");

/*
 *    EXEC SQL DECLARE democursor CURSOR FOR
 *       SELECT fname, lname
 *       INTO :fname, :lname
 *       FROM customer4
 *       WHERE lname < "C";
 */
#line 106 "simple1.ec"
{
#line 110 "simple1.ec"
static const char *sqlcmdtxt[] =
#line 110 "simple1.ec"
{
#line 110 "simple1.ec"
"SELECT fname , lname FROM customer4 WHERE lname < \"C\"",
0
};
#line 110 "simple1.ec"
static ifx_sqlvar_t _sqobind[] = 
{
{ 100, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
{ 100, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
#line 110 "simple1.ec"
};
static ifx_sqlda_t _SD0 = { 2, _sqobind, {0}, 2, 0 };
#line 110 "simple1.ec"
_sqobind[0].sqldata = fname;
#line 110 "simple1.ec"
_sqobind[1].sqldata = lname;
#line 110 "simple1.ec"
sqli_curs_decl_stat(ESQLINTVERSION, sqli_curs_locate(ESQLINTVERSION, _Cn1, 512), _Cn1, sqlcmdtxt, (ifx_sqlda_t *)0, &_SD0, 0, (ifx_literal_t *)0, (ifx_namelist_t *)0, 2, 0, 0);
#line 110 "simple1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 110 "simple1.ec"
}

/* Open the select cursor */
   printf("\n\n   EXEC SQL OPEN democursor;");

/*
 *    EXEC SQL OPEN democursor;
 */
#line 115 "simple1.ec"
{
#line 115 "simple1.ec"
sqli_curs_open(ESQLINTVERSION, sqli_curs_locate(ESQLINTVERSION, _Cn1, 768), (ifx_sqlda_t *)0, (char *)0, (struct value *)0, 0, 0);
#line 115 "simple1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 115 "simple1.ec"
}

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
/*
 *       EXEC SQL FETCH democursor;
 */
#line 139 "simple1.ec"
{
#line 139 "simple1.ec"
static _FetchSpec _FS0 = { 0, 1, 0 };
sqli_curs_fetch(ESQLINTVERSION, sqli_curs_locate(ESQLINTVERSION, _Cn1, 768), (ifx_sqlda_t *)0, (ifx_sqlda_t *)0, (char *)0, &_FS0);
#line 139 "simple1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 139 "simple1.ec"
}
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

/*
 *    EXEC SQL CLOSE democursor;
 */
#line 163 "simple1.ec"
{
#line 163 "simple1.ec"
sqli_curs_close(ESQLINTVERSION, sqli_curs_locate(ESQLINTVERSION, _Cn1, 768));
#line 163 "simple1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 163 "simple1.ec"
}
/*
 *    EXEC SQL FREE democursor;
 */
#line 164 "simple1.ec"
{
#line 164 "simple1.ec"
  sqli_curs_free(ESQLINTVERSION, sqli_curs_locate(ESQLINTVERSION, _Cn1, 770));
#line 164 "simple1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 164 "simple1.ec"
}

   printf("\n\nCursor closed and freed. Press <return> to continue.");
   gets(dummy);

/* Delete customer4 rows */
   printf("\n\n   EXEC SQL DELETE FROM customer4;");
   printf("\n\nPlease wait...");

/*
 *    EXEC SQL DELETE FROM customer4;
 */
#line 173 "simple1.ec"
{
#line 173 "simple1.ec"
static const char *sqlcmdtxt[] =
#line 173 "simple1.ec"
{
#line 173 "simple1.ec"
"DELETE FROM customer4",
0
};
#line 173 "simple1.ec"
static ifx_statement_t _SQ0 = {0};
#line 173 "simple1.ec"
sqli_stmt(ESQLINTVERSION, &_SQ0, sqlcmdtxt, 0, (ifx_sqlvar_t *)0, (struct value *)0, (ifx_literal_t *)0, (ifx_namelist_t *)0, (ifx_cursor_t *)0, 32, 0, 0);
#line 173 "simple1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 173 "simple1.ec"
}

   printf("\n\nAll rows deleted from customer4. Press <return> to continue.");
   gets(dummy);

/* Drop the customer4 table */
   printf("\n\n   EXEC SQL DROP TABLE customer4;");

/*
 *    EXEC SQL DROP TABLE customer4;
 */
#line 181 "simple1.ec"
{
#line 181 "simple1.ec"
static const char *sqlcmdtxt[] =
#line 181 "simple1.ec"
{
#line 181 "simple1.ec"
"DROP TABLE customer4",
0
};
#line 181 "simple1.ec"
static ifx_statement_t _SQ0 = {0};
#line 181 "simple1.ec"
sqli_stmt(ESQLINTVERSION, &_SQ0, sqlcmdtxt, 0, (ifx_sqlvar_t *)0, (struct value *)0, (ifx_literal_t *)0, (ifx_namelist_t *)0, (ifx_cursor_t *)0, -1, 0, 0);
#line 181 "simple1.ec"
{ if (SQLCODE < 0) { sqli_stop_whenever(); exit(1);} }
#line 181 "simple1.ec"
}

   printf("\n\ncustomer4 dropped. Press <return> to continue.");
   gets(dummy);

/* End of the program */
   printf("\nsimple1 program is finished.\n\n");
}
/*** End of simple1.ec ***/

#line 189 "simple1.ec"
