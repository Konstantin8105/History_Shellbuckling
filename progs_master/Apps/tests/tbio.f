C$F77               TBIO
      program       TBIO
C+---------------------------------------------------------------------+
C|    This Program tests the random access Block I/O routines          |
C+---------------------------------------------------------------------+
C+---------------------------------------------------------------------+
C|                  C O M M O N    &    G L O B A L S                  |
C+---------------------------------------------------------------------+
      integer       nbpi,     nbpf,     prusiz
      common /BIOPAR/
     $              nbpi,     nbpf,     prusiz
C+---------------------------------------------------------------------+
C|                  L O C A L   V A R I A B L E S                      |
C+---------------------------------------------------------------------+
      integer       PRULIM
      parameter    (PRULIM = 2048)

      character     edn*32,   opo*2,    opc*1
      integer       ierr,     io6
      logical       ipri

      integer       MXCASE
      parameter    (MXCASE = 4)

      character*32  filnam(MXCASE)
      character*2   optopn(MXCASE)
      character*1   optclo(MXCASE)
C+---------------------------------------------------------------------+
C|                  E X T E R N A L S                                  |
C+---------------------------------------------------------------------+
      external      TSTEDN
C+---------------------------------------------------------------------+
C|                  D  A  T  A                                         |
C+---------------------------------------------------------------------+
      data          io6    / 6 /

      data          filnam / 'fort.4', 
     $                       'SCRATCH',
     $                       'fort.5',
     $                       'fort.4' /

      data          optopn / '  ',
     $                       ' s',
     $                       '  ',
     $                       'ro' /

      data          optclo / ' ',
     $                       ' ',
     $                       'd',
     $                       ' ' /
C+---------------------------------------------------------------------+
C|                  L O G I C                                          |
C+---------------------------------------------------------------------+

      ipri    =  .TRUE.

      call        BLKSIZ (prusiz, nbpi, nbpf, ierr)

      write (io6,4000) prusiz, nbpi, nbpf
 4000 format (//'  TBIO - checking file parameters',
     $        //'    prusiz  =  ',i6,
     $         /'    nbpi    =  ',i6,
     $         /'    nbpf    =  ',i6,/)

      if ((prusiz .le.      0) .or. 
     $    (prusiz .gt. prulim)     )    then
        write (io6,3000) edn, prusiz, prulim
        return
      endif

      do 100 icase = 1,MXCASE

        opo   =  optopn(icase)
        opc   =  optclo(icase)
        edn   =  filnam(icase)

        write (io6,2000) icase
        write (io6,2001) opo, opc, edn

        call     TSTEDN (opo, opc, edn, ipri, ierr)

        write (io6,3001) ' after ( TSTEDN ) call:'
        write (io6,3002) ierr

  100 continue

        stop
C+---------------------------------------------------------------------+
C|    format statements                                                |
C+---------------------------------------------------------------------+

 2000 format (//'+----------------------------------------',
     $          '---------------------------------------+',
     $         /'|                 Testing Block I/O Routi',
     $          'nes   ( Case No ',i2,' )                   |',
     $         /'+----------------------------------------',
     $          '---------------------------------------+')

 2001 format (//' Opening file for testing',
     $        //'    optopn  =  ',A2,
     $         /'    optclo  =  ',A1,
     $         /'    filnam  =  ',A)

 3000 format (/,' Error in TBIO:   BAD returned buffer size (prusiz)',
     $          ' from BLKSIZ(---)',
     $        /,'                    edn  = ',A,
     $        /,'                    prusiz = ',I6,'  prulim = ',I8,/)
 3001 format (/A)
 3002 format ('  ierr = ',I6)
      end
C$F77               TSTEDN
      subroutine    TSTEDN (opo, opc, edn, ipri, ierr)
C+---------------------------------------------------------------------+
C|    this routine tests the random access block I/O routines          |
C|    for the particular options (opt) for file (edn).                 |
C+---------------------------------------------------------------------+
C+---------------------------------------------------------------------+
C|                  A R G U M E N T S                                  |
C+---------------------------------------------------------------------+
      character     opo*(*),  opc*(*),  edn*(*)
      integer       ierr
      logical       ipri
C+---------------------------------------------------------------------+
C|                  C O M M O N    &    G L O B A L S                  |
C+---------------------------------------------------------------------+
      integer       nbpi,     nbpf,     prusiz
      common /BIOPAR/
     $              nbpi,     nbpf,     prusiz
C+---------------------------------------------------------------------+
C|                  L O C A L   V A R I A B L E S                      |
C+---------------------------------------------------------------------+
      integer       NBUF,     NBIO
      parameter    (NBUF = 4096)
      parameter    (NBIO =    5)

      integer       pruw
      integer       npru,     nwds,     nbpb
      integer       lopo,     lopc,     ledn
      integer       fd,       pos,      size

      real          data(prusiz)

      integer       io6
      integer       ordrd(NBIO),        ordwt(NBIO)
C+---------------------------------------------------------------------+
C|                  E X T E R N A L S                                  |
C+---------------------------------------------------------------------+
      external      BLKOPN,   BLKWTR,   BLKRDR,   BLKCLO

      external      MAKBIO,   PRIBLK,   ZEROIT
C+---------------------------------------------------------------------+
C|                  D  A  T  A                                         |
C+---------------------------------------------------------------------+
      data          io6   / 6 /

      data          ordwt / 1, 2, 3, 4, 5 /
      data          ordrd / 2, 5, 1, 4, 3 /
C+---------------------------------------------------------------------+
C|                  L O G I C                                          |
C+---------------------------------------------------------------------+
C+---------------------------------------------------------------------+
C|    open a logical unit on which to perform the test.                |
C+---------------------------------------------------------------------+
      if (ipri)                        then
        write (io6,2001)
      endif

      ledn  =  LEN(edn)
      lopo  =  LEN(opo)

      call     BLKOPN (edn, opo, fd, pruw, size, ierr)

      if (ipri)                        then
        write (io6,4001) ' after ( BLKOPN ) call:'
        write (io6,4002) fd, pruw, size
        write (io6,4000) ierr
      endif

      if (ierr .ne. 0)                 return

      nwds  =  prusiz
      nbpb  =  ( nwds + prusiz - 1 ) / prusiz

      if (opo(1:1) .eq. 'r')           go to 30
C+---------------------------------------------------------------------+
C|    generate buffers of random numbers and output them to the file   |
C+---------------------------------------------------------------------+
      if (ipri)                        then
        write (io6,2002)
      endif

      do 20 jblk = 1,NBIO
        iblk  =  ordwt(jblk)
        if (ipri)                      then
          write (io6,2003) iblk
        endif

        call     MAKBIO (iblk, data(1), nwds)
        if (ipri)                      then
          call   PRIBLK (iblk, data(1), nwds)
        endif

        call     BLKWTR (fd, data(1), nwds, iblk, ierr)

        if (ipri)                      then
          write (io6,4001) ' after ( BLKWTR ) call:'
          write (io6,4004) fd, iblk
          write (io6,4000) ierr
        endif
        
        call     BLKSTA (fd, ierr)

        if (ierr .ne. 0)               return

   20 continue
C+---------------------------------------------------------------------+
C|    check the status of the file                                     |
C+---------------------------------------------------------------------+
   30 call     BLKSTA (fd, ierr)

      if (ipri)                        then
        write (io6,4001) ' after ( BLKSTA ) call:'
        write (io6,4000) ierr
      endif

      if (ierr .ne. 0)                 return
C+---------------------------------------------------------------------+
C|    read buffers back into core, in an random fashion & check them   |
C+---------------------------------------------------------------------+
      if (ipri)                        then
        write (io6,2004)
      endif

      do 40 jblk = 1,NBIO
        iblk  =  ordrd(jblk)
        if (ipri)                      then
          write (io6,2005) iblk
        endif

        call     ZEROIT (data(1), nwds)

        call     BLKLOC (fd, size, pos, ierr)

        if (ipri)                      then
          write (io6,4001) ' after ( BLKLOC ) call:'
          write (io6,4005) pos, size
          write (io6,4000) ierr
        endif

        call     BLKRDR (fd, data(1), nwds, iblk, ierr)

        if (ipri)                      then
          write (io6,4001) ' after ( BLKRDR ) call:'
          write (io6,4004) fd, iblk
          write (io6,4000) ierr
        endif

*       if (ierr .ne. 0)               return

        call     BLKLOC (fd, size, pos, ierr)

        if (ipri)                      then
          write (io6,4001) ' after ( BLKLOC ) call:'
          write (io6,4005) pos, size
          write (io6,4000) ierr
        endif

        if (ipri)                      then
          call   PRIBLK (iblk, data(1), nwds)
        endif

        call     CHKBIO (iblk, data(1), nwds)

   40 continue
C+---------------------------------------------------------------------+
C|    close out the unit and terminate the test.                       |
C+---------------------------------------------------------------------+
      if (ipri)                        then
        write (io6,2006)
      endif

      lopc  =  LEN(opc)

C     call     BLKCLO (fd, opc, size, ierr, LEN(opc))

      call     BLKCLO (fd, opc, size, ierr)

      if (ipri)                        then
        write (io6,4001) ' after ( BLKCLO ) call:'
        write (io6,4003) fd, size
        write (io6,4000) ierr
      endif
C+---------------------------------------------------------------------+
C|    return the unit to the operating system.                         |
C+---------------------------------------------------------------------+
      if (ierr .eq. 0)                 go to 50

*     if (ipri)                        then
*       write (io6,2007)
*     endif

*     call     BLKRTN (fd, ierr)

*     if (ipri)                        then
*       write (io6,4001) ' after ( BLKRTN ) call:'
*       write (io6,4000) ierr
*     endif

   50 write (io6,2008)

      return
C+---------------------------------------------------------------------+
C|    format statements                                                |
C+---------------------------------------------------------------------+
 2001 format (//' Opening file for testing'/)
 2002 format (//' ----- Writing Out Blocks of Data -----',
     $         /' **************************************'//)
 2003 format (' Current:  (iblk) = ',I4)
 2004 format (//' ----- Reading In Blocks of Data -----',
     $         /' *************************************'//)
 2005 format (' Current:  (iblk) = ',I4)
 2006 format (//' Closing file from testing'/)
 2007 format (//' Returning file to Operating System'/)
 2008 format (//' == End of Testing Block I/O Routines =='/)

 4000 format (  '  ierr = ',I6)
 4001 format (/,A)
 4002 format (  '    fd = ',I6,'   pruw = ',I6,'   size = ',I6)
 4003 format (  '    fd = ',I6,'   size = ',I6)
 4004 format (  '    fd = ',I6,'   iblk = ',I6)
 4005 format (  '   pos = ',I6,'   size = ',I6)

      end
C$F77               MAKBIO
      subroutine    MAKBIO (iblk, data, lng)
C+---------------------------------------------------------------------+
C|    this routine fills a data array with randon numbers              |
C+---------------------------------------------------------------------+
C+---------------------------------------------------------------------+
C|                  A R G U M E N T S                                  |
C+---------------------------------------------------------------------+
      integer       iblk,     lng
      real          data(*)
C+---------------------------------------------------------------------+
C|                  L O C A L   V A R I A B L E S                      |
C+---------------------------------------------------------------------+
      integer       i
      real          value
C+---------------------------------------------------------------------+
C|                  L O G I C                                          |
C+---------------------------------------------------------------------+
      value =  REAL(iblk)

      do 10 i = 1,lng
        data(i) =  value
   10 continue

      return
      end
C$F77               CHKBIO
      subroutine    CHKBIO (iblk, data, lng)
C+---------------------------------------------------------------------+
C|    this routine checks a data block for constancy of data           |
C+---------------------------------------------------------------------+
C+---------------------------------------------------------------------+
C|                  A R G U M E N T S                                  |
C+---------------------------------------------------------------------+
      integer       iblk,     lng
      real          data(*)
C+---------------------------------------------------------------------+
C|                  L O C A L   V A R I A B L E S                      |
C+---------------------------------------------------------------------+
      integer       i,        io6
      real          value
C+---------------------------------------------------------------------+
C|                  D A T A                                            |
C+---------------------------------------------------------------------+
      data          io6 / 6 /
C+---------------------------------------------------------------------+
C|    check block for constancy of data                                |
C+---------------------------------------------------------------------+
      value =  REAL(iblk)

      do 10 i = 1,lng
        if (data(i) .ne. value)        go to 20
   10 continue
      return

   20 write (io6,2000) iblk, i
      return
C+---------------------------------------------------------------------+
C|    format statements                                                |
C+---------------------------------------------------------------------+
 2000 format (/5X,'CHKBIO:  check array values for iblk = ',I5,
     $        /5X,'Inconsistency in array ;location (i) = ',I5/)
      end
C$F77               PRIBLK
      subroutine    PRIBLK (iblk, data, lng)
C+---------------------------------------------------------------------+
C|    this routine prints out the test block  a(n)                     |
C+---------------------------------------------------------------------+
C+---------------------------------------------------------------------+
C|                  A R G U M E N T S                                  |
C+---------------------------------------------------------------------+
      integer       iblk,     lng
      real          data(*)
C+---------------------------------------------------------------------+
C|                  L O C A L   V A R I A B L E S                      |
C+---------------------------------------------------------------------+
      integer       nrows,    nwds
      parameter    (nrows = 4)
      parameter    (nwds  = 5 * nrows)

      integer       l1,       l1b,      l1e,      l2,       l2b,
     $              l2e,      io6
C+---------------------------------------------------------------------+
C|                  D A T A                                            |
C+---------------------------------------------------------------------+
      data          io6 / 6 /
C+---------------------------------------------------------------------+
C|                  L O G I C                                          |
C+---------------------------------------------------------------------+
C+---------------------------------------------------------------------+
C|    print out the first and last 'nwds' of array  data(-)            |
C+---------------------------------------------------------------------+
      write (io6,2000) iblk, nwds, lng

      l1b  =   1
      l1e  =   nwds

      l2e  =   lng
      l2b  =   lng - nwds + 1

      if (l1e .gt. l2b)                then

        write (io6,2001) (data(l1),l1=l1b,l2e)

      else

        write (io6,2001) (data(l1),l1=l1b,l1e)
        write (io6,2002)
        write (io6,2001) (data(l2),l2=l2b,l2e)

      endif

      return
C+---------------------------------------------------------------------+
C|    format statements                                                |
C+---------------------------------------------------------------------+
 2000 format (/5X,'PRIBLK:  test array values:  iblk = ',I3,
     $            '  nwds = ',I6,'  lng = ',I6,/)
 2001 format (5X,1P5E15.6)
 2002 format (5(14X,'"')/5(14X,'"'))
      end
C$F77               ZEROIT
      subroutine    ZEROIT (data, lng)
C+---------------------------------------------------------------------+
C|    this routine zeros out the array (data)                          |
C+---------------------------------------------------------------------+
C+---------------------------------------------------------------------+
C|                  A R G U M E N T S                                  |
C+---------------------------------------------------------------------+
      integer       lng
      real          data(*)
C+---------------------------------------------------------------------+
C|                  L O C A L   V A R I A B L E S                      |
C+---------------------------------------------------------------------+
      integer       i
      real          zer
C+---------------------------------------------------------------------+
C|                  D A T A                                            |
C+---------------------------------------------------------------------+
      data          zer / 0.0e+00 /
C+---------------------------------------------------------------------+
C|                  L O G I C                                          |
C+---------------------------------------------------------------------+
      do 10 i = 1,lng
        data(i) =  zer
   10 continue

      return
      end
