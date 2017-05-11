/*
File: util.c
Author: W. D. Bushnell
Date: 8/20/90


util.c: contains various non-standard utilities that I have found
useful.
*/

#include <stdio.h>

#if (_sgi_ || _sol_)
#include <string.h>
#else
#if (!(_cnvx_))
#include <strings.h>
#endif
#endif

#include <math.h>
#include <ctype.h>

#include "util.h"



/*
error: error prints an error or warning message to the screen.
*/
void error(char *s, int fatal)
{
  if (fatal) {
    fprintf(stderr, "Error: %s\n", s);
    exit(fatal);
  }
  else
    fprintf(stderr, "Warning: %s\n", s);
    
}

#if 0
/*

*******OLD VERSION*******

fixstring: takes a string and returns a string with neither prepended
spaces nor trailing whitespace (TABs, spaces, or newlines).
*/
char *fixstring(char *s)
{
int i;

/* Lop off prepended whitespace. */
  if (strlen(s) > 0) {
    for(i=0; s[i] == ' ' || s[i] == '\t' || s[i] == '\n'; i++)
      ;
    strcpy(s, &s[i]);
  }

/* Chop off trailing whitespace. */
  if (strlen(s) > 0) {
    for(i=strlen(s)-1; s[i] == ' ' || s[i] == '\t' || s[i] == '\n'; i--)
      ;
    s[i+1] = '\0';
  }

  return(s);

}

#endif


/*
fixstring: takes a string and returns a string with neither prepended
spaces nor trailing whitespace.  Whitespace characters include
non-printing characters, TABs, and spaces.
*/
char *fixstring(char *s)
{
register i;

/* Lop off prepended whitespace. */
  if (strlen(s) > 0) {
    for(i=0; s[i] && (s[i] <= 32 || s[i] >= 127) ; i++)
      ;
    strcpy(s, &s[i]);
  }

/* Chop off trailing whitespace. */
  if (strlen(s) > 0) {
    for(i=strlen(s)-1; i && (s[i] <= 32 || s[i] >= 127); i--)
      ;
    s[i+1] = '\0';
  }

  return(s);

}

/*
lowerString: converts all uppercase characters in a string to
lowercase.  All other characters in the string are unchanged.
Function returns the converted string.
*/
char *lowerString(char *s)
{
char *c;

c = s;
#if (_cnvx_)
while (*c = tolower(*c))
  c++;
#else
while (*c++ = tolower(*c))
  ;
#endif
return(s);
}


/*
getfactors: takes a int, n, and finds all the factors of that
number including 1 and n.  The factors are returned in array f, and the
return value is the number of factors found.  For negative integers, the
factor -1 is returned instead of +1.  It is assumed that the calling
procedure has allocated enough space for f.
*/
int getfactors(int *f, int n)
{
register int i, j=0, limit;

  limit = (int) round(sqrt((double) n) + 1.0);

  if (n < 0) {
    f[j++] = -1;
    n *= -1;
  }
  else
    f[j++] = 1;

  f[j++] = n;

  for (i=2; i < limit; i++)
    if (!(n % i)) {
      f[j++] = i;
      f[j++] = n/i;
    }

  qsort(f, j, sizeof(int), compare_integer);

  return(j);
}


/*
compare_integer: returns -1 if *n < *m, 0 if *n == *m, and 1 if *n > *m.
*/
int compare_integer(int *n, int *m)
{
  return((*n == *m) ? 0 : (*n < *m) ? -1 : 1);
}



/*
strnlcpy: like strncpy except that a NULL character is always added
at the end of s1.  The caller should allow space for this extra char.
*/
char *strnlcpy(char *s1, char *s2, int n)
{

  strncpy(s1, s2, n);
  s1[n] = '\0';

  return(s1);
}



/*
truncate: takes a double value, trucates toward zero, and returns a double.
*/
double truncate(double x)
{

  if (x < 0.0) {
    x = -1.0 * x;
    x = floor(x);
    x = -1.0 * x;
    return(x);
  }
  else /* x is positive */
    return(floor(x));

} /* end truncate */




/*
round: takes a double, rounds the value, and returns a double.

Example:  0.5 would be rounded to 1.0
         -0.5 would be rounded to -1.0
         -0.499 would be rounded to 0.0
          0.499 would be rounded to 0.0

*/
double round(double x)
{

  if (x < 0.0) {
    x = -1.0 * x;
    return(-1.0 * floor(x + 0.5));
  }
  else
    return(floor(x + 0.5));
} /* end round */

#if 0

/*
strcspn() finds the first character in string s which is a member
of string set.  strcspn() returns an int which is the place of
the first letter in s to be in the set.  The first character in
the string s is in place 0, the second is in place 1, etc.

If no character in s is a member of the set, then strcspn()
returns the place of the null character which terminates string s.
This is also the length of the string as returned by strlen().
*/

int strcspn(char *s, char *set)
{
	int i, j, slen, setlen;

	slen = strlen(s);
	setlen = strlen(set);
	for(i=0; i<slen; i++)
		for(j=0; j<setlen; j++) {
			if(s[i] == set[j]) return(i);
		}
	return(i);
}
	
/*
     strtok() considers the string s1 to consist of a sequence of
     zero  or  more text tokens separated by spans of one or more
     characters from the separator string  s2.   The  first  call
     (with  pointer  s1 specified) returns a pointer to the first
     character of the first token, and will have written  a  null
     character  into s1 immediately following the returned token.
     The function keeps track  of  its  position  in  the  string
     between separate calls, so that subsequent calls (which must
     be made with the first argument a NULL  pointer)  will  work
     through  the string s1 immediately following that token.  In
     this way subsequent calls will work through  the  string  s1
     until no tokens remain.  The separator string s2 may be dif-
     ferent from call to call.  When no token remains  in  s1,  a
     NULL pointer is returned.

*/

static char *save = '\0';
char *strtok(char *s1, char *s2)
{
  register int i;
  char *ret_value;

  if (s1 != '\0')
     save = s1;
  for(; (i = strcspn(save, s2)) == 0 && (*save != '\0'); save++);
  ret_value = save;
  if (save[i] == '\0') {
    if (i == 0)
      ret_value = NULL;
    else
      save += i;
  }
  else {
    save[i] = '\0';
    save += i + 1;
  }
  return(ret_value);
}

#endif
