/*  LOCF:  FORTRAN callable routine to obtain variable address
 *
 *  this INTEGER function is called in fortran (f77) via:
 *
 *       iaddr  =  LOCF (varb)
 *      -----------------------
 *
 *  input arguments:
 *
 *    varb  =  a 4-byte variable
 *
 *  output arguments:
 *
 *    LOCF  =  address of input variable (varb)
 *
 */

/****************/
/* header files */
/****************/

#include <sys/types.h>

#include "mach.h"

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

#define  Location  LOCF

#else
#if defined (ppu) || defined (_ppu_) || defined (_gfc95_)

#define  CallTyp

#define  Location  locf_

#else
#if defined (linux) || defined (_linux_) || defined (_gfc77_)

#define  CallTyp

#define  Location  locf_

#else
/* #if defined (_rs6k_) || defined (_hp_) || defined (_mac_) */

#define  CallTyp

#define  Location  locf

#endif
#endif
#endif

/********************
 *  entry  -  LOCF  *
 ********************/

Long  Location ( Long *varb )

{
  return ( (Long) varb );
}
