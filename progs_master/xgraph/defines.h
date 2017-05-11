/*
 * Globally accessible information from xgraph
 */

#define VERSION_STRING	"14.0  April 2011 "

#ifndef MAXKEYS
#define MAXKEYS		 50
#endif /* MAXKEYS */

#define MAXATTR 	  8
#define MAXSETS		112
#define MAXBUFSIZE 	120

#ifndef MAXLS
#define MAXLS		 50
#endif /* MAXLS */

#ifndef MAXCHBUF
#define MAXCHBUF       1024
#endif /* MAXCHBUF */

#ifndef MAX_BRANCH
#define MAX_BRANCH       50
#endif /* MAX_BRANCH */

#define HARDCOPY_IN_PROGRESS	0x01
#define ABOUT_BEING_SHOWN	0x02

/* Portability */

#ifndef MAXFLOAT
#if defined(FLT_MAX)
#define MAXFLOAT	FLT_MAX
#elif defined(HUGE)
#define MAXFLOAT	HUGE
#endif
#endif

#ifndef BIGINT
#if defined(INT_MAX)
#define BIGINT		INT_MAX
#elif defined(MAXINT)
#define BIGINT          MAXINT
#else
#define BIGINT          0xffffffff
#endif
#endif

#define GRIDPOWER 	10
#define INITSIZE 	128

#define CONTROL_D	'\004'
#define CONTROL_C	'\003'
#define TILDE		'~'

#define BTNPAD		1
#define BTNINTER	3

#define LOG_X           0x01
#define LOG_Y           0x02
#define STK             0x04
#define FITX            0x08
#define FITY            0x10

#define ZERO_THRES	1.0E-07

/* -------  */
/*  macros  */
/* -------  */

#define TorF(a)         ((a) ? 'T' : 'F')

#ifndef MAX
#define MAX(a,b)	((a) > (b) ? (a) : (b))
#endif

#ifndef MIN
#define MIN(a,b)	((a) < (b) ? (a) : (b))
#endif

#ifndef ABS
#define ABS(x)		((x) < 0 ? -(x) : (x))
#endif

#ifndef DUP
#define DUP(str)        strcpy((char *) Malloc((unsigned) (strlen(str)+1)), (str))
#endif /* DUP */

#ifndef STRDUP
#define STRDUP(str)	(strcpy(Malloc((unsigned)(strlen(str)+1)), (str)))
#endif /* STRDUP */

#define SCREENX(ws, userX) (((int) (((userX) - ws->Xbegin)/ws->XUnitsPerPixel) + 0.5) + ws->XOrgX)
#define SCREENY(ws, userY) (ws->XOppY - ((int) (((userY) - ws->Ybegin)/ws->YUnitsPerPixel + 0.5)))

#define nlog10(x)	(x == 0.0 ? 0.0 : log10(x) + 1.0e-15)

#define ISCOLOR		(wi->dev_info.dev_flags & D_COLOR)

#define PIXVALUE(set) 	((set) % MAXATTR)

#define LINESTYLE(set)  (ISCOLOR ?  ((set)/MAXATTR) : ((set) % MAXATTR))

#define MARKSTYLE(set)  (colorMark ? COLMARK(set) : BWMARK(set))

#define COLMARK(set)    ((set) / MAXATTR)

#define BWMARK(set)     ((set) % MAXATTR)

/* --------------------------------- */
/* originaly from ( hard_devices.h ) */
/* --------------------------------- */

#define MFNAME             25

#define D_HPGL              0
#define D_IDRAW             1
#define D_POSTSCRIPT        2
#define D_TGIF              3
#define D_XWINDOWS          4


/* ----------------------- */
/* originaly from ( st.h ) */
/* ----------------------- */

/* Fatal error codes */

#define ST_NO_MEM           0
#define ST_BAD_RET          1
#define ST_BAD_GEN          2

enum st_retval {
    ST_CONTINUE,
    ST_STOP,
    ST_DELETE
};

#define ST_DEFAULT_MAX_DENSITY       5
#define ST_DEFAULT_INIT_TABLE_SIZE  11
#define ST_DEFAULT_GROW_FACTOR     2.0
#define ST_DEFAULT_REORDER_FLAG      0

/* -------------------------- */
/* originaly from ( xgout.h ) */
/* -------------------------- */

/* Passed device option flags */

#define D_DOCU		0x01
#define D_FTP		0x02
#define D_ASP		0x04
#define D_MARG	        0x08

/* Returned device capability flags */

#define D_COLOR		0x01

/* Text justifications */

#define T_CENTER	0
#define T_LEFT		1
#define T_UPPERLEFT	2
#define T_TOP		3
#define T_UPPERRIGHT	4
#define T_RIGHT		5
#define T_LOWERRIGHT	6
#define T_BOTTOM	7
#define T_LOWERLEFT	8

/* Text styles */

#define T_AXIS		0
#define T_TITLE		1

/* Line Styles */

#define L_AXIS		0
#define L_ZERO		1
#define L_VAR		2

/* Marker Styles */

#define P_PIXEL		0
#define P_DOT		1
#define P_MARK		2

#define ERRBUFSIZE	2048
