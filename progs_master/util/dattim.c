/*  DATTIM:  FORTRAN callable routine to fetch current date & time
 *
 *  this subroutine is called in fortran (f77) via:
 *
 *       call    SDATE (op, string, lng)     string = 32 character string
 *      ---------------------------------
 *       call    HDATE (op, holdat, nhol)    holdat = 32 character integer array
 *                                                  =  8 integer words (4 char/word)
 *                                                  =  4 integer words (8 char/word)
 *
 *  output arguments: (dependent upon option key 'op')
 *
 *    op = 0   string = "www mon dd, yyyy @ hh:mm:ss"     27-cha
 *    op = 1   string = "mon dd, yyyy @ hh:mm:ss"         23-cha
 *    op = 2   string = "mon dd, yyyy @ hh:mm:ss (www)"   29-cha
 *
 *    op = 3   string = "mm/dd/yy"   <-- date only         8-cha
 *    op = 4   string = "hh:mm:ss"   <-- time only         8-cha
 *
 *    lng/nhol        =  number of characters in output (string/holdat)
 *
 *
 *  this subroutine is called in fortran (f77) via:
 *
 *       call    IDATE (d, t)
 *      ----------------------
 *
 *  output arguments: (follow the USA conventions )
 *
 *    d(1)  =  current date  MONTH (1 - 12)
 *    d(2)  =  current date  DAY   (1 - 31)
 *    d(3)  =  current date  YEAR  (last two digits)
 *
 *    t(1)  =  current time  HOUR   (0 - 23)
 *    t(2)  =  current time  MIMUTE (0 - 59)
 *    t(3)  =  current time  SECOND (0 - 59)
 *
 */

/****************/
/* header files */
/****************/

#include   "mach.h"

/*  get system header files  */
 
#include  <stdio.h>
#include  <sys/types.h>
#include  <string.h>
#ifdef IBM
#include  <sys/time.h>
#else
#include  <time.h>
#endif

/**********************************/
/* F O R T R A N    B I N D I N G */
/**********************************/

#if defined (_x86_)  /* Microsoft Visual C for PC machines */

#define  CallTyp     __stdcall
#define  LOUT_MS     , Int  lout
#define  LOUT

#define  Date_Time   SDATE
#define  Hdat_Htim   HDATE
#define  Idat_Itim   IDATE

#elif defined (_cray_star_)  /* CRAY surper computers (C-90) & Stardent */

#define  CallTyp
#define  LOUT_MS
#define  LOUT

#define  Date_Time   SDATE
#define  Hdat_Htim   HDATE
#define  Idat_Itim   IDATE
#
#elif defined (_hp_ibm_)  /* Hewlet-Packard & IBM UNIX workstaions */

#define  CallTyp
#define  LOUT_MS
#define  LOUT        , Int  lout

#if defined (_ppu_)

#define  Date_Time   sdate_
#define  Hdat_Htim   hdate_
#define  Idat_Itim   idate_

#else

#define  Date_Time   sdate
#define  Idat_Itim   idate

#endif

#elif defined (_gfc64_) ||  defined (_gfc95_) /* X86 Linux platforms using GNU gfortran Compilers */

#define  CallTyp
#define  LOUT_MS
#define  LOUT        , Int  lout

#define  Date_Time   sdate_
#define  Hdat_Htim   hdate_
#define  Idat_Itim   idate_

#elif defined (_gfc32_) ||  defined (_gfc77_)  /* X86 Linux platforms using GNU g77 compiler */

#define  CallTyp
#define  LOUT_MS
#define  LOUT        , Int  lout

#define  Date_Time   sdate_
#define  Hdat_Htim   hdate_
#define  Idat_Itim   idate_

#elif defined (_linux_)  /* X86 Linux platforms using GNU g77 compiler */

#define  CallTyp
#define  LOUT_MS
#define  LOUT        , Int  lout

#define  Date_Time   sdate_
#define  Hdat_Htim   hdate_
#define  Idat_Itim   idate_

#else  /* all other linux and unix installations */

#define  CallTyp
#define  LOUT_MS
#define  LOUT        , Int  lout

#define  Date_Time   sdate_
#define  Hdat_Htim   hdate_
#define  Idat_Itim   idate_

#endif

/***********************/
/* P R O T O T Y P E S */
/***********************/

void CallTyp  Hdat_Htim ( Int  *op  ,
                          Int  *out ,
                          Int  *lng );

void CallTyp  Date_Time ( Int  *op          ,
                          char *out LOUT_MS ,
                          Int  *lng LOUT    );

void CallTyp  Idat_Itim ( Int  *idate ,
                          Int  *itime );

/*************************
 *  entry  -  Hdat_Htim  *
 *************************/

void CallTyp  Hdat_Htim ( Int  *op  ,
                          Int  *out ,
                          Int  *lng )

{
  time_t           tim;
  struct tm        dt;

  static const char wday_name[7][3] = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };

  static const char mon_name[12][3] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };

  /*  begin logic
      -----------  */

  tim  =   time ((time_t *)0);

  dt   =  *localtime (&tim);

  if (*op == 1) {

    sprintf((char *)out, "%.3s %d, %d @ %.2d:%.2d:%.2d",
            mon_name[dt.tm_mon],
            dt.tm_mday,
            dt.tm_year + 1900,
            dt.tm_hour, dt.tm_min, dt.tm_sec);

    *lng = 23;

  }
  else if (*op == 2) {

    sprintf((char *)out, "%.3s %d, %d @ %.2d:%.2d:%.2d (%.3s)",
            mon_name[dt.tm_mon],
            dt.tm_mday,
            dt.tm_year + 1900,
	    dt.tm_hour, dt.tm_min, dt.tm_sec,
            wday_name[dt.tm_wday]);

    *lng = 29;

  }
  else if (*op == 3) {

    if (dt.tm_year > 99) {
      sprintf((char *)out, "%.2d/%.2d/%.2d",
	      dt.tm_mon + 1, dt.tm_mday, dt.tm_year - 100);
    }
    else {
      sprintf((char *)out, "%.2d/%.2d/%.2d",
	      dt.tm_mon + 1, dt.tm_mday, dt.tm_year);
    }

    *lng = 8;

  }
  else if (*op == 4) {

    sprintf((char *)out, "%.2d:%.2d:%.2d",
	    dt.tm_hour, dt.tm_min, dt.tm_sec);

    *lng = 8;

  }
  else {

    sprintf((char *)out, "%.3s %.3s %d, %d @ %.2d:%.2d:%.2d",
            wday_name[dt.tm_wday],
            mon_name[dt.tm_mon],
            dt.tm_mday,
            dt.tm_year + 1900,
            dt.tm_hour, dt.tm_min, dt.tm_sec);


    *lng = 27;
  }

  return;
}


/*************************
 *  entry  -  Date_Time  *
 *************************/

void CallTyp  Date_Time ( Int  *op          ,
                          char *out LOUT_MS ,
                          Int  *lng LOUT    )

{
  Int  i;

  /*  begin logic
      -----------  */

  Hdat_Htim ( op, (Int *)out, lng );

  for (i = *lng; i < lout; i++) {
    out[i] = ' ';
  }

  return;
}


/*************************
 *  entry  -  Idat_Itim  *
 *************************/

void CallTyp  Idat_Itim ( Int  *d ,
                          Int  *t )

{
  time_t        tim;
  struct tm     dt;

  /* extract current dater and time from the system */

  tim     =   time((time_t *)0);
  dt      =  *localtime(&tim);

  /* store date components appropriately */

  *(d  )  =  dt.tm_mon + 1;
  *(d+1)  =  dt.tm_mday;

  if (dt.tm_year > 99) {
    *(d+2)  =  dt.tm_year - 100;
  }
  else {
    *(d+2)  =  dt.tm_year;
  }

  /* store time components appropriately */

  *(t  )  =  dt.tm_hour;
  *(t+1)  =  dt.tm_min;
  *(t+2)  =  dt.tm_sec;

  return;
}
