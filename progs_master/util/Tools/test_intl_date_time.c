/*  TEST_IDT: routine to test date formating routings */
 
/*  get system header files  */
 
#include   <stdio.h>
#include  <sys/types.h>
#ifndef IBM
#include  <sys/time.h>
#endif
#ifndef SUN
#include  <time.h>
#endif

#include   "mach.h"


/***********************/
/* P R O T O T Y P E S */
/***********************/

void date_abv_ ( Int  *lang ,
                 char *outp ,
                 Int   lout );

void date_ful_ ( Int  *lang ,
                 Int  *ifmt ,
                 char *outp ,
                 Int   lout );


/*  +--------------+
    |  test_idt.c  |
    +--------------+  */

main ( int    argc ,
       char **argv )

{

  char      line[40];  /*  local work string           */
  int       lang;      /*  default language = Deutsch  */
  int       ifmt;      /*  format id specifier         */
  int       leng = 48; /*  length of string line[*]    */

  time_t    tim;
  struct tm dt;

  static char *Lang[4] = {"English", "Deutsch", "Francais", "Espanol"};

  /* -----
     begin
     ----- */

  printf("\n");
  printf(" TEST_IDT - testing international date-time routines\n");
  printf(" ---------------------------------------------------\n");

  tim  =   time ((time_t *)0);
  dt   =  *localtime (&tim);
    
  printf("\n");
  printf(" results from asctime() = %s\n", asctime (&dt));


  /* -------------------------------
     check out routine:  Date_String 
     ------------------------------- */

  /*      lang = 0 (English)
          lang = 1 (Deutsch)
          lang = 2 (Francais)
          lang = 3 (Espanol)                         */

  leng = 48;

  printf("\n");
  printf(" testing routine DATE_ABV(---)\n");
  printf(" -----------------------------\n");

  for (lang = 0; lang < 4; lang++) {

    date_abv_ ( &lang ,
                 line ,
                 leng );

    printf (" Date_String (lang=%d)=  %s\n", lang, line);

  }



  /* ------------------------------------
     check out routine:  Date_String_Full 
     ------------------------------------ */

  leng = 48;

  printf("\n");
  printf(" testing routine DATE_FUL(---)\n");
  printf(" -----------------------------\n");

  for (lang = 0; lang < 4; lang++) {

    printf ("\n");
    printf (" language = %s\n", Lang[lang]);
    printf ("\n");

    for (ifmt=0; ifmt < 5; ifmt++) {

      date_ful_ ( &lang ,
                  &ifmt ,
                   line ,
                   leng );

      printf (" Date_String_Full (ifmt=%d)=  %s\n", ifmt, line);

    }

  }

}


