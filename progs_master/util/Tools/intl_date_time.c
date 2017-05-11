/*  INTL_DATE_TIME:  FORTRAN callable routine to get and print current Time_Of_Day
 *
 *  these subroutinee are called in FORTRAN (f77) via:
 *
 *
 *       call    DATE_ABV ( lang, string )
 *      -----------------------------------
 *
 *       call    DATE_FUL ( lang, ifmt, string )
 *      -----------------------------------------
 *
 */
 
/*  get system header files  */
 
#include  <stdio.h>
#include  <sys/types.h>
#ifndef IBM
#include  <sys/time.h>
#endif
#ifndef SUN
#include  <time.h>
#endif

#include  "mach.h"


#define END(x)  {while(*x) x++;}

/**********************************/
/* F O R T R A N    B I N D I N G */
/**********************************/

#if defined (_x86_)  /* Microsoft Visual C for PC machines */

#define  CallTyp            __stdcall
#define  LOUT               , Int  lout

#define  Date_String        DATE_ABV
#define  Date_String_Full   DATE_FUL

#elif defined (_cray_star_)  /* CRAY surper computers (C-90) & Stardent */

#define  CallTyp
#define  LOUT

#define  Date_String        DATE_ABV
#define  Date_String_Full   DATE_FUL
#
#elif defined (_hp_ibm_)  /* Hewlet-Packard & IBM UNIX workstaions */

#define  CallTyp
#define  LOUT               , Int  lout

#if defined (_ppu_)

#define  Date_String        date_abv_
#define  Date_String_Full   date_ful_

#else

#define  Date_String        date_abv
#define  Date_String_Full   date_ful

#endif

#elif defined (_gfc64_) ||  defined (_gfc95_) /* X86 Linux platforms using GNU gfortran Compilers */

#define  CallTyp
#define  LOUT               , Int  lout

#define  Date_String        date_abv_
#define  Date_String_Full   date_ful_

#elif defined (_gfc32_) ||  defined (_gfc77_)  /* X86 Linux platforms using GNU g77 compiler */

#define  CallTyp
#define  LOUT               , Int  lout

#define  Date_String        date_abv_
#define  Date_String_Full   date_ful_

#elif defined (_linux_)  /* X86 Linux platforms using GNU g77 compiler */

#define  CallTyp
#define  LOUT               , Int  lout

#define  Date_String        date_abv_
#define  Date_String_Full   date_ful_

#else  /* all other linux and unix installations */

#define  CallTyp
#define  LOUT               , Int  lout

#define  Date_String        date_abv_
#define  Date_String_Full   date_ful_

#endif

/***********************/
/* P R O T O T Y P E S */
/***********************/

void CallTyp  Date_String ( Int  *lang      ,
                            char *outp LOUT );

void CallTyp  Date_String_Full ( Int  *lang      ,
                                 Int  *ifmt      ,
                                 char *outp LOUT );

/*+------------------------------------------------------------------------+
  |                                                                        |
  |    (Date_String) returns the current date, time and the day-of-week    |
  |                                                                        |
  |      lang = 0 (English), =1 (Deutsch), =2 (Francais), =3 (Espanol)     |
  |                                                                        |
  +------------------------------------------------------------------------+*/

/***************************
 *  entry  -  Date_String  *
 ***************************/

void CallTyp  Date_String ( Int  *lang      ,
                            char *outp LOUT )

{
  /*  Day-Of-Week names:      English     Deutsch      Francais   Espanol
                              -------     -------      --------   -------    */
  static char *dow[7][4] = {{"Sunday",   "Sonntag",   "Dimanche","Domingo"   },
                            {"Monday",   "Montag",    "Lundi",   "Lunes"     },
                            {"Tuesday",  "Dienstag",  "Mardi",   "Martes"    },
                            {"Wednesday","Mittwoch",  "Mercredi","Miercoles" },
                            {"Thursday", "Donnerstag","Jeudi",   "Jueves"    },
                            {"Friday",   "Freitag",   "Vendredi","Viernes"   },
                            {"Saturday", "Samstag",   "Samedi",  "Sabado"    }};

  /*  Month names:             English     Deutsch     Francais    Espanol
                               -------     -------     --------    -------    */

  static char *mth[12][4] = {{"January",  "Januar",   "Janvier",  "Enero"     },
                             {"February", "Februar",  "Fevrier",  "Febrero"   },
                             {"March",    "Marz",     "Mars",     "Marzo"     },
                             {"April",    "April",    "Avril",    "Abril"     },
                             {"May",      "Mai",      "Mai",      "Mayo"      },
                             {"June",     "Juni",     "Juin",     "Junio"     },
                             {"July",     "Juli",     "Juillet",  "Julio"     },
                             {"August",   "August",   "Aout",     "Agosto"    },
                             {"September","September","Septembre","Septiembre"},
                             {"October",  "Oktober",  "Octobre",  "Octubre"   },
                             {"November", "November", "Novembre", "Noviembre" },
                             {"December", "Dezember", "Decembre", "Diciembre" }};

  /*  Abreviated Months:       Eng    Deu    Fra    Esp
                               ---    ---    ---    --- */

  static char *mab[12][4] = {{"Jan", "Jan", "Jan", "Ene"},
                             {"Feb", "Feb", "Fev", "Feb"},
                             {"Mar", "Mar", "Mar", "Mar"},
                             {"Apr", "Apr", "Avr", "Abr"},
                             {"May", "Mai", "Mai", "May"},
                             {"Jun", "Jun", "Jun", "Jun"},
                             {"Jul", "Jul", "Jul", "Jul"},
                             {"Aug", "Aug", "Aou", "Ago"},
                             {"Sep", "Sep", "Sep", "Sep"},
                             {"Oct", "Okt", "Oct", "Oct"},
                             {"Nov", "Nov", "Nov", "Nov"},
                             {"Dec", "Dez", "Dec", "Dic"}};

  int              lan;
  int              yy;
  time_t           tim;
  struct tm        dt;
  register char   *cp;

  /*  begin logic
      -----------  */

  if ((*lang < 0) || (*lang > 3)) {
    lan =  0;
  }
  else {
    lan = *lang;
  }

  tim  =   time ((time_t *)0);

  dt   =  *localtime (&tim);

  if (dt.tm_year > 99) {
    yy = dt.tm_year - 100;
  }
  else {
    yy = dt.tm_year;
  }

  /*  setup date format based upon language (lang)
      --------------------------------------------  */
    
  switch (lan) {

    case 0:    /*  lang = 0, English  output format  */

      cp  =  "%M %D, %Y  %T (%W)";
      break;

    case 1:    /*  lang = 1, Deutsch  output format  */

      cp  =  "%D. %M %Y  %T (%W)";
      break;

    case 2:    /*  lang = 2, Francais output format  */

      cp  =  "%D %M %Y  %T (%W)";
      break;

    case 3:    /*  lang = 3, Espanol  output format  */

      cp  =  "%D %M %Y  %T (%W)";
      break;

    default:   /*  lang = ?, English  output format  */

      cp  =  "%M %D, %Y  %T (%W)";
      break;
  }

  /*  construct date string using format (cp)
      ---------------------------------------  */

  for ( ; *cp ; cp++) {

    if (*cp != '%') {
      *outp++ = *cp;
    }
    else {

      if (cp[1]) {

        switch(*++cp) {

          case 'M':    /*  month_of_year  */

            sprintf(outp,"%s", mth[dt.tm_mon][lan]);
            END(outp);
            break;

          case 'D':    /*  day_of_month  */

            sprintf(outp,"%d", dt.tm_mday);
            END(outp);
            break;

          case 'Y':    /*  year  */

            if (dt.tm_year > 99) {
              sprintf(outp,"20%02d", yy);
            }
            else {
              sprintf(outp,"19%02d", yy);
            }
            END(outp);
            break;

          case 'T':    /*  time  (HH:MM:SS)  */

            sprintf(outp,"%2d:%02d:%02d",
                         dt.tm_hour, dt.tm_min, dt.tm_sec);
            END(outp);
            break;

          case 'W':    /*  day_of_week  */

            sprintf(outp,"%s", dow[dt.tm_wday][lan]);
            END(outp);
            break;

        }
      }
    }
  }

  *outp = '\0';
}


/*+--------------------------------------------------------------------------+
  |                                                                          |
  |   (Date_String_Full) returns the current date, time and the day-of-week  |
  |                                                                          |
  |       lang = language code (0-3)       ifmt = format code (0-4)          |
  |                                                                          |
  |       lang = 0 (English), =1 (Deutsch), =2 (Francais), =3 (Espanol)      |
  |                                                                          |
  +--------------------------------------------------------------------------+*/

/********************************
 *  entry  -  Date_String_Full  *
 ********************************/

void CallTyp  Date_String_Full ( Int  *lang      ,
                                 Int  *ifmt      ,
                                 char *outp LOUT )

{
  /*  Day-Of-Week names:      English     Deutsch      Francais   Espanol
                              -------     -------      --------   -------    */
  static char *dow[7][4] = {{"Sunday",   "Sonntag",   "Dimanche","Domingo"   },
                            {"Monday",   "Montag",    "Lundi",   "Lunes"     },
                            {"Tuesday",  "Dienstag",  "Mardi",   "Martes"    },
                            {"Wednesday","Mittwoch",  "Mercredi","Miercoles" },
                            {"Thursday", "Donnerstag","Jeudi",   "Jueves"    },
                            {"Friday",   "Freitag",   "Vendredi","Viernes"   },
                            {"Saturday", "Samstag",   "Samedi",  "Sabado"    }};

  /*  Month names:             English     Deutsch     Francais    Espanol
                               -------     -------     --------    -------    */

  static char *mth[12][4] = {{"January",  "Januar",   "Janvier",  "Enero"     },
                             {"February", "Februar",  "Fevrier",  "Febrero"   },
                             {"March",    "Marz",     "Mars",     "Marzo"     },
                             {"April",    "April",    "Avril",    "Abril"     },
                             {"May",      "Mai",      "Mai",      "Mayo"      },
                             {"June",     "Juni",     "Juin",     "Junio"     },
                             {"July",     "Juli",     "Juillet",  "Julio"     },
                             {"August",   "August",   "Aout",     "Agosto"    },
                             {"September","September","Septembre","Septiembre"},
                             {"October",  "Oktober",  "Octobre",  "Octubre"   },
                             {"November", "November", "Novembre", "Noviembre" },
                             {"December", "Dezember", "Decembre", "Diciembre" }};

  /*  Abreviated Months:       Eng    Deu    Fra    Esp
                               ---    ---    ---    --- */

  static char *mab[12][4] = {{"Jan", "Jan", "Jan", "Ene"},
                             {"Feb", "Feb", "Fev", "Feb"},
                             {"Mar", "Mar", "Mar", "Mar"},
                             {"Apr", "Apr", "Avr", "Abr"},
                             {"May", "Mai", "Mai", "May"},
                             {"Jun", "Jun", "Jun", "Jun"},
                             {"Jul", "Jul", "Jul", "Jul"},
                             {"Aug", "Aug", "Aou", "Ago"},
                             {"Sep", "Sep", "Sep", "Sep"},
                             {"Oct", "Okt", "Oct", "Oct"},
                             {"Nov", "Nov", "Nov", "Nov"},
                             {"Dec", "Dez", "Dec", "Dic"}};

  int              lan;
  int              typ;
  int              yy;
  int              yyyy;
  time_t           tim;
  struct tm        dt;
  register char   *cp;
  register int     l;

  /*  begin logic
      -----------  */

  if ((*lang < 0) || (*lang > 3)) {
    lan =  0;
  }
  else {
    lan = *lang;
  }

  if ((*ifmt < 0) || (*ifmt > 4)) {
    typ =  0;
  }
  else {
    typ = *ifmt;
  }

  tim  =   time ((time_t *)0);

  dt   =  *localtime (&tim);

  if (dt.tm_year > 99) {
    yy   = dt.tm_year - 100;
    yyyy = 2000 + yy;
  }
  else {
    yy   = dt.tm_year;
    yyyy = 1900 + yy;
  }



    
  switch (lan) {

   /* +----------------------------------------------------------+
      |                                                          |
      |  lang = 1  ( Deutsch )  representation of dates          |
      |                                                          |
      |  ifmt = 0, return date as (31/12/90)                     |
      |       = 1, return date as (31. Dez 90)                   |
      |       = 2, return date as (31. Dez 1990)                 |
      |       = 3, return date as (31. Dezember 1990)            |
      |       = 4, return date as (31. Dezember 1990  (Montag))  |
      |                                                          |
      +----------------------------------------------------------+ */

    case 1:    /*  lang = 1, Deutsch output format  */

      l   =  1;
      switch (typ) {

        case 1:    /*  ifmt = 1, format:  (31 Dez 90)  */
          cp  =  "%D %A %Z";
          break;
        case 2:    /*  ifmt = 2, format:  (31. Dez 1990)  */
          cp  =  "%D. %A %Y";
          break;
        case 3:    /*  ifmt = 3, format:  (31. Dezember 1990)  */
          cp  =  "%D. %M %Y";
          break;
        case 4:    /*  ifmt = 4, format:  (31. Dezember 1990  (Montag))  */
          cp  =  "%D. %M %Y  (%W)";
          break;
        case 0:    /*  ifmt = 0, format:  (31/12/90)  */
        default:
          cp  =  "%I";
          break;
      }
      break;
 
   /* +--------------------------------------------------------+
      |                                                        |
      |  lang = 2  ( Francais )  representation of dates       |
      |                                                        |
      |  ifmt = 0, return date as (31/12/90)                   |
      |       = 1, return date as (31 Dec 90)                  |
      |       = 2, return date as (31 Dec 1990)                |
      |       = 3, return date as (31 Decembre 1990)           |
      |       = 4, return date as (31 Decembre 1990  (Lundi))  |
      |                                                        |
      +--------------------------------------------------------+ */

    case 2:    /*  lang = 2, Francais output format  */

      l   =  2;
      switch (typ) {

        case 1:    /*  ifmt = 1, format:  (31 Dec 90)  */
          cp  =  "%D %A %Z";
          break;
        case 2:    /*  ifmt = 2, format:  (31 Dec 1990)  */
          cp  =  "%D %A %Y";
          break;
        case 3:    /*  ifmt = 3, format:  (31 Decembre 1990)  */
          cp  =  "%D %M %Y";
          break;
        case 4:    /*  ifmt = 4, format:  (31 Decembre 1990 (Lundi))  */
          cp  =  "%D %M %Y  (%W)";
          break;
        case 0:    /*  ifmt = 0, format:  (31/12/90)  */
        default:
          cp  =  "%I";
          break;
      }
      break;

   /* +---------------------------------------------------------+
      |                                                         |
      |  lang = 3  ( Espanol )  representation of dates         |
      |                                                         |
      |  ifmt = 0, return date as (31/12/90)                    |
      |       = 1, return date as (31 Dic 90)                   |
      |       = 2, return date as (31 Dic 1990)                 |
      |       = 3, return date as (31 Diciembre 1990)           |
      |       = 4, return date as (31 Diciembre 1990  (Lunes))  |
      |                                                         |
      +---------------------------------------------------------+ */

    case 3:    /*  lang = 3, Francais output format  */

      l   =  3;
      switch (typ) {

        case 1:    /*  ifmt = 1, format:  (31 Dic 90)  */
          cp  =  "%D %A %Z";
          break;
        case 2:    /*  ifmt = 2, format:  (31 Dic 1990)  */
          cp  =  "%D %A %Y";
          break;
        case 3:    /*  ifmt = 3, format:  (31 Diciembre 1990)  */
          cp  =  "%D %M %Y";
          break;
        case 4:    /*  ifmt = 4, format:  (31 Diciembre 1990 (Lunes))  */
          cp  =  "%D %M %Y  (%W)";
          break;
        case 0:    /*  ifmt = 0, format:  (31/12/90)  */
        default:
          cp  =  "%I";
          break;
      }
      break;

   /* +----------------------------------------------------------+
      |                                                          |
      |  lang = 0  ( English )  representation of dates          |
      |                                                          |
      |  ifmt = 0, return date as (12/31/90)                     |
      |       = 1, return date as (31 Dec 90)                    |
      |       = 2, return date as (Dec 31, 1990)                 |
      |       = 3, return date as (December 31, 1990)            |
      |       = 4, return date as (December 31, 1990  (Monday))  |
      |                                                          |
      +----------------------------------------------------------+ */

    case 0:    /*  lang = 0, English output format  */
    default:

      l   =  0;
      switch (typ) {

        case 1:    /*  ifmt = 1, format:  (31 Dec 90)  */
          cp  =  "%D %A %Z";
          break;
        case 2:    /*  ifmt = 2, format:  (Dec 31, 1990)  */
          cp  =  "%A %D, %Y";
          break;
        case 3:    /*  ifmt = 3, format:  (December 31, 1990)  */
          cp  =  "%M %D, %Y";
          break;
        case 4:    /*  ifmt = 4, format:  (December 31, 1990 (Monday))  */
          cp  =  "%M %D, %Y  (%W)";
          break;
        case 0:    /*  ifmt = 0, format:  (12/31/90)  */
        default:
          cp  =  "%E";
          break;
      }
      break;

  }

  /* +--------------------------------------------------+
     |                                                  |
     |  construct date/time string using format  (*cp)  |
     |                                                  |
     +--------------------------------------------------+ */

  for ( ; *cp ; cp++) {

    if (*cp != '%') {
      *outp++ = *cp;
    }
    else {

      if (cp[1]) {

        switch(*++cp) {

          case 'M':    /*  month_of_year  */

            sprintf(outp,"%s", mth[dt.tm_mon][l]);
            END(outp);
            break;

          case 'A':    /*  abreviated month_of_year  */

            sprintf(outp,"%s", mab[dt.tm_mon][l]);
            END(outp);
            break;

          case 'D':    /*  day_of_month  */

            sprintf(outp,"%d", dt.tm_mday);
            END(outp);
            break;

          case 'Y':    /*  year  */

            sprintf(outp,"%04d", yyyy);
            END(outp);
            break;

          case 'Z':    /*  year - last 2 digits  */

            sprintf(outp,"%02d", yy);
            END(outp);
            break;

          case 'T':    /*  time  (HH:MM:SS)  */

            sprintf(outp,"%2d:%02d:%02d",
                         dt.tm_hour, dt.tm_min, dt.tm_sec);
            END(outp);
            break;

          case 'E':    /*  date  (MM/DD/YY)  */

            sprintf(outp,"%2d/%02d/%02d",
                         dt.tm_mon+1, dt.tm_mday, yy);
            END(outp);
            break;

          case 'I':    /*  date  (DD/MM/YY)  */

            sprintf(outp,"%2d/%02d/%02d",
                          dt.tm_mday, dt.tm_mon+1, yy);
            END(outp);
            break;

          case 'W':    /*  day_of_week  */

            sprintf(outp,"%s", dow[dt.tm_wday][l]);
            END(outp);
            break;

        }
      }
    }
  }

  *outp = '\0';
}

/* end */
