
#include "aparms.h"

/*
 * calcomp.c: xgraph sizing code
 */


/**************/
/*  iCalComp  */
/**************/

void  iCalComp( LocalWin *wi )

{
    int     pad;
    int     width,  height;
    int     XOrg_X, XOrg_Y;
    int     XOpp_X, XOpp_Y;

    double  stepx,  stepy;
    double  rstpx,  rstpy;
    double  basex,  basey;

    double  xmin, xmax, axix;
    double  ymin, ymax, axiy;

    double  begx, endx, delx;
    double  begy, endy, dely;

    double  xrat, yrat, arat;
    double  prat, lrat;

    static int debug = 0;

    /* get pixel bounding box */

    pad    = wi->dev_info.axis_pad;
    width  = wi->dev_info.axis_width;
    height = wi->dev_info.axis_height;

    XOrg_X = wi->UsrOrgX / wi->XUnitsPerPixel;
    XOrg_Y = wi->UsrOrgY / wi->YUnitsPerPixel;

    XOpp_X = wi->UsrOppX / wi->XUnitsPerPixel;
    XOpp_Y = wi->UsrOppY / wi->YUnitsPerPixel;


    stepx  = (pad + width)  * wi->XUnitsPerPixel;
    stepy  = (pad + height) * wi->YUnitsPerPixel;

    /* get start ( base* ) and increment ( rstp* ) for axes */

    rstpx  =  RoundUp(stepx);
    rstpy  =  RoundUp(stepy);

    basex  =  floor(XOrg_X/rstpx) * rstpx;
    basey  =  floor(XOrg_Y/rstpy) * rstpy;

    if (debug) {
      printf("\n");
      printf("iCalComp(): pad        = %13d\n",   pad);
      printf("==========\n");
      printf("wth/hgt    = %13d  %13d\n",     width,   height);
      printf("X/Y _U_PP  = %13.5e  %13.5e\n", wi->XUnitsPerPixel, wi->YUnitsPerPixel);
      printf("UsrOrgX/Y  = %13.5e  %13.5e\n", wi->UsrOrgX, wi->UsrOrgY);
      printf("UsrOppX/Y  = %13.5e  %13.5e\n", wi->UsrOppX, wi->UsrOppY);
      printf("\n");
      printf("XOrg_X/Y   = %13d  %13d\n",     XOrg_X,  XOrg_Y);
      printf("XOpp_X/Y   = %13d  %13d\n",     XOpp_X,  XOpp_Y);
      printf("\n");
      printf("stepx/y    = %13.5e  %13.5e\n", stepx,   stepy);
      printf("rstpx/y    = %13.5e  %13.5e\n", rstpx,   rstpy);
      printf("basex/y    = %13.5e  %13.5e\n", basex,   basey);
      printf("\n");
    }

    /* PORTRAIT Mode */

    xmin  =  wi->UsrOrgX;
    xmax  =  wi->UsrOppX;
    axix  =  width;

    set_Grid(  xmin ,
               xmax ,
               axix ,
              &begx ,
              &endx ,
	       &delx );

    xrat = (xmax - xmin) / (endx - begx);


    if (debug) {
      printf("\n");
      printf("Portrait x/y %13.5e  %13.5e\n", axix, axiy);
      printf("\n");
      printf("x-min/max  = %13.5e  %13.5e\n", xmin, xmax);
      printf("x-beg/end  = %13.5e  %13.5e\n", begx, endx);
      printf("x-del/rat  = %13.5e  %13.5e\n", delx, xrat);
    }

    ymin  =  wi->UsrOrgY;
    ymax  =  wi->UsrOppY;
    axiy  =  height;

    set_Grid(  ymin ,
               ymax ,
               axiy ,
              &begy ,
              &endy ,
	       &dely );

    yrat = (ymax - ymin) / (endy - begy);

    prat =  xrat * yrat;

    if (debug) {
      printf("\n");
      printf("y-min/max  = %13.5e  %13.5e\n", ymin, ymax);
      printf("y-beg/end  = %13.5e  %13.5e\n", begy, endy);
      printf("y-del/rat  = %13.5e  %13.5e\n", dely, yrat);
      printf("\n");
      printf("p-ratio    = %13.5e\n", prat);
    }


    /* LANDSCAPE Mode */

    xmin  =  wi->UsrOrgX;
    xmax  =  wi->UsrOppX;
    axix  =  height;

    set_Grid(  xmin ,
               xmax ,
               axix ,
              &begx ,
              &endx ,
	       &delx );

    xrat = (xmax - xmin) / (endx - begx);


    if (debug) {
      printf("\n");
      printf("Landscap x/y %13.5e  %13.5e\n", axix, axiy);
      printf("\n");
      printf("x-min/max  = %13.5e  %13.5e\n", xmin, xmax);
      printf("x-beg/end  = %13.5e  %13.5e\n", begx, endx);
      printf("x-del/rat  = %13.5e  %13.5e\n", delx, xrat);
    }

    ymin  =  wi->UsrOrgY;
    ymax  =  wi->UsrOppY;
    axiy  =  width;

    set_Grid(  ymin ,
               ymax ,
               axiy ,
              &begy ,
              &endy ,
	       &dely );

    yrat = (ymax - ymin) / (endy - begy);

    lrat =  xrat * yrat;

    if (debug) {
      printf("\n");
      printf("y-min/max  = %13.5e  %13.5e\n", ymin, ymax);
      printf("y-beg/end  = %13.5e  %13.5e\n", begy, endy);
      printf("y-del/rat  = %13.5e  %13.5e\n", dely, yrat);
      printf("\n");
      printf("l-ratio    = %13.5e\n", lrat);
    }


    return;
}


/**************/
/*  set_Grid  */
/**************/

void  set_Grid( double  zmin ,
                double  zmax ,
                double  axis ,
                double *zbeg ,
                double *zend ,
                double *zdel )

{
    int     i, is, k, ok;

    double  begz, endz, delz;
    double  eps,  add,  p;
    double  resd;

    static double sav[] = { 1.0, 2.0, 4.0, 5.0, 8.0, 10.0, 20.0 };

    static int debug = 0;


    if (debug) {
      printf("\n");
      printf("set_Grid()\n");
      printf("==========\n");
      printf("zmin       = %13.5e\n", zmin);
      printf("zmax       = %13.5e\n", zmax);
      printf("axis       = %13.5e\n", axis);
    }

    eps   =  1.0e-06;
    add   =  eps;
    begz  =  zmin;
    if (zmin < 0.0) add -= 1.0;

    delz  =  (zmax - begz) / axis;
    if (delz < 0.0) {
      delz = 2.0 * begz;
      delz = fabs(delz/axis) + 1.0;
    }

    i     =  (int)(log10(delz) + 1.0e+3);
    p     =  pow(10.0, (double)(i-1000));
    delz  =  delz / p - eps;


    if (debug) {
      printf("\n");
      printf("add        = %13.5e\n", add);
      printf("delz       = %13.5e\n", delz);
      printf("\n");
      printf("i          = %13d\n", i);
      printf("p          = %13.5e\n", p);
      printf("delz       = %13.5e\n", delz);
    }

    for (k = 0; k < 6; k++) {
      is  = k;
      if (sav[is] >= delz) break;
    }

    ok = 1;

    while (ok) {

      delz  =  p * sav[is];
      begz  =  delz * floor(zmin/delz + add);
      endz  =  begz + (axis + eps) * delz;

      if (debug) {
        printf("\n");
        printf("is         = %13d\n", is);
        printf("sav[is]    = %13.5e\n", sav[is]);
        printf("begz       = %13.5e\n", begz);
        printf("endz       = %13.5e\n", endz);
        printf("delz       = %13.5e\n", delz);
      }

      if (endz >= zmax) {
        ok  =  0;
        break;
      }

      /* try shifting begz/endz */

      begz  =  p * floor(zmin/p + add);
      endz  =  begz + (axis + eps) * delz;

      if (debug) {
        printf("\n");
        printf("begz       = %13.5e  shifted\n", begz);
        printf("endz       = %13.5e  shifted\n", endz);
      }

      if (endz >= zmax) {
        ok  =  0;
        break;
      }

      is++;

      if (is > 6) ok = 0;

    }

    resd  =  axis - (zmax - begz) / delz;
    begz  =  begz - floor(0.5*resd) * delz;
    if (zmin*begz <= 0.0) begz = 0.0;

    if (debug) {
      printf("\n");
      printf("resd       = %13.5e\n", resd);
      printf("begz       = %13.5e\n", begz);
      printf("\n");
      printf("begz       = %13.5e  final\n", begz);
      printf("endz       = %13.5e  final\n", endz);
      printf("delz       = %13.5e  final\n", delz);
      printf("\n");
    }

    *zbeg  =  begz;
    *zend  =  endz;
    *zdel  =  delz;

    return;
}
