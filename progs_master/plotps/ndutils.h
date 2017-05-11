/*
  ndutils.h

  Declare all functions in ndutils.c.
*/

#ifndef _int_
#include "paramlength.h"
#endif

extern void cleanup(_int_);
extern void define_aliases(void);
extern void define_fonts(void);
extern void define_markers(void);
extern void derror(char *, _int_);
extern char *escapeParens(char *);
extern enum axis_num_type getAxisNumStyle(_float_, _float_, _float_);
extern void initstruct(void);
extern void markeradd_(void);
extern void markersub_(void);
extern void open_ps_out(char *);
extern void ps2eps(char *);
extern _float_ scaleaxis(_float_, _float_);
extern void scalefont(_float_);
extern void scale_line(_float_);
extern void scalemarker(_float_);
extern void zerorg(void);
