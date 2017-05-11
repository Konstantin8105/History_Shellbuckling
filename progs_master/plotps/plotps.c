  /*
  plotps main program

  See documentation file, docs, for information.  
*/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#include <unistd.h>

#include "paramlength.h"
#include "names.h"
#include "util.h"
#include "di2ps.h"

#define FATAL 1
#define TicksPerAxis 10
#define DefLineThick 13
#define TempDataFile "/tmp/plotps_in"

#ifndef MAXFLOAT
#define MAXFLOAT 1.0e37
#endif

enum orientation_type {PORTRAIT = 1, LANDSCAPE = -1};
enum ppsLinestyle_type {NONE, DOTTED, DASHED, CONTINUOUS};

struct state_type {
  _int_ autocolor,
        border,
        customleg,
        eps,
        mark,
        samescale,
        currMarker,
        xgrid,
        xzero,
        ygrid,
        yzero;
 _float_ legx,
         legy,
	 scaleline,
	 scalemark,
	 scaleplot,
	 scaletext,
	 xdim,
	 xmax,
	 xmin,
	 xtr,
	 ydim,
	 ymax,
	 ymin,
	 ytr;
  char title[MaxLineLength],
       xlabel[MaxLineLength],
       ylabel[MaxLineLength],
       currTraceColor[5];
  enum ppsLinestyle_type lineStyle;
  enum orientation_type orientation;
};

extern void drawplots(char *, struct state_type *);
extern void firstpass(char *, struct state_type *, _int_ *, _int_ *, _float_ *,
                      _float_ *, _float_ *, _float_ *);
extern void parseDirective(char *, struct state_type *);
extern void setDash(struct state_type *);
extern enum linestyle_type mapStyle(enum ppsLinestyle_type);
extern void findpminmax(struct state_type *, _float_, _float_, _float_, _float_,
                        _float_ *, _float_ *, _float_ *, _float_ *, _float_ *,
                        _float_ *);
extern void gridar(_float_ *, _float_ *, _float_ *);



static int   first  = 1;
static char *fmti   = "%ld";
static char *fmt2i  = "%ld,%ld";
static char *fmtf   = " %f";
static char *fmt2f  = " %f, %f";


int main(int argc, char *argv[])
{
/* Declare local vars. */
  _int_   i, tempLong;
  _float_ tempFloat;
  struct state_type state;
  char infile[MaxLineLength], s[MaxLineLength], *s1;

/* setup format statements for decoding input */

  if (first) {
    if (sizeof(_int_) <= 4) {
      fmti  = " %d";
      fmt2i = " %d, %d";
    }
    else {
      fmti  = "%ld";      // 'l' modifier for 'long'
      fmt2i = "%ld,%ld";  // 'l' modifier for 'long'
    }

    if (sizeof(_float_) <= 4) {
      fmtf  = " %f";
      fmt2i = " %f, %f";
    }
    else {
      fmtf  = " %f";      // no modifier for 'double'
      fmt2i = " %f, %f";  // no modifier for 'double'
    }

    first = 0;
  }

/* Set state defaults. */
  state.autocolor = FALSE;
  state.border = FALSE;
  state.customleg = FALSE;
  state.eps = FALSE;
  state.xgrid = 1;
  state.ygrid = 1;
  state.legx = 0.0;
  state.legy = 0.0;
  state.mark = TRUE;
  state.samescale = FALSE;
  state.scaleplot = 1.0;
  state.scaleline = 1.0;
  state.scalemark = 1.0;
  state.scaletext = 1.0;
  state.currMarker = 0;
  state.title[0] = '\0';
  state.xdim = DefPlotDim;
  state.xlabel[0] = '\0';
  state.xmax = 0.0;
  state.xmin = 0.0;
  state.xtr = 0.0;
  state.xzero = FALSE;
  state.ydim = DefPlotDim;
  state.ylabel[0] = '\0';
  state.ymax = 0.0;
  state.ymin = 0.0;
  state.ytr = 0.0;
  state.yzero = FALSE;
  state.orientation = PORTRAIT;
  state.lineStyle = CONTINUOUS;
  strcpy(state.currTraceColor, "NULL");

  *infile = '\0';

/* Parse the command line for state. */
  for (i = 1; i < argc; i++) {
    if (!strcmp(argv[i], "-bb"))
      state.border = TRUE;
    else if (!strcmp(argv[i], "-ac"))
      state.autocolor = TRUE;

/* Obsolete option.
    else if (!strcmp(argv[i], "-color")) {
      derror("Obsolete option: -color  Use -c.", !FATAL);
      state.colors = TRUE;
    }
*/

    else if (!strcmp(argv[i], "-e"))
      state.eps = TRUE;
    else if (!strcmp(argv[i], "-l"))
      state.orientation = LANDSCAPE;

/* Obsolete option.
    else if (!strcmp(argv[i], "-nl")) {
      derror("Obsolete option: -nl  Use -mk n where n<0.", !FATAL);
      state.mark = -1*state.mark;
    }
*/

    else if (!strcmp(argv[i], "-nm"))
      state.mark = FALSE;
    else if (!strcmp(argv[i], "-ss"))
      state.samescale = TRUE;

/* Obsolete option.
    else if (!strcmp(argv[i], "-samescale")) {
      derror("Obsolete option: -samescale  Use -ss.", !FATAL);
      state.samescale = TRUE;
    }
*/

    else if (!strcmp(argv[i], "-tk"))
      state.xgrid = state.ygrid = FALSE;
    else if (!strcmp(argv[i], "-u")) {
      fprintf(stderr, "Usage: plotps [state] [filename] [state]\n");
      exit(0);
    }
    else if (!strcmp(argv[i], "-t"))
      strcpy(state.title, argv[++i]);
    else if (!strcmp(argv[i], "-x"))
      strcpy(state.xlabel, argv[++i]);
    else if (!strcmp(argv[i], "-xyz"))
      state.xzero = state.yzero = TRUE;
    else if (!strcmp(argv[i], "-xz"))
      state.xzero = TRUE;
    else if (!strcmp(argv[i], "-y"))
      strcpy(state.ylabel, argv[++i]);
    else if (!strcmp(argv[i], "-yz"))
      state.yzero = TRUE;

/* old version of -g option
    else if (!strcmp(argv[i], "-g")) {
      strcpy(s, argv[++i]);
      if ((sscanf(s, fmti, &tempLong) == 1) && (tempLong >= 0)) {
	if (state.xgrid)
	  state.xgrid = tempLong;
	if (state.ygrid)
	  state.ygrid = tempLong;
      }
      else
	derror("Bad value for -g option.  Using default value.", !FATAL);
    }
*/

    else if (!strcmp(argv[i], "-g")) {
      strcpy(s, argv[++i]);
      s1 = (char *) strtok(s, ",xX");
      if (sscanf(s1, fmti, &tempLong) == 1)
	state.xgrid = tempLong;
      else
        derror("Bad x value for -g option.  Using default value.", !FATAL);
      s1 = (char *) strtok(NULL, ",xX");
      if (sscanf(s1, fmti, &tempLong) == 1)
	state.ygrid = tempLong;
      else
        derror("Bad y value for -g option.  Using default value.", !FATAL);
    } /* end if */

/* Obsolete option.
    else if (!strcmp(argv[i], "-gx")) {
      derror("Obsolete option: -gx  Use -g n,m.  See documentation.", !FATAL);
      strcpy(s, argv[++i]);
      if ((sscanf(s, fmti, &tempLong) == 1) &&
          (tempLong >= 0) &&
	  (state.xgrid) )
	state.xgrid = tempLong;
      else
	derror("Bad value for -gx option.  Using default value.", !FATAL);
    }
*/

/* Obsolete option.
    else if (!strcmp(argv[i], "-gy")) {
      derror("Obsolete option: -gy  Use -g n,m.  See documentation.", !FATAL);
      strcpy(s, argv[++i]);
      if ((sscanf(s, fmti, &tempLong) == 1) &&
          (tempLong >= 0) &&
          (state.ygrid) )
	state.ygrid = tempLong;
      else
	derror("Bad value for -gy option.  Using default value.", !FATAL);
    }
*/

    else if (!strcmp(argv[i], "-leg")) {
      strcpy(s, argv[++i]);
      s1 = (char *) strtok(s, ",xX");
      if (sscanf(s1, fmtf, &tempFloat) == 1) {
        state.legx = tempFloat;
	s1 = (char *) strtok(NULL, ",xX");
	if (sscanf(s1, fmtf, &tempFloat) == 1) {
	  state.legy = tempFloat;
	  state.customleg = TRUE;
	}
	else
	  derror("Bad y value for -leg option.  Using default value.", !FATAL);
      }
      else
        derror("Bad x value for -leg option.  Using default value.", !FATAL);
    } /* end if */

    else if (!strcmp(argv[i], "-ls")) {
      strcpy(s, argv[++i]);
      if (!strcmp(s, "none"))
        state.lineStyle = NONE;
      else if (!strcmp(s, "dotted"))
        state.lineStyle = DOTTED;
      else if (!strcmp(s, "dashed"))
        state.lineStyle = DASHED;
      else if (!strcmp(s, "continuous"))
        state.lineStyle = CONTINUOUS;
      else
	derror("Bad line style option.  Using default style.", !FATAL);
    } /* end if */

    else if (!strcmp(argv[i], "-mk")) {
      strcpy(s, argv[++i]);
      if (sscanf(s, fmti, &tempLong) == 1)
	state.mark = tempLong;
      else
	derror("Bad value for -mk option.  Using default value.", !FATAL);
    } /* end if */

    else if (!strcmp(argv[i], "-pd")) {
      strcpy(s, argv[++i]);
      s1 = (char *) strtok(s, ",xX");
      if ((sscanf(s1, fmtf, &tempFloat) == 1) &&
          (tempFloat >= 0.0) )
        state.xdim = tempFloat;
      else
        derror("Bad x value for -pd option.  Using default value.", !FATAL);
      s1 = (char *) strtok(NULL, ",xX");
      if ((sscanf(s1, fmtf, &tempFloat) == 1) &&
          (tempFloat >= 0.0) )
        state.ydim = tempFloat;
      else
        derror("Bad y value for -pd option.  Using default value.", !FATAL);
    } /* end if */

    else if (!strcmp(argv[i], "-s")) {
      strcpy(s, argv[++i]);
      if ((sscanf(s, fmtf, &tempFloat) == 1) &&
          (tempFloat >= 0.0) )
        state.scaleplot = tempFloat;
      else
	derror("Bad value for -s option.  Using default value.", !FATAL);
    } /* end if */

    else if (!strcmp(argv[i], "-scm")) {
      strcpy(s, argv[++i]);
      if ((sscanf(s, fmtf, &tempFloat) == 1) &&
          (tempFloat >= 0.0) )
        state.scalemark = tempFloat;
      else
	derror("Bad value for -scm option.  Using default value.", !FATAL);
    } /* end if */

/* Obsolete option.
    else if (!strcmp(argv[i], "-sf")) {
      derror("Obsolete option: -sf  Use -s x.  See documentation.", !FATAL);
      strcpy(s, argv[++i]);
      if ((sscanf(s, fmtf, &tempFloat) == 1) &&
          (tempFloat >= 0.0) )
        state.scaleplot = tempFloat;
      else
	derror("Bad value for -sf option.  Using default value.", !FATAL);
    }
*/

    else if (!strcmp(argv[i], "-sl")) {
      strcpy(s, argv[++i]);
      if ((sscanf(s, fmtf, &tempFloat) == 1) &&
          (tempFloat >= 0.0) )
        state.scaleline = tempFloat;
      else
	derror("Bad value for -sl option.  Using default value.", !FATAL);
    } /* end if */

    else if (!strcmp(argv[i], "-sm")) {
      strcpy(s, argv[++i]);
      if ((sscanf(s, fmti, &tempLong) == 1) &&
          (tempLong >= 0) )
        state.currMarker = tempLong % MaxLeg;
      else
	derror("Bad value for -sm option.  Using default value.", !FATAL);
    } /* end if */

    else if (!strcmp(argv[i], "-st")) {
      strcpy(s, argv[++i]);
      if ((sscanf(s, fmtf, &tempFloat) == 1) &&
          (tempFloat >= 0) )
        state.scaletext = tempFloat;
      else
	derror("Bad value for -st option.  Using default value.", !FATAL);
    } /* end if */

    else if (!strcmp(argv[i], "-tr")) {
      strcpy(s, argv[++i]);
      s1 = (char *) strtok(s, ",xX");
      if (sscanf(s1, fmtf, &tempFloat) == 1) {
        state.xtr = tempFloat;
	s1 = (char *) strtok(NULL, ",xX");
	if (sscanf(s1, fmtf, &tempFloat) == 1)
	  state.ytr = tempFloat;
	else {
	  derror("Bad y value for -tr option.  Using default value.", !FATAL);
          state.xtr = 0.0;
        }
      }
      else
        derror("Bad x value for -tr option.  Using default value.", !FATAL);
    } /* end if */

    else if (!strcmp(argv[i], "-xr")) {
      strcpy(s, argv[++i]);
      s1 = (char *) strtok(s, ",xX");
      if (sscanf(s1, fmtf, &tempFloat) == 1) {
        state.xmin = tempFloat;
	s1 = (char *) strtok(NULL, ",xX");
	if (sscanf(s1, fmtf, &tempFloat) == 1)
	  state.xmax = tempFloat;
	else {
	  derror("Bad max value for -xr option.  Using default value.", !FATAL);
          state.xmin = 0.0;
        }
      }
      else
        derror("Bad min value for -xr option.  Using default value.", !FATAL);
    } /* end if */

    else if (!strcmp(argv[i], "-yr")) {
      strcpy(s, argv[++i]);
      s1 = (char *) strtok(s, ",xX");
      if (sscanf(s1, fmtf, &tempFloat) == 1) {
        state.ymin = tempFloat;
	s1 = (char *) strtok(NULL, ",xX");
	if (sscanf(s1, fmtf, &tempFloat) == 1)
	  state.ymax = tempFloat;
	else {
	  derror("Bad max value for -yr option.  Using default value.", !FATAL);
          state.ymin = 0.0;
        }
      }
      else
        derror("Bad min value for -yr option.  Using default value.", !FATAL);
    } /* end if */

/* Obsolete option.
    else if (!strcmp(argv[i], "-xtr")) {
      derror("Obsolete option: -xtr  Use -tr a,b.  See documentation.", !FATAL);
      strcpy(s, argv[++i]);
      if (sscanf(s, fmtf, &tempFloat) == 1)
        state.xtr = tempFloat;
      else
	derror("Bad value for -xtr option.  Using default value.", !FATAL);
    }
*/

/* Obsolete option.
    else if (!strcmp(argv[i], "-ytr")) {
      derror("Obsolete option: -ytr  Use -tr a,b.  See documentation.", !FATAL);
      strcpy(s, argv[++i]);
      if (sscanf(s, fmtf, &tempFloat) == 1)
        state.ytr = tempFloat;
      else
	derror("Bad value for -ytr option.  Using default value.", !FATAL);
    }
*/

    else if (*argv[i] == '-') {/* Ignore unsupported option. */
      strcpy(s, "Unsupported option: ");
      strcat(s, argv[i]);
      strcat(s, "  Please see documentation.");
      derror(s, !FATAL);
      continue;
    }

    else  /* Retrieve input file name. */
      strcpy(infile, argv[i]);

  } /* end for */

  drawplots(infile, &state);

/* Clean up temporary files. */
  cleanup(0);

/* Force successful exit. */
  exit(0);

} /* end MAIN */




/*
drawplots: draws one page of plots of one or more traces.  Data is from the input
file.

Parameters:   --> infile: name of filename containing plot data
              --> *state: structure containing global plot state
*/
void drawplots(char *infile, struct state_type *state)
{
/* Declare local vars. */
  _int_ ntrace, npts, ltitle, lxlabel, lylabel, tracenum,
	numleg=0, pointnum;
  _float_  xmin, xmax, ymin, ymax, xdim, ydim,
         pxmin, pxstp, pxmax, pymin, pystp, pymax,
         *x, *y, xleg, yleg;
  FILE *fp;
  struct state_type localState;
  char s[MaxLineLength], tempstr[MaxLineLength],
       tempfile[MaxLineLength], outfilename[MaxLineLength],
       tempLegend[MaxLineLength], *tempChar;

/*
Find the number of traces, maximum number of points per trace,
the minimum x & y, the maximum x & y, and parse all global
directives in infile.
*/
  firstpass(infile, state, &ntrace, &npts, &xmin, &xmax, &ymin, &ymax);

/* If eps option selected, then open temporary output file and return its name.
*/
  if (state -> eps)
    open_ps_out(outfilename);

/* Open output and initialize plot parameters. */
  comprs_();

/* Set plot scale factor if option used. */
  if (fabs(state -> scaleplot - 1.0) > EPSILON)
    blowup_(&(state -> scaleplot));

/* Set marker scale factor. */
  scalemarker(state -> scalemark);

/* Set text scale factor. */
  scalefont(state -> scaletext);

/* If no border requested, then call nobrdr. */
  if (!(state -> border)) nobrdr_();

/* If custom legend coordinates entered, then set appropriate static var. */
  if (state -> customleg)
    set_customleg(TRUE);

/* Specify plot dimensions, titles, etc. */
  xdim = state -> xdim;
  ydim = state -> ydim;
  ltitle = (state -> orientation) * MAX(strlen(state -> title), 1);
  lxlabel = MIN(-1.0*strlen(state -> xlabel), -1);
  lylabel = MIN(-1.0*strlen(state -> ylabel), -1);
  title_(state -> title,
         &ltitle,
         state -> xlabel,
         &lxlabel,
         state -> ylabel,
         &lylabel,
         &xdim,
         &ydim);

/* Set plot base translation if either or both state used. */
  if ((fabs(state -> xtr) > EPSILON) || (fabs(state -> ytr) > EPSILON)) {
    zerorg();
    bshift_(&(state -> xtr), &(state -> ytr));
  }

/*
Determine appropriate minimum and maximum x & y values and x & y steps for
the plot given xmin, xmax, ymin, and ymax.
*/
  findpminmax(state, xmin, xmax, ymin, ymax,
              &pxmin, &pxstp, &pxmax, &pymin, &pystp, &pymax);

/* Set up scale on axes with numbered tick marks. */
  graf_(&pxmin, &pxstp, &pxmax, &pymin, &pystp, &pymax);

/* Draw grid lines, if requested. */
  grid_(&(state -> xgrid), &(state -> ygrid));

/* Open input file with read access. */
  if (!(fp = fopen(infile, "r"))) {
    strcpy(tempstr, "Could not open input data file: ");
    strcat(tempstr, infile);
    derror(tempstr, FATAL);
  }

/* Allocate space for x and y arrays of points. */ 
  x = (_float_ *) malloc(sizeof(_float_) * npts);
  y = (_float_ *) malloc(sizeof(_float_) * npts);

/* Read lines from the input data file until EOF. */
  tracenum = 0;
  marker_(&(state -> currMarker));

/* Set plot line thickness. */
  scale_line(state -> scaleline);

/*
   Copy default state into localState before making changes to fields in
   localState.
*/
  memcpy(&localState, state, sizeof(struct state_type));
  pointnum = 0;
  while (fgets(s, MaxLineLength, fp) != NULL) {

    fixstring(s);  /* Get rid of prepended or postpended whitespace. */

  /*
     If first character is a ", then characters that follow
     comprise the legend for that trace.  This option allows for
     compatibility with Xgraph input files.
  */
    if (*s == '"')
      sprintf(tempLegend, "%s", &s[1]);

  /*
      Parse local directive.
  */
    else if ((*s == '+') &&
             (isalpha(fixstring(&s[1])[1])))
  /*
     If the line starts with the directive "+legend", then
     characters within the outermost enclosing parentheses
     comprise the legend for the current trace.
  */
      if (!strncmp(&s[1], "legend", 6)) {
	if ((tempChar = (char *) strchr(s, '(')) == NULL) {
	  derror("No ( for +legend directive.  Ignoring directive.", !FATAL);
	  continue;
	}
	strcpy(tempstr, tempChar+1);
	if ((tempChar = (char *) strrchr(tempstr, ')')) == NULL) {
	  derror("No ) for +legend directive.  Ignoring directive.", !FATAL);
	  continue;
	}
	*tempChar = '\0';
	sprintf(tempLegend, "%s", tempstr);
      }
      else
  /*
     Parse local directive other than "+legend".
  */
	parseDirective(s, &localState);

  /*
     If line is empty and we have read at least one point,
     then we are finished with the current trace.  updateLegend()
     and draw the curve.
  */
    else if ((*s == '\0') && pointnum) {

      if (!strcmp(localState.currTraceColor, "NULL"))
	if (localState.autocolor)
	  strcpy(localState.currTraceColor, returnAutoTraceColor(tracenum));
	else
	  strcpy(localState.currTraceColor, "BLAC");

      if (*tempLegend) { /* Call updateLegend with relevant parameters. */
	numleg = 
	  updateLegend((localState.mark ? localState.currMarker : -1),
		       localState.scaleline,
		       mapStyle(localState.lineStyle),
                       localState.currTraceColor, 
		       tempLegend);
        *tempLegend = '\0'
;
      }

    /* Set attributes for current trace. */
      marker_(&(localState.currMarker));
      setTraceColor(localState.currMarker, localState.currTraceColor);
      scale_line(localState.scaleline);
      scalemarker(localState.scalemark);
      setDash(&localState);

      curve_(x, y, &pointnum, &(localState.mark));
      tracenum++;
      pointnum = 0;
     
/*
Increment state->currMarker if we did not explicitly set
a different marker for the last trace.
*/
      if (state->currMarker == localState.currMarker)
        state->currMarker = (state->currMarker + 1) % MaxLeg;

  /* Restore default state. */
      memcpy(&localState, state, sizeof(struct state_type));
    }

  /* 
     If more than one blank line or if blank appears before any data, do
     nothing with the second blank line.
  */
    else if (*s == '\0' && !pointnum) {
      *tempLegend = '\0';
      continue;
    }
  /*
     If a comment character (#) or a global directive appear in the first column
     anywhere in the file, ignore them.
  */
    else if ((*s == '#') || (*s == '='))
      continue;
  /*
     If none of the above is true, then parse the string into an x & y value.
  */
    else {
      if (sscanf(s, "%f%f", &x[pointnum], &y[pointnum]) != 2)
        derror("Input data in bad format!", FATAL);
      pointnum++;
    } /* end else */

  } /* end while */

  fclose(fp);

/* If infile was tempfile, then unlink it. */
  sprintf(tempfile, "%s%d", TempDataFile, getpid());
  if (!strcmp(tempfile, infile)) {
    if (unlink(infile)) {
      strcpy(tempstr, "Could not delete temporary input data file: ");
      strcat(tempstr, infile);
      derror(tempstr, !FATAL);
    }
  }

/* Draw the last curve if there are points. */
  if (pointnum) {

    if (!strcmp(localState.currTraceColor, "NULL"))
      if (localState.autocolor)
	strcpy(localState.currTraceColor, returnAutoTraceColor(tracenum));
      else
	strcpy(localState.currTraceColor, "BLAC");

    if (*tempLegend) { /* Call updateLegend with relevant parameters. */
      numleg = 
        updateLegend((localState.mark ? localState.currMarker : -1),
                     localState.scaleline,
                     mapStyle(localState.lineStyle),
		     localState.currTraceColor,
                     tempLegend);
      *tempLegend = '\0';
    }

  /* Set attributes for last trace. */
    marker_(&(localState.currMarker));
    setTraceColor(localState.currMarker, localState.currTraceColor);
    scale_line(localState.scaleline);
    scalemarker(localState.scalemark);
    setDash(&localState);

    curve_(x, y, &pointnum, &(localState.mark));
    tracenum++;
    pointnum = 0;

/*
Restore default state.  This prevents wierd behavior in
case the input file contained local directives that can only
be applied globally (e.g. +scaletext(x)).  If such directives
exist, they are overridden by copying the global state into the
local state at this time.
*/
    memcpy(&localState, state, sizeof(struct state_type));
  }

  free(x);
  free(y);

/* Draw legend.  */
  if (state -> customleg) {
    xleg = (state -> legx);
    yleg = (state -> legy);
  }
  else {
    xleg = 0.0;
    yleg = ydim + 0.40*state->scaletext;
  }

/* Print warning message if legend overflowed. */
  if (numleg == 20) {
    sprintf(tempstr, "Legend overflow.  Only first %d legends printed.", MaxLeg);
    derror(tempstr, !FATAL);
  }

/* Draw legend. */
  if (numleg)
    drawLegend(xleg, yleg);

/* End plot. */
  endpl_(&pointnum);

/* Done plot. */
  donepl_();

/* If eps option selected, then post-process PostScript file so it conforms
   to EPSF-2.0.
*/
  if (state -> eps)
    ps2eps(outfilename);

} /* end drawplots */



/*
parseDirective: interprets a directive (command) from the
input file and sets the appropriate field in the state
structure.

Parameters:  -->      s: string from input file
            <--> *state: state vector from calling function.
*/
void parseDirective(char *s, struct state_type *state)
{
  char *directive, *arg, *c;
  char tempStr[MaxLineLength];
  _int_   i1, i2;
  _float_ f1, f2;

  /* Get rid of "+" or "=" sign at beginning of string. */
  s++;

  /*
  Break input string into two parts: the directive and its
  argument.  If there is no argument in the input string, then
  arg is NULL.
  */
  directive = (char *) strtok(s, "(");
  fixstring(directive);
  if (arg = (char *) strtok(NULL, "")) {
    c  = (char *) strrchr(arg, ')');
    *c = '\0';
  }

  if (!strcmp(directive, "border"))
    state->border = TRUE;
  else if (!strcmp(directive, "autocolor"))
    state->autocolor = TRUE;
  else if (!strcmp(directive, "eps"))
    state->eps = TRUE;
  else if (!strcmp(directive, "landscape"))
    state->orientation = LANDSCAPE;
  else if (!strcmp(directive, "markeroff"))
    state->mark = 0;
  else if (!strcmp(directive, "markeron"))
    state->mark = (state->mark ? state->mark : 1);
  else if (!strcmp(directive, "samescale"))
    state->samescale = TRUE;
  else if (!strcmp(directive, "xzero"))
    state->xzero = TRUE;
  else if (!strcmp(directive, "xyzero"))
    state->xzero = state->yzero = TRUE;
  else if (!strcmp(directive, "yzero"))
    state->yzero = TRUE;
  else if (!strcmp(directive, "gridlines"))
    if (sscanf(arg, fmt2i, &i1, &i2) == 2) {
      state->xgrid = i1;
      state->ygrid = i2;
    }
    else
      derror("Bad argument for gridlines directive.  Using default values.", !FATAL);

  else if (!strcmp(directive, "legendloc"))
    if (sscanf(arg, fmt2f, &f1, &f2) == 2) {
      state->legx = f1;
      state->legy = f2;
      state->customleg = TRUE;
    }
    else
      derror("Bad argument for legendloc directive.  Using default values.", !FATAL);

  else if (!strcmp(directive, "linestyle")) {
    fixstring(arg);
    lowerString(arg);
    if (!strcmp(arg, "none"))
      state->lineStyle = NONE;
    else if (!strcmp(arg, "dotted"))
      state->lineStyle = DOTTED;
    else if (!strcmp(arg, "dashed"))
      state->lineStyle = DASHED;
    else if (!strcmp(arg, "continuous"))
      state->lineStyle = CONTINUOUS;
    else
      derror("Bad argument for linestyle directive.  Using default style.", !FATAL);
  }

  else if (!strcmp(directive, "markerfreq"))
    if (sscanf(arg, fmti, &i1) == 1)
      state->mark = i1;
    else
      derror("Bad argument for markerfreq directive.  Using default value.", !FATAL);

  else if (!strcmp(directive, "dimensions"))
    if ((sscanf(arg, fmt2f, &f1, &f2) == 2) && (f1 > 0.0) && (f2 > 0.0)) {
      state->xdim = f1;
      state->ydim = f2;
    }
    else
      derror("Bad argument for dimensions directive.  Using default values.", !FATAL);

  else if (!strcmp(directive, "plotscale"))
    if ((sscanf(arg, fmtf, &f1) == 1) && (f1 > 0.0))
      state->scaleplot = f1;
    else
      derror("Bad argument for plotscale directive.  Using default value.", !FATAL);

  else if (!strcmp(directive, "scalemarker"))
    if ((sscanf(arg, fmtf, &f1) == 1) && (f1 > 0.0))
      state->scalemark= f1;
    else
      derror("Bad argument for scalemarker directive.  Using default value.", !FATAL);

  else if (!strcmp(directive, "scaleline"))
    if ((sscanf(arg, fmtf, &f1) == 1) && (f1 > 0.0))
      state->scaleline = f1;
    else
      derror("Bad argument for scaleline directive.  Using default value.", !FATAL);

  else if (!strcmp(directive, "setmarker"))
    if (sscanf(arg, fmti, &i1) == 1)
      state->currMarker = i1;
    else
      derror("Bad argument for setmarker directive.  Using default value.", !FATAL);

  else if (!strcmp(directive, "scaletext"))
    if ((sscanf(arg, fmtf, &f1) == 1) && (f1 > 0.0))
      state->scaletext = f1;
    else
      derror("Bad argument for scaletext directive.  Using default value.", !FATAL);

  else if (!strcmp(directive, "title"))
    strcpy(state->title, arg);

  else if (!strcmp(directive, "translate"))
    if (sscanf(arg, fmt2f, &f1, &f2) == 2) {
      state->xtr = f1;
      state->ytr = f2;
    }
    else
      derror("Bad argument for translate directive.  Using default values.", !FATAL);

  else if (!strcmp(directive, "xlabel"))
    strcpy(state->xlabel, arg);

  else if (!strcmp(directive, "xrange"))
    if (sscanf(arg, fmt2f, &f1, &f2) == 2) {
      state->xmin = f1;
      state->xmax = f2;
    }
    else
      derror("Bad argument for xrange directive.  Using default values.", !FATAL);

  else if (!strcmp(directive, "ylabel"))
    strcpy(state->ylabel, arg);

  else if (!strcmp(directive, "yrange"))
    if (sscanf(arg, fmt2f, &f1, &f2) == 2) {
      state->ymin = f1;
      state->ymax = f2;
    }
    else
      derror("Bad argument for yrange directive.  Using default values.", !FATAL);

  else if (!strcmp(directive, "color")) {
    fixstring(arg);
    lowerString(arg);
    if (!strcmp(arg, "black"))
      strcpy(state->currTraceColor, "BLAC");
    else if (!strcmp(arg, "red"))
      strcpy(state->currTraceColor, "RED");
    else if (!strcmp(arg, "green"))
      strcpy(state->currTraceColor, "GREE");
    else if (!strcmp(arg, "blue"))
      strcpy(state->currTraceColor, "BLUE");
    else if (!strcmp(arg, "purple"))
      strcpy(state->currTraceColor, "PURP");
    else if (!strcmp(arg, "turquoise"))
      strcpy(state->currTraceColor, "TURQ");
    else if (!strcmp(arg, "orange"))
      strcpy(state->currTraceColor, "ORAN");
    else if (!strcmp(arg, "yellow"))
      strcpy(state->currTraceColor, "YELL");
    else
      derror("Bad argument for color directive.  Using black.", !FATAL);
  }
/*
More directives go here.
*/

  else {   /* Directive does not exist. */
    strcpy(tempStr, "Ignoring bad directive: ");
    strcat(tempStr, directive);
    derror(tempStr, !FATAL);
  }
}


/*
setDash: sets the current line style to linestyle.  setDash calls the low-level
di2ps routines that change the line style.

Parameters:  <-->    *state: state vector from calling function.
*/
extern void setDash(struct state_type *state)
{
  if (state->lineStyle == NONE)
    state->mark = -abs(state->mark);
  else if (state->lineStyle == DOTTED)
    dot_();
  else if (state->lineStyle == DASHED)
    dash_();
  else if (state->lineStyle == CONTINUOUS)
    line_();
}

/*
mapStyle: maps the local plotps lineStyle to the di2ps lineStyle.
di2ps lineStyle is returned.
*/
enum linestyle_type mapStyle(enum ppsLinestyle_type lineStyle)
/*
  Paramters:
              --> lineStyle: plotps lineStyle value.
              <==          : di2ps lineStyle value.
*/
{
  if (lineStyle == NONE)
    return(LINE);
  else if (lineStyle == DOTTED)
    return(DOT);
  else if (lineStyle == DASHED)
    return (DASH);
  else if (lineStyle == CONTINUOUS)
    return (LINE);
  else
    return (LINE);
}


/*
firstpass: finds the minimum x & y values, the maximum x & y values, the
number of points in the largest data set, the number of data sets
(traces), and parse all global directives in the file infile.

Parameters:   -->   infile: name of filename containing plot data
              <--  *state: structure containing global plot state
              <--  *ntrace: number of data sets (traces) in the input file
              <--    *npts: number of points in the largest data set
              <--    *xmin: the minimum x-value in all of the data sets
              <--    *xmax: the maximum x-value in all of the data sets
              <--    *ymin: the minimum y-value in all of the data sets
              <--    *ymax: the maximum y-value in all of the data sets
*/
void firstpass(char *infile, struct state_type *state,
               _int_ *ntrace, _int_ *npts, _float_ *xmin,
               _float_ *xmax, _float_ *ymin, _float_ *ymax)
{
/* Declare local vars. */
  FILE *fp, *fpout;
  _float_ x, y;
  _int_ pointnum;
  char s[MaxLineLength], tempstr[MaxLineLength];

/* Initialize returned arguments. */
  *npts = 0;
  *ntrace = 0;
  *xmin = MAXFLOAT;
  *xmax = -MAXFLOAT;
  *ymin = MAXFLOAT;
  *ymax = -MAXFLOAT;

/* Open input file with read access if *infile is !NULL. */
  if (*infile) {
    if (!(fp = fopen(infile, "r"))) {
      strcpy(tempstr, "Could not open input data file: ");
      strcat(tempstr, infile);
      derror(tempstr, FATAL);
    }
  }
  else { /* Set fp to stdin, infile to "/tmp/plotps$$" tempfile. */
    fp = stdin;
    sprintf(infile, "%s%d", TempDataFile, getpid());
    if (!(fpout = fopen(infile, "w"))) {
      strcpy(tempstr, "Could not open temporary output data file: ");
      strcat(tempstr, infile);
      derror(tempstr, FATAL);
    }
  }

  pointnum = 0;
  while (fgets(s, MaxLineLength, fp) != NULL) {

    if (fp == stdin)
      fputs(s, fpout);

    fixstring(s); /* Get rid of prepended or postpended whitespace. */

    /* two floats successfully parsed */
    if (sscanf(s, "%f%f", &x, &y) == 2) { 
      *xmin = MIN(*xmin, x);  
      *xmax = MAX(*xmax, x);
      *ymin = MIN(*ymin, y);
      *ymax = MAX(*ymax, y);
      pointnum++;
    }

    else if (*s == '=') {  /* Parse global directive. */
      fixstring(&s[1]);
      parseDirective(s, state);
    }

    else if (*s == '"') /* Legend encountered.  Ignore it. */
      continue;

    else if (*s == '#') /* Comment encountered. Ignore it. */
      continue;

    else if (*s == '\0' && pointnum) {
                                      /* If we've just finished parsing a set,
                                         then update *npts and *ntrace. */
      *npts = MAX(*npts, pointnum);
      (*ntrace)++;
      pointnum = 0;
    }

    else
      continue;
    /*
    If none of the two previous conditions is satisfied, then do nothing.
    */  
  } /* end while */

/*
If we've just finished parsing a set, then update *npts and *ntrace.  This
branch is executed if there is no blank line at the end of the file.
*/
  if (pointnum) { 
    *npts = MAX(*npts, pointnum);
    (*ntrace)++;
    pointnum = 0;
  }

/* Close input or output data file. */
  if (fp == stdin)
    fclose(fpout);
  else
    fclose(fp);

} /* end firstpass */




/*
findpminmax: determines a visually pleasing range for the plots given
the actual minimum and maximum values.  findpminmax also returns a
pleasing step size.

Parameters:   --> state: pointer to plot state structure
              -->    xmin: smallest x-value in the data
              -->    xmax: largest x-value in the data
              -->    ymin: smallest y-value in the data
              -->    ymax: largest y-value in the data
              <--  *pxmin: smallest value on x-axis
              <--  *pxstp: size of x increment
              <--  *pxmax: largest value on x-axis
              <--  *pymin: smallest value on y-axis
              <--  *pystp: size of y increment
              <--  *pymax: largest value on y-axis
*/
void findpminmax(struct state_type *state, _float_ xmin,
                 _float_ xmax, _float_ ymin, _float_ ymax,
                 _float_ *pxmin, _float_ *pxstp, _float_ *pxmax,
                 _float_ *pymin, _float_ *pystp, _float_ *pymax)
{
/* Declare local vars. */
  _float_ rangex, rangey;
  void gridar();

  if (fabs(xmax - xmin) < EPSILON)
    if (fabs(xmax + xmin) / 2.0 >= 1.0) {
      xmin -= 1.0 * pow(10.0, trncate(log10(fabs(xmax + xmin) / 2.0)));
      xmax += 1.0 * pow(10.0, trncate(log10(fabs(xmax + xmin) / 2.0)));
    }
    else {
      xmin -= 1.0;
      xmax += 1.0;
    }
  
  if (fabs(ymax - ymin) < EPSILON)
    if (fabs(ymax + ymin) / 2.0 >= 1.0) {
      ymin -= 1.0 * pow(10.0, trncate(log10(fabs(ymax + ymin) / 2.0)));
      ymax += 1.0 * pow(10.0, trncate(log10(fabs(ymax + ymin) / 2.0)));
    }
    else {
      ymin -= 1.0;
      ymax += 1.0;
    }

#define RangeOrigRatio 0.2

/* If user has entered range limits for x-axis... */
  if ((state -> xmin != 0.0) || (state -> xmax != 0.0)) {
    *pxmin = state -> xmin;
    *pxmax = state -> xmax;
  }
  else {
    *pxmax = xmax;
    *pxmin = xmin;

  /* If range is large compared to its distance from zero, and
     (*pxmin) * (*pxmax) > 0.0, then force to zero whichever is closest of
     *pxmin or *pxmax.
  */
    if ((*pxmin > 0.0) && (*pxmin / (*pxmax - *pxmin) < RangeOrigRatio))
      *pxmin = 0.0;
    else if ((*pxmax < 0.0) &&
             (fabs(*pxmax / (*pxmax - *pxmin)) < RangeOrigRatio))
      *pxmax = 0.0;
  }

/* If user has entered range limits for y-axis... */
  if ((state -> ymin != 0.0) || (state -> ymax != 0.0)) {
    *pymin = state -> ymin;
    *pymax = state -> ymax;
  }
  else {
    *pymax = ymax;
    *pymin = ymin;

  /* If (*pymax - *pymin) is large compared to its distance from zero, and
     (*pymin) * (*pymax) > 0.0, then force to zero whichever is closest of
     *pymin or *pymax.
  */
    if ((*pymin > 0.0) && (*pymin / (*pymax - *pymin) < RangeOrigRatio))
      *pymin = 0.0;
    else if ((*pymax < 0.0) &&
             (fabs(*pymax / (*pymax - *pymin)) < RangeOrigRatio))
      *pymax = 0.0;
  }

  if (state -> xzero) {
    if (*pxmin > 0.0)
      *pxmin = 0.0;
    else if (*pxmax < 0.0)
      *pxmax = 0.0;
  }

  if (state -> yzero) {
    if (*pymin > 0.0)
      *pymin = 0.0;
    else if (*pymax < 0.0)
      *pymax = 0.0;
  }

  if (state -> samescale) {
    *pxmax = 0.5 * (*pxmax + *pxmin + MAX(*pxmax - *pxmin, *pymax - *pymin));
    *pxmin = 0.5 * (*pxmax + *pxmin - MAX(*pxmax - *pxmin, *pymax - *pymin));
    *pymax = 0.5 * (*pymax + *pymin + MAX(*pxmax - *pxmin, *pymax - *pymin));
    *pymin = 0.5 * (*pymax + *pymin - MAX(*pxmax - *pxmin, *pymax - *pymin));
  }
  
  gridar(pxmin, pxmax, pxstp);
  gridar(pymin, pymax, pystp);

/* Check to make sure axes cover the same ranges. */
  if (state -> samescale) {
    rangex = *pxmax - *pxmin;
    rangey = *pymax - *pymin;
    if (fabs(rangex - rangey) < *pxstp * 0.5)
      return;
    else if (rangex > rangey)
      if (fabs(*pymax - ymax) < fabs(*pymin - ymin))
        *pymax += *pystp;
      else
        *pymin -= *pystp;
    else if (rangey > rangex)
      if (fabs(*pxmax - xmax) < fabs(*pxmin - xmin))
        *pxmax += *pxstp;
      else
        *pxmin -= *pxstp;
  } /* end if */

} /* end findpminmax */




/*
gridar:  gridar determines visually pleasing limits of an axis for a
cartesian plot.  It also determines an appropriate step size.

Parameters:   <--->  *min: (input) the current minimum value for the axis
                           (output) the adjusted minimum value for the axis
              <--->  *max: (input) the current maximum value for the axis
                           (output) the adjusted maximum value for the axis
              <---  *step: the "best" interval for the tick marks

Note: The logic for this routine was originally written by Karen Neier (97-10)
in FORTRAN and appears in the PANDA2 source library: plot.src.
*/
void gridar(_float_ *min, _float_ *max, _float_ *step)
{
/* Declare local vars. */
  _float_ range, tmin, tmax, tstep;
  _int_ factors[20], again = 0, factornum, stepnum;

/* New Logic */
  if (*max - *min < 0.0)
    derror("*max must be greater than *min.  Function: gridar", FATAL);

  tmin = *min;
  tmax = *max;
  range = tmax - tmin;

  tstep = pow(10.0, floor(log10(range)) - 1.0);
  if (range / tstep < 5.0) tstep = tstep / 2.0;
  if (range / tstep > 10.0) tstep = 2.0 * (tstep);
  if (range / tstep > 10.0) tstep = 5.0 * (tstep) / 2.0;
  if (range / tstep > 10.0) tstep = 2.0 * (tstep);

/* Make sure that plot min/max encompass data min/max. */
  tmin = tstep * trncate(tmin / tstep);
  if (tmin > *min) tmin -= tstep;
  tmax = tstep * trncate(tmax / tstep);
  if (tmax < *max) tmax += tstep;


  for ( ; ; ) {

/* This is where the fun stuff is.
   Make sure that stepnum is divisible by more than only stepnum and 1, unless
   stepnum is equal to 5.
*/
    range = tmax - tmin;
    stepnum = (_int_) round(range / (tstep));
    factornum = getfactors((int *) factors, (int) stepnum);
    if ((factornum < 3) && (stepnum % 5 != 0)) {
      again++;
      if ((fabs(tmin) < EPSILON) ||
          (tmin + (tstep) * stepnum < tmax))
        tmax += tstep;
      else if ((fabs(tmax) < EPSILON) ||
               (tmax - (tstep) * stepnum > tmin))
        tmin -= tstep;
      else if (ODD(again))
        tmax += (tstep);
      else
        tmin -= (tstep);
    }
    else
      break;
  } 

  *min = tmin;
  *max = tmax;
  *step = tstep;

/* Old Logic
  range = fabs(*max - *min);
  *step = pow(10.0, floor(log10(range)) - 1.0);
  if (range / *step < 5.0) *step = *step / 2.0;
  if (range / *step > 10.0) *step = 2.0 * (*step);
  if (range / *step > 10.0) *step = 5.0 * (*step) / 2.0;
  if (range / *step > 10.0) *step = 2.0 * (*step);

  tmin = *step * trncate(*min / *step);
  if (tmin > *min) tmin = tmin - *step;
  *min = tmin;
  tmax = *step * trncate(*max / *step);
  if (tmax < *max) tmax = tmax + *step;
  *max = tmax;
*/
} /* end gridar */

