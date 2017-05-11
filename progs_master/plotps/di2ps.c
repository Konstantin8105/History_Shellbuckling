/*
di2ps.c is a library of selected Disspla functions which instead of
producing a Disspop metafile, produces a PostScript file to stdout 
which can be written to any suitably equipped output device.

The data structures and constants are defined in di2ps.h.

Some of the DISSPLA functions contain only interface declarations and
are waiting for a body.  Others do nothing because they operate on a
CRT terminal (usually Tektronix), and this library concerns itself
only with producing PostScript output.  This library can easily be
expanded to include more DISSPLA functions.  However, any expansion
must be done inside this file (or an include file) since certain static
variables are declared which are local only to functions declared in
this file.

The DISSPLA functions contained in this library are:

   void angle_(ang)
   _float_ *ang;

   void area2d_(xaxis, yaxis)
   _float_ *xaxis, *yaxis;

   void blowup_(xyfac);
   _float_ *xyfac;

   void bshift_(xadd, yadd)
   _float_ *xadd, *yadd;

   void chndot_()

   void chndsh_()

   void comprs_()

   void connpt_(xto, yto)
   _float_ *xto, *yto;

   void curve_(x, y, number, mark)
   _float_ *x, *y;
   _int_ *number, *mark;

   void dash_()

   void delleg_(entry)
   _int_ *entry;

   void donepl_()

   void dot_()

   void endpl_(plotno)
   _int_ *plotno;

   void erase_() --- does nothing, intended for CRT display

   void graf_(xmin, xstp, xmax, ymin, ystp, ymax)
   _float_ *xmin, *xstp, *xmax, *ymin, *ystp, *ymax;

   void grid_(xgrid, ygrid)
   _int_ *xgrid, *ygrid;

   void height_(hite) --- no body
   _float_ *hite;

   void legend_(pkray, nlines, x, y, lpkray)
   char *pkray;
   _int_ *nlines;
   _float_ *x, *y;
   _int_ lpkray;

   void line_() -- Sets line style to solid and width to one.

   void lines_(strng, idry_r, iline, lstrng, lidry_r)
   char *strng, *idry_r;
   _int_ *iline, lstrng, lidry_r;

   _int_ linest_(pkray, nwords, maxchar, lpkray)
   char *pkray;
   _int_ *nwords, *maxchar, lpkray;

   void loglog_(xorig, xcycle, yorig, ycycle)  --- no body
   _float_ *xorig, *xcycle, *yorig, *ycycle;

   void marker_(sym)
   _int_ *sym;

   void messag_(str, lstr, x, y, llstr)
   char *str;
   _int_ *lstr;
   _float_ *x, *y;
   _int_ llstr;

   void mylegn_(str, lstr, llstr)
   char *str;
   _int_ *lstr, llstr;

   void newclr_(color, lcolor)
   char *color;
   _int_ *lcolor;

   void nobrdr_()

   void page_(pagex, pagey)
   _float_ *pagex, *pagey;

   void reset_(mode, lmode)
   char *mode;
   _int_ lmode;

   void setdev_(err, summ)
   _int_ *err, *summ;

   void strtpt_(xto, yto)
   _float_ *xto, *yto;

   void tekall_()

   void title_(title, ltitle, xname, lxname, yname, lyname, xdim, ydim)
   char *title, *xname, *yname;
   _int_ *ltitle, *lxname, *lyname;
   _float_ *xdim, *ydim;

   void tk41_()  --- does nothing

   void vector_(xfrom, yfrom, xto, yto, vec)
   _float_ *xfrom, *yfrom, *xto, *yto;
   _int_ *vec;

   void xlegnd_(ret_value, idleg, nlines, lidleg) - The DISSPLA routine
   _float_ *ret_value;                             is really a function
   char *idleg;                that returns a _float_, but because of
   _int_ *nlines, lidleg;       the inconsistent way various C compilers
			       return floating-point values to a
			       calling FORTRAN program, I thought it
			       best to pass the return value through
			       the parameter list.  So the upshot is
			       that this routine is NOT directly
			       compatible with the equivalent DISSPLA
                               function.

   void ylegnd_(ret_value, idleg, nlines, lidleg) - See note above.
   _float_ *ret_value;
   char *idleg;
   _int_ *nlines, lidleg;

   void xlog_(xorig, xcycle, yorig, ystep) - no body
   _float_ *xorig, *xcycle, *yorig, *ystep;

   void ylog_(xorig, xstep, yorig, ycycle) - no body
   _float_ *xorig, *xstep, *yorig, *ycycle;
*/

#define DEBUG 0

#if (_cray_)
#include <netdb.h>
#endif

#if (_cray_ || _sol_ || _hp700_)
#define random rand
#endif

#include <stdio.h>

#include <string.h>

#include <stdlib.h>

#include <ctype.h>
#include <time.h>
#include <pwd.h>
#include <math.h>

#include <unistd.h>

#include "names.h"
#include "paramlength.h"
#include "util.h"
#include "di2ps.h"

/*
Declarations follow:
*/
static FILE *fp;
static struct old_legend_type legnd;
static struct legend_type leg;
static struct origin_type o;
static struct plotframe_type plot;
static struct bb_type bb;
static struct color_type color;  /* current color for drawing traces and
                                    markers. */
static _int_ markr = 0, level = 0, pointset = 0, pg = 1, eps = 0;
static _float_ mess_angle = 0.0, fontscale = 1.0, markerscale = 1.0;

/*
Include all di2ps function bodies:
*/

#include "axes.cseg"
#include "colors.cseg"
#include "curves.cseg"
#include "dutils.cseg"
#include "ndutils.cseg"
#include "legends.cseg"

