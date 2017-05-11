      SUBROUTINE  READFF (LIST, TYPE, LISTP, STR)
      INTEGER     LIST(1), TYPE(1), LISTP, STR(1)
C+---------------------------------------------------------------------+
C|    Copyright (c) 1993 Lockheed Missiles & Space Company, Inc.       |
C|    Research & Development Division.      All Rights Reserved.       |
C+---------------------------------------------------------------------+
      CHARACTER*6 NAME
      INTEGER ENTITY,CHAR,STRP,ENTER,EXPN
      INTEGER COMMA,BLANK,DOT,PLUS,E,FL,AL,ALNWD,SLASH,STAR
      INTEGER SIGN(2),ENT1,ENT2,ICTL(10)
      CHARACTER*10 STRING
      CHARACTER*1 AAAA(2), CTL(10), LINE(132), UPCASE
      LOGICAL EXPT,DEC,SGN
      LOGICAL ECHO, REED
C     COMMON/ECHOFF/ECHO,IGNORE,LENGTH
      COMMON/ECHOFF/ECHO,IGNORE
      EQUIVALENCE (ENTITY,RENT), (ICTL(1),COMMA), (ICTL(2),BLANK),
     1  (ICTL(3),DOT), (ICTL(4),PLUS), (ICTL(5),MINUS), (ICTL(6),E),
     2  (ICTL(7),SLASH),(ICTL(8),STAR),(ICTL(9),NUML),(ICTL(10),NUMH)
      COMMON/INDAT/NIT
      DATA NOT/6/
      DATA    INT,FL,AL/0,1,-1/
      DATA    MASK,MXCHAR,NCTL,LENGTH
     1        /63,  80,    10,   4  /
      DATA    CTL/',',' ','.','+','-','E','/','*','0','9'/
C     DATA    COMMA,BLANK,DOT,PLUS,MINUS, E ,SLASH,STAR
C    1        /1H,,  1H , 1H., 1H+, 1H-,1HE , 1H/ , 1H* /
C     DATA    NUML,NUMH/
C    1        /1H0, 1H9/
      DATA MSK1,MSK2,MSK3 /3*0/
C+---------------------------------------------------------------------+
C|    define locqal function  LAND(I,J)                                |
C+---------------------------------------------------------------------+
      LAND(I,J) = IAND(I,J)
C
C
      NAME='READFF'
      REED=.TRUE.
      GO TO 100
C+---------------------------------------------------------------------+
C|    entry point:  R1READ                                             |
C+---------------------------------------------------------------------+
      ENTRY  R1READ (LIST, TYPE, LISTP, STR)
      NAME='R1READ'
      REED=.FALSE.
      GO TO 100
C+---------------------------------------------------------------------+
C|    entry point:  R1READ                                             |
C+---------------------------------------------------------------------+
      ENTRY  A1READ (LIST, TYPE, LISTP, STR)
      NAME='A1READ'
      REED=.FALSE.
C     GO TO 100
C+---------------------------------------------------------------------+
C|    entry point:  R1READ                                             |
C+---------------------------------------------------------------------+
  100 NCHAR = MXCHAR
      LISTP = 0
 
      DO 105 I=1,NCTL
        ICTL(I) = ICHAR(CTL(I))
 105  CONTINUE
C
      IF (REED) THEN
C***********************************************************************
C Changes by Harold Cabiness, Feb. 20, 1986...
C
  999    READ(NIT,1,END=901) (LINE(I), I=1,NCHAR)
c        if (line(1) .eq. 'h') then
           line(1) = UPCASE(line(1))
c        endif
c        if ( line(1) .eq. 'H'  .or.  line(1) .eq. 'h'  .or.
c    :        line(1) .eq. 'Y'  .or.  line(1) .eq. 'y'  .or.
c    :        line(1) .eq. 'N'  .or.  line(1) .eq. 'n' ) then
c           aaaa(1:1) = line(1)
c           aaaa(2:2) = line(2)
c           if ( aaaa .ne. 'H '  .and.  aaaa .ne. 'Y '  .and.
c    :           aaaa .ne. 'N ' ) then 
c              if ( line(1) .eq. 'H'  .or.  line(1) .eq. 'h' ) then
c                 WRITE(6,'(A,$)') ' Please enter "H" for help: '
c                 go to 999
c              else
c                 WRITE(6,'(A,$)')
c    :               ' Please enter "Y" for yes or "N" for no: '
c                 go to 999
c              endif
c           endif
c        endif
C End of Cabiness Feb 20, 1986 mods.
C************************************************************************
      DO 107 I=1,NCHAR
        STR(I) = ICHAR(LINE(I))
  107 CONTINUE
      END IF
C
      DO 110 NCHAR = MXCHAR, 1, -1
         IF (STR(NCHAR) .NE. BLANK) GO TO 115
  110 CONTINUE
  115 CONTINUE
      IF (ECHO) WRITE(NOT,2) (STR(I),I=1,NCHAR)
      IF (STR(1).NE.IGNORE)     GO TO 120
      IF (REED)                 GO TO 100
                                GO TO 900
  120 NCHARP      = NCHAR+1
      STR(NCHARP) = BLANK
      STRP = 1

  125 NSTR = 0
      EXPT = .FALSE.
      DEC  = .FALSE.
      SGN  = .TRUE.

*     ASSIGN 180 TO NEXT
*     ASSIGN 300 TO ENTER
      ENTER = 2
      NEXT  = 1

  130    CONTINUE
         CHAR = STR(STRP+NSTR)
         IF (CHAR.NE.BLANK)     GO TO 150
         IF (NSTR.GT.0)         THEN
           IF (ENTER .EQ. 1)    GO TO 280
           IF (ENTER .EQ. 2)    GO TO 300
           WRITE(6,4) NAME, 'ENTER'
           STOP 'ERROR'
         ENDIF
         STRP = 1+STRP
                                GO TO 500
  150    IF (CHAR.NE.COMMA)     GO TO 170
         IF (NSTR.GT.0)         THEN
           IF (ENTER .EQ. 1)    GO TO 280
           IF (ENTER .EQ. 2)    GO TO 300
           WRITE(6,4) NAME, 'ENTER'
           STOP 'ERROR'
         ENDIF

         STRP = 1+STRP
         LISTP= 1+LISTP
         LIST(LISTP) = 0
         TYPE(LISTP) = INT
                                GO TO 500
  170    NSTR = NSTR+1
         IF (NEXT .EQ. 1)       GO TO 180
         IF (NEXT .EQ. 2)       GO TO 500
         WRITE(6,4) NAME, 'NEXT'
         STOP 'ERROR'

  180    IF (SGN)               GO TO 190
         IF (.NOT.EXPT)         GO TO 200
  190    SGN = .FALSE.
         IF (CHAR.EQ.MINUS)     GO TO 500
         IF (CHAR.EQ.PLUS)      GO TO 500
  200    IF (CHAR.LT.NUML)      GO TO 210
         IF (CHAR.LE.NUMH)      GO TO 500
         IF (CHAR.EQ.SLASH)     GO TO 230
  210    IF (DEC)               GO TO 220
         IF (CHAR.EQ.DOT)       GO TO 225
  220    IF (EXPT)              GO TO 230
         IF (CHAR.EQ.E)         GO TO 223
         IF (CHAR.EQ.MINUS)     GO TO 224
         IF (CHAR.EQ.PLUS)      GO TO 224
         IF (NSTR.EQ.1)         GO TO 230
         IF (CHAR.EQ.STAR )     GO TO 230
  223    SGN = .TRUE.
  224    EXPT= .TRUE.
  225    DEC = .TRUE.
                                GO TO 500
  230    CONTINUE
*        ASSIGN 280 TO ENTER
*        ASSIGN 500 TO NEXT
         ENTER = 1
         NEXT  = 2
                                GO TO 500
C
  280 NWD=(NSTR+LENGTH-1)/LENGTH
      LIST(LISTP+NWD)=BLANK
      J=STRP+NSTR-1
      ALNWD=AL*NWD
      KK=0
      DO 290 K=STRP,J,LENGTH
      KK=KK+1
      JJ=MIN0(J,K+LENGTH-1)
c     WRITE (STRING, 3) (STR(I), I = K,JJ)
      ISTR = 0
      DO 285 I=K,JJ
  285 ISTR = 256*ISTR+STR(I)
      LIST(LISTP+KK) = ISTR
  290 TYPE(LISTP+KK)=ALNWD
      LISTP=LISTP+KK
                                GO TO 430
  300    ENT1 = 0
         ENT2 = 0
         SIGN(1)=1
         SIGN(2)=1
         ISGN=1
         IFRAC= 0
         EXPN = 0
         J    = MIN0(NCHAR,STRP+NSTR-1)
         DEC  =.FALSE.
         EXPT =.FALSE.
         LISTP= 1+LISTP
         DO 400 I=STRP,J
            CHAR = STR(I)
            IF (CHAR.LT.NUML)   GO TO 310
            IF (CHAR.LE.NUMH)   GO TO 340
  310       IF (CHAR.EQ.DOT)    GO TO 330
            IF (CHAR.EQ.E  )    GO TO 320
            IF (I.EQ.STRP)      GO TO 335
  320       EXPT=.TRUE.
  330       DEC=.TRUE.
  335       IF (CHAR.EQ.MINUS) SIGN(ISGN)=-1
            ISGN=2
                                GO TO 400
  340       NUM = CHAR-NUML
            IF (EXPT)           GO TO 350
            IF (DEC)            GO TO 360
            ENT1 = 10*ENT1+NUM
                                GO TO 400
  350       EXPN = 10*EXPN+NUM
                                GO TO 400
  360       IFRAC=IFRAC+1
            ENT2 = 10*ENT2+NUM
  400    CONTINUE
         RENT=FLOAT(ENT1)+FLOAT(ENT2)/10.**IFRAC
         IF (SIGN(2).GE.0) RENT=SIGN(1)*RENT*10.**EXPN
         IF (SIGN(2).LT.0) RENT=SIGN(1)*RENT/10.**EXPN
         IF (DEC)               GO TO 410
         ENTITY=RENT
         TYPE(LISTP)=INT
                                GO TO 420
  410    TYPE(LISTP)=FL
  420    LIST(LISTP)=ENTITY
  430    STRP= NSTR+1+STRP
         IF (STRP-NCHAR)    125,125,900
  500 IF (NSTR+STRP-NCHARP) 130,510,510
 
  510 IF (NSTR.GT.0)           THEN
        IF (ENTER .EQ. 1)      GO TO 280
        IF (ENTER .EQ. 2)      GO TO 300
        WRITE(6,4) NAME, 'ENTER'
        STOP 'ERROR'
      ENDIF

  900 RETURN
  901 LISTP=-1
      RETURN
    1 FORMAT(132A1)
    2 FORMAT(6H <IN> , 80A1)
    3 FORMAT(80A1)
    4 FORMAT(/,a,' ** ERROR ** assign goto ',a,
     $       ' not = 1 or 2?')
      END
