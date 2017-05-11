
#include "aparms.h"

/*
 * Postscript output for xgraph
 *
 * Rick Spickelmier
 * David Harrison
 *
 * modified by Dr. Frank C. Weiler
 *
 */

/*
 * Basic scaling parameters
 */

//#define VDPI			1341.12  // ( 48 * 27.94   =  48 * 11.0 * 2.54 )
#define VDPI			1200.0
//#define VDPI			1224.0
#define WDIM			8.5
#define HDIM			11.0
#define MICRONS         	1.00E+04
#define MICRONS_PER_INCH	2.54E+04
#define POINTS_PER_INCH		72.0
#define INCHES_PER_POINT	1.0/72.0
#define MICRON_POINTS	        MICRONS_PER_INCH * POINTS_PER_INCH
#define POINTS_PER_MICRON	POINTS_PER_INCH / MICRONS_PER_INCH
#define MICRONS_PER_POINT	MICRONS_PER_INCH * INCHES_PER_POINT

/*
 * Aesthetic parameters (inches)
 */

#define PS_BDR_PAD		0.075
#define PS_AXIS_PAD		0.175
#define PS_LEG_PAD		0.025
//#define PS_TICK_LEN		0.125
#define PS_TICK_LEN		0.080
#define BASE_DASH		(1.0/48.0)

#define BASE_WIDTH		(1.0/8.0)
#define PS_AXIS_WBASE		1
#define PS_ZERO_WBASE		4
#define PS_DATA_WBASE		7
#define PS_PIXEL		4
#define PS_DOT			12
#define PS_MARK			12

/*
 * Other constants
 */

#define FONT_WIDTH_EST		0.55
#define PS_MAX_SEGS		1000
#define PS_NO_TSTYLE		-1
#define PS_NO_DSTYLE		-1
#define PS_NO_WIDTH		-1
#define PS_NO_LSTYLE		-1
#define PS_NO_COLOR		-1

/*
 * Working macros
 */

#define OUT		(void) fprintf
#define PS(str)		OUT(psFile, str)
#define PSU(str)	OUT(ui->psFile, str)
#define IY(val)		(ui->height_devs - val)

#define TEXTCOLOR	0
#define MAXCOLOR	8	/* Number of gray scales supported */

/*
 * Globals
 */

static double PS_scale;		/* devs/micron */
static int    PS_area_w;
static int    PS_area_h;



/********/
/*  rd  */
/********/

int  rd( double dbl ) 

/* Short and sweet rounding function */
{
    if (dbl < 0.0) {
	return ((int) (dbl - 0.5));
    }
    else {
	return ((int) (dbl + 0.5));
    }
}


/************/
/*  psInit  */
/************/

int  psInit( FILE   *psFile             ,  /* Output file            */
             int     width              ,  /* In microns             */
             int     height             ,  /* In microns             */
             char   *tf                 ,  /* Title font name        */
             double  ts                 ,  /* Title font size        */
             char   *af                 ,  /* Axis  font name        */
             double  as                 ,  /* Axis  font size        */
             int     flags              ,  /* Control flags          */
             xg_out *outInfo            ,  /* Returned device info   */
             char    errmsg[ERRBUFSIZE] )  /* Returned error message */

/*
 * The basic coordinate system is points (roughly 1/72 inch).
 * However,  most laser printers can do much better than that.
 * We invent a coordinate system based on VDPI dots per inch.
 * This goes along the long side of the page.  The long side
 * of the page is HDIM inches in length,  the short side
 * WDIM inches in length.  We we call this unit a `dev'.
 * We map `width' and `height' into devs.
 */
{
    userInfo *ui;
    int       keep_aspect,
              fit_to_page,
              hav_margins;
    double    font_size;
    double    inch_w, inch_h;
    double    pnts_w, pnts_h;
    double    area_ratio;

    static int debug  = 0;

    /* begin */

    PS_area_w  =  outInfo->area_w;
    PS_area_h  =  outInfo->area_h;
    area_ratio =  (double)outInfo->area_w / (double)outInfo->area_h;

    if (debug) {
      printf("\n");
      printf("psInit():  on entry\n");
      printf("-------------------\n");
      printf("width,     height    = %13d %13d  cm-microns\n", width, height);
      printf("width,     height    = %13.5e %13.5e  inches\n", (double)width  / MICRONS_PER_INCH,
                                                               (double)height / MICRONS_PER_INCH);
      printf("area_w,    area_h    = %13d %13d\n", outInfo->area_w, outInfo->area_h);
      printf("area_ratio           = %13.5e\n", area_ratio);
      printf("-------------------\n");
   }

    ui = (userInfo *) Malloc(sizeof(userInfo));
    ui->psFile           = psFile;
    ui->currentTextStyle = PS_NO_TSTYLE;
    ui->currentDashStyle = PS_NO_DSTYLE;
    ui->currentWidth     = PS_NO_WIDTH;
    ui->currentLStyle    = PS_NO_LSTYLE;
    ui->currentColor     = PS_NO_COLOR;
    ui->title_family     = tf;
    ui->title_size       = ts;
    ui->axis_family      = af;
    ui->axis_size        = as;
    /* Roughly,  one-eighth a point in devs */
    ui->baseWidth        = rd(VDPI / POINTS_PER_INCH * BASE_WIDTH);
    ui->flags            = flags;

    inch_w               = (double)width  / (double)MICRONS_PER_INCH; // (  8.5 )
    inch_h               = (double)height / (double)MICRONS_PER_INCH; // ( 11.0 )

    pnts_w               = inch_w * 72.0;  // width  in points ( 612 )
    pnts_h               = inch_h * 72.0;  // height in points ( 792 )

    PS_scale             = VDPI / MICRONS_PER_INCH;


    keep_aspect          = flags & D_ASP;
    fit_to_page          = flags & D_FTP;

    if (!(keep_aspect & fit_to_page)) {
      fit_to_page        = 1;         // default if nothing specified
    }

    if (keep_aspect) {
      if (area_ratio > 1.0) { //plot rotated 90 degrees
        outInfo->area_w  = rd(((double) width) * PS_scale);
        outInfo->area_h  = rd(((double) width) * PS_scale / area_ratio);
      }
      else {                  //plot NOT rotated
        outInfo->area_w  = rd(((double) height) * PS_scale * area_ratio);
        outInfo->area_h  = rd(((double) height) * PS_scale);
      }
    }
    else {  // Fit To Page option
        outInfo->area_w  = rd(((double) width)  * PS_scale);
        outInfo->area_h  = rd(((double) height) * PS_scale);
    }

    outInfo->dev_flags   = flags;

    /* setup the device margins */

    hav_margins          = PM_BOOL("HD_Margins");

    if (hav_margins) {
      outInfo->margin_l  = PM_DBL("PS_Margin_L") * VDPI;
      outInfo->margin_r  = PM_DBL("PS_Margin_R") * VDPI;
      outInfo->margin_t  = PM_DBL("PS_Margin_T") * VDPI;
      outInfo->margin_b  = PM_DBL("PS_Margin_B") * VDPI;
    }
    else {
      outInfo->margin_l  = 0.0;
      outInfo->margin_r  = 0.0;
      outInfo->margin_t  = 0.0;
      outInfo->margin_b  = 0.0;
    }

    if (debug) {
      printf("\n");
      printf("PS_scale             = %13.5e\n", PS_scale);
      printf("\n");
      printf("area_w,    area_h    = %13d %13d\n", outInfo->area_w,   outInfo->area_h);
    }

    ui->height_devs       = outInfo->area_h;

    outInfo->bdr_pad      = rd(PS_BDR_PAD  * VDPI);
    outInfo->axis_pad     = rd(PS_AXIS_PAD * VDPI);
    outInfo->legend_pad   = rd(PS_LEG_PAD  * VDPI);
    outInfo->tick_len     = rd(PS_TICK_LEN * VDPI);

    /* Font estimates */

    font_size             = as * INCHES_PER_POINT * VDPI;
    outInfo->axis_height  = rd(font_size);
    outInfo->axis_width   = rd(font_size * FONT_WIDTH_EST);

    font_size             = ts * INCHES_PER_POINT * VDPI;
    outInfo->title_height = rd(font_size);
    outInfo->title_width  = rd(font_size * FONT_WIDTH_EST);

    outInfo->max_segs     = PS_MAX_SEGS;

    /* Postscript Drawing Routines */

    outInfo->xg_text      = psText;
    outInfo->xg_seg       = psSeg;
    outInfo->xg_dot       = psDot;
    outInfo->xg_end       = psEnd;

    /* save pointer to user state in outInfo */

    outInfo->user_state   = (char *)ui;

    /* Postscript file identification */

    PS("%%!\n");

    /* some debug information */

    if (debug) {
      printf("\n");
      printf("LLX,       LLY       = %13d %13d\n", 0, 0);
      printf("URX,       URY       = %13d %13d\n", outInfo->area_w, outInfo->area_h);
      printf("BBW,       BBH       = %13d %13d\n", (int)(((double)width)  / MICRON_POINTS + 0.5),
                                                   (int)(((double)height) / MICRON_POINTS + 0.5));
      printf("\n");
      printf("pnts_w,    pnts_h    = %13.5e %13.5e\n", pnts_w, pnts_h);
      printf("\n");
      printf("scale_factor         = %13.5e\n", POINTS_PER_INCH / VDPI);
    }

    /* Definitions */

    psScale(psFile, width, height, outInfo);

    psFonts(psFile);

    psMarks(psFile);

    PS("%%\n");
    PS("%% Main body begins here\n");
    PS("%%\n");

    return 1;
}



/**************/
/*  psHeader  */
/**************/

void  psHeader( FILE *psFile   , 
                int  docu_flag ) 

/*
 * Prints out a standard greeting to the Postscript file.
 */
{
  //PS("%%%%EndComments\n");
  //rm PS("%%\n");
    PS("%% Xgraph postscript output\n");
    PS("%% Rick Spickelmier and David Harrison\n");
    PS("%% University of California, Berkeley\n");
    PS("%% \n");
    PS("%% modified by Dr. Frank C. Weiler\n");
    PS("%% retired - Lockheed Martin Missiles & Space Co.\n");
    if (docu_flag) {
	PS("%%\n");
	PS("%% Output produced for inclusion in another document.\n");
	PS("%% This file will not work properly if sent directly to a printer.\n");
    }
    PS("%%\n");
}



/*************/
/*  psScale  */
/*************/

void  psScale( FILE   *psFile  ,  /* Output stream      */
               int     width   ,  /* Output width       */
               int     height  ,  /* Output height      */
               xg_out *outInfo )  /* Output device info */

/*
 * This routine figures out how transform the basic postscript
 * transformation into one suitable for direct use by
 * the drawing primitives.  Two variables X-CENTER-PLOT
 * and Y-CENTER-PLOT determine whether the plot is centered
 * on the page.  If `flags' has D_DOCU set,  then the plot
 * will not be rotated or centered and a bounding box will
 * be displayed.
 */
{
    int     incl_in_doc;
    int     fit_to_page;
    int     keep_aspect;

    double  area_ratio;
    double  factor;
    double  plt_width, plt_height;
    double  pag_width, pag_height;
    int     area_w,    area_h;
 
    static int debug = 0;

    /* begin */

    incl_in_doc = outInfo->dev_flags & D_DOCU;
    fit_to_page = outInfo->dev_flags & D_FTP;
    keep_aspect = outInfo->dev_flags & D_ASP;

    area_ratio  = (double)PS_area_w / (double)PS_area_h;

    /*
     * Scaling.  We have points.  We want devs = Virtual Dots Per Inch.
     */

    factor     = POINTS_PER_INCH / VDPI;

    plt_width  = WDIM * VDPI;
    plt_height = HDIM * VDPI;

    pag_width  = (double)width  * POINTS_PER_MICRON;
    pag_height = (double)height * POINTS_PER_MICRON;

    /* adjust area_w/area_h to fit page */

    if (keep_aspect) {
      if (area_ratio > 1.0) { //plot rotated 90 degrees
        area_w  = rd(pag_width);
        area_h  = rd(pag_width / area_ratio);
      }
      else {                  //plot NOT rotated
        area_w  = rd(pag_height * area_ratio);
        area_h  = rd(pag_height);
      }
    }
    else {  // Fit To Page option
        area_w  = rd(pag_width);
        area_h  = rd(pag_height);
    }

    if (debug) {
      printf("\n");
      printf("psScale():\n");
      printf("----------\n");
      printf("incl_in_doc          = %c\n", TorF(incl_in_doc));
      printf("fit_to_page          = %c\n", TorF(fit_to_page));
      printf("keep_aspect          = %c\n", TorF(keep_aspect));
      printf("\n");
      printf("plt_width, plt_heigh = %13.5e %13.5e\n", plt_width, plt_height);
      printf("pag_width, pag_heigh = %13.5e %13.5e\n", pag_width, pag_height);
      printf("area_wo,   area_ho   = %13d %13d\n",     PS_area_w, PS_area_h);
      printf("area_w,    area_h    = %13d %13d\n",     area_w,    area_h);
    }

    /*
     * Document or regular
     */

    if (incl_in_doc) {

        OUT(psFile, "%%%%BoundingBox: %ld %ld %ld %ld\n", 0, 0, (int)pag_width, (int)pag_height);
        PS("%%%%EndComments\n");
        PS("%%\n");

	psHeader(psFile, 1);

	PS("%% Rotation and centering are turned off for inclusion in a document\n");

    }
    else {

	psHeader(psFile, 0);

	PS("%% Scaling information\n");
	PS("%%\n");
	PS("%% Change these if you would like to change the\n");
	PS("%% centering of the plot in either dimension\n");
	PS("/X-CENTER-PLOT 1 def\n");
	PS("/Y-CENTER-PLOT 1 def\n");

	/*
	 * Determine page size
	 */

        PS("%% Set the initial scale factors\n");
        OUT(psFile, "/x-factor %lg def\n", factor);
        OUT(psFile, "/y-factor %lg def\n", factor);
	PS("%% plot size in (cm)\n");
        OUT(psFile, "/plot-width  %lg x-factor mul def\n", plt_width);
        OUT(psFile, "/plot-height %lg y-factor mul def\n", plt_height);
        PS("/plot-ratio  plot-width plot-height div def\n");
        PS("%% page size in (cm)\n");
        OUT(psFile, "/page-width  %lg def\n", pag_width);
        OUT(psFile, "/page-height %lg def\n", pag_height);
        PS("/page-ratio  page-width page-height div def\n");
        PS("%% original drawing area\n");
        OUT(psFile, "/area-width  %d def\n", area_w);
        OUT(psFile, "/area-height %d def\n", area_h);
        PS("/area-ratio area-width  area-height div def\n");
        PS("%%\n");

	/*
	 * Perform rotation if (width) > (height)
	 */

	PS("%% Determine whether rotation is required\n");
        PS("%% --------------------------------------\n");
	PS("area-width area-height gt\n");
	PS("{ %% Rotation required\n");
	PS("   90 rotate\n");
	PS("   0 plot-width neg translate\n");
	PS("   %% Handle centering\n");
	PS("   Y-CENTER-PLOT 1 eq { %% Center in y\n");

        if (keep_aspect)
	PS("      0\n");
        else
	PS("      plot-height page-width sub 2 div\n");

	PS("   } { %% Don't center in y\n");
	PS("      0\n");
	PS("   } ifelse\n");
	PS("   X-CENTER-PLOT 1 eq { %% Center in x\n");

        if (keep_aspect)
	PS("      plot-width area-height sub 2 div\n");
        else
	PS("      plot-width page-height sub 2 div\n");

	PS("   } { %% Don't center in x\n");
	PS("      0\n");
	PS("   } ifelse\n");
	PS("   translate\n");
	PS("} { %% No rotation - just handle centering\n");
	PS("   X-CENTER-PLOT 1 eq { %% Center in x\n");


        if (keep_aspect)
	PS("      plot-width area-width sub 2 div\n");
        else
	PS("      plot-width page-width sub 2 div\n");

	PS("   } { %% Don't center in x\n");
	PS("      0\n");
	PS("   } ifelse\n");
	PS("   Y-CENTER-PLOT 1 eq { %% Center in y\n");

        if (keep_aspect)
	PS("      0\n");
        else
	PS("      plot-height page-height sub 2 div\n");

        PS("   } { %% Don't center in y\n");
	PS("      0\n");
	PS("   } ifelse\n");
	PS("   translate\n");
	PS("} ifelse\n");

	/*
	 * Set the scale factor
	 */
  
        PS("%% Set the scale\n");
        PS("%% -------------\n");
        PS("x-factor y-factor scale\n");

    }
}




/*************/
/*  psFonts  */
/*************/

void  psFonts( FILE *psFile )  /* Output stream                */

/*
 * Downloads code for drawing title and axis labels
 */
{
    PS("%% Font Handling Functions\n");
    PS("%%\n");
    PS("%% Function giving y-offset to center of font\n");
    PS("%% Assumes font is set and uses numbers to gauge center\n");
    PS("%%\n");
    PS("/choose-font	%% stack: fontsize fontname => ---\n");
    PS("{\n");
    PS("   findfont \n");
    PS("   exch scalefont \n");
    PS("   setfont\n");
    PS("   newpath\n");
    PS("   0 0 moveto (0) true charpath flattenpath pathbbox\n");
    PS("   /top exch def pop\n");
    PS("   /bottom exch def pop\n");
    PS("   bottom top bottom top add 2 div\n");
    PS("   /center-font-val exch def \n");
    PS("   /upper-font-val exch def \n");
    PS("   /lower-font-val exch def\n");
    PS("} def\n");
    PS("%%\n");
    PS("%% Justfication offset routines\n");
    PS("%%\n");
    PS("/center-x-just	%% stack: (string) x y => (string) newx y\n");
    PS("{\n");
    PS("   exch 2 index stringwidth pop 2 div sub exch\n");
    PS("} def\n");
    PS("%%\n");
    PS("/left-x-just	%% stack: (string) x y => (string) newx y\n");
    PS("{ \n");
    PS("} def\n");
    PS("%%\n");
    PS("/right-x-just	%% stack: (string) x y => (string) newx y\n");
    PS("{\n");
    PS("   exch 2 index stringwidth pop sub exch\n");
    PS("} def\n");
    PS("%%\n");
    PS("/center-y-just	%% stack: (string) x y => (string) x newy\n");
    PS("{\n");
    PS("   center-font-val sub\n");
    PS("} def\n");
    PS("%%\n");
    PS("/lower-y-just	%% stack: (string) x y => (string) x newy\n");
    PS("{\n");
    PS("   lower-font-val sub\n");
    PS("} def\n");
    PS("%%\n");
    PS("/upper-y-just	%% stack: (string) x y => (string) x newy\n");
    PS("{\n");
    PS("   upper-font-val sub\n");
    PS("} def\n");
    PS("%%\n");
    PS("%% Shows a string on the page subject to justification\n");
    PS("%%   \n");
    PS("/just-string	%% stack: (string) x y just => ---\n");
    PS("{\n");
    PS("   dup 0 eq { pop center-x-just center-y-just 		} if\n");
    PS("   dup 1 eq { pop left-x-just center-y-just		} if\n");
    PS("   dup 2 eq { pop left-x-just upper-y-just	 	} if\n");
    PS("   dup 3 eq { pop center-x-just upper-y-just 		} if\n");
    PS("   dup 4 eq { pop right-x-just upper-y-just	 	} if\n");
    PS("   dup 5 eq { pop right-x-just center-y-just 		} if\n");
    PS("   dup 6 eq { pop right-x-just lower-y-just	 	} if\n");
    PS("   dup 7 eq { pop center-x-just lower-y-just  		} if\n");
    PS("   dup 8 eq { pop left-x-just lower-y-just	 	} if\n");
    PS("   moveto show\n");
    PS("} def\n");
    PS("%%\n");
}



/*************/
/*  psMarks  */
/*************/

void  psMarks( FILE *psFile ) 

/*
 * Writes out marker definitions
 */
{
    PS("%% Marker definitions\n");
    PS("/mark0 {/size exch def /y exch def /x exch def\n");
    PS("newpath x size sub y size sub moveto\n");
    PS("size size add 0 rlineto 0 size size add rlineto\n");
    PS("0 size size add sub 0 rlineto closepath fill} def\n");

    PS("/mark1 {/size exch def /y exch def /x exch def\n");
    PS("newpath x size sub y size sub moveto\n");
    PS("size size add 0 rlineto 0 size size add rlineto\n");
    PS("0 size size add sub 0 rlineto closepath stroke} def\n");

    PS("/mark2 {/size exch def /y exch def /x exch def\n");
    PS("newpath x y moveto x y size 0 360 arc stroke} def\n");

    PS("/mark3 {/size exch def /y exch def /x exch def\n");
    PS("newpath x size sub y size sub moveto x size add y size add lineto\n");
    PS("x size sub y size add moveto x size add y size sub lineto stroke} def\n");

    PS("/mark4 {/size exch def /y exch def /x exch def\n");
    PS("newpath x size sub y moveto x y size add lineto\n");
    PS("x size add y lineto x y size sub lineto\n");
    PS("closepath stroke} def\n");

    PS("/mark5 {/size exch def /y exch def /x exch def\n");
    PS("x y size mark1\n");
    PS("newpath x size sub y moveto size size add 0 rlineto stroke} def\n");

    PS("/mark6 {/size exch def /y exch def /x exch def\n");
    PS("newpath x y moveto x y size 0 360 arc fill} def\n");

    PS("/mark7 {/size exch def /y exch def /x exch def\n");
    PS("newpath x y moveto x size sub y size sub lineto\n");
    PS("x size add y size sub lineto closepath fill\n");
    PS("newpath x y moveto x size add y size add lineto\n");
    PS("x size sub y size add lineto closepath fill} def\n");
}




/************/
/*  psText  */
/************/

void  psText( char *state ,  /* Really (userInfo *)  */
              int  x      ,  /* Text position (devs) */
              int  y      ,  /* Text position (devs) */
              char *text  ,  /* Text itself          */
              int  just   ,  /* Justification        */
              int  style  )  /* Style                */

/*
 * Draws text at the given location with the given justification
 * and style.
 */
{
    userInfo *ui = (userInfo *)state;

    if (TEXTCOLOR != ui->currentColor) {
	OUT(ui->psFile, "%lg setgray\n", (double) TEXTCOLOR / 8);
	ui->currentColor = TEXTCOLOR;
    }

    if (style != ui->currentTextStyle) {
	switch (style) {
	  case T_AXIS:
	    OUT(ui->psFile, "%lg /%s choose-font\n",
		ui->axis_size * INCHES_PER_POINT * VDPI, ui->axis_family);
	    break;
	  case T_TITLE:
	    OUT(ui->psFile, "%lg /%s choose-font\n",
		ui->title_size * INCHES_PER_POINT * VDPI, ui->title_family);
	    break;
	}
	ui->currentTextStyle = style;
    }
    OUT(ui->psFile, "(%s) %d %d %d just-string\n", text, x, IY(y), just);
}



/***********/
/*  psSeg  */
/***********/

void  psSeg( char     *state   ,  /* Really (userInfo *)        */
             int       ns      ,  /* Number of segments         */
             XSegment *seglist ,  /* X array of segments        */
             int       width   ,  /* Width of lines (devcoords) */
             int       style   ,  /* L_AXIS, L_ZERO, L_VAR      */
             int       lappr   ,  /* Zero to seven              */
             int       color   )  /* Zero to seven              */

/*
 * Draws a number of line segments.  Grid lines are drawn using
 * light lines.  Variable lines (L_VAR) are drawn wider.  This
 * version ignores the color argument.
 */
{
    userInfo *ui       = (userInfo *)state;
    int       newwidth = 0,
              i;

  //printf("psSeg(): style= %3d  ui->curStyle= %3d  width= %3d  ui->curWidth= %3d\n",
  //	   style, ui->currentLStyle, width, ui->currentWidth);

    if ((style != ui->currentLStyle) || (width != ui->currentWidth)) {
	switch (style) {
	  case L_AXIS:
	    newwidth = PS_AXIS_WBASE * ui->baseWidth;
	    PSU("[] 0 setdash\n");
	    break;
	  case L_ZERO:
	    newwidth = PS_ZERO_WBASE * ui->baseWidth;
	    PSU("[] 0 setdash\n");
	    break;
	  case L_VAR:
	    newwidth = PS_DATA_WBASE * ui->baseWidth;
	    break;
	}
      //ui->currentWidth  = MAX(newwidth, width);
	ui->currentWidth  = width;
	ui->currentLStyle = style;
	OUT(ui->psFile, "%d setlinewidth\n", ui->currentWidth);
    }

    if (width > 4) {
	if (color > MAXCOLOR)
	    color -= MAXCOLOR;
	else
	    lappr = 0;
    }
    else
	color = TEXTCOLOR;

    if ((lappr != ui->currentDashStyle) && (style == L_VAR)) {
	if (lappr == 0) {
	    PSU("[] 0 setdash\n");
	}
	else {
	    OUT(ui->psFile, "[%lg] 0 setdash\n",
		((double) lappr) * BASE_DASH * VDPI);
	}
	ui->currentDashStyle = lappr;
    }

    if ((color != ui->currentColor) && (style == L_VAR)) {
	OUT(ui->psFile, "%lg setgray\n", (double) color / MAXCOLOR);
	ui->currentColor = color;
    }

    PSU("newpath\n");
    OUT(ui->psFile, "  %d %d moveto\n", seglist[0].x1, IY(seglist[0].y1));
    OUT(ui->psFile, "  %d %d lineto\n", seglist[0].x2, IY(seglist[0].y2));

    for (i = 1; i < ns; i++) {
	if ((seglist[i].x1 != seglist[i - 1].x2) ||
	    (seglist[i].y1 != seglist[i - 1].y2)) {
	    OUT(ui->psFile, "  %d %d moveto\n", seglist[i].x1, IY(seglist[i].y1));
	}
	OUT(ui->psFile, "  %d %d lineto\n", seglist[i].x2, IY(seglist[i].y2));
    }

    PSU("stroke\n");
}



/***********/
/*  psDot  */
/***********/

void  psDot( char *state ,  /* state information */
             int   x     ,  /* coord of dot */
             int   y     ,  /* coord of dot */
             int   style ,  /* type of dot */
             int   type  ,  /* dot style variation */
             int   color )  /* color of dot */

/*
 * Prints out a dot at the given location
 */
{
    userInfo *ui = (userInfo *)state;

    if (ui->currentDashStyle != PS_NO_DSTYLE) {
	OUT(ui->psFile, "[] 0 setdash\n");
	ui->currentDashStyle = PS_NO_DSTYLE;
    }
    if (ui->currentWidth != PS_ZERO_WBASE * ui->baseWidth) {
	ui->currentWidth = PS_ZERO_WBASE * ui->baseWidth;
	OUT(ui->psFile, "%d setlinewidth\n", ui->currentWidth);
    }
    if (color > MAXCOLOR)
	color -= MAXCOLOR;
    if ((color != ui->currentColor)) {
	OUT(ui->psFile, "%lg setgray\n", (double) color / MAXCOLOR);
	ui->currentColor = color;
    }

    switch (style) {
    case P_PIXEL:
	OUT(ui->psFile, "newpath\n%d %d moveto\n%d %d %d 0 360 arc fill\n",
	    x, IY(y), x, IY(y), PS_PIXEL * ui->baseWidth);
	break;
    case P_DOT:
	OUT(ui->psFile, "newpath\n%d %d moveto\n%d %d %d 0 360 arc fill\n",
	    x, IY(y), x, IY(y), PS_DOT * ui->baseWidth);
	break;
    case P_MARK:
	OUT(ui->psFile, "%d %d %d mark%d\n",
	    x, IY(y), PS_MARK * ui->baseWidth, type);
	break;
    }
    return;
}


/***********/
/*  psEnd  */
/***********/

void  psEnd( char *state )  /* state information */
{
    userInfo *ui = (userInfo *)state;

    if (!(ui->flags & D_DOCU)) {
	PSU("showpage\n");
    }
    PSU("%% End of xgraph output\n");

}
