C$FORTRAN           TGASP
      program       TGASP
C+---------------------------------------------------------------------+
C|    This Program tests the random access I/O routine 'GASP'          |
C+---------------------------------------------------------------------+
C+---------------------------------------------------------------------+
C|                  P A R A M E T E R S                                |
C+---------------------------------------------------------------------+
      integer       NWDS,     NBLK
      parameter    (NWDS = 16384)
      parameter    (NBLK = 5)
C+---------------------------------------------------------------------+
C|                  T Y P E   &   D I M E N S I O N S                  |
C+---------------------------------------------------------------------+
      integer       opt
      integer       ordwt(NBLK),        ordrd(NBLK),        istbk(NBLK)
      integer       data(NWDS)
C+---------------------------------------------------------------------+
C|                  E X T E R N A L S                                  |
C+---------------------------------------------------------------------+
      external      GASP

      external      MAKBLK,   PRIBLK,   ZEROIT
C+---------------------------------------------------------------------+
C|                  D  A  T  A                                         |
C+---------------------------------------------------------------------+
      data          ordwt/ 1, 2, 3, 4, 5 /
      data          istbk/ 0, 0, 0, 0, 0 /
      data          ordrd/ 2, 5, 4, 1, 3 /
C+---------------------------------------------------------------------+
C|                  L O G I C                                          |
C+---------------------------------------------------------------------+
      write (6,2000)
C+---------------------------------------------------------------------+
C|    Open  Unit #1  as the logical unit on which to perform the test. |
C+---------------------------------------------------------------------+
      write (6,2001)

      opt   =  -1
      iloc  =   0

      call     GASP (data, NWDS, opt, iloc)

C+---------------------------------------------------------------------+
C|    Generate buffers of random numbers and output them to the file.  |
C+---------------------------------------------------------------------+
      write (6,2002)
      opt  =   1

      do 200 jblk = 1,nblk

        iblk  =  ordwt(jblk)
        iloc  =  0
        write (6,2005) iblk

        call     MAKBLK (iblk, data(1), NWDS)

        call     PRIBLK (iblk, data(1), NWDS)

        call     GASP (data, NWDS, opt, iloc)

        istbk(jblk)  =  iloc
        write (6,2006) iloc

  200 continue
C+---------------------------------------------------------------------+
C|    Print out the SCRATCH file status                                |
C+---------------------------------------------------------------------+
      write (6,2003)
      opt  =  -3

      call     GASP (data, NWDS, opt, iloc)

C+---------------------------------------------------------------------+
C|    Read buffers back into core, in an random fashion & check them.  |
C+---------------------------------------------------------------------+
      write (6,2004)
      opt  =   3

      call     ZEROIT (data(1), NWDS)

      do 300 jblk = 1,nblk

        iblk  =  ordrd(jblk)
        iloc  =  istbk(iblk)
        write (6,2007) iblk, iloc

        call     ZEROIT (data(1), NWDS)

        call     GASP (data, NWDS, opt, iloc)

        call     PRIBLK (iblk, data(1), NWDS)

  300 continue
C+---------------------------------------------------------------------+
C|    Close out unit #4 and terminate the test.                        |
C+---------------------------------------------------------------------+
      write (6,2008)

      opt  =  -2
      iblk =   0

      call     GASP (data, NWDS, opt, iloc)

      write (6,2009)

      stop
C+---------------------------------------------------------------------+
C|    Format statements                                                |
C+---------------------------------------------------------------------+
 2000 format (////' ===== Testing Random I/O Routine GASP ====='/)
 2001 format (////' Opening GASP I/O Unit'/)
 2002 format (////' ----- Writing Out Blocks of Data -----',
     $           /' **************************************'//)
 2003 format (////' ----- Taking Status of SCRATCH File -----',
     $           /' *****************************************'//)
 2004 format (////' ----- Reading In Blocks of Data -----',
     $           /' *************************************'//)
 2005 format (//5X,' Requested DATA_SET no. = ',I3)
 2006 format (//5X,' Returned starting block number = ',I3)
 2007 format (//5X,' Requested DATA_SET no. = ',I3,
     $         /5X,' Starting Block number  = ',I3)
 2008 format (////' Closing GASP I/O Unit'/)
 2009 format (////' == End of Testing Random I/O Routines =='/)

      end
C$FORTRAN           MAKBLK
      subroutine    MAKBLK (iblk, data, lng)
      dimension     data(*)
      integer       iblk, data, lng, i
C+---------------------------------------------------------------------+
C|    Fill the Data Array with the value of the block number (iblk)    |
C+---------------------------------------------------------------------+
      do 100 i = 1,lng
        data(i) = iblk
  100 continue

      return
      end
C$FORTRAN           PRIBLK
      subroutine    PRIBLK (iblk, a, n)
C+---------------------------------------------------------------------+
C|    Print out the test block  a(n)                                   |
C+---------------------------------------------------------------------+
      integer       iblk, a(*), n
      integer       l1, l1b, l1e, l2, l2b, l2e

      integer       nrows, nwds
      parameter    (nrows = 4)
      parameter    (nwds  = 5 * nrows)
C+---------------------------------------------------------------------+
C|    print out the first and last 'nwds' of array  a(-)               |
C+---------------------------------------------------------------------+
      write(6,2000) iblk, n

      l1b  =   1
      l1e  =   nwds

      l2e  =   n
      l2b  =   n - nwds + 1

      if (l1e .gt. l2b)                then

        write(6,2001) (a(l1),l1=l1b,l2e)

      else

        write(6,2001) (a(l1),l1=l1b,l1e)
        write(6,2002)
        write(6,2001) (a(l2),l2=l2b,l2e)

      endif

      return
C+---------------------------------------------------------------------+
C|    Format Statements                                                |
C+---------------------------------------------------------------------+
 2000 format (/5X,'Test array values:  iblk = ',I3,'  nwds = ',I6/)
 2001 format (5X,10I6)
 2002 format (5X,10(5X,'"')/5X,10(5X,'"'))
      end
C$FORTRAN           ZEROIT
      subroutine    ZEROIT (data, lng)
      integer       data(*), lng, i
C+---------------------------------------------------------------------+
C|    Zero Out the Data Array                                          |
C+---------------------------------------------------------------------+
      do 100 i = 1,lng
        data(i) = 0
  100 continue

      return
      end
C$FORTRAN           SOLSTP
      subroutine SOLSTP ( name )

      character  name*(*)
C+---------------------------------------------------------------------+
C|    terminate the solution process                                   |
C+---------------------------------------------------------------------+
      integer   i1
      integer   j
      integer   k
      integer   l(2)
C+---------------------------------------------------------------------+
C|                  L O G I C                                          |
C+---------------------------------------------------------------------+
      write (6,2000)  name

      close (unit=6)

      i1      = 1459542325
      j       = l(i1)
      l(i1+1) = l(i1+1) + k

      call exit ( 999 )

      stop
C+---------------------------------------------------------------------+
C|    Format Statements                                                |
C+---------------------------------------------------------------------+
 2000 format (// ' Error Traceback generated by the STAGS code',
     &        // ' SOLSTP was called by routine = ', a // )

      end
