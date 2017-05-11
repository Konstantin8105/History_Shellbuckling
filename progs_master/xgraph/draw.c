
#include "aparms.h"

/*
 * draw.c: xgraph drawing code
 *
 * Routines:
 *	void DrawWindow();
 *
 * $Log: draw.c,v $
 * Revision 1.1.1.1  1999/12/03 23:15:53  heideman
 * Revised           April 2011           weiler
 * xgraph-14.0
 *
 */

static double gridBase,
              gridStep,
              gridJuke[101];
static int    gridNJuke,
              gridCurJuke;


/****************/
/*  DrawWindow  */
/****************/

void DrawWindow( LocalWin *win_info )  /* Window information */

/*
 * Draws the data in the window.  Does not clear the window.
 * The data is scaled so that all of the data will fit.
 * Grid lines are drawn at the nearest power of 10 in engineering
 * notation.  Draws axis numbers along bottom and left hand edges.
 * Centers title at top of window.
 */

{
    xg_out    *di;

    static int debug = 0;

    debug = DEBUG;

    /* Figure out the transformation constants */

    di  = &win_info->dev_info;

    if (debug) {
      printf("\n");
      printf("debug information from ( DrawWindow )\n");
      printf("=====================================\n");
    }

    if ( TransformCompute(win_info) ) {

        if (debug) {
          printf("\n");
          printf("struct xg_out   dev_info\n");
          printf("------------------------\n");
          printf("\n");
          printf("dev_flags       = %13d\n", di->dev_flags);
          printf("area_w,area_h   = %13d %13d\n", di->area_w, di->area_h);
          printf("bdr_pad         = %13d\n", di->bdr_pad);
          printf("axis_pad        = %13d\n", di->axis_pad);
          printf("tick_len        = %13d\n", di->tick_len);
          printf("legend_pad      = %13d\n", di->legend_pad);
          printf("axis_width      = %13d\n", di->axis_width);
          printf("axis_height     = %13d\n", di->axis_height);
          printf("title_width     = %13d\n", di->title_width);
          printf("title_height    = %13d\n", di->title_height);
          printf("max_segs        = %13d\n", di->max_segs);
          printf("\n");
        }

	/* Draw the title */

	DrawTitle(win_info);

	/* Draw the legend */

	if (!PM_BOOL("NoLegend"))

	    DrawLegend(win_info);

	/* Draw the axis unit labels,  grid lines,  and grid labels */

	DrawGridAndAxis(win_info);

	/* Draw the data sets themselves */

	DrawData(win_info);
    }
}



/**********************/
/*  TransformCompute  */
/**********************/

int TransformCompute( LocalWin *wi )  /* Window information */

/*
 * This routine figures out how to draw the axis labels and grid lines.
 * Both linear and logarithmic axes are supported.  Axis labels are
 * drawn in engineering notation.  The power of the axes are labeled
 * in the normal axis labeling spots.  The routine also figures
 * out the necessary transformation information for the display
 * of the points (it touches XOrgX, XOrgY, UsrOrgX, UsrOrgY, and
 * UnitsPerPixel).
 */
{
    double  bbCenX,
            bbCenY,
            bbHalfWidth,
            bbHalfHeight;
    double  vali,
            valf;
    int     expX,
            expY,
            lblX,
	    lblY;
    int     idx,
            maxName,
            ledgWidth;
    char    err[MAXBUFSIZE];
    char   *XUnitText = PM_STR("XUnitText");

    static int debug  = 0;
    static int debug2 = 0;

    debug = DEBUG;

    /* get max characters (lblX,lblY) in labels */

    MaxLabelSize(  wi   ,
                  &lblX ,
                  &lblY ,
                  &expX ,
		  &expY );

    /*
     * First,  we figure out the origin in the X window.
     *
     * Above the space we have the title and the Y axis unit label.
     * Left of the space we have the Y axis grid labels.
     */

    wi->XOrgX = (int)wi->dev_info.margin_l
              + wi->dev_info.bdr_pad
              + wi->dev_info.axis_pad / 2
              + wi->dev_info.axis_width * lblY
              + wi->dev_info.bdr_pad

              + wi->dev_info.tick_len;

    wi->XOrgY = (int)wi->dev_info.margin_t
              + wi->dev_info.bdr_pad
              + wi->dev_info.title_height
	      + wi->dev_info.bdr_pad
              + wi->dev_info.axis_height
	      + wi->dev_info.axis_height / 2
              + wi->dev_info.bdr_pad

              + wi->dev_info.tick_len;

    /*
     * Now we find the lower right corner.
     *
     * Below the space we have the X axis grid labels and the X axis unit label.
     * Right of the space we have the legend annotation.
     */

    maxName = 0;
    for (idx = 0; idx < MAXSETS; idx++) {
	if (PlotData[idx].list) {
	    int     tempSize;

	    tempSize = strlen(PlotData[idx].setName);
	    if (tempSize > maxName)
		maxName = tempSize;
	}
    }
    if (PM_BOOL("NoLegend"))
	maxName = 0;

    ledgWidth =  maxName * wi->dev_info.axis_width;

    wi->XOppX = wi->dev_info.area_w
              - (int)wi->dev_info.margin_r
              - wi->dev_info.bdr_pad
              - ledgWidth
              - wi->dev_info.bdr_pad

              - wi->dev_info.axis_width
              - wi->dev_info.tick_len;

    wi->XOppY = wi->dev_info.area_h
              - (int)wi->dev_info.margin_b
              - wi->dev_info.bdr_pad
              - wi->dev_info.axis_height / 2
              - wi->dev_info.axis_height
              - wi->dev_info.bdr_pad
              - wi->dev_info.title_height
              - wi->dev_info.bdr_pad

              - wi->dev_info.tick_len;

    if ((wi->XOrgX >= wi->XOppX) || (wi->XOrgY >= wi->XOppY)) {
	do_error(strcpy(err, "Drawing area is too small\n"));
	return 0;
    }

    /*
     * We now have a bounding box for the drawing region. Figure out the units
     * per pixel using the data set bounding box.
     */

    wi->XUnitsPerPixel = (wi->hiX - wi->loX) / ((double) (wi->XOppX - wi->XOrgX));
    wi->YUnitsPerPixel = (wi->hiY - wi->loY) / ((double) (wi->XOppY - wi->XOrgY));

    /*
     * Find origin in user coordinate space.  We keep the center of the
     * original bounding box in the same place.
     */
    bbCenX       = (wi->loX + wi->hiX) / 2.0;
    bbCenY       = (wi->loY + wi->hiY) / 2.0;
    bbHalfWidth  = ((double) (wi->XOppX - wi->XOrgX)) / 2.0 * wi->XUnitsPerPixel;
    bbHalfHeight = ((double) (wi->XOppY - wi->XOrgY)) / 2.0 * wi->YUnitsPerPixel;

    wi->UsrOrgX = bbCenX - bbHalfWidth;
    wi->UsrOrgY = bbCenY - bbHalfHeight;
    wi->UsrOppX = bbCenX + bbHalfWidth;
    wi->UsrOppY = bbCenY + bbHalfHeight;

    wi->Xbegin  = wi->UsrOrgX;
    wi->Ybegin  = wi->UsrOrgY;

    /*
     * Everything is defined so we can now use the ScreenX and ScreenY
     * transformations.
     */

    if (debug) {
      printf("\n");
      printf("TransformCompute():\n");
      printf("-------------------\n");
      printf("lblX,  lblY   = %13d %13d\n", lblX,       lblY);
      printf("ledgWidth     = %13d\n",      ledgWidth);
      printf("\n");
      printf("area_w,area_h = %13d %13d\n", wi->dev_info.area_w, wi->dev_info.area_h);
      printf("marg_l,marg_r = %13d %13d\n", (int)wi->dev_info.margin_l, (int)wi->dev_info.margin_r);
      printf("marg_t,marg_b = %13d %13d\n", (int)wi->dev_info.margin_t, (int)wi->dev_info.margin_b);
      printf("XOrgX, XOppX  = %13d %13d\n", wi->XOrgX,  wi->XOppX);
      printf("XOrgY, XOppY  = %13d %13d\n", wi->XOrgY,  wi->XOppY);
      printf("\n");
      printf("loX,   hiX    = %13.5e %13.5e\n", wi->loX, wi->hiX);
      printf("loY,   hiY    = %13.5e %13.5e\n", wi->loY, wi->hiY);
      printf("X_UPP, Y_UPP  = %13.5e %13.5e\n", wi->XUnitsPerPixel, wi->YUnitsPerPixel);
      printf("\n");
      printf("UsOrgX,UsOppX = %13.5e %13.5e\n", wi->UsrOrgX, wi->UsrOppX);
      printf("UsOrgY,UsOppY = %13.5e %13.5e\n", wi->UsrOrgY, wi->UsrOppY);
      printf("\n");
    }

    if (debug2) {
      printf("\n");
      printf("TransformCompute():\n");
      printf("-------------------\n");
      printf("lblX,  lblY   = %13d %13d\n", lblX,       lblY);
      printf("ledgWidth     = %13d\n",      ledgWidth);
      printf("\n");
      printf("XOrgX, XOppX  = %13d %13d\n", wi->XOrgX,  wi->XOppX);
      printf("XOrgY, XOppY  = %13d %13d\n", wi->XOrgY,  wi->XOppY);
      printf("\n");
      printf("loX,   hiX    = %13.5e %13.5e\n", wi->loX, wi->hiX);
      printf("loY,   hiY    = %13.5e %13.5e\n", wi->loY, wi->hiY);
      printf("X_UPP, Y_UPP  = %13.5e %13.5e\n", wi->XUnitsPerPixel, wi->YUnitsPerPixel);
      printf("\n");
      printf("UsOrgX,UsOppX = %13.5e %13.5e\n", wi->UsrOrgX, wi->UsrOppX);
      printf("UsOrgY,UsOppY = %13.5e %13.5e\n", wi->UsrOrgY, wi->UsrOppY);
      printf("\n");
    }

    return 1;
}



/***************/
/*  DrawTitle  */
/***************/

void DrawTitle( LocalWin *wi )  /* Window information */

/*
 * This routine draws the title of the graph centered in
 * the window.  It is spaced down from the top by an amount
 * specified by the constant PADDING.  The font must be
 * fixed width.  The routine returns the height of the
 * title in pixels.
 */
{
    int     x_center;
    int     y_center;

    x_center = ( wi->XOrgX + wi->XOppX ) / 2;

    y_center = (int)wi->dev_info.margin_t
             + wi->dev_info.axis_pad
             + wi->dev_info.title_height / 2;

    /*
    y_center = wi->XOrgY
             - wi->dev_info.title_height / 2
	     - wi->dev_info.bdr_pad
             - wi->dev_info.axis_height
	     - wi->dev_info.axis_height / 2
             - wi->dev_info.bdr_pad
             - wi->dev_info.tick_len;
    */

    if (wi->DOrder == 0) 
      wi->dev_info.xg_text(wi->dev_info.user_state, x_center, y_center,
			   PM_STR("TitleText"), T_CENTER, T_TITLE);
    else if (wi->DOrder == 1)
      wi->dev_info.xg_text(wi->dev_info.user_state, x_center, y_center,
			   "First Derivative", T_CENTER, T_TITLE);
    else if (wi->DOrder == 2)
      wi->dev_info.xg_text(wi->dev_info.user_state, x_center, y_center,
			   "Second Derivative", T_CENTER, T_TITLE);
}


/*********************/
/*  DrawGridAndAxis  */
/*********************/

void DrawGridAndAxis( LocalWin *wi )  /* Window information */

/*
 * This routine draws grid line labels in engineering notation,
 * the grid lines themselves,  and unit labels on the axes.
 */
{
    int      expX,
             expY,
             lblX,
	     lblY;

    int      Yspot,
             Xspot;

    char    *format,
             power[10],
             value[10],
             final[MAXBUFSIZE + 10];

    int      ltick;

    int      Xbeg,
             Xend,
             Ybeg,
             Yend,
             Xsiz,
             Ysiz;

    int      Xsizi,
             Ysizi,
             XbegX,
             XendX,
             XbegY,
             XendY;

    int      nyGrid,
             nxGrid,
             nxG,
             nyG,
             nxF,
             nyF;

    double   Xincr,
             Yincr,
             Xstart,
             Ystart,
             Xindex,
             Yindex,
             Xinext,
             Yinext,
             Xfinal,
             Yfinal,
             larger;

    double   Xincro,
             Yincro;

    double   Xdelta,
             Ydelta;

    XSegment  segs[2];
    XSegment *seg1 = &segs[0];
    XSegment *seg2 = &segs[1];

    int      x_axis    = 0;
    int      y_axis    = 1;

    int      tickFlag  = PM_BOOL("Ticks");
    int	     axisFlag  = PM_BOOL("TickAxis");
    int      logXFlag  = PM_BOOL("LogX");
    int      logYFlag  = PM_BOOL("LogY");
    char    *XUnitText = PM_STR("XUnitText");
    char    *YUnitText = PM_STR("YUnitText");

    static int debug    = 0;
    static int debug_ex = 0;
    static int debug_cc = 0;

    debug = DEBUG;

    /* retreive the suggested number of grid spaces for x,y */

    nxGrid = PM_INT("NoXGrids");
    nyGrid = PM_INT("NoYGrids");

    /* first, get the axes exponent and character counts */

    MaxLabelSize(  wi   ,
                  &lblX ,
                  &lblY ,
                  &expX ,
		  &expY );

    ltick  =  3 * wi->dev_info.tick_len / 4;

    /* ------------------------------------ */
    /* determine the (x) grid line controls */
    /* ------------------------------------ */

    Xsizi  = wi->dev_info.axis_width * lblX + wi->dev_info.axis_pad; 
    Xincr  = Xsizi * wi->XUnitsPerPixel;
    Xincro = Xincr;

    axisSizing( wi, x_axis, Xincr, &Xstart, &Xfinal, &nxG );

    /* ADJUST the incremental value per user suggestion or AUTOMATIC */

    if ((nxGrid != 0) && !logXFlag) {
      Xincr = (Xfinal - Xstart) / (double)(nxGrid + 1);
    }
    else {
      Xincr = Xsizi * wi->XUnitsPerPixel;
    }

    axisSizing( wi, x_axis, Xincr, &Xstart, &Xfinal, &nxF );

    /* reset grid x-origin */
    
    wi->Xbegin = Xstart;

    Xbeg   = ScreenX(wi, Xstart);
    Xend   = ScreenX(wi, Xfinal);
    Xsiz   = (Xend - Xbeg) / nxF;

    /* check for x-spacing of grid lines being congested */

    if ((nxGrid != 0) && !logXFlag) {

      if (Xsiz < Xsizi - (wi->dev_info.axis_pad / 2)) {

      //wi->XUnitsPerPixel = (Xfinal - Xstart) / ((double)(wi->XOppX - wi->XOrgX));
        Xincr = Xsizi * wi->XUnitsPerPixel;

        axisSizing( wi, x_axis, Xincr, &Xstart, &Xfinal, &nxF );

        wi->Xbegin = Xstart;
        Xbeg   = ScreenX(wi, Xstart);
        Xend   = ScreenX(wi, Xfinal);

      }

    }

    XbegX  = Xbeg - ltick;
    XendX  = Xend + ltick;

    /* ------------------------------------ */
    /* determine the (y) grid line controls */
    /* ------------------------------------ */

    Ysizi  = wi->dev_info.axis_height * 2 + wi->dev_info.axis_pad / 2;
    Yincr  = Ysizi * wi->YUnitsPerPixel;
    Yincro = Yincr;

    axisSizing( wi, y_axis, Yincr, &Ystart, &Yfinal, &nyG );

    /* ADJUST the incremental value per user suggestion or AUTOMATIC */

    if ((nyGrid != 0) && !logYFlag) {
      Yincr = (Yfinal - Ystart) / (double)(nyGrid + 1);
    }
    else {
      Yincr = Ysizi * wi->YUnitsPerPixel;
    }

    axisSizing( wi, y_axis, Yincr, &Ystart, &Yfinal, &nyF );

    /* reset grid y-origin */

    wi->Ybegin = Ystart;

    Ybeg   = ScreenY(wi, Ystart);
    Yend   = ScreenY(wi, Yfinal);
    Ysiz   = (Ybeg - Yend) / nyF;

    /* check for y-spacing of grid lines being congested */

    if ((nyGrid != 0) && !logYFlag) {

      if (Ysiz < Ysizi) {
    //if (Ysiz < Ysizi - (wi->dev_info.axis_pad / 2)) {

      //wi->YUnitsPerPixel = (Yfinal - Ystart) / ((double)(wi->XOppY - wi->XOrgY));
        Yincr = Ysizi * wi->YUnitsPerPixel;

        axisSizing( wi, y_axis, Yincr, &Ystart, &Yfinal, &nyF );

        wi->Ybegin = Ystart;
        Ybeg   = ScreenY(wi, Ystart);
        Yend   = ScreenY(wi, Yfinal);

      }

    }

    XbegY  = Ybeg + ltick;
    XendY  = Yend - ltick;

    /* ---------------- */
    /* debug print outs */
    /* ---------------- */

    debug_ex = 0;
    debug    = 0;


    if (debug_ex) {

      printf("\n");
      printf("DrawGridAndAxis():  Grid Line Controls\n");
      printf("\n");
      printf("axxi_w,axi_h  = %13d %13d\n", wi->dev_info.axis_width, wi->dev_info.axis_height);
      printf("\n");
      printf("nxGrid,nyGrid = %13d %13d\n", nxGrid, nyGrid);
      printf("nxG,   nyG    = %13d %13d\n", nxG,    nyG);
      printf("nxF,   nyF    = %13d %13d\n", nxF,    nyF);
      printf("Xsizi, Ysizi  = %13d %13d\n", Xsizi,  Ysizi);
      printf("Xsiz,  Ysiz   = %13d %13d\n", Xsiz,   Ysiz);
      printf("\n");
      printf("Xstart,Xfinal = %13.5e %13.5e\n", Xstart, Xfinal);
      printf("Xincr, Xincro = %13.5e %13.5e\n", Xincr,  Xincro);
      printf("Xistep, X_UPP = %13.5e %13.5e\n", RoundUp(Xincr), wi->XUnitsPerPixel);
      printf("\n");
      printf("Ystart,Yfinal = %13.5e %13.5e\n", Ystart, Yfinal);
      printf("Yincr, Yincro = %13.5e %13.5e\n", Yincr,  Yincro);
      printf("Yistep, Y_UPP = %13.5e %13.5e\n", RoundUp(Yincr), wi->YUnitsPerPixel);
      printf("\n");
      printf("Xbeg,   Xend  = %13d %13d\n", Xbeg, Xend);
      printf("Ybeg,   Yend  = %13d %13d\n", Ybeg, Yend);
      printf("\n");
      printf("expX,   expY  = %13d %13d\n", expX,  expY);
    }

    if (debug) {
      printf("\n");
      printf("DrawGridAndAxis():  Grid Line Controls\n");
      printf("\n");
      printf("Xstart, Xincr = %13.5e %13.5e\n", Xstart, Xincr);
      printf("Ystart, Yincr = %13.5e %13.5e\n", Ystart, Yincr);
      printf("\n");
      printf("Xbeg,   Xend  = %13d %13d\n", Xbeg, Xend);
      printf("Ybeg,   Yend  = %13d %13d\n", Ybeg, Yend);
      printf("\n");
      printf("XbegX,  XendX = %13d %13d\n", XbegX, XendX);
      printf("XbegY,  XendY = %13d %13d\n", XbegY, XendY);
      printf("\n");
      printf("expX,   expY  = %13d %13d\n", expX,  expY);
      printf("\n");
      printf("ltick         = %13d\n", ltick);
      printf("\n");
    }


    debug_ex = 0;
    debug    = 0;


    /**************************************/
    /*  draw the axes descriptive labels  */
    /**************************************/

    if (expY != 0) {
	(void) strcpy(final, YUnitText);
	(void) strcat(final, " x 10");
	(void) sprintf(power, "%d", expY);

	Xspot = (int)wi->dev_info.margin_l
              + wi->dev_info.bdr_pad
              + (strlen(final) * wi->dev_info.axis_width)
              + wi->dev_info.axis_width / 2;

        Yspot = (int)wi->dev_info.margin_t
              + wi->dev_info.bdr_pad
              + wi->dev_info.title_height
              + wi->dev_info.bdr_pad
              + wi->dev_info.axis_height / 2
              + wi->dev_info.bdr_pad;

        /*
        Yspot = wi->XOrgY 
	      - wi->dev_info.axis_height / 2
              - wi->dev_info.bdr_pad
              - wi->dev_info.tick_len;
	*/

	wi->dev_info.xg_text(wi->dev_info.user_state,
			     Xspot, Yspot, final, T_RIGHT, T_AXIS);
	Xspot += wi->dev_info.axis_width / 2;
	wi->dev_info.xg_text(wi->dev_info.user_state,
			     Xspot, Yspot, power, T_LOWERLEFT, T_AXIS);
    }
    else {
        Xspot = (int)wi->dev_info.margin_l
              + wi->dev_info.bdr_pad
	      + ((strlen(YUnitText) + 0) * wi->dev_info.axis_width);

        Yspot = (int)wi->dev_info.margin_t
              + wi->dev_info.bdr_pad
              + wi->dev_info.title_height
	      + wi->dev_info.bdr_pad
              + wi->dev_info.axis_height / 2
              + wi->dev_info.bdr_pad;

	wi->dev_info.xg_text(wi->dev_info.user_state,
			     Xspot, Yspot, YUnitText, T_RIGHT, T_AXIS);
    }

    Xspot = ( wi->XOrgX + wi->XOppX ) / 2;

    Yspot = wi->XOppY + wi->dev_info.bdr_pad
                      + wi->dev_info.axis_height
                      + wi->dev_info.bdr_pad
                      + wi->dev_info.title_height / 2;

    if (expX != 0) {
	(void) strcpy(final, XUnitText);
	(void) strcat(final, " x 10");
	(void) sprintf(power, "%d", expX);

        Xspot += (strlen(final) - strlen(power)) * wi->dev_info.axis_width / 2;


	wi->dev_info.xg_text(wi->dev_info.user_state,
			     Xspot, Yspot, final, T_RIGHT, T_AXIS);
	Xspot += wi->dev_info.axis_width / 2;
	wi->dev_info.xg_text(wi->dev_info.user_state,
			     Xspot, Yspot, power, T_LOWERLEFT, T_AXIS);
    }
    else {
	wi->dev_info.xg_text(wi->dev_info.user_state,
			     Xspot, Yspot, XUnitText, T_CENTER, T_AXIS);
    }

    /*
     * check out the equivalent CalComp sizing
     */

    if (debug_cc) {

      iCalComp(wi);

    }

    /************************************/
    /*  draw the axes grid line labels  */
    /************************************/

    Ystart = initGrid(wi->UsrOrgY, Yincr, logYFlag);

    Xspot  = (int)wi->dev_info.margin_l
           + wi->dev_info.bdr_pad
           + wi->dev_info.axis_pad / 2
           + wi->dev_info.axis_width * lblY
           - ltick / 2;

    if (debug_ex) {
      printf("\n");
      printf("DrawGridAndAxis(): draw grid line labels\n");
      printf("========================================\n");
      printf("\n");
      printf("draw Y-Axis\n");
      printf("\n");
      printf("Ystart,Yincr = %13.5e %13.5e\n", Ystart, Yincr);
      printf("Yfinish      = %13.5e\n", wi->UsrOppY);
      printf("Xspot        = %13d\n", Xspot);
      printf("\n");
    }

    for (Yindex = Ystart; Yindex <= Yfinal; Yindex = stepGrid()) {
	Yspot = ScreenY(wi, Yindex);
	/* Write the gridline value */
        if (expY == 0)
          format = PM_STR("Format Y");
        else
          format = PM_STR("Format eY");
	WriteValue(value, format, Yindex, expY, logYFlag);
	wi->dev_info.xg_text(wi->dev_info.user_state,
			     Xspot, Yspot, value, T_RIGHT, T_AXIS);
        if (debug_ex) {
          printf("Yindex,Yspot = %13.5e %13d\n", Yindex, Yspot);
        }
    }

    /* ------------------------------------------ */

    Xstart = initGrid(wi->UsrOrgX, Xincr, logXFlag);

    Yspot  = wi->XOppY
           + wi->dev_info.bdr_pad
           + wi->dev_info.axis_height
           + wi->dev_info.bdr_pad;
           + wi->dev_info.tick_len;

    if (debug_ex) {
      printf("\n");
      printf("draw X-Axis\n");
      printf("\n");
      printf("Xstart,Xincr = %13.5e %13.5e\n", Xstart, Xincr); 
      printf("Xfinish      = %13.5e\n", wi->UsrOppX);
      printf("Yspot        = %13d\n", Yspot);
      printf("\n");
    }
 
    for (Xindex = Xstart; Xindex <= Xfinal; Xindex = stepGrid()) {
	Xspot  = ScreenX(wi, Xindex);
	/* Write the gridline value */
        if (expX == 0)
          format = PM_STR("Format X");
        else
          format = PM_STR("Format eX");
	WriteValue(value, format, Xindex, expX, logXFlag);
	wi->dev_info.xg_text(wi->dev_info.user_state,
			     Xspot, Yspot, value, T_BOTTOM, T_AXIS);
        if (debug_ex) {
          printf("Xindex,Xspot = %13.5e %13d\n", Xindex, Xspot);
        }
    }

    if (debug_ex) {
      printf("\n");
    }

    /******************************/
    /*  draw the axes grid lines  */
    /******************************/

    Ystart = initGrid(wi->UsrOrgY, Yincr, logYFlag);

    if (tickFlag) {
        segs[0].x1 = Xbeg - wi->dev_info.tick_len / 2;
        segs[0].x2 = Xbeg + wi->dev_info.tick_len / 2;
        segs[1].x1 = Xend - wi->dev_info.tick_len / 2;
        segs[1].x2 = Xend + wi->dev_info.tick_len / 2;
    }
    else {
        segs[0].x1 = XbegX;
        segs[0].x2 = XendX;
    }

    for (Yindex = Ystart; Yindex <= Yfinal; Yindex = stepGrid()) {

	Yspot      = ScreenY(wi, Yindex);

	segs[0].y1 = Yspot;
	segs[0].y2 = Yspot;

	if (tickFlag) {
	    segs[1].y1 = Yspot;
	    segs[1].y2 = Yspot;
	}

	if ((ABS(Yindex) < ZERO_THRES) && !logYFlag) {

	  //printf("DrawG(): style= %3d  =L_ZERO            width= %3d  =ZeroWidth\n",
	  //        L_ZERO, PM_INT("ZeroWidth"));

	    wi->dev_info.xg_seg(wi->dev_info.user_state,
				1, seg1, PM_INT("ZeroWidth"), L_ZERO, 0, 0);
	    if (tickFlag) {
		wi->dev_info.xg_seg(wi->dev_info.user_state,
				    1, seg2, PM_INT("ZeroWidth"), L_ZERO, 0, 0);
	    }
	}
	else {

	  //printf("DrawG(): style= %3d  =L_AXIS            width= %3d  =GridSize\n",
	  //        L_AXIS, PM_INT("GridSize"));

	    wi->dev_info.xg_seg(wi->dev_info.user_state,
				1, seg1, PM_INT("GridSize"), L_AXIS, 0, 0);
	    if (tickFlag) {
		wi->dev_info.xg_seg(wi->dev_info.user_state,
				    1, seg2, PM_INT("GridSize"), L_AXIS, 0, 0);
	    }
	}
    }

    if (tickFlag && axisFlag) {
      segs[0].x1 = Xbeg;
      segs[0].x2 = Xend;

      segs[0].y1 = Ybeg;
      segs[0].y2 = Ybeg;

      wi->dev_info.xg_seg(wi->dev_info.user_state,
                          1, seg1, PM_INT("ZeroWidth"), L_ZERO, 0, 0);

      segs[0].y1 = Yend;
      segs[0].y2 = Yend;

      wi->dev_info.xg_seg(wi->dev_info.user_state,
                          1, seg1, PM_INT("ZeroWidth"), L_ZERO, 0, 0);
    }

    /* ------------------------------------------ */

    Xstart = initGrid(wi->UsrOrgX, Xincr, logXFlag);

    if (tickFlag) {
        segs[0].y1 = Ybeg - wi->dev_info.tick_len / 2;
        segs[0].y2 = Ybeg + wi->dev_info.tick_len / 2;
        segs[1].y1 = Yend - wi->dev_info.tick_len / 2;
        segs[1].y2 = Yend + wi->dev_info.tick_len / 2;
    }
    else {
        segs[0].y1 = XbegY;
        segs[0].y2 = XendY;
    }

    for (Xindex = Xstart; Xindex <= Xfinal; Xindex = stepGrid()) {

	Xspot      = ScreenX(wi, Xindex);

        segs[0].x1 = Xspot;
        segs[0].x2 = Xspot;

	if (tickFlag) {
	    segs[1].x1 = Xspot;
	    segs[1].x2 = Xspot;
	}

	if ((ABS(Xindex) < ZERO_THRES) && !logXFlag) {
	    wi->dev_info.xg_seg(wi->dev_info.user_state,
				1, seg1, PM_INT("ZeroWidth"), L_ZERO, 0, 0);
	    if (tickFlag) {
		wi->dev_info.xg_seg(wi->dev_info.user_state,
				    1, seg2, PM_INT("ZeroWidth"), L_ZERO, 0, 0);
	    }
	}
	else {
	    wi->dev_info.xg_seg(wi->dev_info.user_state,
				1, seg1, PM_INT("GridSize"), L_AXIS, 0, 0);
	    if (tickFlag) {
		wi->dev_info.xg_seg(wi->dev_info.user_state,
			            1, seg2, PM_INT("GridSize"), L_AXIS, 0, 0);
	    }
	}
    }

    if (tickFlag && axisFlag) {
      segs[0].y1 = Ybeg;
      segs[0].y2 = Yend;

      segs[0].x1 = Xbeg;
      segs[0].x2 = Xbeg;

      wi->dev_info.xg_seg(wi->dev_info.user_state,
                          1, seg1, PM_INT("ZeroWidth"), L_ZERO, 0, 0);

      segs[0].x1 = Xend;
      segs[0].x2 = Xend;

      wi->dev_info.xg_seg(wi->dev_info.user_state,
                          1, seg1, PM_INT("ZeroWidth"), L_ZERO, 0, 0);
    }

    /***************************/
    /*  draw the bounding box  */
    /***************************/

    /* Check to see if he wants a bounding box */
    if (PM_BOOL("BoundBox")) {
	XSegment bb[4];

	/* Draw bounding box */
	bb[0].x1 = bb[0].x2 = bb[1].x1 = bb[3].x2 = wi->XOrgX;
	bb[0].y1 = bb[2].y2 = bb[3].y1 = bb[3].y2 = wi->XOrgY;
	bb[1].x2 = bb[2].x1 = bb[2].x2 = bb[3].x1 = wi->XOppX;
	bb[0].y2 = bb[1].y1 = bb[1].y2 = bb[2].y1 = wi->XOppY;

	wi->dev_info.xg_seg(wi->dev_info.user_state,
			    4, bb, PM_INT("GridSize"), L_AXIS, 0, 0);
    }


    /***********************************/
    /*  mark the bounding box corners  */
    /***********************************/

    seg1->x1 = 0;
    seg1->y1 = 0;

    wi->dev_info.xg_dot(wi->dev_info.user_state,
			seg1->x1, seg1->y1, P_MARK, BWMARK(0), PIXVALUE(0));

    seg1->x1 = wi->dev_info.area_w;
    seg1->y1 = 0;

    wi->dev_info.xg_dot(wi->dev_info.user_state,
			seg1->x1, seg1->y1, P_MARK, BWMARK(0), PIXVALUE(0));

    seg1->x1 = wi->dev_info.area_w;
    seg1->y1 = wi->dev_info.area_h;

    wi->dev_info.xg_dot(wi->dev_info.user_state,
			seg1->x1, seg1->y1, P_MARK, BWMARK(0), PIXVALUE(0));

    seg1->x1 = 0;
    seg1->y1 = wi->dev_info.area_h;

    wi->dev_info.xg_dot(wi->dev_info.user_state,
			seg1->x1, seg1->y1, P_MARK, BWMARK(0), PIXVALUE(0));


}


/******************/
/*  MaxLabelSize  */
/******************/

void MaxLabelSize( LocalWin *wi      ,  /* Window information          */
                   int      *label_x ,  /* max x-label in # characters */
                   int      *label_y ,  /* max y-label in # characters */
                   int      *expon_x ,  /* exponent for x-label values */
                   int      *expon_y )  /* exponent for y-label values */

/*
 * This routine examines the grid line labels to
 * determine the maximum axis label size
 */
{
    int      expX,
             expY;		/* Engineering powers */

    int      lblX,
             lblY;		/* Label Char Counts */

    int      nMax,
             nMin;

    int      logXFlag  = PM_BOOL("LogX");
    int      logYFlag  = PM_BOOL("LogY");

    char    *format,
             value[10];

    double   valmin,
             valmax;

    static int debug   = 0;

    /*
     * Grid display powers are computed by taking the log of the largest
     * numbers and rounding down to the nearest multiple of 3.
     */

    /* first the x-axis label values */
    /* ----------------------------- */

    if (fabs(wi->loX) > fabs(wi->hiX)) {
        valmin = fabs(wi->hiX);
        valmax = fabs(wi->loX);
    }
    else {
        valmin = fabs(wi->loX);
        valmax = fabs(wi->hiX);
    }

    if (logXFlag) {
	expX = 0;
    }
    else {
        expX = ((int) floor(nlog10(fabs(valmax)) / 2.0)) * 2;
    }

    *expon_x  =  expX;

    if (expX == 0)
      format = PM_STR("Format X");
    else
      format = PM_STR("Format eX");

    WriteValue(value, format, valmin, expX, logXFlag);
    nMin = strlen(value);

    WriteValue(value, format, valmax, expX, logXFlag);
    nMax = strlen(value);

    lblX     =  MAX (nMin, nMax);

   *label_x  =  lblX;

    if (debug) {
      printf("\n");
      printf("MaxLabelSize()\n");
      printf("++++++++++++++\n");
      printf("\n");
      printf("    xvalmin, xvalmax  = %13.5e %13.5e\n", valmin, valmax );
      printf("    expon_x, label_x  = %13d %13d\n",     expX,   lblX);
    }

    /* now the y-axis label values */
    /* --------------------------- */

    if (fabs(wi->loY) > fabs(wi->hiY)) {
        valmin = fabs(wi->hiY);
        valmax = fabs(wi->loY);
    }
    else {
        valmin = fabs(wi->loY);
        valmax = fabs(wi->hiY);
    }

    if (logYFlag) {
	expY = 0;
    }
    else {
        expY = ((int) floor(nlog10(fabs(valmax)) / 2.0)) * 2;
    }

    *expon_y  =  expY;

    if (expY == 0)
      format = PM_STR("Format Y");
    else
      format = PM_STR("Format eY");

    WriteValue(value, format, valmin, expY, logYFlag);
    nMin = strlen(value);

    WriteValue(value, format, valmax, expY, logYFlag);
    nMax = strlen(value);

    lblY     =  MAX (nMin, nMax);

   *label_y  =  lblY;

    if (debug) {
      printf("\n");
      printf("    yvalmin, yvalmax  = %13.5e %13.5e\n", valmin, valmax );
      printf("    expon_y, label_y  = %13d %13d\n",     expY,   lblY);
      printf("\n");
    }

    /* force axis labels to be 5 characters long */
    /* ========================================= */

    *label_x  =  5;
    *label_y  =  5;

}


#define ADD_GRID(val)	(gridJuke[gridNJuke++] = log10(val))

/**************/
/*  initGrid  */
/**************/

double initGrid( double low     ,  /* desired low value          */
                 double step    ,  /* desired step (user coords) */
                 int    logFlag )  /* is axis logarithmic?       */
{
    double      ratio,
                x;
    int         add;
  //int         i;

    static double eps   = 1.0e-08;
    static int    debug = 0;

    gridNJuke             =   0;
    gridCurJuke           =   0;
    gridJuke[gridNJuke++] = 0.0;

    if (logFlag) {
	ratio    = pow(10.0, step);
	gridBase = floor(low);
	gridStep = ceil(step);

        add      = 0;

	if (ratio <= 3.0) {
	    if (ratio > 2.0) {
		ADD_GRID(3.0);
                add++;
	    }
	    else if (ratio > 1.333) {
		ADD_GRID(2.0);
		ADD_GRID(5.0);
                add += 2;
	    }
	    else if (ratio > 1.25) {
		ADD_GRID(1.5);
		ADD_GRID(2.0);
		ADD_GRID(3.0);
		ADD_GRID(5.0);
		ADD_GRID(7.0);
                add += 5;
	    }
	    else {
		for (x = 1.0; x < 10.0 && (x + .5) / (x + .4) >= ratio; x += .5) {
		    ADD_GRID(x + .1);
		    ADD_GRID(x + .2);
		    ADD_GRID(x + .3);
		    ADD_GRID(x + .4);
		    ADD_GRID(x + .5);
                    add += 5;
		}
		if (floor(x) != x)
		    ADD_GRID(x += .5);
                    add ++;
		for (; x < 10.0 && (x + 1.0) / (x + .5) >= ratio; x += 1.0) {
		    ADD_GRID(x + .5);
		    ADD_GRID(x + 1.0);
                    add += 2;
		}
		for (; x < 10.0 && (x + 1.0) / x >= ratio; x += 1.0) {
		    ADD_GRID(x + 1.0);
                    add ++;
		}
		if (x == 7.0) {
		    gridNJuke--;
		    x = 6.0;
		}
		if (x < 7.0) {
		    ADD_GRID(x + 2.0);
                    add ++;
		}
		if (x == 10.0)
		    gridNJuke--;
	    }

	    x = low - gridBase;
            if (fabs(x) < eps) x = 0.0;

	    for (gridCurJuke = -1; x > gridJuke[gridCurJuke + 1]; gridCurJuke++) {
              if (fabs(x-gridJuke[gridCurJuke+1]) < eps) break;
              if (gridCurJuke >= gridNJuke-1) break;
	    }
	}

        if (debug) {
          printf("\n");
          printf("initGrid: gridBase    = %13.5e  gridStep   = %13.5e  ratio= %6.4f  add= %d\n",
	          gridBase, gridStep, ratio, add);
          printf("          gridNJuke   = %13d  gridCurJuke= %13d\n", gridNJuke, gridCurJuke);
	//for (i = 0; i < gridNJuke; i++) {
        //  printf("          gridJuke[%2d]= %13.5e\n", i, gridJuke[i]);
        //}
        }
    }
    else {
	gridStep  = RoundUp(step);
	gridBase  = floor(low / gridStep) * gridStep;
        while (gridBase > low) gridBase -= gridStep;
        gridBase -= gridStep;

        if (debug) {
          printf("initGrid: gridBase= %13.5e  gridStep= %13.5e\n", gridBase, gridStep); 
        }
    }

    return (stepGrid());
  //return (gridBase);
}


/**************/
/*  stepGrid  */
/**************/

double stepGrid( void ) 
{
    if (++gridCurJuke >= gridNJuke) {
	gridCurJuke = 0;
	gridBase   += gridStep;
    }
    return (gridBase + gridJuke[gridCurJuke]);
}


/*************/
/*  RoundUp  */
/*************/

double RoundUp( double val )  /* Value */

/*
 * This routine rounds up the given positive number
 * such that it is some power of ten times either
 * 1, 2, 4, 5 or 7.5.
 * It is used to find increments for grid lines.
 */
{
    int         exponent,
                idx;

    static int  old = 1;



    exponent = (int) floor(nlog10(val));

    if (exponent < 0) {
	for (idx = exponent; idx < 0; idx++) {
	    val *= 10.0;
	}
    }
    else {
	for (idx = 0; idx < exponent; idx++) {
	    val /= 10.0;
	}
    }


    /* old = limited increnednts */

    if (old == 0) {
      if      (val > 5.0)
	val = 10.0;
      else if (val > 2.0)
	val = 5.0;
      else if (val > 1.0)
	val = 2.0;
      else
	val = 1.0;
    }


    /* wxpanded increnednts */

    else if (old < 0) {
      if      (val > 7.5)
	val = 10.0;
      else if (val > 5.0)
	val = 7.5;
      else if (val > 2.0)
	val = 5.0;
      else if (val > 1.0)
	val = 2.0;
      else
	val = 1.0;
    }

    /* wxpanded increnednts */

    else {
      if      (val > 7.5)
	val = 10.0;
      else if (val > 5.0)
	val = 7.5;
      else if (val > 4.0)
	val = 5.0;
      else if (val > 2.0)
	val = 4.0;
      else if (val > 1.0)
	val = 2.0;
      else
	val = 1.0;
    }


    if (exponent < 0) {
	for (idx = exponent; idx < 0; idx++) {
	    val /= 10.0;
	}
    }
    else {
	for (idx = 0; idx < exponent; idx++) {
	    val *= 10.0;
	}
    }

    return val;
}


/****************/
/*  WriteValue  */
/****************/

void WriteValue( char   *str    ,  /* String to write into */
                 char   *fmti   ,  /* Format to print str */
                 double val     ,  /* Value to print       */
                 int    expv    ,  /* Exponent             */
                 int    logFlag )  /* Is this a log axis?  */

/*
 * Writes the value provided into the string in a fixed format
 * consisting of five-six characters.  The format depends upon;
 *   expv  = 0,  format =  -dd.dd
 *   expv != 0,  format =  -d.ddd
 */
{
    int     idx;
    char   *fmt;

    /* point to input format string */

    fmt = fmti;

    /* log10 axis labels */

    if (logFlag) {
	if (val == floor(val)) {
	    if ((strcmp(fmt, "%.2f") == 0) ||
	        (strcmp(fmt, "%.3f") == 0)   )
	        fmt = "%.0e";
	    val = pow(10.0, val);
	}
	else {
	    if (strcmp(fmt, "%.2f") == 0)
		fmt = "%.2g";
	    if (strcmp(fmt, "%.3f") == 0)
		fmt = "%.3g";
	    val = pow(10.0, val - floor(val));
	}
    }

    /* regular axis labels */

    else {
	if (expv < 0) {
	    for (idx = expv; idx < 0; idx++) {
		val *= 10.0;
	    }
	}
	else {
	    for (idx = 0; idx < expv; idx++) {
		val /= 10.0;
	    }
	}
    }

    if (strchr(fmt, 'd') || strchr(fmt, 'x'))
	(void) sprintf(str, fmt, (int) val);
    else
	(void) sprintf(str, fmt, val);
}


#define LEFT_CODE	0x01
#define RIGHT_CODE	0x02
#define BOTTOM_CODE	0x04
#define TOP_CODE	0x08

/* Clipping algorithm from Neumann and Sproull by Cohen and Sutherland */
#define C_CODE(xval, yval, rtn) \
                               rtn  = 0; \
if      ((xval) < wi->UsrOrgX) rtn  = LEFT_CODE; \
else if ((xval) > wi->UsrOppX) rtn  = RIGHT_CODE; \
if      ((yval) < wi->UsrOrgY) rtn |= BOTTOM_CODE; \
else if ((yval) > wi->UsrOppY) rtn |= TOP_CODE


/***************/
/*  EraseData  */
/***************/

void EraseData( LocalWin *wi )  /* Window information */

/*
 * This routine draws the data sets themselves using the macros
 * for translating coordinates.
 */
{
    double  sx1,
            sy1,
            sx2,
            sy2,
            tx = 0,
            ty = 0;
    int     idx,
            subindex;
    int     code1,
            code2,
            cd,
            mark_inside;

    int     X_idx, StoreIDX; /* PW */

    XSegment *ptr;

    PointList *thisList,
              *lastList;

    int     markFlag,
            pixelMarks,
            bigPixel,
            colorMark;

    int     noLines   = PM_BOOL("NoLines");
    int     lineWidth = PM_INT("LineWidth");

    /* PW Suggests we Flush and set first */

    set_mark_flags(&markFlag, &pixelMarks, &bigPixel, &colorMark);

    for (idx = 0; idx < MAXSETS; idx++) {
        if      (wi->DOrder == 0)
	  thisList = PlotData[idx].list;
        else if (wi->DOrder == 1)
	    thisList = DataD1[idx].list;
        else if (wi->DOrder == 2)
	    thisList = DataD2[idx].list;
        else {
          printf ("Internal Error differentiating - order > 2!\n");
          exit (1);
        }
	while (thisList) {
	    X_idx = 0;
	    for (subindex = 0; subindex < thisList->numPoints - 1; subindex++) {
		/* Put segment in (sx1,sy1) (sx2,sy2) */
		sx1 = thisList->xvec[subindex];
		sy1 = thisList->yvec[subindex];
		sx2 = thisList->xvec[subindex + 1];
		sy2 = thisList->yvec[subindex + 1];
		/* Now clip to current window boundary */
		C_CODE(sx1, sy1, code1);
		C_CODE(sx2, sy2, code2);
		mark_inside = (code1 == 0);
		while (code1 || code2) {
		    if (code1 & code2)
			break;
		    cd = (code1 ? code1 : code2);
		    if (cd & LEFT_CODE) {	/* Crosses left edge */
			ty = sy1 + (sy2 - sy1) * (wi->UsrOrgX - sx1) / (sx2 - sx1);
			tx = wi->UsrOrgX;
		    }
		    else if (cd & RIGHT_CODE) {	/* Crosses right edge */
			ty = sy1 + (sy2 - sy1) * (wi->UsrOppX - sx1) / (sx2 - sx1);
			tx = wi->UsrOppX;
		    }
		    else if (cd & BOTTOM_CODE) {/* Crosses bottom edge */
			tx = sx1 + (sx2 - sx1) * (wi->UsrOrgY - sy1) / (sy2 - sy1);
			ty = wi->UsrOrgY;
		    }
		    else if (cd & TOP_CODE) {	/* Crosses top edge */
			tx = sx1 + (sx2 - sx1) * (wi->UsrOppY - sy1) / (sy2 - sy1);
			ty = wi->UsrOppY;
		    }
		    if (cd == code1) {
			sx1 = tx;
			sy1 = ty;
			C_CODE(sx1, sy1, code1);
		    }
		    else {
			sx2 = tx;
			sy2 = ty;
			C_CODE(sx2, sy2, code2);
		    }
		}
		if (!code1 && !code2) {
		    /* Add segment to list */
		    Xsegs[0][X_idx].x1 = Xsegs[1][X_idx].x1;
		    Xsegs[0][X_idx].y1 = Xsegs[1][X_idx].y1;
		    Xsegs[0][X_idx].x2 = Xsegs[1][X_idx].x2;
		    Xsegs[0][X_idx].y2 = Xsegs[1][X_idx].y2;

		    Xsegs[1][X_idx].x1 = ScreenX(wi, sx1);
		    Xsegs[1][X_idx].y1 = ScreenY(wi, sy1);
		    Xsegs[1][X_idx].x2 = ScreenX(wi, sx2);
		    Xsegs[1][X_idx].y2 = ScreenY(wi, sy2);

		    X_idx++;
		}

		/* Draw markers if requested and they are in drawing region */
		if (markFlag && mark_inside) {
		    if (pixelMarks) {
			if (bigPixel) {
			    wi->dev_info.xg_dot(wi->dev_info.user_state,
						Xsegs[1][X_idx - 1].x1,
						Xsegs[1][X_idx - 1].y1,
						P_DOT, 0, idx % MAXATTR);
			}
			else {
			    wi->dev_info.xg_dot(wi->dev_info.user_state,
						Xsegs[1][X_idx - 1].x1,
						Xsegs[1][X_idx - 1].y1,
						P_PIXEL, 0, PIXVALUE(idx));
			}
		    }
		    else {
			/* Distinctive markers */
			wi->dev_info.xg_dot(wi->dev_info.user_state,
					    Xsegs[1][X_idx - 1].x1,
					    Xsegs[1][X_idx - 1].y1,
					    P_MARK, MARKSTYLE(idx),
					    PIXVALUE(idx));
		    }
		}

		/* Draw bar elements if requested */
		if (PM_BOOL("BarGraph")) {
		    int     barPixels,
		            baseSpot;
		    XSegment line;

		    barPixels = (int) ((PM_DBL("BarWidth") /
					wi->XUnitsPerPixel) + 0.5);
		    if (barPixels <= 0)
			barPixels = 1;
		    baseSpot = ScreenY(wi, PM_DBL("BarBase"));
		    line.x1 = line.x2 = Xsegs[1][X_idx - 1].x1 + 
					(int) ((PM_DBL("BarOffset") * idx /
					    wi->XUnitsPerPixel) + 0.5);
		    if (PM_BOOL("StackGraph") && idx != 0)
			line.y1 = Xsegs[0][X_idx - 1].y1;
		    else
			line.y1 = baseSpot;
		    line.y2 = Xsegs[1][X_idx - 1].y1;
		    wi->dev_info.xg_seg(wi->dev_info.user_state,
					1, &line, barPixels, L_VAR,
					LINESTYLE(idx), PIXVALUE(idx));
		}
	    }
	    /* Handle last marker */
	    if (markFlag && (thisList->numPoints > 0)) {
		C_CODE(thisList->xvec[thisList->numPoints - 1],
		       thisList->yvec[thisList->numPoints - 1],
		       mark_inside);
		if (mark_inside == 0) {
		    if (pixelMarks) {
			if (bigPixel) {
			    wi->dev_info.xg_dot(wi->dev_info.user_state,
						Xsegs[1][X_idx - 1].x2,
						Xsegs[1][X_idx - 1].y2,
						P_DOT, 0, idx % MAXATTR);
			}
			else {
			    wi->dev_info.xg_dot(wi->dev_info.user_state,
						Xsegs[1][X_idx - 1].x2,
						Xsegs[1][X_idx - 1].y2,
						P_PIXEL, 0, PIXVALUE(idx));
			}
		    }
		    else {
			/* Distinctive markers */
			wi->dev_info.xg_dot(wi->dev_info.user_state,
					    Xsegs[1][X_idx - 1].x2,
					    Xsegs[1][X_idx - 1].y2,
					    P_MARK, MARKSTYLE(idx),
					    PIXVALUE(idx));
		    }
		}
	    }

	    /* Handle last bar */

	    if ((thisList->numPoints > 0) && PM_BOOL("BarGraph")) {
		int     barPixels,
		        baseSpot;
		XSegment line;

		barPixels = (int) ((PM_DBL("BarWidth") / 
				   wi->XUnitsPerPixel) + 0.5);
		if (barPixels <= 0)
		    barPixels = 1;
		baseSpot = ScreenY(wi, PM_DBL("BarBase"));
		line.x1 = line.x2 = Xsegs[1][X_idx - 1].x2 +
					(int) ((PM_DBL("BarOffset") * idx /
					    wi->XUnitsPerPixel) + 0.5);
		if (PM_BOOL("StackGraph") && idx != 0)
		    line.y1 = Xsegs[0][X_idx - 1].y2;
		else
		    line.y1 = baseSpot;
		line.y2 = Xsegs[1][X_idx - 1].y2;
		wi->dev_info.xg_seg(wi->dev_info.user_state,
				    1, &line, barPixels, L_VAR,
				    LINESTYLE(idx), PIXVALUE(idx));
	    }

	    /* Erase segments */
	    if ((thisList->numPoints > 0) && (!noLines) && (X_idx > 0)) {
		ptr = Xsegs[1];
		while (X_idx > wi->dev_info.max_segs) {
		    wi->dev_info.xg_seg(wi->dev_info.user_state,
					wi->dev_info.max_segs, ptr,
					lineWidth, L_VAR,
					16, (int)(1));
					/*LINESTYLE(8), (int)(1));*/
		    ptr += wi->dev_info.max_segs;
		    X_idx -= wi->dev_info.max_segs;
		}
		wi->dev_info.xg_seg(wi->dev_info.user_state,
				    X_idx, ptr,
				    lineWidth, L_VAR,
				    16,(int)(1));
	    }
	    /* Next subset */
            thisList = thisList->next;
	}
    }
    XFlush (disp);
}



/**************/
/*  DrawData  */
/**************/

void DrawData( LocalWin *wi )  /* Window information */

/*
 * This routine draws the data sets themselves using macros
 * for translating coordinates.
 */
{
    double  sx1,
            sy1,
            sx2,
            sy2,
            tx = 0,
            ty = 0;
    int     idx,
            jdx;
    int     codex,
            codey,
            cd,
            mark_inside;

    int     x1, y1;
    int     x2, y2;

    int     X_idx, StoreIDX; /* PW */

    XSegment  *ptr;

    PointList *thisList,
              *lastList;

    int     markFlag,
            pixelMarks,
            bigPixel,
            colorMark;

    int     noLines   = PM_BOOL("NoLines");
    int     lineWidth = PM_INT("LineWidth");

    /* PW */
    int     theDelay;

    /* PW Suggests we Flush and set first */

    theDelay = PM_INT("DelayValue")*100000;

    XFlush(disp);

    if (PM_BOOL("Animate")) sleep(1);

    set_mark_flags(&markFlag, &pixelMarks, &bigPixel, &colorMark);

    for (idx = 0; idx < MAXSETS; idx++) {

        if      (wi->DOrder == 0)
	  thisList = PlotData[idx].list;
        else if (wi->DOrder == 1)
	  thisList = DataD1[idx].list;
        else if (wi->DOrder == 2)
	  thisList = DataD2[idx].list;
        else {
          printf ("Internal Error differentiating - order > 2!\n");
          exit (1);
        }

	while (thisList) {

	    X_idx = 0;

	    for (jdx = 0; jdx < thisList->numPoints - 1; jdx++) {

		/* Put segment in (sx1,sy1) (sx2,sy2) */

		sx1 = thisList->xvec[jdx];
		sy1 = thisList->yvec[jdx];
		sx2 = thisList->xvec[jdx + 1];
		sy2 = thisList->yvec[jdx + 1];

		/* Now clip to current window boundary */

		C_CODE(sx1, sy1, codex);
		C_CODE(sx2, sy2, codey);

		mark_inside = (codex == 0);

		while (codex || codey) {

		    if (codex & codey)
			break;

		    cd = (codex ? codex : codey);

		    if (cd & LEFT_CODE) {	/* Crosses left edge */
			ty = sy1 + (sy2 - sy1) * (wi->UsrOrgX - sx1) / (sx2 - sx1);
			tx = wi->UsrOrgX;
		    }
		    else if (cd & RIGHT_CODE) {	/* Crosses right edge */
			ty = sy1 + (sy2 - sy1) * (wi->UsrOppX - sx1) / (sx2 - sx1);
			tx = wi->UsrOppX;
		    }
		    else if (cd & BOTTOM_CODE) {/* Crosses bottom edge */
			tx = sx1 + (sx2 - sx1) * (wi->UsrOrgY - sy1) / (sy2 - sy1);
			ty = wi->UsrOrgY;
		    }
		    else if (cd & TOP_CODE) {	/* Crosses top edge */
			tx = sx1 + (sx2 - sx1) * (wi->UsrOppY - sy1) / (sy2 - sy1);
			ty = wi->UsrOppY;
		    }

		    if (cd == codex) {
			sx1 = tx;
			sy1 = ty;
			C_CODE(sx1, sy1, codex);
		    }
		    else {
			sx2 = tx;
			sy2 = ty;
			C_CODE(sx2, sy2, codey);
		    }
		}

		if (!codex && !codey) {

		    /* Add segment to list */

		    Xsegs[0][X_idx].x1 = Xsegs[1][X_idx].x1;
		    Xsegs[0][X_idx].y1 = Xsegs[1][X_idx].y1;
		    Xsegs[0][X_idx].x2 = Xsegs[1][X_idx].x2;
		    Xsegs[0][X_idx].y2 = Xsegs[1][X_idx].y2;

		    Xsegs[1][X_idx].x1 = ScreenX(wi, sx1);
		    Xsegs[1][X_idx].y1 = ScreenY(wi, sy1);
		    Xsegs[1][X_idx].x2 = ScreenX(wi, sx2);
		    Xsegs[1][X_idx].y2 = ScreenY(wi, sy2);

		    X_idx++;
		}

		/* Draw markers if requested and they are in drawing region */

                x1 = (int)Xsegs[1][X_idx - 1].x1;
                y1 = (int)Xsegs[1][X_idx - 1].y1;

		if (markFlag && mark_inside) {
		    if (pixelMarks) {
			if (bigPixel) {
			    wi->dev_info.xg_dot(wi->dev_info.user_state,
						x1, y1, P_DOT, 0, idx % MAXATTR);
			}
			else {
			    wi->dev_info.xg_dot(wi->dev_info.user_state,
						x1, y1, P_PIXEL, 0, PIXVALUE(idx));
			}
		    }
		    else {
			/* Distinctive markers */
			wi->dev_info.xg_dot(wi->dev_info.user_state,
					    x1, y1, P_MARK, MARKSTYLE(idx), PIXVALUE(idx));
		    }
		}

		/* Draw bar elements if requested */

		if (PM_BOOL("BarGraph")) {
		    int     barPixels,
		            baseSpot;
		    XSegment line;

		    barPixels = (int) ((PM_DBL("BarWidth") / wi->XUnitsPerPixel) + 0.5);
		    if (barPixels <= 0)	barPixels = 1;

		    baseSpot = ScreenY(wi, PM_DBL("BarBase"));
		    line.x1 = line.x2 = Xsegs[1][X_idx - 1].x1
				      + (int) ((PM_DBL("BarOffset") * idx / wi->XUnitsPerPixel) + 0.5);

		    if (PM_BOOL("StackGraph") && idx != 0)
			line.y1 = Xsegs[0][X_idx - 1].y1;
		    else
			line.y1 = baseSpot;

		    line.y2 = Xsegs[1][X_idx - 1].y1;

		    wi->dev_info.xg_seg(wi->dev_info.user_state,
			                1, &line, barPixels, L_VAR, LINESTYLE(idx), PIXVALUE(idx));
		}
	    }

	    /* Handle last marker */

	    if (markFlag && (thisList->numPoints > 0)) {

		C_CODE(thisList->xvec[thisList->numPoints - 1],
		       thisList->yvec[thisList->numPoints - 1],
		       mark_inside);

                x2 = (int)Xsegs[1][X_idx - 1].x2;
                y2 = (int)Xsegs[1][X_idx - 1].y2;

		if (mark_inside == 0) {
		    if (pixelMarks) {
			if (bigPixel) {
			    wi->dev_info.xg_dot(wi->dev_info.user_state,
						x2, y2, P_DOT, 0, idx % MAXATTR);
			}
			else {
			    wi->dev_info.xg_dot(wi->dev_info.user_state,
						x2, y2, P_PIXEL, 0, PIXVALUE(idx));
			}
		    }
		    else {
			/* Distinctive markers */
			wi->dev_info.xg_dot(wi->dev_info.user_state,
					    x2, y2, P_MARK, MARKSTYLE(idx), PIXVALUE(idx));
		    }
		}
	    }

	    /* Handle last bar */

	    if ((thisList->numPoints > 0) && PM_BOOL("BarGraph")) {
		int      barPixels;
		XSegment line;

              //x2 = (int)Xsegs[1][X_idx - 1].x2;
              //y2 = (int)Xsegs[1][X_idx - 1].y2;

		barPixels = (int) ((PM_DBL("BarWidth") / wi->XUnitsPerPixel) + 0.5);
		if (barPixels <= 0) barPixels = 1;

		line.x1 = line.x2 = Xsegs[1][X_idx - 1].x2 +
					(int) ((PM_DBL("BarOffset") * idx /
					    wi->XUnitsPerPixel) + 0.5);
		if (PM_BOOL("StackGraph") && idx != 0)
		    line.y1 = Xsegs[0][X_idx - 1].y2;
		else
		    line.y1 = ScreenY(wi, PM_DBL("BarBase"));

		line.y2 = Xsegs[1][X_idx - 1].y2;

		wi->dev_info.xg_seg(wi->dev_info.user_state,
				    1, &line, barPixels, L_VAR,
				    LINESTYLE(idx), PIXVALUE(idx));
	    }

	    /* Draw segments */

            if (!PM_BOOL("Animate")) {

	      if (thisList->numPoints > 0 && (!noLines) && (X_idx > 0)) {

		ptr = Xsegs[1];

		while (X_idx > wi->dev_info.max_segs) {
		    wi->dev_info.xg_seg(wi->dev_info.user_state, wi->dev_info.max_segs, ptr,
					lineWidth, L_VAR, LINESTYLE(idx), PIXVALUE(idx));
		    ptr   += wi->dev_info.max_segs;
		    X_idx -= wi->dev_info.max_segs;
		}
		wi->dev_info.xg_seg(wi->dev_info.user_state, X_idx, ptr,
				    lineWidth, L_VAR, LINESTYLE(idx), PIXVALUE(idx));
	      }

            }
            else {

              StoreIDX = X_idx;

	      if (thisList->numPoints > 0 && (!noLines) && (X_idx > 0)) {

		ptr = Xsegs[1];

		while (X_idx > wi->dev_info.max_segs) {
		    wi->dev_info.xg_seg(wi->dev_info.user_state, wi->dev_info.max_segs, ptr,
					lineWidth, L_VAR, LINESTYLE(1), PIXVALUE(2));
		    ptr   += wi->dev_info.max_segs;
		    X_idx -= wi->dev_info.max_segs;
		}
		wi->dev_info.xg_seg(wi->dev_info.user_state, X_idx, ptr,
				    lineWidth, L_VAR, LINESTYLE(1), PIXVALUE(2));
	      }

              XFlush (disp);

              /* dumi opps to stall for time */
	      for (X_idx = 1; X_idx < theDelay; X_idx++);
                  X_idx = StoreIDX;

	      if ((thisList->numPoints > 0) && (!noLines) && (X_idx > 0)) {

		ptr = Xsegs[1];

		while (X_idx > wi->dev_info.max_segs) {
		    wi->dev_info.xg_seg(wi->dev_info.user_state, wi->dev_info.max_segs, ptr,
					lineWidth, L_VAR, 16, (int)(1));
				              /*LINESTYLE(8), (int)(1));*/
		    ptr += wi->dev_info.max_segs;
		    X_idx -= wi->dev_info.max_segs;
		}
		wi->dev_info.xg_seg(wi->dev_info.user_state, X_idx, ptr,
				    lineWidth, L_VAR, 16,(int)(1));
	      }
            }

	    /* Next subset */

            lastList = thisList;
            thisList = thisList->next;

	} /* End While */

    } /* End for idx == MAXSETS */

    if (PM_BOOL("Animate")) {

      X_idx    = StoreIDX;
      thisList = lastList;

      if (thisList->numPoints > 0 && (!noLines) && (X_idx > 0)) {

        ptr = Xsegs[1];

        while (X_idx > wi->dev_info.max_segs) {
	    wi->dev_info.xg_seg(wi->dev_info.user_state, wi->dev_info.max_segs, ptr,
				lineWidth, L_VAR, LINESTYLE(1), PIXVALUE(2));
	    ptr   += wi->dev_info.max_segs;
	    X_idx -= wi->dev_info.max_segs;
	}
	wi->dev_info.xg_seg(wi->dev_info.user_state, X_idx, ptr,
			    lineWidth, L_VAR, LINESTYLE(1), PIXVALUE(2));
      }

    }

    XFlush (disp);
}




/****************/
/*  DrawLegend  */
/****************/

void DrawLegend( LocalWin *wi )  /* Window information */

/*
 * This draws a legend of the data sets displayed.
 * Only those that will fit are drawn.
 */
{
    int      idx,
             lineLen,
             oneLen, 
	     yincr;

    int      Yspot,
             Xspot;

    XSegment leg_line;

    int      markFlag,
             pixelMarks,
             bigPixel,
             colorMark;

    set_mark_flags(&markFlag, &pixelMarks, &bigPixel, &colorMark);

    Xspot   = wi->XOppX + wi->dev_info.bdr_pad
                        + wi->dev_info.axis_width,
                        + wi->dev_info.tick_len;
    Yspot   = wi->XOrgY;
    lineLen = 0;
    yincr   = 2 + wi->dev_info.axis_height
                + wi->dev_info.bdr_pad;

    /* First pass draws the text */

    for (idx = 0; idx < MAXSETS; idx++) {
	if ((PlotData[idx].list) &&
	    (Yspot + wi->dev_info.axis_height + 2 < wi->XOppY)) {
	    /* Meets the criteria */
	    oneLen = strlen(PlotData[idx].setName);
	    if (oneLen > lineLen) lineLen = oneLen;
	    wi->dev_info.xg_text(wi->dev_info.user_state, Xspot, Yspot + 2,
				 PlotData[idx].setName, T_UPPERLEFT, T_AXIS);
	    Yspot += yincr;
	}
    }

    lineLen     = lineLen     * wi->dev_info.axis_width;
    leg_line.x1 = Xspot;
    leg_line.x2 = leg_line.x1 + lineLen;
    Yspot       = wi->XOrgY;

    /* second pass draws the lines */

    for (idx = 0; idx < MAXSETS; idx++) {
	if ((PlotData[idx].list) && (Yspot + wi->dev_info.axis_height + 2 < wi->XOppY)) {

	    leg_line.y1 = leg_line.y2 = Yspot - wi->dev_info.legend_pad;

	    if (PM_BOOL("BarGraph")) 
		wi->dev_info.xg_seg(wi->dev_info.user_state, 1, &leg_line, yincr / 4,
				    L_VAR, LINESTYLE(idx), PIXVALUE(idx));
	    if (!PM_BOOL("NoLines"))
		wi->dev_info.xg_seg(wi->dev_info.user_state, 1, &leg_line, 1,
                                    L_VAR, LINESTYLE(idx), PIXVALUE(idx));
	    if (markFlag && !pixelMarks) {
		wi->dev_info.xg_dot(wi->dev_info.user_state, leg_line.x1, leg_line.y1,
				    P_MARK, MARKSTYLE(idx), PIXVALUE(idx));

	    }
	    Yspot += yincr;
	}
    } /* End for idx == MAXSETS */
}

/********************/
/*  set_mark_flags  */
/********************/

void set_mark_flags( int *markFlag   , 
                     int *pixelMarks , 
                     int *bigPixel   , 
                     int *colorMark  ) 

/*
 * Determines the values of the old boolean flags based on the
 * new values in the parameters database.
 */
{
    *markFlag   = 0;
    *pixelMarks = 0;
    *bigPixel   = 0;
    *colorMark  = 0;

    if (PM_BOOL("Markers")) {
	*markFlag   = 1;
	*pixelMarks = 0;
	*colorMark  = 0;
    }

    if (PM_BOOL("PixelMarkers")) {
	*markFlag   = 1;
	*pixelMarks = 1;
	*bigPixel   = 0;
    }

    if (PM_BOOL("LargePixels")) {
	*markFlag   = 1;
	*pixelMarks = 1;
	*bigPixel   = 1;
    }

    if (PM_BOOL("StyleMarkers")) {
	*markFlag   = 1;
	*pixelMarks = 0;
	*colorMark  = 1;
    }
}


/*************/
/*  ScreenX  */
/*************/

//#define SCREENX(wi, userX) (((int) (((userX) - wi->UsrOrgX)/wi->XUnitsPerPixel) + 0.5) + wi->XOrgX)

int  ScreenX( LocalWin *wi    ,
              double    userX )
{
    int      val;

  //val  =  (int)((userX - wi->UsrOrgX)/wi->XUnitsPerPixel + 0.5) + wi->XOrgX;
    val  =  (int)((userX - wi->Xbegin)/wi->XUnitsPerPixel + 0.5) + wi->XOrgX;

    return (val);
}


/*************/
/*  ScreenY  */
/*************/

//#define SCREENY(wi, userY) (wi->XOppY - ((int) (((userY) - wi->UsrOrgY)/wi->YUnitsPerPixel + 0.5)))

int  ScreenY( LocalWin *wi    ,
              double    userY )
{
    int     val;

  //val  =  wi->XOppY - (int)((userY - wi->UsrOrgY)/wi->YUnitsPerPixel + 0.5);
    val  =  wi->XOppY - (int)((userY - wi->Ybegin)/wi->YUnitsPerPixel + 0.5);

    return (val);
}



/****************/
/*  axisSizing  */
/****************/

void axisSizing( LocalWin *wi      ,  /* Window information  */
                 int       axis_id ,  /* 0 = X, 1 = Y        */
                 double    Delta   ,  /* Tic mark distance   */
                 double   *Start   ,  /* Begining value      */
                 double   *Final   ,  /* Ending   value      */
                 int      *num     )  /* Number of tic marks */

/*
 * This routine calculates the begining and ending values
 * of the axis, and the number of increments in the axis,
 * given the caller's estimate of the incremental value,
 * i.e., the distance between tic marks (grid lines).
 */
{
 
    /* axis_id = 0,  calculate the X-axis variables */
    /* -------------------------------------------- */

    if      (axis_id == 0) {

      *Start = initGrid( wi->UsrOrgX, Delta, PM_BOOL("LogX"));

      *Final = *Start;
      *num   = 0;
      do {
        *Final = stepGrid();
        (*num)++;
      } while (*Final < wi->UsrOppX);

      /* reset the units per pixel scale based upon Start,Final */
    
    //if ( !numGrid ) {
        wi->XUnitsPerPixel = (*Final - *Start) / ((double)(wi->XOppX - wi->XOrgX));
    //}

    }

    /* axis_id = 1,  calculate the Y-axis variables */
    /* -------------------------------------------- */

    else if (axis_id == 1) {

      *Start = initGrid( wi->UsrOrgY, Delta, PM_BOOL("LogY"));

      *Final = *Start;
      *num   = 0;
      do {
        *Final = stepGrid();
        (*num)++;
      } while (*Final < wi->UsrOppY);

      /* reset the units per pixel scale based upon Start,Final */
    
    //if ( !numGrid ) {
        wi->YUnitsPerPixel = (*Final - *Start) / ((double)(wi->XOppY - wi->XOrgY));
    //}

    }

    /* axis_id = ?,  unknown axis, return NULL values */
    /* ---------------------------------------------- */

     else {

      *Start = 0.0;
      *Final = 0.0;
      *num   = 0;

    }

}
