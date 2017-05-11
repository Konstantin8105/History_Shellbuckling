C=DECK CC2H
      subroutine    CC2H
     *                    (c, h, n)
C+---------------------------------------------------------------------+
C|    CC2H copies a Fortran 77 CHARACTER string into a Hollerith       |
C|    string.  This "conversion" is needed to fool the compiler and    |
C|    the block i/o system, in order to input/output char data.        |
C+---------------------------------------------------------------------+
C|    The calling sequence is:                                         |
C|                                                                     |
C|        CALL     CC2H  (C, H, N)                                     |
C|                                                                     |
C|    Inputs -                                                         |
C|                                                                     |
C|      C          Source character string.                            |
C|      H          Target Hollerith string.                            |
C|      N          Number of characters to be moved.                   |
C|                 No operation if N le 0.                             |
C|                                                                     |
C|    Outputs -                                                        |
C|                                                                     |
C|      H          Updated Hollerith string.                           |
C+---------------------------------------------------------------------+
      implicit      none










C+---------------------------------------------------------------------+
C|                  T Y P E   &   D I M E N S I O N                    |
C+---------------------------------------------------------------------+
      character*1   c(*)
      integer       h(*), n
      integer       ich, iwd, jch, k, lcs, nask(4), nwd
C+---------------------------------------------------------------------+
C|                  D A T A                                            |
C+---------------------------------------------------------------------+
      data          nask(1) / z'FFFFFF00' /,
     *              nask(2) / z'FFFF00FF' /,
     *              nask(3) / z'FF00FFFF' /,
     *              nask(4) / z'00FFFFFF' /
C+---------------------------------------------------------------------+
C|                  L O G I C                                          |
C+---------------------------------------------------------------------+
      do 1000  k = 1,n
        iwd     =  (k-1)/4 + 1
        lcs     =  8 * (k-1)
        nwd     =  k - 4*(iwd-1)
        ich     =  lshift (ichar(c(k)),lcs)
        jch     =  and (h(iwd), nask(nwd))
        h(iwd)  =  or  (jch, ich)
 1000 continue











      return
      end

