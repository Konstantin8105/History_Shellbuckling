/*
   names.h contains macros that convert all FORTRAN-callable function names
   in the di2ps.c library to the format appropriate for that machine.
*/

/*
#if (_cray_)
*/
#if (FALSE)

#define angle_	ANGLE
#define area2d_	AREA2D
#define blowup_	BLOWUP
#define bshift_	BSHIFT
#define chndot_	CHNDOT
#define chndsh_	CHNDSH
#define comprs_	COMPRS
#define connpt_	CONNPT
#define curve_	CURVE
#define dash_	DASH
#define delleg_	DELLEG
#define donepl_	DONEPL
#define dot_	DOT
#define endpl_	ENDPL
#define erase_	ERASE
#define graf_	GRAF
#define grid_	GRID
#define height_	HEIGHT
#define legend_	LEGEND
#define line_   LINE
#define lines_	LINES
#define linest_	LINEST
#define loglog_	LOGLOG
#define marker_	MARKER
#define markersub_	MARKERSUB
#define messag_	MESSAG
#define mylegn_	MYLEGN
#define newclr_	NEWCLR
#define nobrdr_	NOBRDR
#define page_	PAGE
#define reset_	RESET
#define setdev_	SETDEV
#define strtpt_	STRTPT
#define tekall_ TEKALL
#define title_	TITLE
#define tk41_	TK41
#define vector_	VECTOR
#define xlegnd_	XLEGND
#define ylegnd_	YLEGND
#define xlog_	XLOG
#define ylog_	YLOG

#else
#if (_rs6k_ || _hp700_)

#define angle_	angle
#define area2d_	area2d
#define blowup_	blowup
#define bshift_	bshift
#define chndot_	chndot
#define chndsh_	chndsh
#define comprs_	comprs
#define connpt_	connpt
#define curve_	curve
#define dash_	dash
#define delleg_	delleg
#define donepl_	donepl
#define dot_	dot
#define endpl_	endpl
#define erase_	erase
#define graf_	graf
#define grid_	grid
#define height_	height
#define legend_	legend
#define line_   line
#define lines_	lines
#define linest_	linest
#define loglog_	loglog
#define marker_	marker
#define markersub_	markersub
#define messag_	messag
#define mylegn_	mylegn
#define newclr_	newclr
#define nobrdr_	nobrdr
#define page_	page
#define reset_	reset
#define setdev_	setdev
#define strtpt_	strtpt
#define tekall_ tekall
#define title_	title
#define tk41_	tk41
#define vector_	vector
#define xlegnd_	xlegnd
#define ylegnd_	ylegnd
#define xlog_	xlog
#define ylog_	ylog

#endif
#endif
