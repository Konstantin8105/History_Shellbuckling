/*  BLK***:  low-level block i/o routines written in C-language with
 *           appropriate hooks into the Unix kernal through the
 *           standard interface definitions (System V & Berkeley 4.*)
 *
 *  collected together below are all of the required 'header' files
 *
 */
 
#include   <stdio.h>
#include   <sys/types.h>
#include   <sys/file.h>
#include   <sys/stat.h>
#include   <errno.h>
 
#include   <fcntl.h>
/*
 *    the following flags represent file
 *    accessing  modes used by open(---)
 *
 */
#define    R_OK     04      /* read permission            */
#define    W_OK     02      /* write permission           */
#define    X_OK     01      /* execute/search permission  */
#define    F_OK     00      /* file existence             */
 
/*
 *    the following flags represent file positioning
 *    parameters used by lseek(---)
 *
 */
#define    L_SET     0      /* absolute offset (from BOF) */
#define    L_INCR    1      /* relative to current offset */
#define    L_XTND    2      /* relative to end of file    */
 
/*
 *    define all global variables here
 *    for use in all of the functions
 */
 
int     PRUBLK = 1024;         /* preset block/buffer size    */
int     NCPW   =    4;         /* no. characters per word     */
 
#define MAXFD    64            /* max no. of file descriptors */
char   *fnpt[MAXFD];           /* array of file name pointers */
char    ftyp[MAXFD];           /* file type option (char)     */
 
/*
 *    make lint happy
 */
 
extern char  *malloc();
extern char  *strcpy();
extern int    read();
extern int    write();
extern int    close();
extern int    fstat();
extern long   lseek();
 
/* end */

/*
#define exit exit_
#define blkopn blkopn_
#define blkpos blkpos_
#define blkwtr blkwtr_
#define blkrdr blkrdr_
#define blkclo blkclo_
#define blksta blksta_
#define blkerr blkerr_
#define blkloc blkloc_
#define blkrtn blkrtn_
*/
 
/*  BLKOPN:  open a file for randon i/o, given it's path name
 *
 *  this routine is called in fortran (f77) via:
 *
 *       call  blkopn (path, opt, fd, size, ierr)
 *      ------------------------------------------
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
 *    size  =  size of file (in words)
 *    ierr  =  error return number (zero if no error)
 *
 */
 
/**********************
 *  entry  -  BLKOPN  *
 **********************/
 
blkopn (path, opt, fd, size, ierr, lpath, lopt)
 
char       *path, *opt;
long int   *fd,   *size, *ierr, lpath, lopt;
 
{
 
     char         oc,  fnam[256];
     static char  *op, *pp;
     static int   lop, lpp;
     unsigned     lfnam;
 
     int          i, flags, mode, acc;
     struct stat  stbuf;
 
     *ierr =  0;                         /* clear the user error code */
     errno =  0;                         /* clear error code no.      */
 
     /* create C-pointers and lengths for FORTRAN character strings */
 
     pp   =  path;
     lpp  =  lpath;
 
     op   =  opt;
     lop  =  lopt;
 
     /* transfer FORTRAN character string (path) to local array fnam[] */
 
     i   =  0;
     while ((*pp != '\0') && (*pp != ' ') && (i < lpp))
       {
       fnam[i++] = *(pp++);
       }
     fnam[i] =  '\0';
     lfnam   =  i + 1;
 
     /* setup open options by checking file status */
 
     oc    =  'c';                     /* set open/create flag = 'create' */
     acc   =  access(fnam, F_OK);      /* attempt to access the file  */
 
     if (acc == -1)                    /* file does not exist */
       {                               /* =================== */
       if (*(op+1)=='o')               /* user option says 'old' */
         {
         printf ("\n");
         printf (" BLKOPN: file does not exist !\n");
         printf (" BLKOPN:   fnam = %s\n", fnam);
         printf (" BLKOPN: opt[2] = %s\n", *(op+1));
         printf ("\n");
         blkerr_(errno, ierr);         /* extract error number  */
         return;                       /* return to user */
         }
       }
     else                              /* file exists */
       {                               /* =========== */
       if (*(op+1)=='n')               /* user option says 'new' */
         {
         printf ("\n");
         printf (" BLKOPN: file already exists, user opt = 'new' !\n");
         printf (" BLKOPN:   fnam = %s\n", fnam);
         printf (" BLKOPN: opt[2] = %s\n", *(op+1));
         printf ("\n");
         errno = EEXIST;               /* set 'exists' error message */
         blkerr_(errno, ierr);         /* extract error number  */
         return;                       /* return to user */
         }
       else                            /* user option says 'old/both' */
         oc = 'o';                     /* set open/create flag = 'open' */
       }
 
     mode  =  0644;                    /* set protection = (rw_,r__,r__) */
 
     flags =  0;                       /* set open 'flags' using (opt)   */
 
     if (*(op) == 'r')     flags = flags | O_RDONLY;
     if (*(op) == 'w')     flags = flags | O_WRONLY | O_APPEND;
     if (*(op) == ' ')     flags = flags | O_RDWR;
 
     if (*(op+1) == 'o')   flags = flags | O_EXCL;
     if (*(op+1) == 'n')   flags = flags | O_CREAT  | O_EXCL;
     if (*(op+1) == 's')   flags = flags | O_CREAT;
     if (*(op+1) == ' ')   flags = flags | O_CREAT;
 
  /* flags = flags | O_RAW;               invoke UNBUFFERED i/o      */
 
     *size =  0;                       /* set defaults for file size */
 
     *fd = open(fnam, flags, mode);    /* open/create file 'path' */
 
     if (*fd == -1)                    /* error on open/create request  */
       {
       printf ("\n");
       printf (" BLKOPN: cannot open file !\n");
       printf (" BLKOPN:  fnam = %s\n", fnam);
       printf (" BLKOPN: flags = %o\n", flags);
       printf (" BLKOPN:  mode = %o\n", mode);
       printf ("\n");
       blkerr_(errno, ierr);           /* extract error number          */
       }
     else                              /* valid file open, check status */
       {
       if (fstat((int)*fd, &stbuf) == -1)  /* error in status request ? */
         {
         printf ("\n BLKOPN:  *fd = %d  has a bad status !\n", *fd);
         blkerr_(errno, ierr);         /* extract error number          */
         }
       else                            /* valid status info             */
         {
         *size = stbuf.st_size/NCPW;   /* set 'size' = file size (word) */
         blkerr_(NULL, ierr);          /* clear error number            */
         }
       }
 
     /* save file name (fnam) and type (opt[1]) for use by BLKCLO */
 
     if ((*fd < 0) | (*fd >= MAXFD))   /* check for (fd) out of range     */
       {
       printf ("\n");
       printf (" BLKOPN: (*fd) out of range !\n");
       printf (" BLKOPN:  fnam = %s\n", fnam);
       printf (" BLKOPN:   *fd = %d\n", *fd);
       printf (" BLKOPN: MAXFD = %d\n", MAXFD);
       printf ("\n");
       errno  =  1;                    /* set error no. = 1 (local error) */
       blkerr_(errno, ierr);
       }
 
     fnpt[(int)*fd]  =  malloc(lfnam); /* allocate storage for file name */
     strcpy (fnpt[(int)*fd], fnam);    /* copy (fnam) to this storage    */
 
     ftyp[(int)*fd]  =  *(op+1);       /* save file type (opt[1])        */
 
     return;
}
 
/* end */
 
/*  BLKPOS:  position file 'fd' to starting block no. 'blk'
 *
 *  this routine is called in fortran (f77) via:
 *
 *       call  blkpos (fd, blk, pos, ierr)
 *      -----------------------------------
 *
 *  input arguements:
 *
 *    fd    =  file descriptor for file
 *    blk   =  starting 'block' number in file
 *
 *  output arguements:
 *
 *    pos   =  file position (in bytes)
 *    ierr  =  error return number (zero if no error)
 *
 */
 
/********************
 *  entry - BLKPOS  *
 ********************/
 
blkpos (fd, blk, pos, ierr)
 
long int   *fd, *blk, *pos, *ierr;
 
{
 
     long int     offset;
 
     *ierr =  0;                       /* clear the user error code */
     errno =  0;                       /* clear error code no.      */
 
     offset =  PRUBLK * (*blk - 1);    /* (byte_wise) offset for 'blk' */
 
     *pos = lseek((int)*fd, 0L, L_INCR);  /* check current file position */
 
     if (*pos != offset)               /* if not at offset, put it there */
       {
       *pos  =  lseek((int)*fd, offset, L_SET);
 
       if (*pos == -1)                 /* error in lseek call ? */
         {
         printf ("\n");
         printf (" BLKPOS: can not position file by lseek(---)\n");
         printf (" BLKPOS:     fd = %d\n", *fd);
         printf (" BLKPOS:    blk = %d\n", *blk);
         printf (" BLKPOS: offset = %d\n", offset);
         printf ("\n");
         blkerr_(errno, ierr);         /* extract error number   */
         }
       }
     else                              /* valid status info      */
       {
       blkerr_(NULL, ierr);            /* clear error number     */
       }
     return;
}
 
/* end */
 
/*  BLKRDR:  read 'n' words from file 'fd', starting at block no. 'blk'
 *
 *  this routine is called in fortran (f77) via:
 *
 *       call  blkrdr (fd, buf, nwds, blk, ierr)
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
 *    ierr  =  error return number (zero if no error)
 *
 */
 
/********************
 *  entry - BLKRDR  *
 ********************/
 
blkrdr (fd, buf, nwds, blk, ierr)
 
char       *buf;
long int   *fd, *nwds, *blk, *ierr;
 
{
 
     int         nbuf, ibuf;
     long int    pos,  offset;
 
     *ierr =  0;                       /* clear the user error code */
     errno =  0;                       /* clear error code no.      */
 
     nbuf   =  *nwds * NCPW;           /* no_bytes = NCPW * no_words  */
     offset =  PRUBLK * (*blk - 1);    /* (byte_wise) offset of 'blk' */
 
     if (offset >= 0)                  /* position file before read request */
       {
       pos   =  lseek((int)*fd, offset, L_SET);
 
       if (pos == -1)                  /* error condition in lseek call  */
         {
         printf ("\n");
         printf (" BLKRDR: can not position file by lseek(---)\n");
         printf (" BLKRDR:     fd = %d\n", *fd);
         printf (" BLKRDR:    blk = %d\n", *blk);
         printf (" BLKRDR: offset = %d\n", offset);
         printf ("\n");
         blkerr_(errno, ierr);         /* extract error number           */
         return;
         }
       }
 
     ibuf  =  read((int)*fd, buf, nbuf);   /* read 'nbuf' bytes to 'buf' */
 
     if ((ibuf == -1) || (ibuf != nbuf))    /* error condition on read */
       {
       printf ("\n");
       printf (" BLKRDR:    *fd = %d  has a bad read!\n", *fd);
       printf (" BLKRDR:    blk = %d\n", *blk);
       printf (" BLKRDR: offset = %d\n", offset);
       printf (" BLKRDR:   nwds = %d  (requested)\n", *nwds);
       printf (" BLKRDR:   nbuf = %d  (requested)\n", nbuf);
       printf (" BLKRDR:   ibuf = %d  (actual read)\n", ibuf);
       printf ("\n");
       if ((ibuf != nbuf) && (errno == 0))
	 {
	   errno  =  -1;
         }
       blkerr_(errno, ierr);           /* extract error number */
       }
     else
       {
       blkerr_(NULL, ierr);            /* clear error number */
       }
     return;
}
 
/* end */
 
/*  BLKWTR:  write 'n' words to file 'fd', starting at block no. 'blk'
 *
 *  this routine is called in fortran (f77) via:
 *
 *       call  blkwtr (fd, buf, nwds, blk, ierr)
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
 *    ierr  =  error return number (zero if no error)
 *
 */
 
/********************
 *  entry - BLKWTR  *
 ********************/
 
blkwtr (fd, buf, nwds, blk, ierr)
 
char       *buf;
long int   *fd, *nwds, *blk, *ierr;
 
{
 
     int         nbuf, ibuf;
     long int    pos,  offset;
 
     *ierr =  0;                       /* clear the user error code */
     errno =  0;                       /* clear error code no.      */
 
     nbuf   =  *nwds * NCPW;           /* no_bytes = NCPW * no_words  */
     offset =  PRUBLK * (*blk - 1);    /* (byte_wise) offset of 'blk' */
 
     if (offset >= 0)                  /* position file before write request */
       {
       pos = lseek((int)*fd, offset, L_SET);
 
       if (pos == -1)                  /* error condition in lseek call ? */
         {
         printf ("\n");
         printf (" BLKWTR: can not position file by lseek(---)\n");
         printf (" BLKWTR:     fd = %d\n", *fd);
         printf (" BLKWTR:    blk = %d\n", *blk);
         printf (" BLKWTR: offset = %d\n", offset);
         printf ("\n");
         blkerr_(errno, ierr);         /* extract error number            */
         return;
         }
       }
 
     ibuf  =  write((int)*fd, buf, nbuf); /* write 'nbuf' bytes to 'buf'  */
 
     if ((ibuf == -1) || (ibuf != nbuf))    /* error condition on write */
       {
       printf ("\n");
       printf (" BLKWTR:    *fd = %d  has a bad write!\n", *fd);
       printf (" BLKWTR:    blk = %d\n", *blk);
       printf (" BLKWTR: offset = %d\n", offset);
       printf (" BLKWTR:   nwds = %d  (requested)\n", *nwds);
       printf (" BLKWTR:   nbuf = %d  (requested)\n", nbuf);
       printf (" BLKWTR:   ibuf = %d  (actual write", ibuf);
       printf ("\n");
       if ((ibuf != nbuf) && (errno == 0))
	 {
	   errno  =  -1;
         }
       blkerr_(errno, ierr);           /* extract error number */
       }
     else
       {
       blkerr_(NULL, ierr);            /* clear error number */
       }
 
     return;
}
 
/* end */
 
/*  BLKCLO:  close (/delete) a file from randon i/o, given it's descriptor
 *
 *  this routine is called in fortran (f77) via:
 *
 *       call  blkclo (fd, opt, size, ierr)
 *      ------------------------------------------
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
 *    size  =  size of file (in words)
 *    ierr  =  error return number (zero if no error)
 *
 */
 
/********************
 *  entry - BLKCLO  *
 ********************/
 
blkclo (fd, opt, size, ierr, lopt)
 
char       *opt;
long int   *fd,  *size, *ierr;
long int   lopt;
 
{
 
     static char  *op;
     static int   lop;
 
     struct stat  stbuf;
 
     *ierr =  0;                        /* clear the user error code */
     errno =  0;                        /* clear the error code no.  */
 
     /* create C-pointers and lengths for FORTRAN character strings */
 
     op   =  opt;
     lop  =  lopt;
 
     /* first, extract the file's stats for return */
 
     if (fstat((int)*fd, &stbuf) == -1)  /* error in status request ? */
       {
       *size = 0;                      /* clear file statistics  */
       printf ("\n BLKCLO:  *fd = %d  has a bad status !\n", *fd);
       blkerr_(errno, ierr);           /* extract error number   */
       }
     else                              /* valid status info      */
       {
       *size = stbuf.st_size/NCPW;     /* set 'size' = file size (word) */
       blkerr_(NULL, ierr);            /* clear error number            */
       }
 
     /* second, close the file pointed to by 'fd' */
 
     if (close((int)*fd) == -1)        /* error on close request ? */
       {
       printf ("\n");
       printf (" BLKCLO: can not close file !\n");
       printf (" BLKCLO:   *fd = %d\n", *fd);
       printf (" BLKCLO:   opt = %s\n",  op);
       printf ("\n");
       blkerr_(errno, ierr);           /* extract error number   */
       return;
       }
 
     /* last, check option and delete file if request is on */
 
     if ((*op == 'd') || (ftyp[*fd] == 's'))    /* delete option on ? */
       {                                        /* or  scratch file ? */
 
       /* unlink/delete the file (name) pointed to by fnpt[*fd] */
 
       if (unlink(fnpt[(int)*fd]) == -1)   /* error on delete request ? */
         {
         printf ("\n");
         printf (" BLKCLO: can not unlink file !\n");
         printf (" BLKCLO:   *fd = %d\n", *fd);
         printf (" BLKCLO:  fnam = %s\n", fnpt[*fd]);
         printf (" BLKCLO:   opt = %s\n", op);
         printf ("\n");
         blkerr_(errno, ierr);             /* extract error number    */
         }
       }
     return;
}
 
/* end */
 
/*  BLKSTA:  extract the current status of a file
 *
 *  this routine is called in fortran (f77) via:
 *
 *       call  blksta (fd, ierr)
 *      -------------------------
 *
 *  input arguements:
 *
 *    fd    =  file descriptor for file
 *
 *  output arguements:
 *
 *    ierr  =  error return number (zero if no error)
 *
 */
 
/********************
 *  entry - BLKSTA  *
 ********************/
 
blksta (fd, ierr)
 
long int   *fd, *ierr;
 
{
 
     struct stat  stbuf;
     ushort       mode, uid,  gid;
     short        nlnk;
     off_t        size;
     int          bksz, blks;
     time_t       atim, mtim, ctim;
     ino_t        ino;
 
     printf ("\n");
     printf (" BLKSTA:    fd = %8x\n", *fd);
 
     if (fstat((int)*fd, &stbuf) == -1)  /* error in status request ?    */
       {
       printf ("\n BLKSTA:  *fd = %d  has a bad status !\n", *fd);
       blkerr_(errno, ierr);           /* extract error number           */
       }
     else                              /* valid status info              */
       {
       ino  = stbuf.st_ino;            /* set 'ino'  = inode number      */
       nlnk = stbuf.st_nlink;          /* set 'nlnk' = no. hard links    */
       mode = stbuf.st_mode;           /* set 'mode' = file protection   */
       uid  = stbuf.st_uid;            /* set 'uid'  = user-id of owner  */
       gid  = stbuf.st_gid;            /* set 'gid'  = group-id of owner */
       size = stbuf.st_size/NCPW;      /* set 'size' = file size (words) */
       bksz = PRUBLK/NCPW;             /* set 'bksz' = file block size   */
       blks = (size-1)/bksz + 1;       /* set 'blks' = no. of blocks     */
       atim = stbuf.st_atime;          /* set 'atim' = last access time  */
       mtim = stbuf.st_mtime;          /* set 'mtim' = last modify time  */
       ctim = stbuf.st_ctime;          /* set 'ctim' = last change time  */
 
       blkerr_(NULL, ierr);            /* clear error number             */
 
       printf (" BLKSTA: ino  (hex) = %8x\n", ino);
       printf (" BLKSTA: nlnk (dec) = %8d\n", nlnk);
       printf (" BLKSTA: mode (oct) = %8o\n", mode);
       printf (" BLKSTA: uid  (dec) = %8d\n", uid);
       printf (" BLKSTA: gid  (dec) = %8d\n", gid);
       printf (" BLKSTA: size (dec) = %8d\n", size);
       printf (" BLKSTA: bksz (dec) = %8d\n", bksz);
       printf (" BLKSTA: blks (dec) = %8d\n", blks);
       printf (" BLKSTA: atim (hex) = %16x\n", atim);
       printf (" BLKSTA: mtim (hex) = %16x\n", mtim);
       printf (" BLKSTA: ctim (hex) = %16x\n", ctim);
       printf ("\n");
 
       }
     return;
}
 
/* end */
 
/*  blkerr:  return a system error number, given 'erno'
 *
 *      blkerr_(erno, ierr)
 *     ---------------------
 *
 *  input arguements:
 *
 *    erno    =  system error number
 *               if erno =         0,  NULL error, ierr = 0
 *                  erno <         0,  undefined,  ierr = -1
 *                  erno >  sys_nerr,  undefined,  ierr = -1
 *
 *  output arguements:
 *
 *    ierr    =  error number (zero if 'erno' == NULL)
 *
 */
 
/********************
 *  entry - BLKERR  *
 ********************/
 
blkerr_(erno, ierr)
 
int        erno;
long int  *ierr;
 
{
 
  extern int   sys_nerr;        /* largest error no. for which system  */
                                /* system tables has a defined message */
  extern char *sys_errlist[];   /* table of system error messages      */
 
    if (erno == NULL)           /* NULL error message returned */
      {
      *ierr =  0;
      return;
      }
 
    if (erno>0 && erno<sys_nerr)
      {
      *ierr =  erno;
      printf (" BLKERR: ierr = %4d  (%s)", errno, sys_errlist[erno]);
      }
    else
      {
      *ierr =  -1;
      printf (" BLKERR: ierr = %4d  (unkown error value ?)", errno);
      }
 
  return;
}
 
/* end */
 
/*  BLKLOC:  extract the current position within a file
 *
 *  this routine is called in fortran (f77) via:
 *
 *       call  blkloc (fd, size, pos, ierr)
 *      ------------------------------------
 *
 *  input arguements:
 *
 *    fd    =  file descriptor for file
 *
 *  output arguements:
 *
 *    size  =  size of file (in words)
 *    pos   =  position within file returned by lseek(2)
 *    ierr  =  error return number (zero if no error)
 *
 */
 
/********************
 *  entry - BLKLOC  *
 ********************/
 
blkloc (fd, size, pos, ierr)
 
long int   *fd, *size, *pos, *ierr;
 
{
 
     struct stat  stbuf;
 
     *ierr =  0;                         /* clear the user error code */
     errno =  0;                         /* clear error code no.      */
 
     *pos  =  lseek ((int)*fd, 0L, L_INCR);  /* extract position of file */
 
     if (fstat((int)*fd, &stbuf) == -1)     /* error in status request ? */
       {
       *size = 0;                      /* clear file statistics  */
       printf ("\n BLKLOC:  *fd = %d  has a bad status !\n", *fd);
       blkerr_(errno, ierr);           /* extract error number   */
       }
     else                              /* valid status info      */
       {
       *size = stbuf.st_size/NCPW;     /* set 'size' = file size (word) */
       blkerr_(NULL, ierr);            /* clear error number            */
       }
     return;
}
 
/* end */
 
/*  BLKRTN:  delete a file from randon i/o, given it's descriptor
 *
 *  this routine is called in fortran (f77) via:
 *
 *       call  blkrtn (fd, ierr)
 *      -------------------------------
 *
 *  input arguements:
 *
 *    fd    =  file descriptor for file
 *
 *  output arguements:
 *
 *    ierr  =  error return number (zero if no error)
 *
 */
 
/********************
 *  entry - BLKRTN  *
 ********************/
 
blkrtn (fd, ierr)
 
long int   *fd,  *ierr;
 
{
 
     *ierr =  0;                        /* clear the user error code */
     errno =  0;                        /* clear the error code no.  */
 
 
     /* unlink/delete the file pointed to by fnpt[*fd] */
 
     if (unlink(fnpt[(int)*fd]) == -1)  /* error on delete request ? */
       {
       printf ("\n");
       printf (" BLKRTN: can not unlink file !\n");
       printf (" BLKRTN:   *fd = %d\n", *fd);
       printf (" BLKRTN:  fnpt = %s\n", fnpt[*fd]);
       printf ("\n");
       blkerr_(errno, ierr);            /* extract error number    */
       }
 
     return;
}
