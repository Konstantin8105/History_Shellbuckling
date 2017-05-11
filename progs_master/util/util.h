/*
util.h

util.h contains some useful C utility macros.
*/

#define MAXINT 32767

#ifndef EPSILON
#define EPSILON 1.0e-07
#endif

#ifndef PI
#define PI	3.14159265
#endif

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

#define	MIN(x,y)        (((x) < (y)) ? (x) : (y))
#define MAX(x,y)        (((x) > (y)) ? (x) : (y))

#define MAX3(x,y,z)	MAX(MAX((x),(y)), (z))
#define MIN3(x,y,z)	MIN(MIN((x),(y)), (z))

#define SQR(x)	((x) * (x))
#define CUBE(x)	(SQR(x) * (x))
#define FOURTH(x)	(SQR(x) * SQR(x))
#define FIFTH(x)	(SQR(x) * CUBE(x))
#define SIXTH(x)	(CUBE(x) * CUBE(x))

#define EVEN(n) ((!((n) % 2)) ? (TRUE) : (FALSE))
#define ODD(n) (((n) % 2) ? (TRUE) : (FALSE))

#define ASSIGN(x, y) memcpy((char *) &x, (char *) &y, sizeof(x))

/*
  Declare functions.
*/
extern void error(char *, int);
extern char *fixstring(char *);
extern char *lowerString(char *);
extern int   getfactors(int *, int);
extern int   compare_integer(const int *, const int *);
extern char *strnlcpy(char *, char *, int);
extern double truncate(double);
extern double round(double);

#if 0
extern int strcspn(char *, char *);
extern char *strtok(char *, char *);
#endif

/*
end of util.h
*/
