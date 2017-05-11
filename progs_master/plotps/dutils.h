/*
  dutils.h

  Declare all functions in dutils.c.
*/

#ifndef _int_
#include "paramlength.h"
#endif

extern void blowup_(_float_ *);
extern void bshift_(_float_ *, _float_ *);
extern void chndot_(void);
extern void chndsh_(void);
extern void comprs_(void);
extern _int_ currentmarker_(void);
extern void dash_(void);
extern void delleg_(_int_ *);
extern void donepl_(void);
extern void dot_(void);
extern void erase_(void);
extern void height_(_float_ *);
extern void line_(void);
extern void marker_(_int_ *);
extern void nobrdr_(void);
extern void reset_(char *, _int_);
extern void setdev_(_int_ *, _int_ *);
extern void tekall_(void);
extern void tk41_(void);
