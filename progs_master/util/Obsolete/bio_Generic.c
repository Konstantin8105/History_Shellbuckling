/*
  $Id: bio.c,v 1.6 1995/09/08 20:08:45 rankin Exp $
  $Locker:  $
  $Log: bio.c,v $
 * Revision 1.6  1995/09/08  20:08:45  rankin
 * Change name of block label to prevent conflict with NICE bio.c
 *
 * Revision 1.5  1994/06/28  17:59:27  stags
 * Removed comment after #endif.
 *
 * Revision 1.4  1993/11/30  22:52:29  bushnell
 * Cleaned up comments and converted TABs to spaces where the TABs made the
 * text appear messy in the _mac_ else block.
 *
 * Revision 1.3  1993/11/24  03:54:37  bushnell
 * added Macintosh version of bio.c
 *
 * Revision 1.2  1993/11/23  03:23:04  stags
 * added RCS keyword substitution flags to file
 *
 */
/*
   bio.c for QSTAGS
*/


#define _SYS5_  (_sgi_ || _rs6k_ || _star_ || _hp700_ || _cray_ || _alpha_ || _sol_)
#define _BSD_   (_sun4_ || _cnvx_ || _dec_)
#define _UNIX_  (_SYS5_ || _BSD_)
#define _VUNIX_ (_vax_ || _UNIX_)

#if (_cray_)
#define _float_ Real
#define _double_ 0
#else
#define _float_ Double Precision
#define _double_ 1
#endif

#define _false_ 0
#define _true_ 1

#define _implicit_none_ Implicit None

#if (!_mac_)

#define PRUBLK PRUBLC
#if _alpha_
#ifndef INT64
#define INT64 1
#endif
#endif
#include   <stdio.h>
#include   <sys/types.h>
#include   <sys/file.h>
#include   <sys/stat.h>
#include   <time.h>
#include   <errno.h>
#if _SYS5_
#include   <fcntl.h>
#define    R_OK     04      
#define    W_OK     02      
#define    X_OK     01      
#define    F_OK     00      
#define    L_SET     0      
#define    L_INCR    1      
#define    L_XTND    2      
#endif
#if _star_
typedef struct {char *addr;    
                int   leng;    
               } F77PTR;
#endif
#if _SYS5_
#if _cray_
int     PRUBLK = 4096;         
int     NCPW   =    8;         
#else
int     PRUBLK = 1024;         
int     NCPW   =    4;         
#endif
#else
int     PRUBLK =  512;         
int     NCPW   =    4;         
#endif
#define MAXFD    64            
char   *fnpt[MAXFD];           
char    ftyp[MAXFD];           

extern char  *malloc();
extern char  *strcpy();
#if (_cray_ || _star_)
BLKOPN(path, opt, fd, size, ierr)
#if _cray_
char       *path, *opt;
#endif
#if _star_
F77PTR     *path, *opt;
#endif
long int   *fd,   *size, *ierr;
#else
#if (_rs6k_ || _hp700_)
blkopn (path, opt, fd, size, ierr, lpath, lopt)
#else
blkopn_(path, opt, fd, size, ierr, lpath, lopt)
#endif
char       *path, *opt;
#ifdef INT64
int        *fd,   *size, *ierr, lpath, lopt;
#else
long int   *fd,   *size, *ierr, lpath, lopt;
#endif
#endif
{
     char         oc,  fnam[256];
     static char  *op, *pp;
     static int   lop, lpp;
     unsigned     lfnam;
     int          i, flags, mode, acc;
     struct stat  stbuf;
     *ierr  =  0;                        
     errno  =  0;                        
#if (_cray_ || _star_)
     FTN2CP_(path, &pp, &lpp);
     FTN2CP_(opt,  &op, &lop);
#else
     pp   =  path;
     lpp  =  lpath;
     op   =  opt;
     lop  =  lopt;
#endif
     i   =  0;
     while ((*pp != '\0') && (*pp != ' ') && (i < lpp))
       {
         fnam[i++] = *(pp++);
       }
     fnam[i] =  '\0';
     lfnam   =  i + 1;
     oc    =  'c';                     
     acc   =  access(fnam, F_OK);      
     if (acc == -1)                    
       {                               
       if (*(op+1)=='o')               
         {
           printf ("\n");
           printf (" BLKOPN: file does not exist !\n");
           printf (" BLKOPN:   fnam = %s\n", fnam);
           printf (" BLKOPN: opt[2] = %s\n", *(op+1));
           printf ("\n");
           blkerr_(errno, ierr);       
           return;                     
         }
       }
     else                              
       {                               
       if (*(op+1)=='n')               
         {
           printf ("\n");
           printf (" BLKOPN: file already exists, user opt = 'new' !\n");
           printf (" BLKOPN:   fnam = %s\n", fnam);
           printf (" BLKOPN: opt[2] = %s\n", *(op+1));
           printf ("\n");
           errno = EEXIST;             
           blkerr_(errno, ierr);       
           return;                     
         }
       else                            
         oc = 'o';                     
       }
     mode  =  0644;                    
     flags =  0;                       
     if (*(op)   == 'r')   flags = flags | O_RDONLY;
     if (*(op)   == 'w')   flags = flags | O_WRONLY | O_APPEND;
     if (*(op)   == ' ')   flags = flags | O_RDWR;
     if (*(op+1) == 'o')   flags = flags | O_EXCL;
     if (*(op+1) == 'n')   flags = flags | O_CREAT  | O_EXCL;
     if (*(op+1) == 's')   flags = flags | O_CREAT;
     if (*(op+1) == ' ')   flags = flags | O_CREAT;
     *fd  =  open(fnam, flags, mode);  
     if (*fd == -1)                    
       {
         printf ("\n");
         printf (" BLKOPN: cannot open file !\n");
         printf (" BLKOPN:  fnam = %s\n", fnam);
         printf (" BLKOPN: flags = %o\n", flags);
         printf (" BLKOPN:  mode = %o\n", mode);
         printf ("\n");
         blkerr_(errno, ierr);         
       }
     else                              
       {
         if (fstat((int)*fd, &stbuf) == -1)  
           {
             printf ("\n BLKOPN:  *fd = %d  has a bad status !\n", *fd);
             blkerr_(errno, ierr);      
           }
         else                           
           {
            *size  =  stbuf.st_size;    
             blkerr_(NULL, ierr);       
           }
       }
     
     if ((*fd < 0) | (*fd >= MAXFD))   
       {
         printf ("\n");
         printf (" BLKOPN: (*fd) out of range !\n");
         printf (" BLKOPN:  fnam = %s\n", fnam);
         printf (" BLKOPN:   *fd = %d\n", *fd);
         printf (" BLKOPN: MAXFD = %d\n", MAXFD);
         printf ("\n");
         errno  =  -1;                 
         blkerr_(errno, ierr);
       }
     fnpt[(int)*fd]  =  malloc(lfnam); 
     strcpy (fnpt[(int)*fd], fnam);    
     ftyp[(int)*fd]  =  *(op+1);       
     return;
}
#if (_cray_ || _star_)
BLKPOS(fd, blk, pos, ierr)
#else
#if (_rs6k_ || _hp700_)
blkpos (fd, blk, pos, ierr)
#else
blkpos_(fd, blk, pos, ierr)
#endif
#endif
#ifdef INT64
int        *fd, *blk, *pos, *ierr;
#else
long int   *fd, *blk, *pos, *ierr;
#endif
{
     long int     offset;
     *ierr  =  0;                      
     errno  =  0;                      
     offset =  PRUBLK * (*blk - 1);    
    *pos    = lseek((int)*fd, 0L, L_INCR);  
     if (*pos != offset)               
       {
       *pos  =  lseek((int)*fd, offset, L_SET);
       if (*pos == -1)                 
         {
           printf ("\n");
           printf (" BLKPOS: can not position file by lseek(---)\n");
           printf (" BLKPOS:     fd = %d\n", *fd);
           printf (" BLKPOS:    blk = %d\n", *blk);
           printf (" BLKPOS: offset = %d\n", offset);
           printf ("\n");
           blkerr_(errno, ierr);       
         }
       }
     else                              
       {
         blkerr_(NULL, ierr);          
       }
     return;
}
#if (_cray_ || _star_)
BLKRDR(fd, buf, nwds, blk, ierr)
#else
#if (_rs6k_ || _hp700_)
blkrdr (fd, buf, nwds, blk, ierr)
#else
blkrdr_(fd, buf, nwds, blk, ierr)
#endif
#endif
char       *buf;
#ifdef INT64
int        *fd,  *nwds, *blk, *ierr;
#else
long int   *fd,  *nwds, *blk, *ierr;
#endif
{
     int         nbuf, ibuf;
     long int    pos,  offset;
     *ierr  =  0;                      
     errno  =  0;                      
     nbuf   =  *nwds * NCPW;           
     offset =  PRUBLK * (*blk - 1);    
     if (offset >= 0)                  
       {
         pos   =  lseek((int)*fd, offset, L_SET);
         if (pos == -1)                
           {
             printf ("\n");
             printf (" BLKRDR: can not position file by lseek(---)\n");
             printf (" BLKRDR:     fd = %d\n", *fd);
             printf (" BLKRDR:    blk = %d\n", *blk);
             printf (" BLKRDR: offset = %d\n", offset);
             printf ("\n");
             blkerr_(errno, ierr);     
             return;
           }
       }
     ibuf  =  read((int)*fd, buf, nbuf);   
     if ((ibuf == -1) || (ibuf != nbuf))    
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
         blkerr_(errno, ierr);         
       }
     else
       {
         blkerr_(NULL, ierr);          
       }
     return;
}
#if (_cray_ || _star_)
BLKWTR(fd, buf, nwds, blk, ierr)
#else
#if (_rs6k_ || _hp700_)
blkwtr (fd, buf, nwds, blk, ierr)
#else
blkwtr_(fd, buf, nwds, blk, ierr)
#endif
#endif
char       *buf;
#ifdef INT64
int        *fd,  *nwds, *blk, *ierr;
#else
long int   *fd,  *nwds, *blk, *ierr;
#endif
{
     int         nbuf, ibuf;
     long int    pos,  offset;
     *ierr  =  0;                      
     errno  =  0;                      
     nbuf   =  *nwds * NCPW;           
     offset =  PRUBLK * (*blk - 1);    
     if (offset >= 0)                  
       {
         pos = lseek((int)*fd, offset, L_SET);
         if (pos == -1)                
           {
             printf ("\n");
             printf (" BLKWTR: can not position file by lseek(---)\n");
             printf (" BLKWTR:     fd = %d\n", *fd);
             printf (" BLKWTR:    blk = %d\n", *blk);
             printf (" BLKWTR: offset = %d\n", offset);
             printf ("\n");
             blkerr_(errno, ierr);     
             return;
           }
       }
     ibuf  =  write((int)*fd, buf, nbuf); 
     if ((ibuf == -1) || (ibuf != nbuf))    
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
         blkerr_(errno, ierr);         
       }
     else
       {
         blkerr_(NULL, ierr);          
       }
     return;
}
#if (_cray_ || _star_)
BLKCLO(fd, opt, size, ierr)
#if _cray_
char       *opt;
#endif
#if _star_
F77PTR     *opt;
#endif
long int   *fd,  *size, *ierr;
#else
#if (_rs6k_ || _hp700_)
blkclo (fd, opt, size, ierr, lopt)
#else
blkclo_(fd, opt, size, ierr, lopt)
#endif
char       *opt;
#ifdef INT64
int        *fd,  *size, *ierr;
int        lopt;
#else
long int   *fd,  *size, *ierr;
long int   lopt;
#endif
#endif
{
     static char  *op;
     static int   lop;
     struct stat  stbuf;
     *ierr =  0;                        
     errno =  0;                        
#if (_cray_ || _star_)
     FTN2CP_(opt,  &op, &lop);
#else
     op   =  opt;
     lop  =  lopt;
#endif
     if (fstat((int)*fd, &stbuf) == -1)  
       {
        *size  =  0;                   
         printf ("\n BLKCLO:  *fd = %d  has a bad status !\n", *fd);
         blkerr_(errno, ierr);         
       }
     else                              
       {
        *size  =  stbuf.st_size;       
         blkerr_(NULL, ierr);          
       }
     if (close((int)*fd) == -1)        
       {
         printf ("\n");
         printf (" BLKCLO: can not close file !\n");
         printf (" BLKCLO:   *fd = %d\n", *fd);
         printf (" BLKCLO:   opt = %s\n",  op);
         printf ("\n");
         blkerr_(errno, ierr);         
         return;
       }
     if ((*op == 'd') || (ftyp[*fd] == 's'))    
       {                                        
         if (unlink(fnpt[(int)*fd]) == -1)   
           {
             printf ("\n");
             printf (" BLKCLO: can not unlink file !\n");
             printf (" BLKCLO:   *fd = %d\n", *fd);
             printf (" BLKCLO:  fnam = %s\n", fnpt[*fd]);
             printf (" BLKCLO:   opt = %s\n", op);
             printf ("\n");
             blkerr_(errno, ierr);           
           }
       }
     return;
}
#if (_cray_ || _star_)
BLKSTA(fd, ierr)
#else
#if (_rs6k_ || _hp700_)
blksta (fd, ierr)
#else
blksta_(fd, ierr)
#endif
#endif
#ifdef INT64
int        *fd, *ierr;
#else
long int   *fd, *ierr;
#endif
{
     struct stat  stbuf;
     ushort       mode, uid,  gid;
     short        nlnk;
     off_t        size;
     int          bksz, blks;
     time_t       atim, mtim, ctim;
     ino_t        ino;
     struct tm    dt;
     if (fstat((int)*fd, &stbuf) == -1)  
       {
         printf ("\n BLKSTA:  *fd = %d  has a bad status !\n", *fd);
         blkerr_(errno, ierr);           
       }
     else                              
       {
         ino  = stbuf.st_ino;          
         nlnk = stbuf.st_nlink;        
         mode = stbuf.st_mode;         
         uid  = stbuf.st_uid;          
         gid  = stbuf.st_gid;          
         size = stbuf.st_size;         
         bksz = PRUBLK;                
         blks = (size-1)/bksz + 1;     
         atim = stbuf.st_atime;        
         mtim = stbuf.st_mtime;        
         ctim = stbuf.st_ctime;        
         blkerr_(NULL, ierr);          
         printf (" BLKSTA: ino   (hex) = %8x\n", ino);
         printf (" BLKSTA: nlnk  (dec) = %8d\n", nlnk);
         printf (" BLKSTA: mode  (oct) = %8o\n", mode);
         printf (" BLKSTA: uid   (dec) = %8d\n", uid);
         printf (" BLKSTA: gid   (dec) = %8d\n", gid);
         printf (" BLKSTA: size  (dec) = %8d  (in bytes)\n", size);
         printf (" BLKSTA: bksz  (dec) = %8d  (no. bytes/block)\n", bksz);
         printf (" BLKSTA: blks  (dec) = %8d\n", blks);
         dt   = *localtime(&atim);
         printf (" BLKSTA: last access = %2d/%2.2d/%2.2d - %2d:%2.2d:%2.2d\n",
                 (dt.tm_mon+1), dt.tm_mday, dt.tm_year,
                  dt.tm_hour,   dt.tm_min,  dt.tm_sec);
         dt   = *localtime(&mtim);
         printf (" BLKSTA: last modify = %2d/%2.2d/%2.2d - %2d:%2.2d:%2.2d\n",
                 (dt.tm_mon+1), dt.tm_mday, dt.tm_year,
                  dt.tm_hour,   dt.tm_min,  dt.tm_sec);
         dt   = *localtime(&ctim);
         printf (" BLKSTA: last change = %2d/%2.2d/%2.2d - %2d:%2.2d:%2.2d\n",
                 (dt.tm_mon+1), dt.tm_mday, dt.tm_year,
                  dt.tm_hour,   dt.tm_min,  dt.tm_sec);
         printf ("\n");
       }
     return;
}
blkerr_(erno, ierr)
int        erno;
#ifdef INT64
int       *ierr;
#else
long int  *ierr;
#endif
{
  extern int   sys_nerr;        
  extern char *sys_errlist[];   
    if (erno == NULL)           
      {
        *ierr =  0;
        return;
      }
    if ((erno > 0) && (erno < sys_nerr))
      {
        *ierr  =  erno;
        printf (" BLKERR: ierr = %4d  (%s)", erno, sys_errlist[erno]);
      }
    else
      {
        if (erno < 0)
          {
            *ierr =  erno;
            printf (" BLKERR: ierr = %4d  (local error)", erno);
          }
        else
          {
            *ierr =  -sys_nerr;
            printf (" BLKERR: ierr = %4d  (unkown error value ?)", erno);
          }
      }
  return;
}
#if (_star_ || _cray_)
BLKLOC(fd, size, pos, ierr)
#else
#if (_rs6k_ || _hp700_)
blkloc (fd, size, pos, ierr)
#else
blkloc_(fd, size, pos, ierr)
#endif
#endif
#ifdef INT64
int        *fd, *size, *pos, *ierr;
#else
long int   *fd, *size, *pos, *ierr;
#endif
{
     struct stat  stbuf;
     *ierr  =  0;                        
     errno  =  0;                        
    *pos   =  lseek ((int)*fd, 0L, L_INCR);  
     if (fstat((int)*fd, &stbuf) == -1)     
       {
        *size  =  0;                   
         printf ("\n BLKLOC:  *fd = %d  has a bad status !\n", *fd);
         blkerr_(errno, ierr);         
       }
     else                              
       {
        *size  =  stbuf.st_size;       
         blkerr_(NULL, ierr);          
       }
     return;
}
#if (_star_ || _cray_)
BLKRTN(fd, ierr)
#else
#if (_rs6k_ || _hp700_)
blkrtn (fd, ierr)
#else
blkrtn_(fd, ierr)
#endif
#endif
#ifdef INT64
int        *fd,  *ierr;
#else
long int   *fd,  *ierr;
#endif
{
     *ierr  =  0;                       
     errno  =  0;                       
     if (unlink(fnpt[(int)*fd]) == -1)  
       {
         printf ("\n");
         printf (" BLKRTN: can not unlink file !\n");
         printf (" BLKRTN:   *fd = %d\n", *fd);
         printf (" BLKRTN:  fnpt = %s\n", fnpt[*fd]);
         printf ("\n");
         blkerr_(errno, ierr);          
       }
     return;
}
#if _cray_
FTN2CP_(f77des, cptr, clng)
char      *f77des;            
char       **cptr;            
long int   **clng;            
{
     long int    fwrd;        
     long int    cwrd;        
     long int    clen;        
     fwrd     =  (long int)f77des;           
#ifdef XMP
     cwrd     =  ((fwrd & (077 << 24)) << 34 ) | (0xffffff & fwrd);
     clen     =  fwrd >> 33;                 
#else
     cwrd     =  (fwrd & (077 << 58)) | (0xffffffff & fwrd);
     clen     =  (fwrd >> 35) & 0x7fffff;    
#endif
     *clng       =  (long int*)clen;         
     *cptr       =  (char *)cwrd;            
     return;
}
#endif
#if _star_
FTN2CP_(f77des, cptr, clng)
F77PTR    *f77des;            
char       **cptr;            
long int   **clng;            
{
     *clng       =  f77des->leng;               
     *cptr       =  (char *)f77des->addr;       
     return;
}
#endif

#else


/*
  Basic I/O routines called from GASP written for the Macintosh.
  This library could conceivably be called from another type of
  block I/O subprogram.  This library includes subroutines:

	BLKOPN - open a file for block I/O
	BLKCLO - close block I/O file
	BLKRDR - read data from block I/O file
	BLKWTR - write data to block I/O file

	Author: W. D. Bushnell, M. A. Wright (4/89), D. Park (?/89)
	Date: March, 1990
*/

#include <Errors.h>
#include <Files.h>

#define FALSE 0
#define blksize 512
#define Sync 0
#define nil 0
#define BytesPerWord 4


/*
	BLKOPN - open a file for block I/O

	Arguments:

	--> path	-	file name or path name to open
	--> opt		-	2-character string option parameter:
					char 1 : 'r' - read only
						 'w' - write/append only
						 'b' - both read and write
					char 2 : 'o' - old
						 'n' - new
	<-- fd		-	integer file descriptor
	<-- size	-	size of file in words

	Return value: status code;	TOOLBOX error or:
					0 = no error
*/

OSErr BLKOPN(path, opt, fd, size)
char path[];
char opt[];
long *fd, *size;
{
	HParamBlockRec	pb;
	WDPBRec			pbWD;
	OSErr			status = 0;
	int			volume;
	long			directory;
	
	*fd = *size = 0;
/*
	Get working volume & directory.
*/
	pbWD.ioCompletion = nil;
	pbWD.ioNamePtr = nil;
	status = PBHGetVol(&pbWD, FALSE);
	if(status == nsvErr) {
		volume = 0;
		directory = 0;
	}
	else {
		volume = pbWD.ioWDVRefNum;
		directory = pbWD.ioWDDirID;
	}
/*	
	Prepare the parameter block.
*/
	pb.ioParam.ioCompletion = nil;
	pb.ioParam.ioNamePtr = path;
	pb.ioParam.ioVRefNum = volume;
	switch (opt[0]) {
		case 'r': pb.ioParam.ioPermssn = fsRdPerm;
				 break;
		case 'w': pb.ioParam.ioPermssn = fsWrPerm;
			 	break;
		case 'b': pb.ioParam.ioPermssn = fsRdWrPerm;
				 break;
		default : break;
	}
	pb.ioParam.ioMisc = 0;
	pb.fileParam.ioDirID = directory;

/*	
	Create new file if requested.  If old file exists, delete it first.
*/
	if (opt[1] == 'n') {
		while ((status = PBHCreate(&pb, Sync)) == dupFNErr) {
			status = PBHDelete(&pb, Sync);
			if (status != noErr)
				return(status);
		}
		if (status != noErr)
			return(status);
	}
/*
	Open file.  If it doesn't exist, create it.
*/
	while ((status = PBHOpen(&pb, Sync)) == fnfErr) {
		status = PBHCreate(&pb, Sync);
		if (status != noErr)
			return(status);
	}
	if (status == noErr) {
		*fd = pb.ioParam.ioRefNum;
		status = PBGetEOF((ParmBlkPtr) &pb, Sync);
		if (status != noErr) {
			return(status);
		}
		*size = pb.ioParam.ioMisc/(float) BytesPerWord;
		return(status);
	} 
	return(status);

} /* End BLKOPN */


/*
	BLKCLO - close a file for block I/O

	Arguments:

	--> path	-	file name or path name to close
	--> opt		-	character string option parameter:
				   ' ', 's': close and save
					'd': close and delete
	--> fd		-	integer file descriptor
	<-- size	-	size of file in bytes

	Return value: status code;	TOOLBOX error or:
                                        0 = no error
*/
OSErr BLKCLO(path, opt, fd, size)
char path[];
char opt;
long fd, *size;
{
	HParamBlockRec	pb;
	WDPBRec			pbWD;
	OSErr			status = 0;
	int			volume;
	long			directory;
/*
	Get working volume & directory.
*/
	pbWD.ioCompletion = nil;
	pbWD.ioNamePtr = nil;
	status = PBHGetVol(&pbWD, FALSE);
	if(status == nsvErr) {
		volume = 0;
		directory = 0;
	}
	else {
		volume = pbWD.ioWDVRefNum;
		directory = pbWD.ioWDDirID;
	}
/*
	Prepare the parameter block.
*/
	pb.ioParam.ioCompletion = nil;
	pb.ioParam.ioRefNum = fd;
	pb.ioParam.ioVRefNum = volume;
	pb.fileParam.ioDirID = directory;
	pb.ioParam.ioNamePtr = path;
/*
	Get the file size.
*/
	status = PBGetEOF((ParmBlkPtr) &pb, Sync);
	if (status != noErr) {
		return(status);
	}
	*size = pb.ioParam.ioMisc/(float) BytesPerWord;
/*
	Close the file.
*/
	status = PBClose((ParmBlkPtr) &pb, Sync);
	if (status != noErr) {
		return(status);
	}
/*
	Delete the file if requested.
*/
	if (opt == 'd')
		status = PBHDelete(&pb, Sync);

	return(status);
	
} /* End BLKCLO */


/*
	BLKRDR - block read from a file

	Arguments:

	--> fd		-	integer file descriptor
	--> nwds	-	number of words to transfer (nwds*4 = bytes)
	--> blk		-	read from block I/O file starting at offset blk
	<-- buf		-	array into which data is read

	Return value: status code;	TOOLBOX error or:
                                        0 = no error
                                       -2 = fd was zero
                                       -3 = negative nwds
                                       -4 = negative blk
*/
OSErr BLKRDR(fd, nwds, blk, buf)
long fd, nwds, blk, *buf;
{
	HParamBlockRec 	pb;
	OSErr		status = 0;
	
	if (fd == 0) return(-2);
	if (nwds < 0) return(-3);
	if (blk < 0) return(-4);
/*
	Set up parameter block
*/
	pb.ioParam.ioRefNum = fd;
	pb.ioParam.ioCompletion = 0;
	pb.ioParam.ioBuffer = (Ptr) buf;
	pb.ioParam.ioReqCount = nwds*BytesPerWord;
	pb.ioParam.ioPosMode = 1;
	pb.ioParam.ioPosOffset = (blk-1)*blksize;
/*
	Perform READ
*/
	status = PBRead((ParmBlkPtr) &pb, Sync);
	return(status);
} /* End BLKRDR */

/*
	BLKWTR - block write to a file

	Arguments:

	--> fd		-	integer file descriptor
	--> nwds	-	number of words to transfer (nwds*BytesPerWord = bytes)
	--> blk		-	read from block I/O file starting at offset blk
	--> buf		-	array from which data is written

	Return value: status code;	TOOLBOX error or:
                                        0 = no error
                                       -2 = fd was zero
                                       -3 = negative nwds
                                       -4 = negative blk
*/ 
OSErr BLKWTR(fd, nwds, blk, buf)
long fd, nwds, blk, *buf;
{
	HParamBlockRec	pb;
	OSErr		status = 0;
	
	if (fd == 0) return(-2);
	if (nwds < 0) return(-3);
	if (blk < 0) return(-4);
/*
	Prepare parameter block
*/
	pb.ioParam.ioRefNum = fd;
	pb.ioParam.ioCompletion = 0;
	pb.ioParam.ioBuffer = (Ptr) buf;
	pb.ioParam.ioReqCount = nwds*BytesPerWord;
	pb.ioParam.ioPosMode = 1;
	pb.ioParam.ioPosOffset = (blk-1)*blksize;
/*
	Perform WRITE
*/
	status = PBWrite((ParmBlkPtr) &pb, Sync);
	return(status);
} /* End BLKWTR */

#endif

