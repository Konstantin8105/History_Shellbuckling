/*
   ieeexx.c suppresses the warnings caused by IEEE FPE errors: 
   "inexact" and "underflow".
*/

#if (sun3 || sun4)
#include <stdio.h>
#include <sys/ieeefp.h>
#endif

#if (star || cray)
#define ieeexx_ IEEEXX
#endif

#if (rs6k || hp700)
#define ieeexx_ ieeexx
#endif

void ieeexx_()

{
#if (sun3 || sun4)
  char dummy[80];

  if(ieee_flags("clear", "exception", "inexact", dummy) != 0)
    fprintf(stderr, "ieee_flags could not clear inexact exception.\n");

  if (ieee_flags("clear", "exception", "underflow", dummy) != 0)
    fprintf(stderr, "ieee_flags could not clear underflow exception.\n");

  if (ieee_flags("clear", "exception", "invalid", dummy) != 0)
    fprintf(stderr, "ieee_flags could not clear invalid exception.\n");

#endif

}

