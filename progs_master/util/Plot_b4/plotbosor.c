/*
plotbosor.c

plotbosor takes a data file in the same format as an Xgraph data file, and
plots the points according to the command line options.  plotbosor was written
to replace Xgraph for people who can't run Xgraph.  Instead of plotting points
to a screen, plotbosor writes the equivalent PostScript commands to stdout.
plotbosor may also be used by people wishing to obtain "cleaner-looking"
hard-copies of their plots than is available by using the print option from
within Xgraph.  The command line options are a subset of those for Xgraph with
the addition of the "-samescale" and "-nm" options.  Options supported are:

          -bb --  draw plot border
          -nl --  no connecting lines, just markers
          -nm --  no markers, just connecting lines  (also no legends)
          -tk --  no grid lines, just tick marks
   -samescale --  keep scale of x and y axes the same
       -usage --  prints plotbosor invocation syntax
     -t title --  title of plot
     -y label --  draw y-axis label
     -x label --  draw x-axis label

Other options are permitted but will be ignored by plotbosor.

Invocation syntax:		plotbosor [options] filename

Output is sent to stdout.

*/

#include <stdio.h>

#if sgi
#include <string.h>
#else
#include <strings.h>
#endif

#include <math.h>

#include "names.h"
#include "paramlength.h"
#include "util.h"
#include "di2ps.h"

#define FATAL 1
#define TicksPerAxis 10
#define MaxLineLength 133
#define MaxLeg 19

#ifndef MAXFLOAT
#define MAXFLOAT 1.0e37
#endif

struct options_type {
  _int_ border,
       grid,
       mark,
       samescale;
  char title[80],
       xlabel[80],
       ylabel[80];
};

extern void drawplots(char infile[80], struct options_type *options);
extern void drawcurve(char **legend, _int_ *legend_exists, _int_ *tracenum,
                      _float_ *x, _float_ *y, _int_ pointnum, _int_ mark);
extern void findminmax(char *infile, _int_ *ntrace, _int_ *npts, _float_ *xmin,
                       _float_ *xmax, _float_ *ymin, _float_ *ymax);
extern void findpminmax(_int_ samescale, _float_ xmin, _float_ xmax, _float_ ymin,
                        _float_ ymax, _float_ *pxmin, _float_ *pxstp, _float_ *pxmax,
                        _float_ *pymin, _float_ *pystp, _float_ *pymax);
extern void gridar(_float_ *min, _float_ *max, _float_ *step);




_int_ main(argc, argv)
_int_ argc;
char *argv[];
{
/* Declare local vars. */
  _int_ i, j;
  struct options_type options;
  char infile[MaxLineLength], usercommand[MaxLineLength], s[MaxLineLength];

/* Set options defaults. */
  options.border = 0;
  options.grid = 1;
  options.mark = 1;
  options.samescale = 0;
  options.title[0] = '\0';
  options.xlabel[0] = '\0';
  options.ylabel[0] = '\0';

/* Check for enough arguments. */
  if (argc == 1) error("Usage: plotbosor [options] filename", FATAL);


/* Parse the command line for options. */
  for (i = 1; i < argc-1; i++) {
    if (!strcmp(argv[i], "-bb"))
      options.border = 1;
    else if (!strcmp(argv[i], "-nl"))
      options.mark = -1;
    else if (!strcmp(argv[i], "-nm"))
      options.mark = 0;
    else if (!strcmp(argv[i], "-samescale"))
      options.samescale = 1;
    else if (!strcmp(argv[i], "-tk"))
      options.grid = 0;

    else if (!strcmp(argv[i], "-t")) {
      j = i+1;
      while (argv[j][0] != '-' && j < argc-1) {
        if (j > i+1)
          strcat(options.title, " ");
        strcat(options.title, argv[j++]);
      }
      i = j-1;
    } /* end if */

    else if (!strcmp(argv[i], "-x")) {
      j = i+1;
      while (argv[j][0] != '-' && j < argc-1) {
        if (j > i+1)
          strcat(options.xlabel, " ");
        strcat(options.xlabel, argv[j++]);
      }
      i = j-1;
    } /* end if */

    else if (!strcmp(argv[i], "-y")) {
      j = i+1;
      while (argv[j][0] != '-' && j < argc-1) {
        if (j > i+1)
          strcat(options.ylabel, " ");
        strcat(options.ylabel, argv[j++]);
      }
      i = j-1;
    } /* end if */
  } /* end for */

/* Retrieve input file name. */
  strcpy(infile, argv[argc-1]);

  drawplots(infile, &options);

#ifdef sun4
/* Force successful exit. */
  exit(0);
#endif

} /* end MAIN */




/*
drawplots: draws one page of plots of one or more traces.  Data is from the input
file, and plot options are passed through the options structure.

Input parameters:    infile - name of the input data file
                   *options - the structure containing plot options
*/
void drawplots(char infile[80], struct options_type *options)
{
/* Declare local vars. */
  _int_ i, k, ntrace, npts, mlen, ltitle, lxlabel, lylabel,
       starting_marker = 0, *legend_exists, tracenum, pointnum;
  _float_  xmin, xmax, ymin, ymax, xdim, ydim,
         pxmin, pxstp, pxmax, pymin, pystp, pymax,
         *x, *y, xleg, yleg, mx, my;
  FILE *fp;
  char s[MaxLineLength], *pak, *legnd[MaxLeg],
       *casename;
/*
  Initialize *legnd
*/
  for (i=0;i<MaxLeg;i++)
    legnd[i] = NULL;

/*
Find the number of traces, maximum number of points per trace,
the minimum x & y, and the maximum x & y in infile.
*/
  findminmax(infile, &ntrace, &npts, &xmin, &xmax, &ymin, &ymax);
  if (ntrace > MaxLeg-1)
    error("Legends printed for first 18 curves only.", !FATAL);

/* Open metafile. */
  comprs_();

/* If no border requested, then call nobrdr. */
  if (options -> border == 0) nobrdr_();

/* Specify plot dimensions, titles, etc. */
  xdim = 6.5; /* inches */
  ydim = 6.5; /* inches */
  ltitle = MAX(strlen(options -> title), 1);
  lxlabel = MIN(-1.0*strlen(options -> xlabel), -1);
  lylabel = MIN(-1.0*strlen(options -> ylabel), -1);
  title_(options -> title,
         &ltitle,
         options -> xlabel,
         &lxlabel,
         options -> ylabel,
         &lylabel,
         &xdim,
         &ydim);

/*
Determine appropriate minimum and maximum x & y values and x & y steps for
the plot given xmin, xmax, ymin, and ymax.
*/
  findpminmax(options -> samescale, xmin, xmax, ymin, ymax,
              &pxmin, &pxstp, &pxmax, &pymin, &pystp, &pymax);

/* Set up scale on axes with numbered tick marks. */
  graf_(&pxmin, &pxstp, &pxmax, &pymin, &pystp, &pymax);

/* Draw grid lines, if requested. */
  grid_(&(options -> grid), &(options -> grid));

/* Determine case name. */
  casename = (char *) strtok(options -> title, "..");
  if (casename == NULL) {
    casename = (char *) malloc(1);
    *casename = '\0';
  }

/* Get case title from the {casename}.DOC file. */
  sprintf(s, "%s.DOC", casename);
  if (!(fp = fopen(s, "r")))
    error("Could not open .DOC file.", FATAL);
  if (fgets(s, MaxLineLength, fp) == NULL)
    error("Could not read from .DOC file.", FATAL);
  s[strlen(s)-1] = '\0'; /* Get rid of newline at end of string. */
  fclose(fp);

/* Put case title on plot page beneath the plot. */
  mx = 0.0;
  my = -0.8; 
  mlen = strlen(s);
  messag_(s, &mlen, &mx, &my, mlen);

/* Open input file with read access. */
  if (!(fp = fopen(infile, "r")))
    error("Could not open input data file for reading.", FATAL);

/* Allocate space for x and y arrays of points. */ 
  x = (_float_ *) malloc(sizeof(_float_) * npts);
  y = (_float_ *) malloc(sizeof(_float_) * npts);

/* Allocate space for legend_exists array. */
  legend_exists = (_int_ *) malloc(sizeof(_int_) * (ntrace+1));

/* Initialize legend_exists[*] to zero. */
  for(i=0; i<MIN(ntrace+1,MaxLeg); i++)
    legend_exists[i] = 0;

/* Read lines from the input data file until EOF. */
  tracenum = starting_marker;
  pointnum = 0;
  while (fgets(s, MaxLineLength, fp) != NULL) {
    s[strlen(s)-1] = '\0'; /* Get rid of newline at end of string. */

  /*
     If first character is a ", then characters that follow comprise the legend
     for that trace.
  */
    if (*s == '"') {
      if (tracenum >= MaxLeg-1) continue;
      if (legnd[tracenum] == NULL)
        legnd[tracenum] = (char *) malloc(MaxLineLength);
      sprintf(legnd[tracenum], "%s$%d$", &s[1], tracenum);
      legend_exists[tracenum] = 1;
    }

  /*
     If line is empty and we have read at least one point,
     then we are finished with the current trace.  Draw the curve.
  */
    else if (*s == '\0' && pointnum) {
      drawcurve(legnd, legend_exists, &tracenum,
                x, y, pointnum, options -> mark);
      tracenum++;
      pointnum = 0;
    }
  /* 
     If more than one blank line or if blank appears before any data, do
     nothing with the second blank line.
  */
    else if (*s == '\0' && !pointnum)
      continue;
  /*
     If a comment character (#) appears in the first column anywhere in the
     file, ignore it.
  */
    else if (*s == '#')
      continue;
  /*
     If none of the above is true, then parse the string into an x & y value.
  */
    else {
      if (sscanf(s, "%f%f", &x[pointnum], &y[pointnum]) != 2)
        error("Input data in bad format!", FATAL);
      pointnum++;
    } /* end else */
  } /* end while */

  fclose(fp);

/* Draw the last curve if there are points. */
  if (pointnum) {
    drawcurve(legnd, legend_exists, &tracenum,
              x, y, pointnum, options -> mark);
    tracenum++;
    pointnum = 0;
  }

  tracenum--;
  free(x);
  free(y);

/* Pack legend lines into pak with lines_ */
  pak = (char *) malloc((MaxLineLength + 4) * ntrace);
  *pak = '\0';
  for (k = starting_marker; k < MIN(tracenum+1, MaxLeg); k++) {
    if (legend_exists[k]) {
      lines_(legnd[k], pak, &k, strlen(legnd[k]), strlen(pak));
      free(legnd[k]);
    }
  }

  free(legend_exists);

/* Draw legend.  (unless no markers) */
  xleg = 0.0;
  yleg = ydim + 0.4;
  if ((options -> mark) && (*pak != '\0')) {
    legend_(pak, &tracenum, &xleg, &yleg, strlen(pak));
  }
  free(pak);

/* End plot. */
  endpl_(&pointnum);

/* Done plot. */
  donepl_();

} /* end drawplots */



/*
drawcurve: draws the requested curve given the following conditions:

    legend               style of curve drawn             legend drawn?
   --------             ----------------------           ---------------
 "Undeformed"                dashed line                        NO
 "Deformed"                   solid line                        NO
 "Model Geometry"             solid line                        NO
 "Ring Locations"            markers only                      YES
  anything else       taken from command-line args             YES

Parameters:   -->         legend: the array of legend strings
             <-->  legend_exists: the array of booleans for existence of legend
             <-->      *tracenum: the number of the current trace.
              -->             *x: array of x values (passed to "curve_")
              -->             *y: array of y values (passed to "curve_")
              -->       pointnum: dimension of x and y (passed to "curve_")
              -->           mark: marker style (passed to "curve_")
*/
void drawcurve(char **legend, _int_ *legend_exists, _int_ *tracenum,
               _float_ *x, _float_ *y, _int_ pointnum, _int_ mark)
{

/* local vars. */
  static _int_ prev_legend_number = 0;
  _int_ curr_legend_number;
 
  if (legend[*tracenum] == NULL)
    curr_legend_number = prev_legend_number;
  else
    curr_legend_number = *tracenum;
 
  if (!strncmp(legend[curr_legend_number],
               "Undeformed", strlen("Undeformed"))) {
    mark = 0;
    dash_();
    curve_(x, y, &pointnum, &mark);
    reset_("DASH", strlen("DASH"));
    legend_exists[curr_legend_number] = 0;
    *tracenum = curr_legend_number;
  } else

  if (!strncmp(legend[curr_legend_number], "Deformed", strlen("Deformed")) ||
      !strncmp(legend[curr_legend_number],
               "Model Geometry", strlen("Model Geometry"))) {
    mark = 0;
    curve_(x, y, &pointnum, &mark);
    legend_exists[curr_legend_number] = 0;
    *tracenum = curr_legend_number;
  } else

  if (!strncmp(legend[curr_legend_number],
               "Ring Location", strlen("Ring Location"))) {
    mark = -1;
    marker_(&curr_legend_number);
    curve_(x, y, &pointnum, &mark);
  } else

    curve_(x, y, &pointnum, &mark);

  prev_legend_number = curr_legend_number;
}



/*
findminmax: finds the minimum x & y values, the maximum x & y values, the
number of points in the largest data set, and the number of data sets
(traces) in the file infile.

Parameters:   -->  infile: name of filename containing plot data
              <-- *ntrace: number of data sets (traces) in the input file
              <--   *npts: number of points in the largest data set
              <--   *xmin: the minimum x-value in all of the data sets
              <--   *xmax: the maximum x-value in all of the data sets
              <--   *ymin: the minimum y-value in all of the data sets
              <--   *ymax: the maximum y-value in all of the data sets
*/
void findminmax(char *infile, _int_ *ntrace, _int_ *npts, _float_ *xmin,
                _float_ *xmax, _float_ *ymin, _float_ *ymax)
{
/* Declare local vars. */
  FILE *fp;
  _float_ x, y;
  _int_ pointnum;
  char s[MaxLineLength];

/* Initialize returned arguments. */
  *npts = 0;
  *ntrace = 0;
  *xmin = MAXFLOAT;
  *xmax = -MAXFLOAT;
  *ymin = MAXFLOAT;
  *ymax = -MAXFLOAT;

/* Open input file with read access. */
  if (!(fp = fopen(infile, "r")))
    error("Could not open input data file for reading.", FATAL);

  pointnum = 0;
  while (fgets(s, MaxLineLength, fp) != NULL) {

    s[strlen(s)-1] = '\0'; /* Get rid of newline at end of string. */

    if (sscanf(s, "%f%f", &x, &y) == 2) { 
      *xmin = MIN(*xmin, x);  /* two floats successfully parsed */
      *xmax = MAX(*xmax, x);
      *ymin = MIN(*ymin, y);
      *ymax = MAX(*ymax, y);
      pointnum++;
    }

    else if (*s == '"') /* Legend encountered.  Ignore it. */
      continue;

    else if (*s == '#') /* Comment encountered. Ignore it. */
      continue;

    else if (pointnum) {  /* If we've just finished parsing a set,
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

/* Close input data file. */
  fclose(fp);

} /* end findminmax */




/*
findpminmax: determines a visually pleasing range for the plots given
the actual minimum and maximum values.  findpminmax also returns a
pleasing step size.

Parameters:   --> samescale: if x & y axes have same scale, set to 1,
                             zero otherwise
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
void findpminmax(_int_ samescale, _float_ xmin, _float_ xmax, _float_ ymin,
                 _float_ ymax, _float_ *pxmin, _float_ *pxstp, _float_ *pxmax,
                 _float_ *pymin, _float_ *pystp, _float_ *pymax)
{
/* Declare local vars. */
  _float_ rangex, rangey;

  if (fabs(xmax - xmin) < EPSILON)
    if (fabs(xmax + xmin) / 2.0 >= 1.0) {
      xmin -= 1.0 * pow(10.0, truncate(log10(fabs(xmax + xmin) / 2.0)));
      xmax += 1.0 * pow(10.0, truncate(log10(fabs(xmax + xmin) / 2.0)));
    }
    else {
      xmin -= 1.0;
      xmax += 1.0;
    }
  
  if (fabs(ymax - ymin) < EPSILON)
    if (fabs(ymax + ymin) / 2.0 >= 1.0) {
      ymin -= 1.0 * pow(10.0, truncate(log10(fabs(ymax + ymin) / 2.0)));
      ymax += 1.0 * pow(10.0, truncate(log10(fabs(ymax + ymin) / 2.0)));
    }
    else {
      ymin -= 1.0;
      ymax += 1.0;
    }
  

  if (samescale) {
    *pxmax = 0.5 * (xmax + xmin + MAX(xmax-xmin, ymax-ymin));
    *pxmin = 0.5 * (xmax + xmin - MAX(xmax-xmin, ymax-ymin));
    *pymax = 0.5 * (ymax + ymin + MAX(xmax-xmin, ymax-ymin));
    *pymin = 0.5 * (ymax + ymin - MAX(xmax-xmin, ymax-ymin));
  }
  else {
    *pxmax = xmax;
    *pxmin = xmin;
    *pymax = ymax;
    *pymin = ymin;
  }
  
  gridar(pxmin, pxmax, pxstp);
  gridar(pymin, pymax, pystp);

  if (samescale) { /* Check to make sure axes cover the same ranges. */
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
  _float_ range, tmin, tmax;

/* Logic */
  range = fabs(*max - *min);
  if (range <= 0.0) range = 5.0;
  *step = pow(10.0, floor(log10(range)) * 1.0 - 1.0);
  if (range / *step < 5.0) *step = *step / 2.0;
  if (range / *step > 10.0) *step = 2.0 * (*step);
  if (range / *step > 10.0) *step = 5.0 * (*step) / 2.0;
  if (range / *step > 10.0) *step = 2.0 * (*step);

  tmin = *step * truncate(*min / *step);
/*  if (tmin < 0.0) tmin = 1.0001 * tmin;
*/
  if (tmin > *min) tmin = tmin - *step;
  *min = tmin;
  tmax = *step * truncate(*max / *step);
/*  if (tmax > 0.0 ) tmax = 1.0001 * tmax;
*/
  if (tmax < *max) tmax = tmax + *step;
  *max = tmax;

} /* end gridar */

