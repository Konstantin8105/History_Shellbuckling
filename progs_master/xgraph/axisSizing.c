
/****************/
/*  axisSizing  */
/****************/

void axisSizing( LocalWin *wi      ,  /* Window information  */
                 int       axis_id ,  /* 0 = X, 1 = Y        */
                 int       numGrid ,  /* Suggested no. incr  */
                 int       logFlag ,  /* Is this a log axis? */
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

      *Start = initGrid( wi->UsrOrgX, Delta, logFlag );

      *Final = *Start;
      *num   = 0;
      do {
        *Final = stepGrid();
        *num++;
      } while (*Final < wi->UsrOppX);

      /* reset the units per pixel scale based upon Start,Final */
    
    //if ( !numGrid ) {
        wi->XUnitsPerPixel = (*Final - *Start) / ((double)(wi->XOppX - wi->XOrgX));
    //}

    }

    /* axis_id = 1,  calculate the Y-axis variables */
    /* -------------------------------------------- */

    else if (axis_id == 1) {

      *Start = initGrid( wi->UsrOrgY, Delta, logFlag );

      *Final = *Start;
      *num   = 0;
      do {
        *Final = stepGrid();
        *num++;
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
