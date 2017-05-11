
/*
Declare machine-dependent integer and float parameter macros.

This is done primarily to maintain compatibility between the
FORTRAN and C compilers on different machines.

For example, on the DEC Alpha, an "integer" in FORTRAN is
the same length as an "int" data type in C, but on a Sun Solaris an
"integer" in FORTRAN is the same length as a "long" in C.

We have not yet found an similar word-length inconsistency with
floating-point values, but we have included a _float_ macro in
case such an inconsistency arises at a later time.
*/

#if (_alpha_)
#define _int_ int
#else
#define _int_ long
#endif

#define _float_ float

