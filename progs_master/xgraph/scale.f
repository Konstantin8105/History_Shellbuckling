C$F77               SCALE
      subroutine    SCALE (array, axleng, npts, inc)

      implicit double precision (a-h,o-z)
c+---------------------------------------------------------------------+
c|    This subroutine scales data to fit along an axis.                |
c|                                                                     |
c|     array = name of the real array containing values to be scaled.  |
c|                                                                     |
c|    axleng = length (in inches) over which array is to be scaled.    |
c|                                                                     |
c|      npts = number of points to be scaled.                          |
c|                                                                     |
c|       inc = increment of location of successive points in array.    |
c+---------------------------------------------------------------------+
c|    The subroutine returns the scalling information in the input     |
c|    (array) as follows, with  (nn) = (npts * inc + 1)                |
c|                                                                     |
c|        array(nn    ) = relative minimum value of array(i)           |
c|        array(nn+inc) = scale factor for array(i) array              |
c+---------------------------------------------------------------------+
c+---------------------------------------------------------------------+
c|                  A R G U M E N T S                                  |
c+---------------------------------------------------------------------+
      integer       npts,     inc
      double precision        array(*), axleng
c+---------------------------------------------------------------------+
c|                  L O C A L   V A R I A B L E S                      |
c+---------------------------------------------------------------------+
      double precision        save(9),  eps
      double precision        zer,      hlf,      one,      two,
     $                        ten,      tsd
c+---------------------------------------------------------------------+
c|                  D A T A                                            |
c+---------------------------------------------------------------------+
      data          save(1) /  1.0d+00/,          save(2) /  2.0d+00/,
     $              save(3) /  4.0d+00/,          save(4) /  5.0d+00/,
     $              save(5) /  8.0d+00/,          save(6) / 10.0d+00/,
     $              save(7) / 20.0d+00/

      data          eps     / 0.01d+00/

      data          zer     / 0.00d+00 /
      data          hlf     / 5.00d-01 /
      data          one     / 1.00d+00 /
      data          two     / 2.00d+00 /
      data          ten     / 1.00d+01 /
      data          tsd     / 1.00d+03 /
c+---------------------------------------------------------------------+
c|                  L O G I C                                          |
c+---------------------------------------------------------------------+
      add   =  eps
      k     =  ABS(inc)
      n     =  npts * k
      xmin  =  array(1)
      xmax  =  xmin

      do 10 i = 1,n,k
        xi  =  array(i)
        if     (xi .lt. xmin)          then
          xmin = xi
        elseif (xi .gt. xmax)          then
          xmax = xi
        endif
   10 continue

      firstv  =  xmin
      if (xmin .lt. zer)               add = add - one

      deltav  =  (xmax-firstv) / axleng
      if (deltav .le. zer)             then
        deltav  =  two * firstv
        deltav  =  ABS (deltav/axleng) + one
      endif

      i       =  LOG10 (deltav) + tsd
      p       =  ten**(i-1000)
      deltav  =  deltav / p - eps

      do 15 i = 1,6
        is   = i
        if (save(i) .ge. deltav)       go to 20
   15 continue

   20 deltav  =  p * save(is)
      firstv  =  deltav * INT (xmin/deltav + add)
      top     =  firstv + (axleng + eps) * deltav

      if (top .lt. xmax)               then
        firstv  =  p * INT (xmin/p + add)
        top     =  firstv + (axleng + eps) * deltav
        if (top .lt. xmax)             then
          is    =  is + 1
          go to 20
        endif
      endif

      resid   =  axleng - (xmax - firstv) / deltav
      firstv  =  firstv - INT (hlf*resid) * deltav
      if (xmin*firstv .le. zer)        firstv = zer

      if (inc .le. 0)                  then
        firstv  =  firstv + INT (axleng + hlf) * deltav
        deltav  = -deltav
      endif

      n         =  n + 1
      array(n)  =  firstv
      n         =  n + k
      array(n)  =  deltav

      return
      end
