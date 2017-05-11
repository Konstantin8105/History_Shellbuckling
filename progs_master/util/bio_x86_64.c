/*
 *  BIO***:  low-level block i/o routines written in C-language with
 *           appropriate hooks into the Unix kernal through the
 *           standard interface definitions (System V & Berkeley 4.*)
 */
 
/*
 *    define global header files
 */

/*
#ifndef __USE_BSD
#define __USE_BSD
#endif
*/
 
#include   "mach.h"

#include   <stdio.h>
#include   <sys/types.h>

#if defined (_x86_)
#include   <fcntl.h>
#include   <io.h>
#else
#if defined (_rs6k_)
#include   <fcntl.h>
#else
#include   <sys/fcntl.h>
#endif
#include   <sys/file.h>
#endif

#include   <sys/stat.h>
#include   <time.h>
#include   <errno.h>

#include   <string.h>

#if !defined (_macosx_)
#include   <malloc.h>
#endif

#if defined (_cray_f2c_)
#include   <fortran.h>
#endif

/*
 *    since __STDC__ was NOT defined in <mach.h> it
 *    is defined here for Wintel machines (_x86_)
 *
 */

#if  defined (_x86_) && !defined (__STDC__)
#define __STDC__  1
#endif

/*
 *    the following flags represent file positioning
 *    parameters used by lseek(---)
 *
 */

#if defined (__STDC__) && !defined (_x86_)

#include   <unistd.h>

#endif

#if defined (__STDC__) || defined (_x86_)

#define    LSEEK_SET  SEEK_SET  /* absolute offset (from BOF) */
#define    LSEEK_CUR  SEEK_CUR  /* relative to current offset */
#define    LSEEK_END  SEEK_END  /* relative to end of file    */

#else

#define    LSEEK_SET  L_SET     /* absolute offset (from BOF) */
#define    LSEEK_CUR  L_INCR    /* relative to current offset */
#define    LSEEK_END  L_XTND    /* relative to end of file    */

#endif


/*
 *    the following flags represent file
 *    accessing  modes used by open(---)
 *
 */

#if defined (_sys5_) && !defined(R_OK) && !defined(W_OK) && !defined(X_OK) && !defined(F_OK)

#define    R_OK     04      /* read permission            */
#define    W_OK     02      /* write permission           */
#define    X_OK     01      /* execute/search permission  */
#define    F_OK     00      /* file existence             */
 
#endif


/*
 *    define FORTRAN character variable structure
 *   ---------------------------------------------
 */

#if defined (_star_)
 
/*
 *    define f77 character string structure
 *    for use on ARDENT Titan machines
 */
 
typedef struct {char *addr;    /* pointer to character string  */
                int   leng;    /* length  of character string  */
               } F77PTR;

#endif


/*
 *    define all global variables here
 *    for use in all of the functions
 *   ----------------------------------
 */


int     NBInt  = sizeof(Int);    /* no. bytes per (int) word      */
int     NBFlt  = sizeof(Float);  /* no. bytes per (float) word    */


#ifndef BUFSIZ                 /* if stdio.h does not contain the
                                  standard definition of physical
                                  record unit size (BUFSIZ), then
                                  define it here for bio.c use    */
#define BUFSIZ   512
#endif


#if defined (_cray_star_)      /* CRAY super computers (C-90) & Stardent */
#define BUFSIZ   4096
#endif

#if defined (_cnvx_)           /* redefine buffer size for Convex */
#define BUFSIZ   4096
#endif

#define PRUSIZ   BUFSIZ        /* preset block/buffer size, where
                                  BUFSIZ is defined in (stdio.h)  */

#define MAXFD    64            /* max no. of file descriptors     */
char   *fnpt[MAXFD];           /* array of file name pointers     */
char    ftyp[MAXFD];           /* file type option (char)         */
 
/*
 *    some compilers do not like the following
 *   ------------------------------------------

extern char  *malloc();
extern char  *strcpy();

extern int    printf();
 
extern int    open();
extern int    read();
extern int    write();
extern int    close();
extern int    fstat();
extern long   lseek();
 
 *
 *    so they are commented out
 *   ---------------------------
 */

 
#if  defined (_x86_)

#if !defined (__STDC__)
#define __STDC__  1


/* Non-ANSI names for compatibility */

#define O_RDONLY     _O_RDONLY
#define O_WRONLY     _O_WRONLY
#define O_RDWR       _O_RDWR
#define O_APPEND     _O_APPEND
#define O_CREAT      _O_CREAT
#define O_TRUNC      _O_TRUNC
#define O_EXCL       _O_EXCL
#define O_TEXT       _O_TEXT
#define O_BINARY     _O_BINARY
#define O_RAW        _O_BINARY
#define O_TEMPORARY  _O_TEMPORARY
#define O_NOINHERIT  _O_NOINHERIT
#define O_SEQUENTIAL _O_SEQUENTIAL
#define O_RANDOM     _O_RANDOM

#endif
#endif
 
 
 /*
 *    setup the (f77) name conventions here
 *   ---------------------------------------
 */



#if defined (_x86_)  /* Microsoft Visual C for PC machines */

#define  LPATH_MS , Int  lpath
#define  LOPT_MS  , Int  lopt

#define  LPATH
#define  LOPT

#define  KPATH
#define  KOPT

#define  KLPATH
#define  KLOPT

#define  CallTyp  __stdcall

#define  blk_six  BLKSIZ
#define  blk_opn  BLKOPN
#define  blk_pos  BLKPOS
#define  blk_rdr  BLKRDR
#define  blk_wtr  BLKWTR
#define  blk_clo  BLKCLO
#define  blk_sta  BLKSTA
#define  blk_loc  BLKLOC
#define  blk_rtn  BLKRTN
#define  blk_dbg  BLKDBG

#elif defined (_cray_star_)  /* CRAY surper computers (C-90) & Stardent */

#define  LPATH_MS
#define  LOPT_MS

#define  LPATH
#define  LOPT

#define  KPATH
#define  KOPT

#define  KLPATH
#define  KLOPT

#define  CallTyp

#define  blk_six  BLKSIZ
#define  blk_opn  BLKOPN
#define  blk_pos  BLKPOS
#define  blk_rdr  BLKRDR
#define  blk_wtr  BLKWTR
#define  blk_clo  BLKCLO
#define  blk_sta  BLKSTA
#define  blk_loc  BLKLOC
#define  blk_rtn  BLKRTN
#define  blk_dbg  BLKDBG

#elif defined (_hp_ibm_)  /* Hewlet-Packard & IBM UNIX workstaions */

#define  LPATH_MS
#define  LOPT_MS

#define  LPATH    , Int  lpath
#define  LOPT     , Int  lopt

#define  KPATH    , lpath
#define  KOPT     , lopt

#define  KLPATH   Int  lpath;
#define  KLOPT    Int  lopt;

#define  CallTyp

/*
#define  blk_siz  blksiz
#define  blk_opn  blkopn
#define  blk_pos  blkpos
#define  blk_rdr  blkrdr
#define  blk_wtr  blkwtr
#define  blk_clo  blkclo
#define  blk_sta  blksta
#define  blk_loc  blkloc
#define  blk_rtn  blkrtn
#define  blk_dbg  blkdbg
*/

#define  blk_siz  blksiz_
#define  blk_opn  blkopn_
#define  blk_pos  blkpos_
#define  blk_rdr  blkrdr_
#define  blk_wtr  blkwtr_
#define  blk_clo  blkclo_
#define  blk_sta  blksta_
#define  blk_loc  blkloc_
#define  blk_rtn  blkrtn_
#define  blk_dbg  blkdbg_

#elif defined (_cnvx_)  /* Convex with 8 byte integers and reals */

#define  LPATH_MS
#define  LOPT_MS

#define  LPATH    , int  lpath
#define  LOPT     , int  lopt

#define  KPATH    , lpath
#define  KOPT     , lopt

#define  KLPATH   int  lpath;
#define  KLOPT    int  lopt;

#define  CallTyp

#define  blk_siz  blksiz_
#define  blk_opn  blkopn_
#define  blk_pos  blkpos_
#define  blk_rdr  blkrdr_
#define  blk_wtr  blkwtr_
#define  blk_clo  blkclo_
#define  blk_sta  blksta_
#define  blk_loc  blkloc_
#define  blk_rtn  blkrtn_
#define  blk_dbg  blkdbg_

#else  /* DEC_3100, DEC_5400, DEC Alpha, SUN, SPARC, SGI, ... workstaions */

#define  LPATH_MS
#define  LOPT_MS

#define  LPATH    , Int  lpath
#define  LOPT     , Int  lopt

#define  KPATH    , lpath
#define  KOPT     , lopt

#define  KLPATH   Int  lpath;
#define  KLOPT    Int  lopt;

#define  CallTyp

#define  blk_siz  blksiz_
#define  blk_opn  blkopn_
#define  blk_pos  blkpos_
#define  blk_rdr  blkrdr_
#define  blk_wtr  blkwtr_
#define  blk_clo  blkclo_
#define  blk_sta  blksta_
#define  blk_loc  blkloc_
#define  blk_rtn  blkrtn_
#define  blk_dbg  blkdbg_

#endif


/*
 *    define the prototypes
 *   ----------------------
 */
 
#ifdef __STDC__

void CallTyp blk_siz ( Int   *pruw  ,
                       Int   *nbpi  ,
                       Int   *nbpf  ,
                       Int   *uerr  );

void CallTyp blk_opn ( Char   path  LPATH_MS ,
                       Char   opt   LOPT_MS  ,
                       Int   *fd    ,
                       Int   *pruw  ,
                       Int   *size  ,
                       Int   *uerr  LPATH LOPT);

void CallTyp blk_pos ( Int   *fd   , 
                       Int   *blk  ,
                       Int   *pos  ,
                       Int   *uerr );

void CallTyp blk_rdr ( Int   *fd   ,
                       Int   *buf  ,
                       Int   *nwds ,
                       Int   *blk  ,
                       Int   *uerr );

void CallTyp blk_wtr ( Int   *fd   ,
                       Int   *buf  ,
                       Int   *nwds ,
                       Int   *blk  ,
                       Int   *uerr );

void CallTyp blk_clo ( Int   *fd   ,
                       Char   opt  LOPT_MS ,
                       Int   *size ,
                       Int   *uerr LOPT);

void CallTyp blk_sta ( Int   *fd   ,
                       Int   *uerr );

void CallTyp blk_err ( int    erno ,
                       int   *ierr );

void CallTyp blk_loc ( Int   *fd   ,
                       Int   *size ,
                       Int   *pos  ,
                       Int   *uerr );

void CallTyp blk_rtn ( Int   *fd   ,
                       Int   *uerr );

void CallTyp blk_dbg ( Int   *idbg );

#if defined (_cray_f2c_)

void CallTyp F2CPTR_( _fcd     f77des ,
                      char   **cptr   ,
                      int     *clng   );
 
#elif defined (_star_)

void CallTyp F2CPTR_( F77PTR  *f77des ,
                      char   **cptr   ,
                      int    **clng   );

#endif


#else


void CallTyp blk_siz ( ); 
void CallTyp blk_opn ( ); 
void CallTyp blk_pos ( ); 
void CallTyp blk_rdr ( ); 
void CallTyp blk_wtr ( ); 
void CallTyp blk_clo ( ); 
void CallTyp blk_sta ( ); 
void CallTyp blk_err ( ); 
void CallTyp blk_loc ( );
void CallTyp blk_rtn ( ); 

#if defined (_cray_f2c_) || defined (_star_)

void CallTyp F2CPTR_ ( );

#endif

#endif


/*
 *    set DEBUG print-outs
 *   ----------------------
 */


int     debug   = 0;

int     debug_2 = 0;


/* end */


/*  BLK_SIZ  retreive the computer's byte/word/buffer sizes
 *
 *  this routine is called in fortran (f77) via:
 *
 *
 *       call  BLKSIZ (pruw, nbpi, nbpf, uerr)
 *      ---------------------------------------
 *
 *  output arguements:
 *
 *    pruw  =  physical record unit size in words  (integer or s.p.)
 *    nbpi  =  number of bytes per (integer) word
 *    nbpf  =  number of bytes per ( float ) word
 *    uerr  =  error return number (zero if no error)
 *
 */

/***********************
 *  entry  -  BLK_SIZ  *
 ***********************/

#ifdef __STDC__

void  CallTyp  blk_siz ( Int   *pruw  ,
                         Int   *nbpi  ,
                         Int   *nbpf  ,
                         Int   *uerr  )

#else

void  CallTyp  blk_siz ( pruw ,
                         nbpi ,
                         nbpf ,
                         uerr )

Int   *pruw;
Int   *nbpi;
Int   *nbpf;
Int   *uerr;

#endif

{

     *nbpi  = (Int) NBInt;             /* no. bytes per  Int  word */
     *nbpf  = (Int) NBFlt;             /* no. bytes per Float word */

     *pruw  = (Int) (PRUSIZ/NBInt);    /* block/buffer size in integer
                                          or single precision words */
     if ( debug ) {
       printf ("\n");
       printf (" BLK_SIZ debug print out of parameters\n");
       printf ("\n");
       printf (" BLK_SIZ PRUSIZ = %d (no. bytes per buffer)\n", PRUSIZ);
       printf (" BLK_SIZ NBInt  = %d (no. bytes per  int  word)\n", NBInt);
       printf (" BLK_SIZ NBFlt  = %d (no. bytes per float word)\n", NBFlt);
       printf (" BLK_SIZ *pruw  = %d (no. words per buffer)\n", *pruw);
       printf ("\n");
     }

     *uerr  =  (Int) 0;             /* set the user error code          */

     return;

}

/* end */
 
/*  BLK_OPN  open a file for randon i/o, given it's path name
 *
 *  this routine is called in fortran (f77) via:
 *
 *
 *       call  BLKOPN (path, opt, fd, pruw, size, uerr)
 *      ------------------------------------------------
 *
 *  input arguements:
 *
 *    path  =  complete 'path' name of file
 *    opt   =  2 character open option flags, where
 *             opt[0] = 'r' for 'read_only'
 *                      'w' for 'write_append'
 *                      ' ' for both 'read_write'
 *             opt[1] = 'o' for  'existing'  file open
 *                      'n' for 'create_new' file open
 *                      's' for 'scratch'    file open
 *                      ' ' for 'create_new' even if file
 *                          already exists (truncate old)
 *
 *  output arguements:
 *
 *    fd    =  file descriptor for open file
 *    pruw  =  physical record unit size in words (integer or s.p.)
 *    size  =  size of file in words (long int)
 *    uerr  =  error return number (zero if no error)
 *
 */
 
/***********************
 *  entry  -  BLK_OPN  *
 ***********************/

#ifdef __STDC__ 

void CallTyp blk_opn ( Char   path  LPATH_MS ,
                       Char   opt   LOPT_MS  ,
                       Int   *fd    ,
                       Int   *pruw  ,
                       Int   *size  ,
                       Int   *uerr  LPATH LOPT)

#else
 
void CallTyp blk_opn ( path  ,
                       opt   ,
                       fd    ,
                       pruw  ,
                       size  ,
                       uerr  KPATH KOPT)

Char   path;
Char   opt;
Int   *fd;
Int   *pruw;
Int   *size;
Int   *uerr;
KLPATH
KLOPT

#endif

{

     int          fdes, ierr;
 
     char         oc,  fnam[256];
     static char  *op, *pp;
     static int   lop, lpp;
     unsigned     lfnam;
 
     long int     sizb;
     int          i, flags, mode, acc;
     struct stat  stbuf;
 
     ierr   =  0;                      /* clear the user error code */
     errno  =  0;                      /* clear error code no.      */
 
     *fd    = (Int) -1;                /* set bogus file descriptor */

     *pruw  = (Int) (PRUSIZ/NBInt);    /* block/buffer size in integer
                                          or single precision words */

     if ( debug ) {
       printf ("\n");
       printf (" BLK_OPN debug print out of parameters\n");
       printf ("\n");
       printf (" BLK_OPN PRUSIZ = %d (no. bytes per buffer)\n", PRUSIZ);
       printf (" BLK_OPN NBInt  = %d (no. bytes per word)\n", NBInt);
       printf (" BLK_OPN *pruw  = %d (no. words per buffer)\n", *pruw);
       printf ("\n");
     }

#if defined (_cray_star_)

     /* create C-pointers form FORTRAN-Descriptor-Words */
 
     F2CPTR_(path, &pp, &lpp);
 
     F2CPTR_(opt,  &op, &lop);

#else

     /* create C-pointers and lengths for FORTRAN character strings */
 
     pp   =  path;
     lpp  =  (int) lpath;
 
     op   =  opt;
     lop  =  (int) lopt;

     if ( debug ) {
       printf (" BLK_OPN    pp = %8x\n", pp);
       printf (" BLK_OPN    op = %8x\n", op);
       printf ("\n");
     }

#endif

     if ( debug ) {
       printf ("\n");
       printf (" BLK_OPN    pp = %s\n", pp);
       printf (" BLK_OPN   lpp = %d\n", lpp);
       printf ("\n");
       printf (" BLK_OPN    op = %s\n", op);
       printf (" BLK_OPN   lop = %d\n", lop);
       printf ("\n");
     }

     /* transfer FORTRAN character string (path) to local array fnam[] */
 
     i   =  0;

     while ((*pp != '\0') && (*pp != ' ') && (i < lpp)) {

       fnam[i++] = *(pp++);

     }

     fnam[i] =  '\0';
     lfnam   =  i + 1;

     if ( debug ) {
       printf (" BLK_OPN  fnam = %s\n", fnam);
       printf (" BLK_OPN lfnam = %d\n", i);
     }
 
     /* setup open options by checking file status */
 
     oc    =  'c';                     /* set open/create flag = 'create' */
     acc   =  access(fnam, F_OK);      /* attempt to access the file  */

     if ( debug ) {
       printf (" BLK_OPN   acc = %6d\n", acc);
       printf ("\n");
     }
 
     if (acc == -1) {                  /* file does not exist */
                                       /* =================== */
       if (*(op+1)=='o') {             /* user option says 'old'  */

         printf ("\n");
         printf (" BLK_OPN file does not exist !\n");
         printf (" BLK_OPN   fnam = %s\n", fnam);
         printf (" BLK_OPN opt[2] = %s\n", *(op+1));
         printf ("\n");

         blk_err(errno, &ierr);        /* extract error number    */

         *uerr = (Int) ierr;           /* set the user error code */

         return;                       /* return to user          */

       }

     }

     else {                            /* file exists */
                                       /* =========== */
       if (*(op+1)=='n') {             /* user option says 'new'  */

         printf ("\n");
         printf (" BLK_OPN file already exists, user opt = 'new' !\n");
         printf (" BLK_OPN   fnam = %s\n", fnam);
         printf (" BLK_OPN opt[2] = %s\n", *(op+1));
         printf ("\n");

         errno = EEXIST;               /* set 'exists' error message */

         blk_err(errno, &ierr);        /* extract error number       */

         *uerr = (Int) ierr;           /* set the user error code    */

         return;                       /* return to user             */

       }

       else                            /* user option says 'old/both'   */

         oc = 'o';                     /* set open/create flag = 'open' */

     }
 
     mode  =  0644;                    /* set protection = (rw_,r__,r__) */
 
     /* set open 'flags' using the (opt) variables */
 
     flags =  0;

#if defined (_cray_) || defined (_cray_xmp_)
  /* flags =  O_RAW;                      invoke UNBUFFERED i/o      */
#endif

#if defined (_x86_)
  /* flags =  _O_BINARY;                  invoke UNBUFFERED i/o      */
     flags =   O_BINARY;               /* invoke UNBUFFERED i/o      */
#endif

     if (*(op)   == 'r')   flags = flags | O_RDONLY;
     if (*(op)   == 'w')   flags = flags | O_WRONLY | O_APPEND;
     if (*(op)   == ' ')   flags = flags | O_RDWR;
 
     if (*(op+1) == 'o')   flags = flags | O_EXCL;
     if (*(op+1) == 'n')   flags = flags | O_CREAT  | O_EXCL;
     if (*(op+1) == 's')   flags = flags | O_CREAT;
     if (*(op+1) == ' ')   flags = flags | O_CREAT  | O_TRUNC;
  // if (*(op+1) == ' ')   flags = flags | O_CREAT;

     if ( debug ) {
       printf (" BLK_OPN   opt    = %s\n",  op);
       printf (" BLK_OPN   lop    = %d\n", lop);
       printf ("\n");
       printf (" BLK_OPN *(opt)   = %c  %4x\n", *(op)  , *(op)  );
       printf (" BLK_OPN *(opt+1) = %c  %4x\n", *(op+1), *(op+1));
       printf ("\n");
       printf ("                       dec      hex      oct\n");
       printf ("\n");
       printf (" BLK_OPN O_RDONLY = %6d %8x %8o\n", O_RDONLY, O_RDONLY, O_RDONLY);
       printf (" BLK_OPN O_WRONLY = %6d %8x %8o\n", O_WRONLY, O_WRONLY, O_WRONLY);
       printf (" BLK_OPN O_RDWR   = %6d %8x %8o\n", O_RDWR,   O_RDWR,   O_RDWR);
       printf (" BLK_OPN O_APPEND = %6d %8x %8o\n", O_APPEND, O_APPEND, O_APPEND);
       printf (" BLK_OPN O_EXCL   = %6d %8x %8o\n", O_EXCL,   O_EXCL,   O_EXCL);
       printf (" BLK_OPN O_CREAT  = %6d %8x %8o\n", O_CREAT,  O_CREAT,  O_CREAT);
 
#if defined (_cray_) || defined (_cray_xmp_)
    /* printf (" BLK_OPN O_RAW    = %6d %8x %8o\n", O_RAW,    O_RAW,    O_RAW); */
#endif

#if defined (_x86_)
       printf (" BLK_OPN O_BINARY = %6d %8x %8o\n", _O_BINARY, _O_BINARY, _O_BINARY);
#endif

       printf ("\n");
     }
 
     sizb  =  0;                       /* set defaults for file size */

     if ( debug ) {
       printf (" BLK_OPN flags    = %6d %8x %8o\n", flags, flags, flags);
       printf (" BLK_OPN  mode    = %6d %8x %8o\n", mode,  mode,  mode);
       printf ("\n");
     }
 
     fdes =  open(fnam, flags, mode);  /* open/create file 'path' */

     *fd  =  (Int) fdes;               /* set file descriptor     */

     if ( debug ) {
       printf (" BLK_OPN *fd from open = %d\n", *fd);
       printf (" BLK_OPN         errno = %d\n", errno);
       printf ("\n");
     }
 
     if (fdes == -1) {                /* error on open/create request  */

       printf ("\n");
       printf (" BLK_OPN cannot open file !\n");
       printf (" BLK_OPN  fnam = %s\n", fnam);
       printf (" BLK_OPN flags = %o\n", flags);
       printf (" BLK_OPN  mode = %o\n", mode);
       printf ("\n");

       blk_err(errno, &ierr);          /* extract error number          */

     }

     else {                            /* valid file open, check status */

       if (fstat((int)fdes, &stbuf) == -1) { /* error in status request ? */

         if ( debug ) {
           printf (" BLK_OPN fs from fstat = %d\n", fstat(*fd, &stbuf));
           printf (" BLK_OPN         errno = %d\n", errno);
         }

         printf ("\n BLK_OPN  *fd = %d  has a bad status !\n", *fd);

         blk_err(errno, &ierr);        /* extract error number          */

       }

       else {                          /* valid status info             */

         sizb  =  stbuf.st_size;       /* file size in bytes            */
         blk_err((int)0, &ierr);    /* clear error number            */

       }

     }
 
     *size  =  (Int) (sizb / NBInt);   /* cvt byte count to words */

     if ((sizb % NBInt) != 0) {

       printf ("\n");
       printf (" BLK_OPN file size not word-even in byte count !\n");
       printf (" BLK_OPN     sizb = %d (in bytes)\n", sizb);
       printf (" BLK_OPN    *size = %d (in words)\n", *size);
       printf (" BLK_OPN residual = %d (in bytes)\n", (sizb % NBInt));
       printf (" BLK_OPN    NBInt = %d (no. bytes per word)\n", NBInt);
       printf ("\n");
       errno  =  -2;                   /* set error no. = -2 (local error) */
       blk_err(errno, &ierr);          /* extract error number    */

     }

     if ( debug ) {
       printf (" BLK_OPN NBInt = %d (no. bytes per word)\n", NBInt);
       printf (" BLK_OPN PRUSIZ= %d (no. bytes per buffer)\n", PRUSIZ);
       printf (" BLK_OPN *pruw = %d (no. words per buffer)\n", *pruw);
       printf (" BLK_OPN  sizb = %d (in bytes)\n", sizb);
       printf (" BLK_OPN  size = %d (in words)\n", *size);
       printf (" BLK_OPN  ierr = %d\n", ierr);
       printf ("\n");
     }
 
     /* save file name (fnam) and type (opt[1]) for use by BLK_CLO*/
 
     if ((fdes < 0) | (fdes >= MAXFD)) { /* check for (fd) out of range     */

       printf ("\n");
       printf (" BLK_OPN (*fd) out of range !\n");
       printf (" BLK_OPN  fnam = %s\n", fnam);
       printf (" BLK_OPN   *fd = %d\n", *fd);
       printf (" BLK_OPN MAXFD = %d\n", MAXFD);
       printf ("\n");

       errno  =  -1;                   /* set error no. = -1 (local error) */

       blk_err(errno, &ierr);

     }
 
     fnpt[(int)fdes] =  (char *) malloc(lfnam); /* storage for file name   */
     strcpy (fnpt[(int)fdes], fnam);   /* copy (fnam) to this storage      */
 
     ftyp[(int)fdes]  =  *(op+1);      /* save file type (opt[1])          */
 
     *uerr  =  (Int) ierr;             /* set the user error code          */

     return;

}
 
/* end */
 
/*  BLK_POS  position file 'fd' to starting block no. 'blk'
 *
 *  this routine is called in fortran (f77) via:
 *
 *
 *       call  BLKPOS (fd, blk, pos, uerr)
 *      -----------------------------------
 *
 *  input arguements:
 *
 *    fd    =  file descriptor for file
 *    blk   =  starting 'block' number in file
 *
 *  output arguements:
 *
 *    pos   =  file position in words (long int)
 *    uerr  =  error return number (zero if no error)
 *
 */
 
/*********************
 *  entry - BLK_POS  *
 *********************/
 
#ifdef __STDC__

void CallTyp blk_pos ( Int   *fd   , 
                       Int   *blk  ,
                       Int   *pos  ,
                       Int   *uerr )

#else
 
void CallTyp blk_pos ( fd   , 
                       blk  ,
                       pos  ,
                       uerr )

Int   *fd;
Int   *blk;
Int   *pos;
Int   *uerr;

#endif

{

     int          ierr;
     long int     offset, posb;
 
     ierr   =  0;                      /* clear the user error code */
     errno  =  0;                      /* clear error code no.      */

     if ( debug ) {
       printf ("\n");
       printf (" BLK_POS PRUSIZ = %d\n", PRUSIZ);
     }
 
     offset =  PRUSIZ * (*blk - 1);    /* (byte_wise) offset for 'blk' */

     if ( debug ) {
       printf (" BLK_POS     fd = %d\n", *fd);
       printf (" BLK_POS    blk = %d\n", *blk);
       printf (" BLK_POS offset = %d\n", offset);
     }
 
     posb = lseek((int)*fd, 0L, LSEEK_CUR);  /* check current file position */

     if ( debug ) {
       printf (" BLK_POS    pos = %d\n", posb);
       printf (" BLK_POS  errno = %d\n", errno);
     }
 
     if (posb != offset) {             /* if not at offset, put it there */

       posb  =  lseek((int)*fd, offset, LSEEK_SET);

       if ( debug ) {
         printf (" BLK_POS    pos = %d\n", posb);
         printf (" BLK_POS  errno = %d\n", errno);
       }
 
       if (posb == -1) {               /* error in lseek call ?   */

         printf ("\n");
         printf (" BLK_POS can not position file by lseek(---)\n");
         printf (" BLK_POS     fd = %d\n", *fd);
         printf (" BLK_POS    blk = %d\n", *blk);
         printf (" BLK_POS offset = %d\n", offset);
         printf ("\n");

         blk_err(errno, &ierr);        /* extract error number    */

       }

     }

     else {                            /* valid status info       */

         blk_err((int)0, &ierr);    /* clear error number      */

     }
 
     *pos  =  posb / NBInt;            /* cvt byte count to words */

     if ((posb % NBInt) != 0) {

       printf ("\n");
       printf (" BLK_POS position not even count in word count !\n");
       printf (" BLK_POS     pos  = %d (in bytes)\n", posb);
       printf (" BLK_POS     *pos = %d (in words)\n", *pos);
       printf (" BLK_POS residual = %d (in bytes)\n", (posb % NBInt));
       printf (" BLK_POS    NBInt = %d (no. bytes per word)\n", NBInt);
       printf ("\n");

       errno  =  -2;                   /* set error no. = -2 (local error) */

       blk_err(errno, &ierr);          /* extract error number             */

     }

     *uerr  =  (Int) ierr;             /* set the user error code          */

     if ( debug_2 ) {
       printf (" BLK_POS:  blk = %6d  pos = %10d\n", *blk, *pos);
     }
     
     return;

}
 
/* end */
 
/*  BLK_RDR  read 'n' words from file 'fd', starting at block no. 'blk'
 *
 *  this routine is called in fortran (f77) via:
 *
 *
 *       call  BLKRDR (fd, buf, nwds, blk, uerr)
 *      -----------------------------------------
 *
 *  input arguements:
 *
 *    fd    =  file descriptor for file
 *    buf   =  pointer to buffer string (char)
 *    nwds  =  number of words (long int) to read in
 *    blk   =  starting 'block' number in file
 *
 *  output arguements:
 *
 *    uerr  =  error return number (zero if no error)
 *
 */
 
/*********************
 *  entry - BLK_RDR  *
 *********************/

#ifdef __STDC__

void CallTyp blk_rdr ( Int   *fd   ,
                       Int   *buf  ,
                       Int   *nwds ,
                       Int   *blk  ,
                       Int   *uerr )

#else
 
void CallTyp blk_rdr ( fd   ,
                       buf  ,
                       nwds ,
                       blk  ,
                       uerr )

Int   *fd;
Int   *buf;
Int   *nwds;
Int   *blk;
Int   *uerr;

#endif

{
 
     int         nbuf, ibuf, ierr;
     long int    pos,  offset;
 
     ierr   =  0;                      /* clear the user error code */
     errno  =  0;                      /* clear error code no.      */

     if ( debug ) {
       printf ("\n");
       printf (" BLK_RDR PRUSIZ = %d\n", PRUSIZ);
     }
 
     nbuf   =  (int) (*nwds * NBInt);  /* no_bytes = NBInt * no_words */
     offset =  PRUSIZ * (*blk - 1);    /* (byte_wise) offset of 'blk' */

     if ( debug_2 ) {
       pos  =  lseek ((int)*fd, 0L, LSEEK_CUR);  /* extract position of file */

       printf (" BLK_RDR:  blk = %6d  nwds = %8d  offset = %10d  pos  = %10d\n",
                          *blk,      *nwds,       offset,        pos);
     }

     if ( debug ) {
       printf (" BLK_RDR     fd = %d\n", *fd);
       printf (" BLK_RDR   nwds = %d\n", *nwds);
       printf (" BLK_RDR   nbuf = %d\n", nbuf);
       printf (" BLK_RDR    blk = %d\n", *blk);
       printf (" BLK_RDR offset = %d\n", offset);
     }
 
     if (offset >= 0) {                /* position file before read request */

         pos   =  lseek((int)*fd, offset, LSEEK_SET);

         if ( debug ) {
           printf ("\n");
           printf (" BLK_RDR    pos = %d\n", pos);
           printf (" BLK_RDR  errno = %d\n", errno);
         }
 
         if (pos == -1) {              /* error condition in lseek call  */

           printf ("\n");
           printf (" BLK_RDR can not position file by lseek(---)\n");
           printf (" BLK_RDR     fd = %d\n", *fd);
           printf (" BLK_RDR    blk = %d\n", *blk);
           printf (" BLK_RDR offset = %d\n", offset);
           printf ("\n");

           blk_err(errno, &ierr);      /* extract error number    */

           *uerr = (Int) ierr;         /* set the user error code */

           return;

         }

     }
 
     ibuf  =  read((int)*fd, buf, nbuf);   /* read 'nbuf' bytes to 'buf' */

     if ( debug ) {
       printf (" BLK_RDR   ibuf = %d\n", ibuf);
       printf (" BLK_RDR   nwds = %d\n", *nwds);
       printf (" BLK_RDR  errno = %d\n", errno);
     }
 
     if ((ibuf == -1) || (ibuf != nbuf)) { /* error condition on read */

       printf ("\n");
       printf (" BLK_RDR    *fd = %d  has a bad read!\n", *fd);
       printf (" BLK_RDR    blk = %d\n", *blk);
       printf (" BLK_RDR offset = %d\n", offset);
       printf (" BLK_RDR   nwds = %d  (requested)\n", *nwds);
       printf (" BLK_RDR   nbuf = %d  (requested)\n", nbuf);
       printf (" BLK_RDR   ibuf = %d  (actual read)\n", ibuf);
       printf ("\n");

       if ((ibuf != nbuf) && (errno == 0)) {

         errno  =  -1;                 /* make sure of error termination */

       }

       blk_err(errno, &ierr);          /* extract error number */

     }

     else {

       blk_err((int)0, &ierr);      /* clear error number   */

     }

     *uerr  =  (Int) ierr;             /* set the user error code */


     if ( debug_2 ) {
       nbuf   =  (int) (*nwds * NBInt);  /* no_bytes = NBInt * no_words */

       printf (" BLK_RDR:                                 nbuf   = %10d  ibuf = %10d\n",
                                                          nbuf,          ibuf);
     }
     
     return;
}
 
/* end */
 
/*  BLK_WTR  write 'n' words to file 'fd', starting at block no. 'blk'
 *
 *  this routine is called in fortran (f77) via:
 *
 *
 *       call  BLKWTR (fd, buf, nwds, blk, uerr)
 *      -----------------------------------------
 *
 *  input arguements:
 *
 *    fd    =  file descriptor for file
 *    buf   =  pointer to buffer string (long int)
 *    nwds  =  number of words (long int) to write out
 *    blk   =  starting 'block' number in file
 *
 *  output arguements:
 *
 *    uerr  =  error return number (zero if no error)
 *
 */
 
/*********************
 *  entry - BLK_WTR  *
 *********************/

#ifdef __STDC__

void CallTyp blk_wtr ( Int   *fd   ,
                       Int   *buf  ,
                       Int   *nwds ,
                       Int   *blk  ,
                       Int   *uerr )

#else
 
void CallTyp blk_wtr ( fd   ,
                       buf  ,
                       nwds ,
                       blk  ,
                       uerr )

Int   *fd;
Int   *buf;
Int   *nwds;
Int   *blk;
Int   *uerr;

#endif

{
 
     int         nbuf, ibuf, ierr;
     long int    pos,  offset;
 
     ierr   =  0;                      /* clear the user error code */
     errno  =  0;                      /* clear error code no.      */

     if ( debug ) {
       printf ("\n");
       printf (" BLK_WTR PRUSIZ = %d\n", PRUSIZ);
     }
 
     nbuf   =  (int) (*nwds * NBInt);  /* no_bytes = NBInt * no_words */
     offset =  PRUSIZ * (*blk - 1);    /* (byte_wise) offset of 'blk' */

     if ( debug_2 ) {
       pos  =  lseek ((int)*fd, 0L, LSEEK_CUR);  /* extract position of file */

       printf (" BLK_WTR:  blk = %6d  nwds = %8d  offset = %10d  pos  = %10d\n",
                          *blk,      *nwds,       offset,        pos);
     }

     if ( debug ) {
       printf (" BLK_WTR     fd = %d\n", *fd);
       printf (" BLK_WTR   nwds = %d\n", *nwds);
       printf (" BLK_WTR   nbuf = %d\n", nbuf);
       printf (" BLK_WTR    blk = %d\n", *blk);
       printf (" BLK_WTR offset = %d\n", offset);
     }
 
     if (offset >= 0) {                /* position file before write request */

       pos = lseek((int)*fd, offset, LSEEK_SET);

       if ( debug ) {
         printf ("\n");
         printf (" BLK_WTR    pos = %d\n", pos);
         printf (" BLK_WTR  errno = %d\n", errno);
       }
 
       if (pos == -1) {                /* error condition in lseek call ? */

         printf ("\n");
         printf (" BLK_WTR can not position file by lseek(---)\n");
         printf (" BLK_WTR     fd = %d\n", *fd);
         printf (" BLK_WTR    blk = %d\n", *blk);
         printf (" BLK_WTR offset = %d\n", offset);
         printf ("\n");

         blk_err(errno, &ierr);        /* extract error number    */

         *uerr = (Int) ierr;           /* set the user error code */

         return;

       }

     }
 
     ibuf  =  write((int)*fd, buf, nbuf); /* write 'nbuf' bytes to 'buf'  */

     if ( debug ) {
       printf (" BLK_WTR   ibuf = %d\n", ibuf);
       printf (" BLK_WTR   nwds = %d\n", *nwds);
       printf (" BLK_WTR  errno = %d\n", errno);
     }
 
     if ((ibuf == -1) || (ibuf != nbuf)) {  /* error condition on write */

       printf ("\n");
       printf (" BLK_WTR    *fd = %d  has a bad write!\n", *fd);
       printf (" BLK_WTR    blk = %d\n", *blk);
       printf (" BLK_WTR offset = %d\n", offset);
       printf (" BLK_WTR   nwds = %d  (requested)\n", *nwds);
       printf (" BLK_WTR   nbuf = %d  (requested)\n", nbuf);
       printf (" BLK_WTR   ibuf = %d  (actual write", ibuf);
       printf ("\n");

       if ((ibuf != nbuf) && (errno == 0)) {

         errno  =  -1;                 /* make sure of error termination */

       }

       blk_err(errno, &ierr);          /* extract error number */

     }

     else {

       blk_err((int)0, &ierr);      /* clear error number */

     }

     *uerr  =  (Int) ierr;             /* set the user error code */

     if ( debug_2 ) {
       nbuf   =  (int) (*nwds * NBInt);  /* no_bytes = NBInt * no_words */

       printf (" BLK_WTR:                                 nbuf   = %10d  ibuf = %10d\n",
                                                          nbuf,          ibuf);
     }

     return;

}
 
/* end */
 
/*  BLK_CLO  close (/delete) a file from randon i/o, given it's descriptor
 *
 *  this routine is called in fortran (f77) via:
 *
 *
 *       call  BLKCLO (fd, opt, size, uerr)
 *      ------------------------------------
 *
 *  input arguements:
 *
 *    fd    =  file descriptor for file (for closing)
 *    opt   =  1 character close option flag, where
 *             opt = ' ' for normal close
 *                   'd' for close/delete option
 *
 *  output arguements:
 *
 *    size  =  size of file in words (long int)
 *    uerr  =  error return number (zero if no error)
 *
 */
 
/*********************
 *  entry - BLK_CLO  *
 *********************/

#ifdef __STDC__ 

void CallTyp blk_clo ( Int   *fd   ,
                       Char   opt  LOPT_MS ,
                       Int   *size ,
                       Int   *uerr LOPT)

#else
 
void CallTyp blk_clo ( fd   ,
                       opt  ,
                       size ,
                       uerr KOPT)

Int   *fd;
Char   opt;
Int   *size;
Int   *uerr;
KLOPT

#endif

{
 
     static char  *op;
     static int   lop;
 
     int          ierr;
     long int     sizb;
     struct stat  stbuf;
 
     ierr  =  0;                        /* clear the user error code */
     errno =  0;                        /* clear the error code no.  */
 
#if defined (_cray_star_)

     /* create C-pointers form FORTRAN-Descriptor-Words */
 
     F2CPTR_(opt,  &op, &lop);

#else
 
     /* create C-pointers and lengths for FORTRAN character strings */
 
     op   =  opt;
     lop  =  (int) lopt;
 
#endif

     /* first, extract the file's stats for return */
 
     if ( debug ) {
       printf ("\n");
       printf (" BLK_CLO    fd = %d\n", *fd);
     }

     if (fstat((int)*fd, &stbuf) == -1) { /* error in status request ? */

       if ( debug ) {
         printf (" BLK_CLO fstat = %d\n", fstat(*fd, &stbuf));
         printf (" BLK_CLO errno = %d\n", errno);
       }

       sizb  =  0;                     /* clear file statistics  */

       printf ("\n BLK_CLO  *fd = %d  has a bad status !\n", *fd);

       blk_err(errno, &ierr);          /* extract error number   */

     }

     else {                            /* valid status info      */

       if ( debug ) {
         printf (" BLK_CLO fstat = %d\n", fstat(*fd, &stbuf));
         printf (" BLK_CLO errno = %d\n", errno);
       }

       sizb  =  stbuf.st_size;         /* file size in bytes      */

       blk_err((int)0, &ierr);      /* clear error number      */

     }
 
     *size  =  (Int) (sizb / NBInt);   /* cvt byte count to words */

     if ((sizb % NBInt) != 0) {

       printf ("\n");
       printf (" BLK_CLO file size not word-even in byte count !\n");
       printf (" BLK_CLO     sizb = %d (in bytes)\n", sizb);
       printf (" BLK_CLO    *size = %d (in words)\n", *size);
       printf (" BLK_CLO residual = %d (in bytes)\n", (sizb % NBInt));
       printf (" BLK_CLO    NBInt = %d (no. bytes per word)\n", NBInt);
       printf ("\n");

       errno  =  -2;                   /* set error no. = -2 (local error) */

       blk_err(errno, &ierr);          /* extract error number    */

     }

     if ( debug ) {
       printf (" BLK_CLO  size = %d\n", *size);
     }
 
     /* second, close the file pointed to by 'fd' */
 
     if (close((int)*fd) == -1) {      /* error on close request ? */

       printf ("\n");
       printf (" BLK_CLO can not close file !\n");
       printf (" BLK_CLO   *fd = %d\n", *fd);
       printf (" BLK_CLO   opt = %s\n",  op);
       printf ("\n");

       blk_err(errno, &ierr);          /* extract error number   */

       *uerr = (Int) ierr;             /* set the user error code */

       return;

     }

     if ( debug ) {
       printf (" BLK_CLO after call to close(---)\n");
       printf (" BLK_CLO   *fd = %d\n", *fd);
       printf (" BLK_CLO   opt = %s\n",  op);
     }
 
     /* last, check option and delete file if request is on */
 
     if ((*op == 'd') || (ftyp[*fd] == 's')) {  /* delete option on ? */

       /* unlink/delete the file (name) pointed to by fnpt[*fd] */

       if ( debug ) {
         printf ("\n");
         printf (" BLK_CLO   opt = %s\n",  op);
         printf (" BLK_CLO  fnam = %s\n",  fnpt[*fd]);
         printf (" BLK_CLO  ftyp = %s\n", &ftyp[*fd]);
       }
 
       if (unlink(fnpt[(int)*fd]) == -1) { /* error on delete request ? */

#if defined (_x86_)
      /* printf (" BLK_CLO Windows O/S can not unlink attached files !\n"); */
#else
         printf ("\n");
         printf (" BLK_CLO can not unlink file !\n");
         printf (" BLK_CLO   *fd = %d\n", *fd);
         printf (" BLK_CLO  fnam = %s\n", fnpt[*fd]);
         printf (" BLK_CLO   opt = %s\n", op);
         printf ("\n");

         blk_err(errno, &ierr);        /* extract error number    */
#endif
       }

       if ( debug ) {
         printf (" BLK_CLO after call to unlink(---)\n");
         printf (" BLK_CLO   *fd = %d\n", *fd);
         printf (" BLK_CLO  fnam = %s\n", fnpt[*fd]);
       }

     }

     if ( debug ) {
       printf (" BLK_CLO errno = %d\n", errno);
     }

     *uerr  =  (Int) ierr;             /* set the user error code */

     return;

}
 
/* end */
 
/*  BLK_STA  extract the current status of a file
 *
 *  this routine is called in fortran (f77) via:
 *
 *
 *       call  BLKSTA (fd, uerr)
 *      -------------------------
 *
 *  input arguements:
 *
 *    fd    =  file descriptor for file
 *
 *  output arguements:
 *
 *    uerr  =  error return number (zero if no error)
 *
 */
 
/*********************
 *  entry - BLK_STA  *
 *********************/
 
#ifdef __STDC__

void CallTyp blk_sta ( Int   *fd   ,
                       Int   *uerr )

#else
 
void CallTyp blk_sta ( fd   , 
                       uerr )

Int   *fd;
Int   *uerr;

#endif

{

     int            ierr;
 
     struct stat    stbuf;
     unsigned short mode, uid,  gid;
     short          nlnk;
     off_t          sizb, size;
     int            bksz, blks;
     time_t         atim, mtim, ctim;
     ino_t          ino;
 
     struct tm    dt;
 
     printf ("\n");
     printf (" BLK_STA fd          = %8x\n", *fd);
 
     if (fstat((int)*fd, &stbuf) == -1) { /* error in status request ?    */

       if ( debug ) {
         printf (" BLK_STA fs from fstat = %d\n", fstat(*fd, &stbuf));
         printf (" BLK_STA         errno = %d\n", errno);
       }

       printf ("\n");
       printf (" BLK_STA *fd         = %d  has a bad status !\n", *fd);

       blk_err(errno, &ierr);          /* extract error number           */

     }

     else {                            /* valid status info              */

       ino  = stbuf.st_ino;            /* set 'ino'  = inode number      */
       nlnk = stbuf.st_nlink;          /* set 'nlnk' = no. hard links    */
       mode = stbuf.st_mode;           /* set 'mode' = file protection   */
       uid  = stbuf.st_uid;            /* set 'uid'  = user-id of owner  */
       gid  = stbuf.st_gid;            /* set 'gid'  = group-id of owner */
       sizb = stbuf.st_size;           /* set 'size' = file size (char)  */
       size = sizb / NBInt;            /* set 'size' = file size (char)  */
       bksz = PRUSIZ;                  /* set 'bksz' = file block size   */
       blks = (sizb-1)/bksz + 1;       /* set 'blks' = no. of blocks     */
       atim = stbuf.st_atime;          /* set 'atim' = last access time  */
       mtim = stbuf.st_mtime;          /* set 'mtim' = last modify time  */
       ctim = stbuf.st_ctime;          /* set 'ctim' = last change time  */
 
       blk_err((int)0, &ierr);      /* clear error number             */
 
       printf (" BLK_STA ino   (hex) = %8x\n", ino);
       printf (" BLK_STA nlnk  (dec) = %8d\n", nlnk);
       printf (" BLK_STA mode  (oct) = %8o\n", mode);
       printf (" BLK_STA uid   (dec) = %8d\n", uid);
       printf (" BLK_STA gid   (dec) = %8d\n", gid);
       printf (" BLK_STA sizb  (dec) = %8d  (in bytes)\n", sizb);
       printf (" BLK_STA size  (dec) = %8d  (in words)\n", size);
       printf (" BLK_STA bksz  (dec) = %8d  (no. bytes/block)\n", bksz);
       printf (" BLK_STA blks  (dec) = %8d\n", blks);
       printf (" BLK_STA NBInt (dec) = %8d  (no. bytes/word)\n", NBInt);
 
       dt         = *localtime(&atim);
       dt.tm_year = ( dt.tm_year > 99 ) ? dt.tm_year - 100 : dt.tm_year;

       printf (" BLK_STA last access = %2d/%2.2d/%2.2d - %2d:%2.2d:%2.2d\n",
               (dt.tm_mon+1), dt.tm_mday, dt.tm_year,
                dt.tm_hour,   dt.tm_min,  dt.tm_sec);
 
       dt         = *localtime(&mtim);
       dt.tm_year = ( dt.tm_year > 99 ) ? dt.tm_year - 100 : dt.tm_year;
       printf (" BLK_STA last modify = %2d/%2.2d/%2.2d - %2d:%2.2d:%2.2d\n",
               (dt.tm_mon+1), dt.tm_mday, dt.tm_year,
                dt.tm_hour,   dt.tm_min,  dt.tm_sec);
 
       dt         = *localtime(&ctim);
       dt.tm_year = ( dt.tm_year > 99 ) ? dt.tm_year - 100 : dt.tm_year;
       printf (" BLK_STA last change = %2d/%2.2d/%2.2d - %2d:%2.2d:%2.2d\n",
               (dt.tm_mon+1), dt.tm_mday, dt.tm_year,
                dt.tm_hour,   dt.tm_min,  dt.tm_sec);
 
       printf ("\n");
 
     }

     *uerr  =  (Int) ierr;             /* set the user error code */

     return;

}
 
/* end */
 
/*  BLK_ERR  return a system error number, given 'erno'
 *
 *      blk_err (erno, ierr)
 *     ----------------------
 *
 *  input arguements:
 *
 *    erno    =  system error number
 *               if erno =         0,  NULL error, ierr = 0
 *                  erno <         0,  local error
 *                  erno >  sys_nerr,  undefined,  ierr = -sys_nerr
 *
 *  output arguements:
 *
 *    ierr    =  error number (zero if 'erno' == NULL)
 *
 */
 
/*********************
 *  entry - BLK_ERR  *
 *********************/
 
#ifdef __STDC__

void CallTyp blk_err ( int    erno ,
                       int   *ierr )

#else
 
void CallTyp blk_err ( erno , 
                       ierr )

int    erno;
int   *ierr;

#endif

{
 
#ifdef _macosx_
  extern int errno;
#elif _gfc64_
// #ifdef  __USE_GNU
#elif _linux_
  extern int   _sys_nerr;        /* largest error no. for which system  */
                                 /* system tables has a defined message */
  extern char *_sys_errlist[];   /* table of system error messages      */
// #ifdef  __USE_BSD
#else
  extern int    sys_nerr;        /* largest error no. for which system  */
                                 /* system tables has a defined message */
  extern char  *sys_errlist[];   /* table of system error messages      */
#endif
 

     if (erno == (int)0) {   /* NULL error message returned */

       *ierr =  0;

       return;

     }
 
#ifdef _macosx_
     if ((erno > 0) && (erno <  sys_nerr)) {
       *ierr  =  erno;
       printf (" BLK_ERR ierr = %4d  (%s)", erno,  sys_errlist[erno]);
     }
#elif _gfc64_ 
     if (erno > 0) {
       *ierr  =  erno;
       printf (" BLK_ERR ierr = %4d  (%s)", erno, strerror(erno));
     }
#elif _linux_ 
     if ((erno > 0) && (erno < _sys_nerr)) {
       *ierr  =  erno;
       printf (" BLK_ERR ierr = %4d  (%s)", erno, _sys_errlist[erno]);
     }
#else
     if ((erno > 0) && (erno <  sys_nerr)) {
       *ierr  =  erno;
       printf (" BLK_ERR ierr = %4d  (%s)", erno,  sys_errlist[erno]);
     }
#endif


     else {

       if (erno < 0) {

         *ierr =  erno;

         printf (" BLK_ERR ierr = %4d  (local error)", erno);

       }

       else {

#ifdef _macosx_
         *ierr =   -sys_nerr;
#elif _gfc64_ 
         *ierr =  -999; 
#elif  _linux_
         *ierr =  -_sys_nerr; 
#else
         *ierr =   -sys_nerr;
#endif

         printf (" BLK_ERR ierr = %4d  (unkown error value ?)", erno);

       }

     }

     return;

}
 
/* end */
 
/*  BLK_LOC  extract the current position within a file
 *
 *  this routine is called in fortran (f77) via:
 *
 *
 *       call  BLKLOC (fd, size, pos, uerr)
 *      ------------------------------------
 *
 *  input arguements:
 *
 *    fd    =  file descriptor for file
 *
 *  output arguements:
 *
 *    size  =  size     of file in words (long int)
 *    pos   =  position of file in words (long int)
 *    uerr  =  error return number (zero if no error)
 *
 */
 
/*********************
 *  entry - BLK_LOC  *
 *********************/

#ifdef __STDC__

void CallTyp blk_loc ( Int   *fd   , 
                       Int   *size ,
                       Int   *pos  ,
                       Int   *uerr )

#else
 
void CallTyp blk_loc ( fd   , 
                       size ,
                       pos  ,
                       uerr )

Int   *fd;
Int   *size;
Int   *pos;
Int   *uerr;

#endif

{
 
     int          ierr;
     long int     sizb, posb;
     struct stat  stbuf;
 
     ierr   =  0;                        /* clear the user error code */
     errno  =  0;                        /* clear error code no.      */

     if ( debug ) {
       printf ("\n");
       printf (" BLK_LOC    fd = %8x\n", fd);
       printf (" BLK_LOC   *fd = %8d\n", *fd);
     }
 
     posb  =  lseek ((int)*fd, 0L, LSEEK_CUR);  /* extract position of file */
 
     if ( debug ) {
       printf (" BLK_LOC  posb = %d\n", posb);
       printf (" BLK_LOC errno = %d\n", errno);
     }

     if (fstat((int)*fd, &stbuf) == -1) {   /* error in status request ? */

       if ( debug ) {
         printf (" BLK_LOC fs from fstat = %d\n", fstat(*fd, &stbuf));
         printf (" BLK_LOC         errno = %d\n", errno);
       }

       sizb  =  0;                     /* clear file statistics  */

       printf ("\n BLK_LOC  *fd = %d  has a bad status !\n", *fd);

       blk_err(errno, &ierr);          /* extract error number   */

     }

     else {                            /* valid status info      */

       if ( debug ) {
         printf (" BLK_LOC fs from fstat = %d\n", fstat(*fd, &stbuf));
         printf (" BLK_LOC         errno = %d\n", errno);
       }

       sizb  =  stbuf.st_size;         /* file size in bytes     */

       blk_err((int)0, &ierr);      /* clear error number     */

     }
 
     *size  =  (Int) (sizb / NBInt);   /* cvt byte count to words */

     if ((sizb % NBInt) != 0) {

       printf ("\n");
       printf (" BLK_LOC file size not word-even in byte count !\n");
       printf (" BLK_LOC     sizb = %d (in bytes)\n", sizb);
       printf (" BLK_LOC    *size = %d (in words)\n", *size);
       printf (" BLK_LOC residual = %d (in bytes)\n", (sizb % NBInt));
       printf (" BLK_LOC    NBInt = %d (no. bytes per word)\n", NBInt);
       printf ("\n");

       errno  =  -2;                   /* set error no. = -2 (local error) */

       blk_err(errno, &ierr);          /* extract error number    */

     }
 
     *pos  =  (Int) (posb / NBInt);    /* cvt byte count to words */

     if ((posb % NBInt) != 0) {

       printf ("\n");
       printf (" BLK_LOC position not word-even in byte count !\n");
       printf (" BLK_LOC     pos  = %d (in bytes)\n", posb);
       printf (" BLK_LOC     *pos = %d (in words)\n", *pos);
       printf (" BLK_LOC residual = %d (in bytes)\n", (posb % NBInt));
       printf (" BLK_LOC    NBInt = %d (no. bytes per word)\n", NBInt);
       printf ("\n");

       errno  =  -2;                   /* set error no. = -2 (local error) */

       blk_err(errno, &ierr);          /* extract error number    */

     }

     *uerr  =  (Int) ierr;             /* set the user error code */

     return;

}
 
/* end */
 
/*  BLK_RTN  delete a file from randon i/o, given it's descriptor
 *
 *  this routine is called in fortran (f77) via:
 *
 *
 *       call  BLKRTN (fd, uerr)
 *      -------------------------
 *
 *  input arguements:
 *
 *    fd    =  file descriptor for file
 *
 *  output arguements:
 *
 *    uerr  =  error return number (zero if no error)
 *
 */
 
/*********************
 *  entry - BLK_RTN  *
 *********************/

#ifdef __STDC__

void CallTyp blk_rtn ( Int   *fd   ,
                       Int   *uerr )

#else
 
void CallTyp blk_rtn ( fd   , 
                       uerr )

Int   *fd;
Int   *uerr;

#endif

{

     int          ierr;
 
     ierr   =  0;                      /* clear the user error code */
     errno  =  0;                      /* clear the error code no.  */
 
     if ( debug ) {
       printf ("\n");
       printf (" BLK_RTN    fd = %d\n", *fd);
     }
 
     /* unlink/delete the file pointed to by fnpt[*fd] */

     if ( debug ) {
       printf ("\n");
       printf (" BLK_RTN  fnpt = %s\n",  fnpt[*fd]);
       printf (" BLK_RTN  ftyp = %s\n", &ftyp[*fd]);
     }
 
     if (unlink(fnpt[(int)*fd]) == -1) { /* error on delete request ? */

#if defined (_x86_)
    /* printf (" BLK_RTN Windows O/S can not unlink attached files !\n"); */
#else
       printf ("\n");
       printf (" BLK_RTN can not unlink file !\n");
       printf (" BLK_RTN   *fd = %d\n", *fd);
       printf (" BLK_RTN  fnpt = %s\n", fnpt[*fd]);
       printf ("\n");

       blk_err(errno, &ierr);          /* extract error number    */
#endif

     }

     if ( debug ) {
       printf (" BLK_RTN after call to unlink(---)\n");
       printf (" BLK_RTN   *fd = %d\n", *fd);
       printf (" BLK_RTN  fnpt = %s\n",  fnpt[*fd]);
       printf (" BLK_RTN errno = %d\n",  errno);
     }

     *uerr  =  (Int) ierr;             /* set the user error code */

     return;

}

/* end */
 
/*  BLK_DBG  set the internal debug flags
 *
 *  this routine is called in fortran (f77) via:
 *
 *
 *       call  BLKDBG (idbg)
 *      -------------------------
 *
 *  input arguements:
 *
 *    idbg  =  0,  clear ALL debug flags
 *          =  1,  turn on ( o_debug   )
 *          =  2,  turn on ( o_debug_2 )
 *
 */
 
/*********************
 *  entry - BLK_DBG  *
 *********************/

#ifdef __STDC__

void CallTyp blk_dbg ( Int   *idbg )

#else
 
void CallTyp blk_dbg ( idbg )

Int   *idbg;

#endif

{
     if      ( *idbg == 0 ) {
       debug    =  0;
       debug_2  =  0;
     }
     else if ( *idbg == 1 ) {
       debug    =  1;
     }
     else if ( *idbg == 2 ) {
       debug_2  =  1;
     }
 
     if ( debug ) {
       printf (" BLK_DBG  debug = %d  debug_2 = %d\n", debug, debug_2);
     }

     return;

}

/* end */
