/*
di2ps.h contains all of the data structures and static variables
used for the di2ps library.
*/

/* dash definitions */
#define DASHLEN 7
#define LDASHLEN 9
#define SDASHLEN 5
#define DOTLEN 1
#define SPCLEN 1
#define PIXEL 1

/* font definitions */

#define Courier "Courier"
#define Times "Times-Roman"
#define TimesBold "Times-Bold"
#define Helvetica "Helvetica"

#define AxisNumFont Helvetica
#define AxisLabelFont Helvetica
#define AxisExpFont Helvetica
#define MessFont Helvetica
#define TitleFont TimesBold
#define LegendFont Helvetica

#define AxisNumFSize 12.0
#define AxisLabelFSize 15.0
#define AxisExpFSize 10.0
#define MessFSize 12.0
#define TitleFSize 15.0
#define LegendFSize 10.0

#define AxisNumFcpi 13.3
#define AxisLabelFcpi 10.64
#define AxisExpFcpi 15.96
#define MessFcpi 13.3
#define TitleFcpi 11.1
#define LegendFcpi 15.96

#define AxisNumFcpiSD 0.68
#define AxisLabelFcpiSD 0.54
#define AxisExpFcpiSD 0.81
#define MessFcpiSD 0.68
#define TitleFcpiSD 0.42
#define LegendFcpiSD 0.81

#define AxisNumFlpi 5.41
#define AxisLabelFlpi 4.33
#define AxisExpFlpi 6.50
#define MessFlpi 5.41
#define TitleFlpi 4.5
#define LegendFlpi 6.50

/* marker definitions */
#define ButtCap 0            /* line cap is butted */
#define RoundCap 1           /* line cap is rounded */
#define SquareCap 2          /* line cap is projecting square cap */
#define MiterJoin 0          /* line joints are mitered */
#define RoundJoin 1          /* line joints are rounded */
#define BevelJoin 2          /* line joints are beveled */
#define MarkLineThick 0.33   /* marker line thickness in pixels */
#define DefaultMarker 0

/* misc. definitions */
#define MaxLeg 19         /* maximum number of legends */
#define MaxLineLength 256 /* maximum number of characters in a line of text */
#define DefPlotDim 6.5           /* inches */
#define DefPageWidth 8.5         /* inches */
#define DefPageHeight 11.0       /* inches */
#define TickLength 0.1           /* inches */
#define TickLineThickness 0.1    /* pixels */
#define BoxLineWidth 1.7         /* pixels */
#define MarkerDia 6.0            /* pixels */
#define TraceLineWidth 1.0       /* pixels, default value */
#define DPI 72.0             /* dots per inch */
#define CPW 4                /* charaters/bytes per word */
#define MaxPath 1000       /* maximum number of pending moves in a path */
#define TempPostScriptFile "/tmp/di2ps_out"
#define FATAL 1

#ifndef DATELEN
#define DATELEN 27
#endif

#ifndef MAXHOSTNAMELEN
#define MAXHOSTNAMELEN 65
#endif

#ifndef _int_
#include "paramlength.h"
#endif

enum linestyle_type {LINE, DASH, DOT, CHNDSH, CHNDOT};

struct old_legend_type {
   _int_ drawit[MaxLeg],
        eopkray,
        numleg; /* number of legends total */
   char heading[MaxLineLength];
};

struct legend_type {
  _int_ marker[MaxLeg];
  _float_ lineThick[MaxLeg];
  enum linestyle_type lineStyle[MaxLeg];
  char color[MaxLeg][5];
  char text[MaxLeg][MaxLineLength];
  _int_ lines;
  char heading[MaxLineLength];
};

/* in inches relative to the lower-left corner of the paper.  struct
origin_type is never scaled.  i.e. If the plot is translated and scaled,
o.x and o.y will always be in original units before scaling.
*/
struct origin_type {
   _float_ x, y;
};

struct plotframe_type {
   char title[MaxLineLength],
        xname[MaxLineLength],
        yname[MaxLineLength],
        color[MaxLeg][5];

   enum linestyle_type lineStyle[MaxLeg];

   /* Units are in inches for xlen, ylen, pwidth, pheight.
      and in plot units for xmin, xmax, ymin, ymax, xstp, ystp. */
   _float_ xlen, ylen,
         xmin, xmax, xstp,
         ymin, ymax, ystp,
         pwidth, pheight, sf;

   /* xtick, ytick, border, color, customleg, and marker[i] are booleans*/
   _int_ xtick,
        ytick,
        border,
        customleg,
        marker[MaxLeg];

   /* Units for linethick are in dots. */
   _float_ linethick;
};

struct color_type {
   _float_ hue, saturation, intensity;
};

/* Units are in inches. */
struct bb_type {
   _float_ left, bottom, right, top;
};

/* Define type for graph axis numerals. */
enum axis_num_type {INTEGER, FLOAT, SCALEFLOAT};

/*
  Declare all di2ps functions:
*/

#include "axes.h"
#include "colors.h"
#include "curves.h"
#include "dutils.h"
#include "legends.h"
#include "ndutils.h"

