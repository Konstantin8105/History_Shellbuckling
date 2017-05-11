/*
etime.c returns elapsed time since process started.
*/

#if rs6k
/*
#define etime etime_
*/

int etime(cpu)
 float *cpu;
   struct tbuf {
          long  utime;
          long  stime;
          long  cutime;
          long  cstime;
    } ;
{
#define   HZ  100 ;  /* 60 ticks/cycle for RT, 100 ticks/cycle for RIOS */
   struct tbuf t;
   long l,times();
   l = times(&t) ;
  *cpu = (t.utime) ;
  *cpu = *cpu/HZ ;
   return ;
}
#endif
#if hp700

/*  ETIME:  FORTRAN callable routine to get elasped CPU time
 *
 *  this subroutine is called in fortran (f77) via:
 *
 *       call    ETIME (et)
 *      --------------------
 *
 *  output arguments:
 *
 *    et(1)  =  elasped user   CPU time in seconds
 *    et(2)  =  elasped system CPU time in seconds
 *
 */


#ifndef _INCLUDE_POSIX_SOURCE
#define _INCLUDE_POSIX_SOURCE
#endif

#include   <sys/types.h>
#include   <time.h>
#include   <sys/times.h>

/*********************
 *  entry  -  ETIME  *
 *********************/

void etime (et)

  float    *et;

{
  clock_t     tim;
  struct tms  tym;

  tim      =  times(&tym);

  *(et  )  =  ((float) tym.tms_utime) / ((float) CLK_TCK);
  *(et+1)  =  ((float) tym.tms_stime) / ((float) CLK_TCK);

  return;
}

#endif
