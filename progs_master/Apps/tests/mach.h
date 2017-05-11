
/*  First, identifier flags will be set to guide the compilation.
 *
 *  Indentifier  Applicable machines (not necessarily all listed)
 *  -----------  ------------------------------------------------
 *  _alpha_      DEC_ALPHA workstations running OSF/1
 *  _cray_       CRAY-XMP/EA, CRAY-YMP, CRAY-2 (all 32 bit addressing)
 *  _cray_xmp_   CRAY-1, CRAY-1S, CRAY-XMP     (all 24 bit addressing)
 *  _crayts_     CRAY-T90 architecture
 *  _hpo_        HP - HPUX with 32-bit architecture and 4-byte int,...
 *  _hp4_        HP - HPUX with 64-bit architecture and 4-byte int,...
 *  _hp8_        HP - HPUX with 64-bit architecture and 8-byte int,...
 *  _rs6k_       IBM Risc 6000 workstations running AIX
 *  _sgin_       SGI with MIPS 32-bit architecture, 4-byte integers
 *  _sgi4_       SGI with MIPS 64-bit architecture, 4-byte integers
 *  _sgi8_       SGI with MIPS 64-bit architecture, 8-byte integers
 *  _star_       STARDENT (Titan II, III with P2000 or P3000 MIPS booards)
 *  _x86_        Intel *86/Pentium 32-bit machines running Windows NT/95/98/2K/XP
 *  _linux_      Intel *86/Pentium 32-bit machines runing  Linux i386-PC
 *  _linux64_    Intel *86/Pentium 64-bit machines runing  Linux i386-PC
 *  _x8664_      Intel *86/Pentium 64-bit machines runing  Linux i386-PC
 *  (none)       SUN-3, SUN-4, SPARC, DEC3100, DEC5400, etc.
 *
 *
 *  Indentifier  equivalent FORTRAN-77 data representations
 *  -----------  ------------------------------------------
 *  _i4_         use 32 bit (4 byte) integer        (= int)      <default>
 *  _i8_         use 64 bit (8 byte) integer        (= long int)
 *
 *  _r4_         use 32 bit (4 byte) floating point (= float)    <default>
 *  _r8_         use 64 bit (8 byte) floating point (= double)
 *
 */


/*  use the machine's DEFAULT id to set machine flag
   ================================================== */

#if defined (_AIX)

#define _rs6k_   1

#else
#if defined (__alpha)

#define _alpha_  1

#else
#if defined (_CRAY)

#define _cray_   1

#else
#if defined (__hpux)

#define _hp_  1

#else
#if defined (__linux)

/* #define _linux_  1 */

#else
#if defined(_X86_) || defined(_WIN32)

#define _x86_  1

#else
#if defined (sgi)

#define _sgi_    1

#else
#if defined (__sun)

#define _sun_    1
#define _sol_    1

#else

#define _sun_    1

#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif

/*  use the "machine flag" to setup control flags
   =============================================== */

/*  cray  */
/* ------ */

#if defined (_cray_) || defined (_crayts_) || defined (_cray_xmp_)

#if !defined (_CRAY_)
#define _CRAY_  1
#endif

#if !defined (_sys5_)
#define _sys5_  1
#endif

#define _cray_f2c_

#if !defined (_cray_star_)
#define _cray_star_  1
#endif

#endif

/*  Stardent  */
/* ---------- */

#if defined (_star_)

#if !defined (_sys5_)
#define _sys5_  1
#endif

#if !defined (_cray_star_)
#define _cray_star_  1
#endif

#endif

/*  Hewlet-Packard  */
/* ---------------- */

#if  defined (_hpo_) || defined (_hp4_) || defined (_hp8_)

#if !defined(_INCLUDE_POSIX_SOURCE)
/* #define _INCLUDE_POSIX_SOURCE  1 */
#endif

#if !defined (_hp_ibm_)
#define _hp_ibm_  1
#endif

#if !defined (_hp_)
#define _hp_  1
#endif

#endif


/*  Silicon Graphics Inc.  */
/* ----------------------- */

#if  defined (_sgin_) || defined (_sgi4_) || defined (_sgi8_)

#if !defined (_sgi_)
#define _sgi_  1
#endif

#endif

/*  Linux i386/i486/i586 PC  */
/* ------------------------- */

#if  defined (_linux_)

#if !defined (__STDC__)
#define __STDC__  1
#endif

#if !defined (_sys5_)
#define _sys5_  1
#endif

#endif

/*  IBM (Risc_6000)  */
/* ----------------- */

#if  defined (_rs6k_)

#if !defined (_hp_ibm_)
#define _hp_ibm_  1
#endif

#endif

/*  WinTel  */
/* -------- */

#if  defined (_x86_)

#if !defined (__STDC__)
/* #define __STDC__  1 */
#endif

#if !defined (_sys5_)
#define _sys5_  1
#endif

#endif


/*
 *    define misc. data representations
 *   -----------------------------------
 */

/*
typedef  unsigned short ushort;
*/

#if  !defined(_alpha_) && !defined(_alpha8_) && !defined(_cray_) && !defined(_rs6k_)
typedef  unsigned char  uchar;
#endif


/*
 *    establish integer representations
 *   -----------------------------------
 */

#if  defined(_alpha_)

#if  defined(_i8_)
typedef  long           Int;
typedef  unsigned long  UInt;
#else
typedef  int            Int;
typedef  unsigned int   UInt;
#endif

typedef  long           Long;
typedef  unsigned long  ULong;

#else
#if  defined (_convex_) || defined (_cnvx_)

typedef  long long           Int;
typedef  unsigned long long  UInt;
typedef  long long           Long;
typedef  unsigned long long  ULong;

#else
#if  defined(_hp4_)

typedef  int            Int;
typedef  unsigned int   UInt;
typedef  long           Long;
typedef  unsigned long  ULong;

#else
#if  defined(_hp_) || defined (_hp8_)

typedef  long                Int;
typedef  unsigned long       UInt;
typedef  long                Long;
typedef  unsigned long       ULong;

#else
#if  defined(_hp8L_)

#ifdef __LP64__

typedef  long                Int;
typedef  unsigned long       UInt;
typedef  long                Long;
typedef  unsigned long       ULong;

#else

typedef  long long           Int;
typedef  unsigned long long  UInt;
typedef  long long           Long;
typedef  unsigned long long  ULong;

#endif

#else
#if  defined(_ia64_)

typedef  long           Int;
typedef  unsigned long  UInt;
typedef  long           Long;
typedef  unsigned long  ULong;

#else
#if  defined(_sgi4_)

typedef  int            Int;
typedef  unsigned int   UInt;
typedef  long           Long;
typedef  unsigned long  ULong;

#else
#if  defined(_sgi8_)

typedef  long           Int;
typedef  unsigned long  UInt;
typedef  long           Long;
typedef  unsigned long  ULong;

#else
#if  defined(_i8_)

typedef  long           Int;
typedef  unsigned long  UInt;
typedef  long           Long;
typedef  unsigned long  ULong;

#else

typedef  int            Int;
typedef  unsigned int   UInt;
typedef  long           Long;
typedef  unsigned long  ULong;

#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif

/*
 *   establish FLOAT representations
 *  =================================
 */

#if defined (_cray_) || defined (_crayts_) || defined (_cray_xmp_)

typedef  float          Float;

#else
#if defined (_cnvx_)

typedef  double         Float;

#else
#if defined (_double_) || defined(_hp8_) || defined(_ia64_) || defined(_sgi8_) || defined(_r8_)

typedef  double         Float;

#else

typedef  double         Float;

#endif
#endif
#endif


/*
 *   establish REAL representations
 *  ================================
 */

#if defined (_alpha_) || defined(_hp8_) || defined(_ia64_) || defined (_sgi_) || defined(_sgi4_) || defined(_sgi8_)

#if defined(_r8_) || defined(_hp8_) || defined(_ia64_)
typedef  double         Real;

#else

typedef  float          Real;

#endif

#else
#if defined (_cnvx_)

typedef  double         Real;

#else

typedef  float          Real;

#endif
#endif


/*
 *    establish character representations
 *   -------------------------------------
 */

#if defined (_cray_f2c_)

#define  Char           _fcd

#else
#if defined (_star_)

#define  Char           F77PTR *

#else

typedef  char*          Char;

#endif
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
 *    define logical representations
 *   -------------------------------
 */

#if !defined (FALSE)
#define   FALSE        0
#endif

#if !defined (TRUE)
#define   TRUE         1
#endif
