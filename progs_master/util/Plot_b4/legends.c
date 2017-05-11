
/*
angle: Writes all annotation from messag_, realno_, intno_, rlmess_,
rlreal_, rlint_ at the specified angle.
*/
void angle_(_float_ *ang)
{

  if (level < 1 || level > 3) {
    derror("Level must be 1, 2, or 3.  Routine: angle", !FATAL);
    return;
  }

  mess_angle = *ang;
}

/*
lines: Produces lines of text for use by legend by packing an internal
array of lines each terminated by a "$" and returns a pointer
through idry_r.
*/
void lines_(char *strng, char *idry_r, _int_ *iline, _int_ lstrng, _int_ lidry_r)
/*
Arguments:    strng - a string of characters describing a line of a 
		      legend.
	     idry_r - an array of characters into which lstrng and
		      *iline are packed.  Memory for idry_r must be
		      allocated by the calling sub-program.
	     *iline - sequence number of lstrng.
	     lstrng - length of strng.
	    lidry_r - length of idry_r.
*/
{
_int_ i, currline;
char temp[5], *s;

  if (level < 1 || level > 3) {
    derror("Level must be 1, 2, or 3.  Routine: lines", !FATAL);
    return;
  }

/* Initialize idry_r if legnd.eopkray is zero. */
  if (legnd.eopkray == 0)
    idry_r[0] = '\0';

  i = strcspn(strng, "$");
  s = malloc(i + 1);
  strnlcpy(s, strng, i);
  fixstring(s);

/* Pack characters of lstrng into idry_r. */
  strcat(idry_r, s);
  legnd.eopkray += strlen(s);

  free(s);
/*
   If curve not using current marker, increment i so legend is
   associated with next used marker.
*/
  for (i = 0; (legnd.drawit[(*iline + i) % MaxLeg] != -1)
	      && (i < MaxLeg); i++)
    ;
  currline = (*iline + i) % MaxLeg;

/* Pack legend number iline into idry_r. */
  sprintf(temp, "$%2d$", currline);

  strcat(idry_r, temp);
  legnd.eopkray += strlen(temp);

/* Update status variables. */
  legnd.drawit[currline] = 1;
  legnd.numleg = MIN(legnd.numleg + 1, MaxLeg);
}

/*
linest: initializes the array pkray into which packed lines of text
will be stored.  The function returns the maximum number of lines that
can be packed into an array.
*/
_int_ linest_(char *pkray, _int_ *nwords, _int_ *maxchar, _int_ lpkray)
/*
Arguments:   pkray - array of characters allocated by the calling
		     sub-program into which lines of the legend are
		     packed
	   *nwords - number of words allocated for pkray (typically
		     4 bytes per word, 32-bit words on most machines)
	  *maxchar - number of characters in longest line.
	    lpkray - length of pkray.
*/
{
_int_ max;

  if (level < 1 || level > 3) {
    derror("Level must be 1, 2, or 3.  Routine: linest", !FATAL);
    return(-1);
  }

  max = (*nwords * CPW) / (*maxchar + 4);
  return(max);
}

/*
messag: draws str at (x, y) inches from the current physical origin.
*/
void messag_(char *str, _int_ *lstr, _float_ *x, _float_ *y, _int_ llstr)
/*
Arguments:   str - a charcter string to be written at (*x, *y).
	   *lstr - the length of str.  (Including the terminator if it exists)
	      *x - the x-ordinate of the lower left corner of str
	      *y - the y-ordinate of the lower left corner of str
	   llstr - length of str.
*/
{
char s[MaxLineLength];
_int_ eos, i;

  if (level < 2 || level > 3) {
    derror("Level must be 2 or 3.  Routine: messag", !FATAL);
    return;
  }

  eos = strcspn(str, "$");
  i = MIN(MIN(eos, MaxLineLength), *lstr);
  strnlcpy(s, str, i);
  fixstring(s);
  fprintf(fp, "%%\n%% draw string at (%.2f, %.2f) inches\n", *x, *y);
  fprintf(fp, "%.2f /%s ChooseFont\n", MessFSize*fontscale, MessFont);
  fprintf(fp, "newpath\n");
  fprintf(fp, "%.2f rotate\n", mess_angle);
  fprintf(fp, "(%s) %.2f %.2f %d JustString\n", escapeParens(s),
              (*x)*DPI, (*y)*DPI, 8);
  fprintf(fp, "%.2f rotate\n", -mess_angle);

/* Update bb struct. */
  bb.left = MIN(bb.left, (*x - sin(mess_angle*PI/180.0) *
			 MessFSize*fontscale/DPI) *
			 plot.sf + o.x);
  bb.right = MAX(bb.right, (*x + strlen(s) * cos(mess_angle*PI/180.0) /
			   ((MessFcpi-3.0*MessFcpiSD)/fontscale)) *
			   plot.sf + o.x);
  bb.bottom = MIN(bb.bottom, (*y - MessFSize*fontscale/3/DPI) * plot.sf + o.y);
  bb.top = MAX(bb.top, (*y + strlen(s) * sin(mess_angle*PI/180.0) /
			     ((MessFcpi-3.0*MessFcpiSD)/fontscale) +
			     MessFSize*fontscale/DPI *
			     cos(mess_angle*PI/180.0)) *
		       plot.sf + o.y);
}

/*
mylegn: changes the word "LEGEND" to a user-supplied string as a
heading when legend is called.
*/
void mylegn_(char *str, _int_ *lstr, _int_ llstr)
/*
Arguments:   str - a character string containing the new legend header.
	   *lstr - number of characters in str (including the
		   terminator character).
	   llstr - length of str.
*/
{
_int_ eos, i;

  if (level < 1 || level > 3) {
    derror("Level must be 1, 2, or 3.  Routine: mylegn", !FATAL);
    return;
  }

  eos = strcspn(str, "$");
  i = MIN(MIN(eos, MaxLineLength), *lstr);
  strnlcpy(legnd.heading, str, i);
  fixstring(legnd.heading);
}


/*
set_customleg: sets the plot.customleg variable to TRUE so that the white
rectangle will be drawn around the legend when it is drawn.
*/
void set_customleg(_int_ b)
{

  if (level < 1 || level > 3) {
    derror("Level must be 1, 2, or 3.  Routine: set_customleg", !FATAL);
    return;
  }

  plot.customleg = b;

}

/*
updateLegend: inserts a new legend line into the legend as defined by the
type, leg_type.  Function returns the number of lines currently in the
legend (1-19).  If legend is full and updateLegend was unsuccessful, 20 is
returned.  If there is some other error, a number less than 0 is returned.
*/
_int_ updateLegend(_int_ marker, _float_ lineThick,
                   enum linestyle_type lineStyle,
                   char *color, char *text)
/*
Parameters:
                 --> marker:    marker associated with the current legend line.
                 --> lineThick: trace line thickness associated with the current
				legend line.
                 --> lineStyle: trace line style associated with the current
				legend line.
                 --> color:     trace line color associated with the current
				legend line.
                 --> text:      text associated with current legend line.
*/
{
  _int_ i;

  if (level != 3) {
    derror("Level must be 3.  Routine: updateLegend", !FATAL);
    return(-1);
  }

  if (leg.lines == MaxLeg)
    return(20);

  i = leg.lines;

/* Set next line in leg structure. */
  leg.marker[i] = marker;
  leg.lineThick[i] = lineThick;
  leg.lineStyle[i] = lineStyle;
  strcpy(leg.color[i], color);
  strcpy(leg.text[i], text);

  leg.lines++;
  return(leg.lines);
}

_float_ legtext_x_offset = 0.35, legtit_y_offset = 0.15,
        legmark_x_offset = 0.15, legline_y_offset = 0.09,
        legend_x_margin = 0.06,  legend_y_margin = 0.06;

/*
drawLegend: draws the current legend so that the lower left corner of the
legend is located at the coordinates (x, y) inches from the origin.
*/
void drawLegend(_float_ x, _float_ y)
/*
  Parameters:
                 --> x: x ordinate of lower-left corner of legend location on
                        page (in inches).
                 --> y: y ordinate of lower-left corner of legend location on
                        page (in inches).
*/
{
_int_ i, n, just = 1;
_float_ xleg, yleg, borderthick = 0.007, shadowthick = 0.04;

  if (level != 3) {
    derror("Level must be 3.  Routine: drawLegend", !FATAL);
    return;
  }

/*
Find xleg and yleg, the predicted width and height in inches of the legend.
*/
  for (i=0, n=0; i<leg.lines; i++)
    n = MAX(n, strlen(leg.text[i]));
  xleg = ((_float_) n) /
	 ((LegendFcpi - 3.0*LegendFcpiSD)/fontscale) + legtext_x_offset;
  yleg = ((_float_) leg.lines + 
          ((_int_) leg.heading[0] ? 1.0 : 0.0) + 
          legtit_y_offset) / 
         (LegendFlpi / fontscale);

/*
Set markr to -1 to indicate that we've finished drawing the traces
for one plot.
*/
  markr = -1;

/* Scale margins and offsets by fontscale. */
  legend_x_margin *= fontscale;
  legend_y_margin *= fontscale;
  legline_y_offset *= fontscale;

  fprintf(fp, "%%\n%% draw legend\n");
  fprintf(fp, "%.2f /%s ChooseFont\n", LegendFSize*fontscale, LegendFont);

/* Draw white rectangle over legend area so legend is readable. */
  if (plot.customleg) {

/* Run each legend line through the PS interpreter and find the longest line.
   Save the length of this line on the stack and use it to determine the
   right-hand side of the legend bounding box.
*/
    fprintf(fp, "%%\n%% Determine length of longest legend string.\n");
    fprintf(fp, "%%\n%% Push width of the legend heading onto the stack.\n");
    fprintf(fp, "(%s) stringwidth pop\n", leg.heading);
    fprintf(fp, "%%\n%% Loop over legend lines to find longest legend.\n");
    for(i = 0; i < leg.lines; i++) {
      fprintf(fp, "%.2f (%s) stringwidth pop add\n", legtext_x_offset*DPI,
						     leg.text[i]);
      fprintf(fp, "%d copy\n", 2);
      fprintf(fp, "gt\n");
      fprintf(fp, "{pop} {exch pop} ifelse\n");
    }
    fprintf(fp, "dup\n");
    fprintf(fp, "%%\n%% Draw filled-white rectangle.\n");
    fprintf(fp, "newpath\n");
    fprintf(fp, "%.2f %.2f m\n", (x - legend_x_margin)*DPI,
				 (y - legend_y_margin)*DPI);
    fprintf(fp, "%.2f %.2f rl\n", 0.0, (yleg + legend_y_margin*2.0)*DPI);
    fprintf(fp, "%.2f add %.2f rl\n", (legend_x_margin*2.0)*DPI, 0.0);
    fprintf(fp, "%.2f %.2f rl\n", 0.0, (-yleg - legend_y_margin*2.0)*DPI);
    fprintf(fp, "closepath\n");
    fprintf(fp, "%.2f setgray gsave fill grestore\n", 1.0);
    fprintf(fp, "%.2f setlinewidth\n", borderthick*DPI);
    fprintf(fp, "%d setlinejoin\n", 0);
    fprintf(fp, "%.2f setgray\n", 0.0);
    fprintf(fp, "stroke\n");

/* True shadow box. */
    fprintf(fp, "%%\n%% Draw shadow box for legend rectangle\n");
    fprintf(fp, "newpath\n");
    fprintf(fp, "%.2f %.2f m\n", (x - legend_x_margin + shadowthick)*DPI,
				 (y - legend_y_margin - 0.5*borderthick)*DPI);
    fprintf(fp, "%.2f %.2f rl\n", 0.0,
                                 -shadowthick*DPI);
    fprintf(fp, "%.2f add %.2f rl\n",
                             (legend_x_margin*2.0 + 0.5*borderthick)*DPI, 0.0);
    fprintf(fp, "%.2f %.2f rl\n", 0.0, (yleg + legend_y_margin*2.0 +
                                        0.5*borderthick)*DPI);
    fprintf(fp, "%.2f %.2f rl\n", -shadowthick*DPI, 0.0);
    fprintf(fp, "%.2f %.2f rl\n", 0.0, -(yleg + legend_y_margin*2.0 +
                                         0.5*borderthick - shadowthick)*DPI);
    fprintf(fp, "closepath\n");
    fprintf(fp, "%.2f setgray fill\n", 0.0);

/* "shadow" box with beveled corners. */
/*
    fprintf(fp, "newpath\n");
    fprintf(fp, "%.2f %.2f m\n", (x - legend_x_margin - 0.5*borderthick)*DPI,
				 (y - legend_y_margin - 0.5*borderthick)*DPI);
    fprintf(fp, "%.2f %.2f rl\n", sqrt(2.0 * SQR(shadowthick * DPI)),
                                 -sqrt(2.0 * SQR(shadowthick * DPI)));
    fprintf(fp, "%.2f add %.2f rl\n",
                             (legend_x_margin*2.0 + borderthick)*DPI, 0.0);
    fprintf(fp, "%.2f %.2f rl\n", 0.0, (yleg + legend_y_margin*2.0 +
                                        0.5*borderthick)*DPI);
    fprintf(fp, "%.2f %.2f rl\n", -sqrt(2.0 * SQR(shadowthick * DPI)),
                                   sqrt(2.0 * SQR(shadowthick * DPI)));
    fprintf(fp, "%.2f %.2f rl\n", 0.0, -(yleg + legend_y_margin*2.0 +
                                         0.5*borderthick)*DPI);
    fprintf(fp, "closepath\n");
    fprintf(fp, "%.2f setgray fill\n", 0.0);
*/

/* Update bb struct. */
    bb.bottom = MIN(bb.bottom, (y - legend_y_margin - 0.5*borderthick -
                                shadowthick) * plot.sf + o.y);
    bb.top = MAX(bb.top, (y + yleg + legend_y_margin + 0.5*borderthick) *
			 plot.sf + o.y);
    bb.left = MIN(bb.left, (x - legend_x_margin - 0.5*borderthick) *
			   plot.sf + o.x);
    bb.right = MAX(bb.right, (x + xleg + legend_x_margin + 0.5*borderthick +
                              shadowthick) * plot.sf + o.x);
  }
  else {
/* Update bb struct. */
    bb.bottom = MIN(bb.bottom, (y) * plot.sf + o.y);
    bb.top = MAX(bb.top, (y + yleg) * plot.sf + o.y);
    bb.left = MIN(bb.left, (x) * plot.sf + o.x);
    bb.right = MAX(bb.right, (x + xleg) * plot.sf + o.x);
  }

  for(i = leg.lines-1; i >= 0; i--) {

  /* Set pen color to current color for trace/marker. */
      newclr_(leg.color[i], strlen(leg.color[i]));
      fprintf(fp, "%%\n%% set color for legend %d\n", i);
      fprintf(fp, "%.5f %.3f %.3f sethsbcolor\n", color.hue,
						  color.saturation,
						  color.intensity);

      fprintf(fp, "%%\n%% draw legend %d\n", i);

  /* Plot markers in legend if markers appear in plot. */
      if (leg.marker[i] >= 0)
	fprintf(fp, "%.2f %.2f %f M%d\n", (x + legmark_x_offset)*DPI,
		(y + (leg.lines-i-1)/(LegendFlpi/fontscale) + legline_y_offset)*DPI,
		1.0, leg.marker[i]);

  /* Plot line segments in legend if no markers appear in plot. */
      else {

        fprintf(fp, "gsave\n");
        switch (leg.lineStyle[i]) {
          case LINE:
            line_();
            break;
          case DASH:
            dash_();
            break;
          case DOT:
            dot_();
            break;
          case CHNDSH:
            chndsh_();
            break;
          case CHNDOT:
            chndot_();
            break;
        }
        fprintf(fp, "newpath\n");  /* insert newpath here (Jan18,95, FAB) */
	fprintf(fp, "%.2f %.2f m\n", x*DPI,
	       (y + (leg.lines-i-1)/(LegendFlpi/fontscale) + legline_y_offset)*DPI);
	fprintf(fp, "%.2f %.2f rl\n", 0.3*DPI, 0.0);
	fprintf(fp, "%.2f setlinewidth\n", leg.lineThick[i]);
	fprintf(fp, "%d setlinejoin\n", RoundJoin);
	fprintf(fp, "stroke\n");
        fprintf(fp, "grestore\n");
      }

  /* Reset pen color to black for remainder of legend line. */
      fprintf(fp, "%%\n%% set color to black for remainder of line. \n");
      fprintf(fp, "%.2f setgray\n", 0.0);

  /* Finish printing legend. */
      fprintf(fp, "(%s) %.2f %.2f %d JustString\n",
                  escapeParens(leg.text[i]),
		  (x + legtext_x_offset)*DPI,
		  (y + legline_y_offset +
		   (leg.lines-i-1)/(LegendFlpi/fontscale))*DPI,
                  just);

    } /*  for(i = leg.lines-1; i >= 0; i--)  */

  fprintf(fp, "%%\n%% draw legend heading\n");
  fprintf(fp, "(%s) %.2f %.2f %d JustString\n",
              escapeParens(leg.heading),
              (x)*DPI,
	      (y + (leg.lines + legtit_y_offset)/
               (LegendFlpi/fontscale) + legline_y_offset)*DPI,
              just);

}




/*
Old-style legend functions for DISSPLA compatibility.
*/

/*
legend: Places a legend at (x, y) inches from the current physical
origin.
*/
void legend_(char *pkray, _int_ *nlines, _float_ *x, _float_ *y, _int_ lpkray)
/*
Arguments:   pkray - an array of characters containing each line of the
		     legend.  The array format may be as follows:

		   First Legend$ 1$Third Legend$03$Second Legend$2$

		     Notice that the legends do not necessarily have to
		     be packed in order and that each legend consists
		     two "fields" in pkray, the actual characters of
		     the legend, and the number of the legend.  (This 
		     number is later associated with the appropriate
		     marker symbol as defined by define_markers().)
		     The "$" is the delimiting character for pkray.
		     Memory for pkray must be allocated by the calling
		     sub-program.
	   *nlines - the number of lines contained in the legend.
		*x - the x-ordinate of the lower left corner of the 
		     "legend rectangle".
		*y - the y-ordinate of the lower left corner of the 
		     "legend rectangle".
	    lpkray - length of pkray.
*/
{
char leglines[MaxLeg][MaxLineLength], *l, *lnum, pak[MaxLineLength*MaxLeg+1];
_int_ i, legsofar, lastline, just = 1;
_float_ xleg, yleg, borderthick = 0.007, shadowthick = 0.04;

  if (level != 3) {
    derror("Level must be 3.  Routine: legend", !FATAL);
    return;
  }

/*
Set markr to -1 to indicate that we've finished drawing the traces
for one plot.
*/
  markr = -1;

/* Scale margins and offsets by fontscale. */
  legend_x_margin *= fontscale;
  legend_y_margin *= fontscale;
  legline_y_offset *= fontscale;

  fprintf(fp, "%%\n%% draw legend\n");
  fprintf(fp, "%.2f /%s ChooseFont\n", LegendFSize*fontscale, LegendFont);

  strnlcpy(pak, pkray, legnd.eopkray+1);

  for(i=0; i<legnd.numleg; i++) {
    if (i == 0)
      l = (char *) strtok(pak, "$");
    else
      l = (char *) strtok(NULL, "$");
    lnum = (char *) strtok(NULL, "$");

/* Copy l into leglines[atoi(lnum)]. */
    if (l != NULL)
      strcpy(leglines[atoi(lnum)], l);
  }

  lastline = atoi(lnum);

/* Determine legend dimensions. */
  xlegnd_(&xleg, pkray, &legnd.numleg, strlen(pkray));
  ylegnd_(&yleg, pkray, &legnd.numleg, strlen(pkray));

/* Draw white rectangle over legend area so legend is readable. */
  if (plot.customleg) {

/* Run each legend line through the PS interpreter and find the longest line.
   Save the length of this line on the stack and use it to determine the
   right-hand side of the legend bounding box.
*/
    fprintf(fp, "%%\n%% Determine length of longest legend string.\n");
    fprintf(fp, "%%\n%% Push width of the legend heading onto the stack.\n");
    fprintf(fp, "(%s) stringwidth pop\n", legnd.heading);
    fprintf(fp, "%%\n%% Loop over legend lines to find longest legend.\n");
    for(i = lastline, legsofar = 0;
	legsofar < legnd.numleg;
	i = ((i == 0) ? (MaxLeg-1) : (i-1)), legsofar++)
      if (legnd.drawit[i] > 0) {
        fprintf(fp, "%.2f (%s) stringwidth pop add\n", legtext_x_offset*DPI,
                                                       leglines[i]);
        fprintf(fp, "%d copy\n", 2);
        fprintf(fp, "gt\n");
        fprintf(fp, "{pop} {exch pop} ifelse\n");
      }
    fprintf(fp, "dup\n");
    fprintf(fp, "%%\n%% Draw filled-white rectangle.\n");
    fprintf(fp, "newpath\n");
    fprintf(fp, "%.2f %.2f m\n", (*x - legend_x_margin)*DPI,
				 (*y - legend_y_margin)*DPI);
    fprintf(fp, "%.2f %.2f rl\n", 0.0, (yleg + legend_y_margin*2.0)*DPI);
    fprintf(fp, "%.2f add %.2f rl\n", (legend_x_margin*2.0)*DPI, 0.0);
    fprintf(fp, "%.2f %.2f rl\n", 0.0, (-yleg - legend_y_margin*2.0)*DPI);
    fprintf(fp, "closepath\n");
    fprintf(fp, "%.2f setgray gsave fill grestore\n", 1.0);
    fprintf(fp, "%.2f setlinewidth\n", borderthick*DPI);
    fprintf(fp, "%d setlinejoin\n", 0);
    fprintf(fp, "%.2f setgray\n", 0.0);
    fprintf(fp, "stroke\n");

/* True shadow box. */
    fprintf(fp, "%%\n%% Draw shadow box for legend rectangle\n");
    fprintf(fp, "newpath\n");
    fprintf(fp, "%.2f %.2f m\n", (*x - legend_x_margin + shadowthick)*DPI,
				 (*y - legend_y_margin - 0.5*borderthick)*DPI);
    fprintf(fp, "%.2f %.2f rl\n", 0.0,
                                 -shadowthick*DPI);
    fprintf(fp, "%.2f add %.2f rl\n",
                             (legend_x_margin*2.0 + 0.5*borderthick)*DPI, 0.0);
    fprintf(fp, "%.2f %.2f rl\n", 0.0, (yleg + legend_y_margin*2.0 +
                                        0.5*borderthick)*DPI);
    fprintf(fp, "%.2f %.2f rl\n", -shadowthick*DPI, 0.0);
    fprintf(fp, "%.2f %.2f rl\n", 0.0, -(yleg + legend_y_margin*2.0 +
                                         0.5*borderthick - shadowthick)*DPI);
    fprintf(fp, "closepath\n");
    fprintf(fp, "%.2f setgray fill\n", 0.0);

/* "shadow" box with beveled corners. */
/*
    fprintf(fp, "newpath\n");
    fprintf(fp, "%.2f %.2f m\n", (*x - legend_x_margin - 0.5*borderthick)*DPI,
				 (*y - legend_y_margin - 0.5*borderthick)*DPI);
    fprintf(fp, "%.2f %.2f rl\n", sqrt(2.0 * SQR(shadowthick * DPI)),
                                 -sqrt(2.0 * SQR(shadowthick * DPI)));
    fprintf(fp, "%.2f add %.2f rl\n",
                             (legend_x_margin*2.0 + borderthick)*DPI, 0.0);
    fprintf(fp, "%.2f %.2f rl\n", 0.0, (yleg + legend_y_margin*2.0 +
                                        0.5*borderthick)*DPI);
    fprintf(fp, "%.2f %.2f rl\n", -sqrt(2.0 * SQR(shadowthick * DPI)),
                                   sqrt(2.0 * SQR(shadowthick * DPI)));
    fprintf(fp, "%.2f %.2f rl\n", 0.0, -(yleg + legend_y_margin*2.0 +
                                         0.5*borderthick)*DPI);
    fprintf(fp, "closepath\n");
    fprintf(fp, "%.2f setgray fill\n", 0.0);
*/

/* Update bb struct. */
    bb.bottom = MIN(bb.bottom, (*y - legend_y_margin - 0.5*borderthick -
                                shadowthick) * plot.sf + o.y);
    bb.top = MAX(bb.top, (*y + yleg + legend_y_margin + 0.5*borderthick) *
			 plot.sf + o.y);
    bb.left = MIN(bb.left, (*x - legend_x_margin - 0.5*borderthick) *
			   plot.sf + o.x);
    bb.right = MAX(bb.right, (*x + xleg + legend_x_margin + 0.5*borderthick +
                              shadowthick) * plot.sf + o.x);
  }
  else {
/* Update bb struct. */
    bb.bottom = MIN(bb.bottom, (*y) * plot.sf + o.y);
    bb.top = MAX(bb.top, (*y + yleg) * plot.sf + o.y);
    bb.left = MIN(bb.left, (*x) * plot.sf + o.x);
    bb.right = MAX(bb.right, (*x + xleg) * plot.sf + o.x);
  }

  for(i = lastline, legsofar = 0;
      legsofar < legnd.numleg;
      i = ((i == 0) ? (MaxLeg-1) : (i-1)))

    if (legnd.drawit[i] > 0) {

  /* Set pen color to current color for trace/marker. */
      newclr_(plot.color[i], strlen(plot.color[i]));
      fprintf(fp, "%%\n%% set color for trace/marker %d\n", i);
      fprintf(fp, "%.5f %.3f %.3f sethsbcolor\n", color.hue,
						  color.saturation,
						  color.intensity);

      fprintf(fp, "%%\n%% draw legend %d\n", i);

  /* Plot markers in legend if markers appear in plot. */
      if (plot.marker[i])
	fprintf(fp, "%.2f %.2f %f M%d\n", (*x + legmark_x_offset)*DPI,
		(*y + legsofar/(LegendFlpi/fontscale) + legline_y_offset)*DPI,
		1.0, i);

  /* Plot line segments in legend if no markers appear in plot. */
      else {

        fprintf(fp, "gsave\n");
        switch (plot.lineStyle[i]) {
          case LINE:
            line_();
            break;
          case DASH:
            dash_();
            break;
          case DOT:
            dot_();
            break;
          case CHNDSH:
            chndsh_();
            break;
          case CHNDOT:
            chndot_();
            break;
        }
        fprintf(fp, "newpath\n");  /* insert newpath here (Jan18,95, FAB) */
	fprintf(fp, "%.2f %.2f m\n", *x*DPI,
	       (*y + legsofar/(LegendFlpi/fontscale) + legline_y_offset)*DPI);
	fprintf(fp, "%.2f %.2f rl\n", 0.3*DPI, 0.0);
	fprintf(fp, "%.2f setlinewidth\n", plot.linethick);
	fprintf(fp, "%d setlinejoin\n", RoundJoin);
	fprintf(fp, "stroke\n");
        fprintf(fp, "grestore\n");
      }

  /* Reset pen color to black for remainder of legend line. */
      fprintf(fp, "%%\n%% set color to black for remainder of line. \n");
      fprintf(fp, "%.2f setgray\n", 0.0);

  /* Finish printing legend. */
      fprintf(fp, "(%s) %.2f %.2f %d JustString\n",
                  escapeParens(leglines[i]),
		  (*x + legtext_x_offset)*DPI,
		    (*y + legline_y_offset +
		    legsofar/(LegendFlpi/fontscale))*DPI,
                  just);

      legsofar++;
    } /* end if (legnd.drawit[i] > 0) */

  fprintf(fp, "%%\n%% draw legend heading\n");
  fprintf(fp, "(%s) %.2f %.2f %d JustString\n",
              escapeParens(legnd.heading),
              (*x)*DPI,
	      (*y + (legnd.numleg + legtit_y_offset)/
		(LegendFlpi/fontscale) + legline_y_offset)*DPI,
              just);

}

/*
xlegnd: Returns the x dimension of the requested legend in inches
through a user-defined variable.
*/
void xlegnd_(_float_ *ret_value, char *idleg, _int_ *nlines, _int_ lidleg)
/*
Arguments: ret_value - the return value
	       idleg - the array of characters (same as idry_r or pkray)
		       containing all the lines of the legend.
	     *nlines - the number of lines in the legend.
	      lidleg - the length of the character string idleg.
*/
{
char *line, *number, pak[MaxLineLength*MaxLeg+1];
_int_ i, maxchar=0;

 if (level < 1 || level > 3) {
   derror("Level must be 1, 2, or 3.  Routine: xlegnd", !FATAL);
   return;
 }

  strnlcpy(pak, idleg, legnd.eopkray+1);

  for(i = 0; i < MaxLeg; i++) {

/* Read legend line from pak. */
    if (i == 0)
      line = (char *) strtok(pak, "$");
    else
      line = (char *) strtok(NULL, "$");

/* Read legend number from pak. */
    number = (char *) strtok(NULL, "$");
    if ((line != NULL) && legnd.drawit[atoi(number)])
      maxchar = MAX(maxchar, strlen(line));

  } /* end for */

  *ret_value = ((_float_) maxchar) /
	       ((LegendFcpi - 3.0*LegendFcpiSD)/fontscale) + legtext_x_offset;
}

/*
ylegnd: Returns the y dimension of the requested legend in inches
through a user-defined variable.
*/
void ylegnd_(_float_ *ret_value, char *idleg, _int_ *nlines, _int_ lidleg)
/*
Arguments: ret_value - the return value
	       idleg - the array of characters (same as idry_r or pkray)
		       containing all the lines of the legend.
	     *nlines - the number of lines in the legend.
	      lidleg - the length of the character string idleg.
*/
{

  if (level < 1 || level > 3) {
    derror("Level must be 1, 2, or 3.  Routine: ylegnd", !FATAL);
    return;
  }
  
  *ret_value = ((_float_) *nlines + 1.0 + legtit_y_offset) /
	       (LegendFlpi / fontscale);
}
