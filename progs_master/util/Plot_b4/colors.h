/*
  colors.h

  Declare all functions in colors.c.
*/

#ifndef _int_
#include "paramlength.h"
#endif

extern void newclr_(char *, _int_);
extern void set_color(_float_, _float_, _float_);
extern char *returnAutoTraceColor(_int_);
extern void setTraceColor(_int_, char *);
