/*
 * Globally accessible information from xgraph
 */

/* --------------------------- */
/* originaly from ( xgraph.h ) */
/* --------------------------- */

/* Globally accessible values */

extern Display    *disp;	/* Open display            */
extern Visual     *vis;		/* Standard visual         */
extern Colormap    cmap;	/* Standard colormap       */
extern int         screen;	/* Screen number           */
extern int         depth;	/* Depth of screen         */

extern int         DEBUG;

extern unsigned long xtb_fg;    /* tool box foreground color */
extern unsigned long xtb_bg;    /* tool box background color */
extern unsigned long xtb_bd;    /* tool box   border   color */

extern NewDataSet  PlotData[MAXSETS];
extern NewDataSet  DataD1[MAXSETS];
extern NewDataSet  DataD2[MAXSETS];

extern XSegment   *Xsegs[2];		 /* Point space for X */
extern double      llx, lly, urx, ury;	 /* Bounding box of all data */
extern int         numFiles;		 /* Number of input files   */
extern char       *inFileNames[MAXSETS]; /* File names              */

/* Total number of active windows */

extern Window      main_window;
extern int         Num_Windows;
extern char       *Prog_Name;
extern char       *disp_name;

/* To make lint happy */

extern void       *Malloc();
extern void       *Realloc();
extern void        Free();

#ifndef _POSIX_SOURCE
extern void        exit();
extern double      atof();
extern void        abort();
#endif /* _POSIX_SOURCE */

/* --------------------------------- */
/* originaly from ( hard_devices.h ) */
/* --------------------------------- */

extern int       hard_count;
extern hard_dev  hard_devices[];
extern char     *hd_name_extn[];

/* --------------------------------- */
/* originaly from ( hard_devices.c ) */
/* --------------------------------- */

extern char     *getenv();

/* --------------------------- */
/* originaly from ( params.h ) */
/* --------------------------- */

/* Some parameter variables */

extern params      param_temp;
extern params     *param_temp_ptr;
extern XColor      param_null_color;
extern param_style param_null_style;

/* these macro definitions are REQUIRED here  */
/* since they depend upon the above variables */

#define PM_INT(name)	\
((param_temp_ptr = param_get(name, &param_temp)) ? \
 param_temp_ptr->intv.value : \
 (abort(), (int) 0))

#define PM_STR(name)	\
((param_temp_ptr = param_get(name, &param_temp)) ? \
 param_temp_ptr->strv.value : \
 (abort(), (char *) 0))

#define PM_COLOR(name)	\
((param_temp_ptr = param_get(name, &param_temp)) ? \
 param_temp_ptr->pixv.value : \
 (abort(), param_null_color))

#define PM_PIXEL(name)	\
((param_temp_ptr = param_get(name, &param_temp)) ? \
 param_temp_ptr->pixv.value.pixel : \
 (abort(), (Pixel) 0))

#define PM_FONT(name)	\
((param_temp_ptr = param_get(name, &param_temp)) ? \
 param_temp_ptr->fontv.value : \
 (abort(), (XFontStruct *) 0))

#define PM_STYLE(name)	\
((param_temp_ptr = param_get(name, &param_temp)) ? \
 param_temp_ptr->stylev : \
 (abort(), param_null_style))

#define PM_BOOL(name)	\
((param_temp_ptr = param_get(name, &param_temp)) ? \
 param_temp_ptr->boolv.value : \
 (abort(), 0))

#define PM_DBL(name)	\
((param_temp_ptr = param_get(name, &param_temp)) ? \
 param_temp_ptr->dblv.value : \
 (abort(), 0.0))

/* ----------------------- */
/* originaly from ( st.h ) */
/* ----------------------- */

extern char  st_pkg_name[];

