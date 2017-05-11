/*
  legends.h

  Declare all functions in legends.c.
*/

#ifndef _int_
#include "paramlength.h"
#endif

extern void angle_(_float_ *);
extern void lines_(char *, char *, _int_ *, _int_, _int_);
extern _int_ linest_(char *, _int_ *, _int_ *, _int_);
extern void messag_(char *, _int_ *, _float_ *, _float_ *, _int_);
extern void mylegn_(char *, _int_ *, _int_);
extern void set_customleg(_int_);
extern _int_ updateLegend(_int_, _float_, enum linestyle_type, char *, char *);
extern void drawLegend(_float_, _float_);
extern void legend_(char *, _int_ *, _float_ *, _float_ *, _int_);
extern void xlegnd_(_float_ *, char *, _int_ *, _int_);
extern void ylegnd_(_float_ *, char *, _int_ *, _int_);
