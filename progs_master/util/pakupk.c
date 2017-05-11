/*  PAKUPK: FORTRAN callable routine to pack/unpack characters
 *
 *  these subroutine are called in fortran (f77) via:
 *
 *       call    CC2H (cha, hol, n)
 *      ----------------------------
 *
 *       call    CC2HO (cha, hol, o, n)
 *      --------------------------------
 *
 *       call    CH2C (hol, cha, n)
 *      ----------------------------
 *
 *       call    CHO2C (hol, o, cha, n)
 *      --------------------------------
 *
 *  where:
 *
 *    cha(*)   =  character string
 *    hol(*)   =  hollerith (integer) string/array
 *
 *    o        =  offset into hollerith (integer) array
 *    n        =  number of characters to pack/unpack
 *
 */

/****************/
/* header files */
/****************/

#include "mach.h"

//#include <stdio.h>
#include <stdio.h>
#include <string.h>

/***********************/
/* pre processor flags */
/***********************/

/*  #define __STDC__   */

/**********************************/
/* F O R T R A N    B I N D I N G */
/**********************************/

#if defined (_x86_)  /* Microsoft Visual C for PC machines */

#define  CallTyp  __stdcall

#define  LCH_MS       , Int  lcha
#define  LCH

#define  KCH

#define  Pack_Char           CC2H
#define  Pack_Char_Offset    CC2HO
#define  Unpack_Char         CH2C
#define  Unpack_Char_Offset  CHO2C

#elif defined (_cray_star_)  /* CRAY surper computers (C-90) & Stardent */

#define  CallTyp

#define  LCH_MS
#define  LCH

#define  KCH

#define  Pack_Char           CC2H
#define  Pack_Char_Offset    CC2HO
#define  Unpack_Char         CH2C
#define  Unpack_Char_Offset  CHO2C

#elif defined (_hp_ibm_)  /* Hewlet-Packard & IBM UNIX workstaions */

#define  CallTyp

#define  LCH_MS
#define  LCH          , Int  lcha

#define  KCH            Int  lcha;

#if defined (_ppu_)

#define  Pack_Char           cc2h_
#define  Pack_Char_Offset    cc2ho_
#define  Unpack_Char         ch2c_
#define  Unpack_Char_Offset  cho2c_

#else

#define  Pack_Char           cc2h
#define  Pack_Char_Offset    cc2ho
#define  Unpack_Char         ch2c
#define  Unpack_Char_Offset  cho2c

#endif

#elif defined (_gfc77_)  /* X86 Linux platforms using GNU g77 compiler */

#define  CallTyp

#define  LCH_MS
#define  LCH          , Int  lcha

#define  KCH            Int  lcha;

#define  Pack_Char           cc2h_
#define  Pack_Char_Offset    cc2ho_
#define  Unpack_Char         ch2c_
#define  Unpack_Char_Offset  cho2c_

#else  /* all other linux and unix installations */

#define  CallTyp

#define  LCH_MS
#define  LCH          , Int  lcha

#define  KCH            Int  lcha;

#define  Pack_Char           cc2h_
#define  Pack_Char_Offset    cc2ho_
#define  Unpack_Char         ch2c_
#define  Unpack_Char_Offset  cho2c_

#endif

/***********************/
/* P R O T O T Y P E S */
/***********************/

#ifdef __STDC__

void CallTyp  Pack_Char   ( Char  cha LCH_MS ,
                            Int  *hol        ,
                            Int  *n   LCH    );

void CallTyp  Pack_Char_Offset   ( Char  cha LCH_MS ,
                                   Int  *hol        ,
                                   Int  *o          ,
                                   Int  *n   LCH    );

void CallTyp  Unpack_Char ( Int  *hol        ,
                            Char  cha LCH_MS ,
                            Int  *n   LCH    );

void CallTyp  Unpack_Char_Offset ( Int  *hol        ,
                                   Int  *o          ,
                                   Char  cha LCH_MS ,
                                   Int  *n   LCH    );

#else

void CallTyp  Pack_Char   ( );
void CallTyp  Pack_Char_Offset   ( );
void CallTyp  Unpack_Char ( );
void CallTyp  Unpack_Char_Offset ( );

#endif

/*
 *    set DEBUG print-outs
 *   ----------------------
 */

int     debug_bio   = 0;

/*#######################*/
/*#                     #*/
/*#  P a c k _ C h a r  #*/
/*#                     #*/
/*#######################*/

/*****************************************/
/*                                       */
/* P U R P O S E:                        */
/* =============                         */
/*       pack input characters (c) into  */
/*       the string of integers (h)      */
/*                                       */
/*****************************************/

#ifdef __STDC__

void CallTyp  Pack_Char ( Char  cha LCH_MS ,
                          Int  *hol        ,
                          Int  *n   LCH    )

#else

void CallTyp  Pack_Char ( )

Char  cha;
Int  *hol;
Int  *n;
KCH

#endif

{
  char       *c;
  char       *h;
  int         no;

  char       *str;
  int         lstr;

  /*******************************/
  /*  pack the hollerith string  */
  /*******************************/

  no   = *n;

#if defined (_cray_star_)
  /* create C-pointers form FORTRAN-Descriptor-Words */

  str  = (char *) cha->addr;   /* string address           */
  lstr = (int)    cha->leng;   /* string length (in bytes) */
#else
  /* create C-pointers and lengths for FORTRAN character strings */

  str  = cha;
  lstr = (int) lcha;
#endif

  if ( debug_bio ) {
    printf (" CC2H  str = %8x  lstr = %d  hol = %8x  no. char = %d\n", str, lstr, hol, *n);
  }

  if (no <= 0) {
    return;
  }

  if (no > lstr) {
    printf (" CC2H: no. char = %d exceeds string length = %d\n", *n, lstr);
    no = lstr;
  }

  h   =  (Char  ) hol;
  c   =  str;

  while (no-- > 0) {

    *h++ = *c++;

  }

  return;

}

/*#####################################*/
/*#                                   #*/
/*#  P a c k _ C h a r _ O f f s e t  #*/
/*#                                   #*/
/*#####################################*/

/*****************************************/
/*                                       */
/* P U R P O S E:                        */
/* =============                         */
/*       pack input characters (c) into  */
/*       the string of integers (h)      */
/*       starting at offset location (o) */
/*                                       */
/*****************************************/

#ifdef __STDC__

void CallTyp  Pack_Char_Offset ( Char  cha LCH_MS ,
                                 Int  *hol        ,
                                 Int  *off        ,
                                 Int  *n   LCH    )

#else

void CallTyp  Pack_Char_Offset ( )

Char  cha;
Int  *hol;
Int  *off;
Int  *n;
KCH

#endif

{
  char       *c;
  char       *h;
  int         no;

  char       *str;
  int         lstr;

  /*******************************/
  /*  pack the hollerith string  */
  /*******************************/

  no   = *n;

#if defined (_cray_star_)
  /* create C-pointers form FORTRAN-Descriptor-Words */

  str  = (char *) cha->addr;   /* string address           */
  lstr = (int)    cha->leng;   /* string length (in bytes) */
#else
  /* create C-pointers and lengths for FORTRAN character strings */

  str  = cha;
  lstr = (int) lcha;
#endif

  if ( debug_bio ) {
    printf (" CC2HO  str = %8x  lstr = %d  hol = %8x  no. char = %d\n", str, lstr, hol, *n);
  }

  if (no <= 0) {
    return;
  }

  if (no > lstr) {
    printf (" CC2HO: no. char = %d exceeds string length = %d\n", *n, lstr);
    no = lstr;
  }

  h   =  (Char) hol;
  c   =  cha;

  /* 1st position the pointer in the hollerith string */

  no  = *off;

  while (no-- > 0) {
  //*h++;
     h++;
  }

  /* 2nd, put characters into the hollerith string */

  no  = *n;

  while (no-- > 0) {

    *h++ = *c++;

  }

  return;

}

/*###########################*/
/*#                         #*/
/*#  U n p a c k _ C h a r  #*/
/*#                         #*/
/*###########################*/

/********************************************/
/*                                          */
/* P U R P O S E:                           */
/* =============                            */
/*       unpack input hollerith string (h)  */
/*       into the string of characters (c). */
/*                                          */
/********************************************/

#ifdef __STDC__

void CallTyp  Unpack_Char ( Int  *hol        ,
                            Char  cha LCH_MS ,
                            Int  *n   LCH    )

#else

void CallTyp  Unpack_Char ( )

Int  *hol;
Char  cha;
Int  *n;
KCH

#endif

{
  char       *h;
  char       *c;
  int         no;

  char       *str;
  int         lstr;

  /*********************************/
  /*  unpack the hollerith string  */
  /*********************************/

  no   = *n;

#if defined (_cray_star_)
  /* create C-pointers form FORTRAN-Descriptor-Words */

  str  = (char *) cha->addr;   /* string address           */
  lstr = (int)    cha->leng;   /* string length (in bytes) */
#else
  /* create C-pointers and lengths for FORTRAN character strings */

  str  = cha;
  lstr = (int) lcha;
#endif

  if ( debug_bio ) {
    printf (" CH2C  str = %8x  lstr = %d  hol = %8x  no. char = %d\n", str, lstr, hol, *n);
  }

  if (no <= 0) {
    return;
  }

  if (no > lstr) {
    printf (" CH2C: no. char = %d exceeds string length = %d\n", *n, lstr);
    no = lstr;
  }

  h  =  (Char) hol;
  c  =  cha;

  while (no-- > 0) {

    *c++ = *h++;

  }

  return;

}

/*#########################################*/
/*#                                       #*/
/*#  U n p a c k _ C h a r _ O f f s e t  #*/
/*#                                       #*/
/*#########################################*/

/********************************************/
/*                                          */
/* P U R P O S E:                           */
/* =============                            */
/*       unpack input hollerith string (h)  */
/*       starting at offset location (o)    */
/*       into the string of characters (c). */
/*                                          */
/********************************************/

#ifdef __STDC__

void CallTyp  Unpack_Char_Offset ( Int  *hol        ,
                                   Int  *off        ,
                                   Char  cha LCH_MS ,
                                   Int  *n   LCH    )

#else

void CallTyp  Unpack_Char_Offset ( )

Int  *hol;
Int  *off;
Char  cha;
Int  *n;
KCH

#endif

{
  char       *h;
  char       *c;
  int         no;

  char       *str;
  int         lstr;

  /*********************************/
  /*  unpack the hollerith string  */
  /*********************************/

  no   = *n;

#if defined (_cray_star_)
  /* create C-pointers form FORTRAN-Descriptor-Words */

  str  = (char *) cha->addr;   /* string address           */
  lstr = (int)    cha->leng;   /* string length (in bytes) */
#else
  /* create C-pointers and lengths for FORTRAN character strings */

  str  = cha;
  lstr = (int) lcha;
#endif

  if ( debug_bio ) {
    printf (" CHO2C  str = %8x  lstr = %d  hol = %8x  no. char = %d\n", str, lstr, hol, *n);
  }

  if (no <= 0) {
    return;
  }

  if (no > lstr) {
    printf (" CHO2C: no. char = %d exceeds string length = %d\n", *n, lstr);
    no = lstr;
  }

  h  =  (Char) hol;
  c  =  cha;

  /* 1st position the pointer in the hollerith string */

  no  = *off;

  while (no-- > 0) {
  //*h++;
     h++;
  }

  /* 2nd, extract the characters from the hollerith string */

  no  = *n;

  while (no-- > 0) {

    *c++ = *h++;

  }

  return;

}
