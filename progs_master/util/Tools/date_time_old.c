/*  DATTIM:  FORTRAN callable routine to fetch current date & time
 *
 *  this subroutine is called in fortran (f77) via:
 *
 *       call    DATTIM (d, t)
 *      -----------------------
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

#include   <sys/types.h>
#include   <time.h>

/***********************/
/* pre processor flags */
/***********************/

/*  #define __STDC__   */


/*
 *    setup the (fortran) naming conventions here
 *   ---------------------------------------------
 */

#if defined (_cray_) || defined (_star_) || defined (_x86_)

#if defined (_x86_)
#define  CallTyp  __stdcall
#else
#define  CallTyp
#endif

#define  Date_Time  DATTIM

#else
#if defined (ppu) || defined (_ppu_) || defined (_gfc95_) || defined (_gfc64_)

#define  CallTyp

#define  Date_Time  dattim_

#else
#if defined (linux) || defined (_linux_) || defined (_gfc77_) || defined (_gfc32_)

#define  CallTyp

#define  Date_Time  dattim_

#else
/* #if defined (_rs6k_) || defined (_hp_) || defined (_macosx_) */

#define  CallTyp

#define  Date_Time  dattim

#endif
#endif
#endif

/**********************
 *  entry  -  DATTIM  *
 **********************/

#ifdef __STDC__

void CallTyp  Date_Time ( Int  *d ,
                          Int  *t )

#else

void CallTyp  Date_Time ( )

Int  *d;
Int  *t;

#endif

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
