C$F77               GASP
      subroutine     GASP (a, nw, ic, id)
C+---------------------------------------------------------------------+
C|    General Auxiliary Storage Program  (Mass Storage)                |
C|                                                                     |
C|            a(-)  =   Array Involved in Transfer                     |
C|                                                                     |
C|            nw    =   Size of array A                                |
C|                                                                     |
C|            ic    =  -1,  Open/Initialize file for activity          |
C|                  =  -2,  Close/Release  file from activity          |
C|                  =   1,  Write A to mass storage                    |
C|                  =   2,  Null operation (error return)              |
C|                  =   3,  Read A from mass storage                   |
C|                                                                     |
C|            id    =   Data block (sector) reference number           |
C|                      Set ID = 0 before first call to gasp           |
C|                                                                     |
C|                      (If ID=0 on calls for WRITE, data will         |
C|                       be written at the end of the file)            |
C|                                                                     |
C|                      (The starting (id) is returned as an           |
C|                       arguement for (ic=1) write operations)        |
C+---------------------------------------------------------------------+
C+---------------------------------------------------------------------+
C|                   P A R A M E T E R S                               |
C+---------------------------------------------------------------------+
      integer        PRU
#if cray
      parameter     (PRU = 512)
#else
#if (sgi || rs6k || alpha || hp700)
      parameter     (PRU = 256)
#else
      parameter     (PRU = 128)
#endif
#endif
C+---------------------------------------------------------------------+
C|                   T Y P E    &    D I M E N S I O N                 |
C+---------------------------------------------------------------------+
      character      sfn*7,    opt*2
      integer        fd,       size
C
      integer        a(*),     nw,       ic,       id
C
      integer        j,        n,        nwtogo
      integer        b(PRU), istor, lu, fdi(2), iblki(2)
      save           fdi, iblki
C+---------------------------------------------------------------------+
C|                   C O M M O N    &    G L O B A L S                 |
C+---------------------------------------------------------------------+
C
      COMMON/UNITNO/iu
C+---------------------------------------------------------------------+
C|                   D A T A                                           |
C+---------------------------------------------------------------------+
      data           ibug   / 0 /
      not = 0
C+---------------------------------------------------------------------+
C|                   L O G I C                                         |
C+---------------------------------------------------------------------+
      if (iu .eq. 10) then
        lu = 2
        sfn = 'fort.10'
      else 
        iu = 11
        lu = 1
        sfn = 'fort.11'
      endif

      if (ic .eq. -1)                  go to 1000
      if (ic .eq. -2)                  go to 4000
      if (ic .eq.  1)                  go to 2000
      if (ic .eq.  3)                  go to 3000
C
      write (not,900) ic, id
C
      call     EXIT (1)
C+---------------------------------------------------------------------+
C|                                                                     |
C|                   O P E N        O p e r a t i o n                  |
C|                                                                     |
C+---------------------------------------------------------------------+
 1000 continue
C
      nwa     =  1
      iblk    =  1
C
      opt     =  '  '
C
      call       BLKOPN (sfn, opt, fd, size, ierr)
C
      lstblk  =  (size + PRU-1) / PRU
      iblk = lstblk + 1
      fdi(lu) = fd
      iblki(lu) = iblk
C
      if (ierr .ne. 0)                 then
        write (not,908) fd, lstblk, ierr
        call   EXIT (2)
      endif
C
c begin diagnostics
c     write(6,*) 'GASP OPEN ------'
c     write(6,*) '  size = ', size
c     write(6,'(a,i1,a,i4)') '   iblki[',lu,'] = ', iblki(lu)
c end diagnostics
      return
C+---------------------------------------------------------------------+
C|                                                                     |
C|                   W R I T E      O p e r a t i o n                  |
C|                                                                     |
C+---------------------------------------------------------------------+
 2000 continue
      fd = fdi(lu)
      iblk = iblki(lu)
C+---------------------------------------------------------------------+
C|    nblk  =    number of blocks to write out                         |
C+---------------------------------------------------------------------+
      idi   =     id
      nblk  =    (nw-1)/PRU + 1
C
      if (id .gt. 0)                   go to 2500
C+---------------------------------------------------------------------+
C|    id = 0,  append A(-) to the end of the existing file             |
C+---------------------------------------------------------------------+
C+---------------------------------------------------------------------+
C|    idi     =  current block (sector) reference number               |
C|    iblk    =  current total number of blocks stored                 |
C|    istor   =  current total number of words stored                  |
C|    nwds    =  number of words (even multiple of PRU's)              |
C+---------------------------------------------------------------------+
      idi    =   iblk
      iblk   =   iblk  + nblk
      istor  =   istor + nw
C
      id     =   idi
C+---------------------------------------------------------------------+
C|    id > 0,  Write out A(-) at block number ( id )                   |
C+---------------------------------------------------------------------+
 2500 continue
C+---------------------------------------------------------------------+
C|    Write out directly from output array  a(-)  the next 'n/PRU'     |
C|    complete blocks of desired data.                                 |
C+---------------------------------------------------------------------+
      nwtogo =   nw
      nwds   =  (nwtogo/PRU)*PRU
C
      if ( nwds .eq. 0 )               go to 2600
C
      call       BLKWTR (fd, a(1), nwds, idi, ierr)
C
      if (ierr .ne. 0)                 then
        write (not,909) fd, ic, id, nw, idi, nblk, nwds,  iblk,
     $                                             istor, ierr
        call     EXIT (3)
        stop
      endif
C
      idi    =   idi + nwds/PRU
C+---------------------------------------------------------------------+
C|      nwds = total number of words transfered in last write          |
C|       idi = starting block number for any aditional writes          |
C|    nwtogo = number of words left to write out from a(-)             |
C+---------------------------------------------------------------------+
      nwtogo =   nwtogo - nwds
C
 2600 if ( nwtogo .le. 0 )             go to 2800
C+---------------------------------------------------------------------+
C|    Last portion of desired record not on alignment boundary, hence  |
C|    transfer that portion of output array  a(-)  to this buffer and  |
C|    zero fill remainder of buffer, and write it out.                 |
C+---------------------------------------------------------------------+
      do 2700  j = 1,nwtogo
        b(j) =    a(nwds+j)
 2700 continue
C
      do 2750  j = nwtogo+1,PRU
        b(j) =  0
 2750 continue
C
      call       BLKWTR (fd, b(1), PRU, idi, ierr)
C
      if (ierr .ne. 0)                 then
        write (not,909) fd, ic, id, nw, idi, nblk, PRU,   iblk,
     $                                             istor, ierr
        call     EXIT (3)
        stop
      endif
C
      idi    =   idi + 1
C
 2800 continue
C
      if (ibug .eq. 1)                 then
        write  (not,904) fd, nw, a(nw), ic
      endif
C
      iblk   =   MAX (iblk, idi)
      iblki(lu) = iblk
c begin diagnostics
c     write(6,*) 'GASP WRITE------'
c     write(6,*) '  nw = ', nw
c     write(6,'(a,i1,a,i4)') '   iblki[',lu,'] = ', iblki(lu)
c end diagnostics
      return
C+---------------------------------------------------------------------+
C|                                                                     |
C|                   R E A D        O p e r a t i o n                  |
C|                                                                     |
C+---------------------------------------------------------------------+
 3000 continue
      fd = fdi(lu)
      iblk = iblki(lu)
C+---------------------------------------------------------------------+
C|    nblk    =  number of blocks to read in                           |
C+---------------------------------------------------------------------+
      idi   =    id
      nblk  =   (nw-1)/PRU + 1
C
      if (id .gt. 0)                   go to 3200
C+---------------------------------------------------------------------+
C|    id = 0,  ERROR for Read operation                                |
C+---------------------------------------------------------------------+
      write (not,905) nw, ic, id
C
      call     EXIT (4)
C+---------------------------------------------------------------------+
C|    ID > 0,  Check for Reading past the EOF                          |
C+---------------------------------------------------------------------+
 3200 continue
      if ((id+nblk-1) .lt. iblk)       go to 3500
C
      write (not,906) nw, id, ic, nblk, iblk, PRU
C
      call       EXIT (4)
C+---------------------------------------------------------------------+
C|    ID > 0,  Read in A(-) from block number ( id )                   |
C+---------------------------------------------------------------------+
 3500 continue
C+---------------------------------------------------------------------+
C|    Read into output array  a(-)  the next 'n/64' complete blocks    |
C|    of desired data.  No intermediate transfers are required here.   |
C+---------------------------------------------------------------------+
      nwtogo =   nw
      nwds   =  (nwtogo/PRU)*PRU
C
      if ( nwds .eq. 0 )               go to 3600
C
      call       BLKRDR (fd, a(1), nwds, idi, ierr)
C
      if (ierr .ne. 0)                 then
        write (not,909) fd, ic, id, nw, idi, nblk, nwds,  iblk,
     $                                             istor, ierr
        call     EXIT (5)
        stop
      endif
C
      idi    =   idi + nwds/PRU
C+---------------------------------------------------------------------+
C|      nwds = last word read into array a(-)                          |
C|       ide = next starting block number for any aditional reads      |
C|    nwtogo = number of words left to read in array a(-)              |
C+---------------------------------------------------------------------+
      nwtogo =   nwtogo - nwds
C
 3600 if ( nwtogo .le. 0 )             go to 3800
C+---------------------------------------------------------------------+
C|    Last portion of desired record not on alignment boundary, hence  |
C|    read into buffer  b(-)  and transfer residual portion to the     |
C|    output array  a(-)  which will end the transfer of desired data. |
C+---------------------------------------------------------------------+
C
      call       BLKRDR (fd, b, PRU, idi, ierr)
C
      if (ierr .ne. 0)                 then
        write (not,909) fd, ic, id, nw, idi, nblk, PRU,   iblk,
     $                                             istor, ierr
        call     EXIT (5)
        stop
      endif
C
      idi    =   idi + 1
C
      do 3700 j = 1,nwtogo
        a(nwds+j) =  b(j)
 3700 continue
C
 3800 continue
C
      if (ibug .eq. 1)                 then
        write  (not,904) id, nw, a(nw), ic
      endif
C
c begin diagnostics
c     write(6,*) 'GASP READ------'
c     write(6,*) '  nw = ', nw
c     write(6,*) '  id = ', id
c     write(6,'(a,i1,a,i4)') '   iblki[',lu,'] = ', iblki(lu)
c end diagnostics
      return
C+---------------------------------------------------------------------+
C|                                                                     |
C|                   C L O S E      O p e r a t i o n                  |
C|                                                                     |
C+---------------------------------------------------------------------+
 4000 continue
      fd = fdi(lu)
      opt   =    '  '
C
      call       BLKCLO (fd, opt, size, ierr)
C
      if (ierr .ne. 0)                 then
        write (not,903) fd, nw, ic, id, ierr
        call   EXIT (6)
        stop
      endif
C
c begin diagnostics
c     write(6,*) 'GASP CLOSE------'
c     write(6,*) '  size = ', size
c     write(6,'(a,i1,a,i4)') '   iblki[',lu,'] = ', iblki(lu)
c end diagnostics
      return
C+---------------------------------------------------------------------+
C|                    Format Statements                                |
C+---------------------------------------------------------------------+
  900 format (/' Error in GASP:   Illegal Op-Code   ic = ',I6,
     $           '  id = ',I6/)
  901 format (/' Error in GASP:   Opening file = ',A,'   fd = ',I4,
     $         '  iopen = ',I8,'  ierr = ',I4/)
  902 format (/' Error in GASP:   Disc Limit = ',I10,'  Exceeded.'/)
  903 format (/' ERROR in GASP Block I/O,   fd = ',I6,'   nw = ',I6,
     $         '  ic = ',I6,'  id = ',I8,'  ierr = ',I6/)
  904 format (' GASP:   id = ',Z10,'  nw = ',I6,'  a(nw) = ',Z16,
     $        '  ic = ',I3)
  905 format (/' Error in GASP:   Illegal Block No. for READ Op',
     $         '   nw = ',I6,'  ic = ',I6,'  id = ',I8/)
  906 format ( /' Error in GASP:   Illegal Record Size for READ Op',
     $         /'    nw = ',I8,'     id = ',I6,'   ic = ',I8,
     $        //'  nblk = ',I8,'   iblk = ',I6,'  PRU = ',I8/)
  908 format (/' Error in GASP:   Opening file  fd = ',I4,
     $         '  lstblk = ',I8,'  ierr = ',Z16/)
  909 format (//' Error in GASP:   Data Transfer Error Return with:'//
     $          '      fd   ic     id      nw    idi    nblk',
     $          '    nwds   iblk     istor             ierr',
     $         /8X,I7,I5,2(I7,I8),I8,I7,I10,1X,Z16)
C
      end
