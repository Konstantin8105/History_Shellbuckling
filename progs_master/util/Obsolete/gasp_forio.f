C=DECK      GASPNEWLIB
C
C  THIS IS THE GASP LIBRARY THAT IS PORTABLE TO OTHER OPERATING
C  SYSTEMS THAN VAX VMS. IT IS SLOWER THAN THE VERSION CALLED
C  GASPOLD.OLD, WHICH IS WRITTEN EXPRESSLY FOR VAX VMS.
C
C
C
C=DECK      GASP
      SUBROUTINE GASP
     1(A, NW, IC, ID)
C
c
c                       D I M E N S I O N
c
      DIMENSION A(1)
      INTEGER A
      INTEGER ddpars(4),lsect
      DOUBLE PRECISION WTRANS
      COMMON/IDHIGH/IDMAX
C
C  FOUR LINES ADDED BY D. BUSHNELL ON AUG. 29, 1985..
C
      COMMON/IBLCK/IBLOCK
      COMMON/UNITNO/IU
      CHARACTER*7 FORNAM
      CHARACTER*2 CNNN
C  END OF 29 AUG. 1985 UPDATE, FIRST PART
c
c                          D A T A
c
      DATA  ldi /8/, ddpars /4*0/
      DATA  IBLANK /4H    /
      DATA IBUG /0/
C     DATA FIL /4HDIS /
c
c
c                           L O G I C
c
      NOT = 6
      IF (IC.EQ.-1)               GO TO 1000
      IF (IC.EQ.-2)               GO TO 2000
      GO TO 10
c
c.... Initialization (Set sector pointer and declare file)
c
 1000 NWA=1
      IBLOCK=IDMAX+1
C  FOLLOWING STATEMENT COMMENTED OUT BY D. BUSHNELL ON 29 AUG., 1985
C      IU=11
C
      NSECT=512
      IOPEN=-1
      WTRANS=0.
C
C  CHANGED 29 AUG. 1985..
C     CALL BIOMFO (IU,'FOR011 ',IOPEN,IERR)
c
c File naming changed 8/24/92 for compatibility with UNIX fort.* naming
c schemes and PANDA2's dual block i/o file use.
c     CALL CONVRT(IU,CNNN)
      FORNAM = 'fort.11'
      CALL BIOMFO (IU,FORNAM,IOPEN,IERR)
C  END OF 29 AUG. 1985 MODS.
      IF (IERR.NE.0) GO TO 820
      RETURN
c
   10 IF (IC.EQ.3)                GO TO 30
      IF (IC.NE.1)   CALL ABORT
c
c.... Write A to disc
c
      IF (ID.GT.0)                GO TO 20
c
c.... New record
c
      ID=IBLOCK
      NBYTES=4*NW
      IBLOCK=IBLOCK+(NBYTES-1)/NSECT+1
      IDMAX = IBLOCK
      CALL BIOMFW (IU,A,NBYTES,ID,IERR)
      IF (IERR.NE.0) GO TO 840
      ISTOR = (IBLOCK-1)*(NSECT/4)
      IF (IBLOCK.GE.0) GO TO 20
C     PRINT 900,  nlim * lsect
  900 FORMAT (/' ERROR IN GASP:  DISC LIMIT =',i10,' EXCEEDED.'/)
      CALL  ABORT
c
   20 NBYTES=4*NW
      CALL BIOMFW (IU,A,NBYTES,ID,IERR)
      IF (IERR.NE.0) GO TO 860
      IF (IBUG.EQ.1) WRITE (6,925) ID,NW,A(NW),IC
  925 FORMAT (' ID= ', I10, '  NW= ', I6, '  CHECK= ', I14,' IC= ',I3)
      GO TO 50
c
c.... Read A from disc
c
   30 NBYTES=4*NW
      CALL BIOMFR (IU,A,NBYTES,ID,IERR)
      IF (IERR.NE.0) GO TO 880
      IF (IBUG.EQ.1) WRITE (6,925) ID,NW,A(NW),IC
CUPD  OCT26,81
   50 WTRANS=WTRANS+NW
CEND  OCT26,81
      IGAS = IGAS + 1
      RETURN
c
c.... Finalization (list statistics and close file)
 2000 CALL BIOMFC (IU,IERR)
      IF (IERR.NE.0) GO TO 890
      RETURN
  820 CONTINUE
      WRITE (NOT,920) IU,'FOR011.DAT',IOPEN,IERR
  920 FORMAT (/ ' ERROR OPENING FILE.  IU   NAME   IOPEN  IERR '
     $ / 20X I4, A10 , I8, I4)
      CALL ABORT
  840 CONTINUE
      WRITE (NOT,940) IU,NW,IC,ID,IERR
  940 FORMAT (/' ERROR IN BLOCKIO.  IU    NW    IC    ID   IERR '
     $ / 22X 3I6, I8,I6)
      CALL ABORT
      STOP
  860 GO TO 840
  880 GO TO 840
  890 GO TO 840
      END
C
C
C
C=DECK      IB
      FUNCTION IB(N)
CD     M = N
      IB= N
      IF (N.LE.0) IB = 1
CD     TYPE *,'IB ENTERED',M,N
      RETURN
      END
C
C
C
C=DECK      F77BIO
C
C      This collection of "pure" Fortran 77 subroutines simulate the
C      machine  dependent block I/O calls that BOSOR4 expects from
C      GASP
C
C + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
C     Open file
C + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
C
      subroutine  BIOMFO  ( IU, NAME, IOPEN, IERR )
C
      character  NAME*(*)
C
      if ( IOPEN .ne. 2 )  then
        open ( unit=IU, file=NAME, form='unformatted',
     *         access='direct', status='unknown', recl=512,
     *         iostat=IERR )
       else
        open ( unit=IU, file=NAME, form='unformatted',
     *         access='direct', status='scratch', recl=512,
     *         iostat=IERR )
       end if
C
      return
      end
C
C + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
C     Read from file
C + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
C
      subroutine  BIOMFR  ( IU, A, NBYTES, NBLOCK, IERR )
C
      dimension  A(1)
      character  ekey*4
C
      n = IOMRDA ( IU, A, NBYTES/4, NBLOCK-1, 128, nwx, ekey, IERR )
      if ( IERR .ne. 0 ) then
         print *,' BIOMFR: nwx , ekey = ', nwx,ekey
      end if
C
      return
      end
C
C + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
C     Write to file
C + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
C
      subroutine  BIOMFW  ( IU, A, NBYTES, NBLOCK, IERR )
C
      dimension  A(1)
      character  ekey*4
C
      n = IOMWDA ( IU, A, NBYTES/4, NBLOCK-1, 128, nwx, ekey, IERR )
      if ( IERR .ne. 0 ) then
         print *,' BIOMFW: nwx, ekey, n = ', nwx,ekey,n
         print *,' BIOMFW: NBYTES, NBLOCK =', NBYTES, NBLOCK
         print *,' A array =',(A(i),i=1,NBYTES/4)
      end if
C
      return
      end
C
C + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
C     Close file
C + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
C
      subroutine  BIOMFC  ( IU, IERR )
C
      close ( unit=IU, iostat=IERR )
C
      return
      end
C
C
C + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
C     F77 simulation of block I/O routines
C + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
C
C
C
C
C=DECK      IOMRDA
C=PURPOSE Read FRU-spanning record from DA Fortran file
C=AUTHOR C. A. Felippa, January 1980
C=VERSION June 1982
C=KEYWORDS auxiliary storage manager input output I/O
C=KEYWORDS data management database DMS DBMS
C=BLOCK USAGE
C
C       NEWFRU =  IOMRDA  (LU, A, NW, IFRU, FRU, NWX, EKEY, IOST)
C
C     Input arguments:
C
C       LU          Fortran logical unit number.
C       A           Array that will receive record.
C       NW          Number of words to read.
C       IFRU        First source FRU (counting from 0).
C       FRU         FRU size in words.
C
C     Output arguments:
C
C       NWX         Number of words transferred.
C       EKEY        4-letter error information key.
C       IOST        Receives I/O status code returned by Fortran
C                   I/O library in case of error.
C
C     Function return:
C
C       IOMRDA      If no abnormal condition detected, returns
C                   next FRU to read/write (a positive integer).
C                   If error detected, returns -1.
C
C=END USAGE
C=BLOCK FORTRAN
      integer function IOMRDA
     $    (lu, a, nw, ifru, fru, nwx, ekey, iost)
C
C                   T Y P E   &   D I M E N S I O N
C
      integer       fru, lu, nw, ifru, nwx, iost, a(*)
      character*4   ekey
      integer       j, kr, kx, n, size
C
C                   L O G I C
C
      kr =       ifru
      size =     nw
      kx =       0
      nwx =      0
      ekey =     ' '
C
 2000   IOMRDA =   kr
        kr =       kr + 1
        n =        min0(size,fru)
        if (n .le. 0)                       return
        read (unit=lu,rec=kr,iostat=iost,err=8000) (a(kx+j),j=1,n)
        kx =       kx + n
        nwx =      kx
        size =     size - n
        go to 2000
C
 8000 IOMRDA = -1
      ekey =     'MIRE'
      if (iost .lt. 0)                      ekey = 'RBEI'
      return
      end
C=END FORTRAN
C
C
C=DECK      IOMWDA
C=PURPOSE Write FRU-spanning record on DA Fortran file
C=AUTHOR C. A. Felippa, January 1980
C=VERSION June 1982
C=KEYWORDS auxiliary storage manager input output I/O
C=KEYWORDS data management database DMS DBMS
C=BLOCK USAGE
C
C       NEWFRU =  IOMWDA  (LU, A, NW, IFRU, FRU, NWX, EKEY, IOST)
C
C     Input arguments:
C
C       LU          Fortran logical unit number.
C       A           Array to transmit.
C       NW          Number of words to write.
C       IFRU        First receiving FRU (counting from 0).
C       FRU         Fortran record unit size in words.
C
C     Output arguments:
C
C       NWX         Number of words transmitted.
C       EKEY        4-letter error information key.
C       IOST        Receives I/O status code returned by Fortran
C                   I/O library in case of error.
C
C     Function return:
C
C       IOMWDA      If no abnormal condition detected, returns
C                   next FRU to read/write (a positive integer).
C                   -10    If I/O error detected.
C
C=END USAGE
C=BLOCK FORTRAN
      integer function IOMWDA
     $    (lu, a, nw, ifru, fru, nwx, ekey, iost)
C
C                   T Y P E   &   D I M E N S I O N
C
      integer       fru, lu, nw, ifru, nwx, iost, a(*)
      character*4   ekey
      integer       j, kr, kx, n, size
C
C                   L O G I C
C
      kr =       ifru
      size =     nw
      kx =       0
      ekey =     ' '
C
 2000   IOMWDA =   kr
        kr =       kr + 1
        n =        min0(size,fru)
        if (n .le. 0)                      return
        write (unit=lu,rec=kr,iostat=iost,err=8000) (a(kx+j),j=1,n)
        kx =       kx + n
        nwx =      kx
        size =     size - n
        go to 2000
C
 8000 IOMWDA = -1
      ekey =    'MIWE'
      return
      end
C=END FORTRAN
C
C
C
C=DECK      ABORT
C./	 ADD   NAME=ANGLE
      SUBROUTINE ABORT(II)
C
C     THIS ROUTINE EFFECTS AN EXIT FOR THE CURRENT EXECUTION
C     OF THE PROGRAM VIA A CALL TO  E X I T   OR TO A SYSTEM
C     ERROR TERMINATION TRANSFER POINT
C     01 JULY 1976 VERSION
C
      I=0
      GO TO (10,20,30), II
   10 CALL ERREX
   20 GO TO(10,30),I
   30 RETURN
      END
C
C
C
c Added by B. Bushnell 8/24/92
c
c int2str converts an integer to a left-adjusted character string.
c
c  Arguments:
c
c	IN ---> number : the number to be converted
c      OUT <--- outstr : the output character string
c
      subroutine int2str(number, outstr)
      integer number
      character*(*) outstr

c ----------------------- Declarations -----------------------

      integer digits
      character*11 fmtstr, temp, ladjust

c ----------------------- Executable Code --------------------

      if (number .gt. 0) then
        digits = INT(LOG10(FLOAT(number))) + 1
      else if (number .lt. 0) then
        digits = INT(LOG10(FLOAT(ABS(number)))) + 2
      else
        digits = 1
      endif
      write(fmtstr, 5) digits

      write(temp, '(a)') ladjust(fmtstr)
      fmtstr = temp
      write(temp, 15) fmtstr(1:index(fmtstr,' ')-1)
      write(fmtstr, '(a)') temp(1:index(temp,' ')-1)

      write(outstr, fmtstr) number
      write(temp,'(a)') ladjust(outstr)
      write(outstr, '(a)') temp(1:index(temp,' ')-1)

      return

c format statements here

    5 format(i2)
   15 format('(i',a,')')

      end
