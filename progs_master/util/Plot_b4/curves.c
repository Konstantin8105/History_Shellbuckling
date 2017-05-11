
/*
connpt: connects new point with old point set by previous call to connpt
or strtpt.
*/
void connpt_(_float_ *xto, _float_ *yto)
{

  if (level < 2 || level > 3) {
    derror("Level must be 2 or 3.  Routine: connpt", !FATAL);
    return;
  }

  if (!pointset) {
    derror("No current point.  Routine: connpt", !FATAL);
    return;
  }
  
  fprintf(fp, "%%\n%% Draw line from current point to (%.2f, %.2f) inches.\n",
                                                     *xto, *yto);
  fprintf(fp, "%.2f %.2f l\n", *xto*DPI, *yto*DPI);
  fprintf(fp, "stroke\n");
  fprintf(fp, "%.2f %.2f m\n", *xto*DPI, *yto*DPI);

}

/*
curve: Plots data points with curve markers and draws the connecting
curve,  Each time curve is called, a new marker symbol is used.  Works
only for rectangular coordinates on linear axes.
*/
void curve_(_float_ *x, _float_ *y, _int_ *number, _int_ *mark)
/*
Arguments:   x - array of x-values to plot and/or interpolate
             y - array of y-values to plot and/or interpolate
       *number - number of points in arrays x and y
         *mark - marker specification:
                 mark > 0 -- points are interpolated and a marker will
                             be written at every mark symbol
                 mark < 0 -- points are not interpolated and a marker
                             will be written at every mark symbol
                 mark = 0 -- points are interpolated and no marker will
                             be written
*/
{
_int_ i, r;
_float_ xconv, yconv, xoff, yoff;

if (level != 3) {
  derror("Level must be 3.  Routine: curve", !FATAL);
  return;
}

{ /* begin block */
/*
   Set up a static var, errcond, so that the error message below is only
   printed once per program execution.
*/
static _int_ errcond = FALSE;
/* Check to make sure x & y values are within plot area. */
  for(i=0; (i < *number) && !errcond ; i++)
    if (x[i] + EPSILON < plot.xmin || x[i] - EPSILON > plot.xmax ||
        y[i] + EPSILON < plot.ymin || y[i] - EPSILON > plot.ymax) {
      derror("Plot values do not all lie within plot rectangle.", !FATAL);
      errcond = TRUE;
      break;
    }
} /* end block */

/* Set conversion factor for actual to screen coordinates. */
  xconv = plot.xlen * DPI / (plot.xmax - plot.xmin);
  yconv = plot.ylen * DPI / (plot.ymax - plot.ymin);
  xoff  = -plot.xmin;
  yoff  = -plot.ymin;

/* Set clip region for plotting markers and drawing curves. */
  fprintf(fp, "%%\n%% set clip region for markers and curves.\n");
  fprintf(fp, "gsave\n");
  fprintf(fp, "newpath\n");
  fprintf(fp, "%.2f %.2f m\n", -0.5 * (MarkerDia + MarkLineThick),
                               -0.5 * (MarkerDia + MarkLineThick));
  fprintf(fp, "%.2f %.2f rl\n", 0.0,
                                plot.ylen*DPI + (MarkerDia + MarkLineThick));
  fprintf(fp, "%.2f %.2f rl\n", plot.xlen*DPI + (MarkerDia + MarkLineThick),
                                0.0);
  fprintf(fp, "%.2f %.2f rl\n", 0.0,
                                -(plot.ylen*DPI + (MarkerDia + MarkLineThick)));
  fprintf(fp, "closepath\n");
  fprintf(fp, "clip\n");
  fprintf(fp, "newpath\n");

/* Set pen to current color. */
  fprintf(fp, "%%\n%% set color. \n");
  fprintf(fp, "%.5f %.3f %.3f sethsbcolor\n", color.hue,
					      color.saturation,
					      color.intensity);

/* Plot markers if requested. */
  if (*mark) {
    plot.marker[markr] = *mark;

/* Make sure markers are plotted using solid lines. */
    fprintf(fp, "%%\n%% plot markers using solid lines.\n");
    fprintf(fp, "gsave\n");
    line_();

/*
    If markers printed at every *mark data points, then randomly offset the
    start of the sequence.
*/
    r = abs(random() - time((_int_ *) 0));
    for (i=0; i < *number; i++)
      if (!(abs(i - r) % *mark))
        fprintf(fp, "%.2f %.2f %.3f M%d\n",
                    xconv*(x[i] + xoff), yconv*(y[i] + yoff),
                    markerscale, markr);

/*  Restore graphic state in case lines use a style other than continuous. */
    fprintf(fp, "%%\n%% restore previous graphic state\n");
    fprintf(fp, "grestore\n");

  } /* if */

/* Plot line trace if requested. */
  if (*mark >= 0) {
    fprintf(fp, "%%\n%% plot line trace\n");
    fprintf(fp, "newpath\n");
    fprintf(fp, "%.2f %.2f m\n", xconv*(x[0] + xoff),
                                 yconv*(y[0] + yoff));
    for (i=1; i < *number; i++) {
      fprintf(fp, "%.2f %.2f l\n", xconv*(x[i] + xoff),
                                   yconv*(y[i] + yoff));
      if (i % MaxPath == 0) {
        fprintf(fp, "%%\n%% draw path & clear path buffer.\n");
        fprintf(fp, "%.2f setlinewidth\n", plot.linethick);
        fprintf(fp, "%d setlinejoin\n", RoundJoin);
        fprintf(fp, "stroke\n");
        fprintf(fp, "%%\n%% establish new path.\n");
        fprintf(fp, "newpath\n");
        fprintf(fp, "%.2f %.2f m\n", xconv*(x[i] + xoff),
                                     yconv*(y[i] + yoff));
      }
    }
    fprintf(fp, "%.2f setlinewidth\n", plot.linethick);
    fprintf(fp, "%d setlinejoin\n", RoundJoin);
    fprintf(fp, "stroke\n");
  } /* end if */

/* Restore graphic state previous to clipping. */
  fprintf(fp, "%%\n%% Restore graphic state previous to clipping.\n");
  fprintf(fp, "grestore\n");

  legnd.drawit[markr] = -1;
  markr = (markr + 1) % MaxLeg;
  pointset = 0;

/* Reset pen color to black. */
  newclr_("BLAC", 4);
  fprintf(fp, "%%\n%% set color to black. \n");
  fprintf(fp, "%.2f setgray\n", 0.0);

} /* end curve */

/*
strtpt: moves the current point to the coordinates (xto, yto) without drawing
a line.
*/
void strtpt_(_float_ *xto, _float_ *yto)
{

  if (level < 2 || level > 3) {
    derror("Level must be 2 or 3.  Routine: strtpt", !FATAL);
    return;
  }

  fprintf(fp, "%%\n%% Move current point to (%.2f, %.2f) inches\n", *xto, *yto);
  fprintf(fp, "newpath\n");
  fprintf(fp, "%.2f %.2f m\n", *xto*DPI, *yto*DPI);

  pointset = 1;
}
  
/*
vector: draws a vector with the end points specified in inches from the
current physical origin.
Note:  This version assumes vec = 0.  (i.e. No arrow heads are drawn.)
*/
void vector_(_float_ *xfrom, _float_ *yfrom, _float_ *xto, _float_ *yto, _int_ *vec)
{

  if (level < 2 || level > 3) {
    derror("Level must be 2 or 3.  Routine: vector", !FATAL);
    return;
  }

  if (*vec != 0)
    derror("Vector will be drawn without arrow heads.  Sorry.", !FATAL);

  fprintf(fp, "%%\n%% Draw vector from (%.2f, %.2f) to (%.2f, %.2f) inches.\n",
              *xfrom, *yfrom, *xto, *yto);
  fprintf(fp, "newpath\n");
  fprintf(fp, "%.2f %.2f m\n", *xfrom*DPI, *yfrom*DPI);
  fprintf(fp, "%.2f %.2f l\n", *xto*DPI, *yto*DPI);
  fprintf(fp, "stroke\n");

}

