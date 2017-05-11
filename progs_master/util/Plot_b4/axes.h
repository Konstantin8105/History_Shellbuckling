/*
  axes.h

  Declare all functions in axes.c.
*/

#ifndef _int_
#include "paramlength.h"
#endif

extern void area2d_(_float_ *, _float_ *);
extern void graf_(_float_ *, _float_ *, _float_ *, _float_ *,
           _float_ *, _float_ *);
extern void grid_(_int_ *, _int_ *);
extern void loglog_(_float_ *, _float_ *, _float_ *, _float_ *);
extern void page_(_float_ *, _float_ *);
extern void title_(char *, _int_ *, char *, _int_ *, char *,
                   _int_ *, _float_ *, _float_ *);
extern void xlog_(_float_ *, _float_ *, _float_ *, _float_ *);
extern void ylog_(_float_ *, _float_ *, _float_ *, _float_ *);

