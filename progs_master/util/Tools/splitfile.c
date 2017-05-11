/* splitfile.c opens the {case}.PLT2 file created by the bosorpost processor
and splits each of the data subsections into separate files, which can then be
interpreted by third-party graphing software or by bosorplot, which uses
xgraph.
*/

#include <stdio.h>
#include <string.h>
#define MAXLENGTH 201
#define LINELENGTH 80
#define CASELENGTH 9
#define EXTENSION ".PLT2"

main(argc, argv)
int argc;
char *argv[];

{
int i;
char infile[LINELENGTH], outfile[LINELENGTH], line1[MAXLENGTH];
char casename[CASELENGTH], line2[MAXLENGTH], temp[LINELENGTH];
extern char *strtok(), *fgets();
FILE *ifp, *ofp;
extern FILE *fopen();

  for(i=1;i<argc;i++) {
    strcpy(infile, argv[i]);
    if((ifp = fopen(infile, "r")) == NULL)
      error("MAIN: Input file not found",1);
    
    while (!feof(ifp)) {
      strcpy(line2, "!@#$%^&*");
      while (line2[0] != '*') {
        strcpy(line1, line2);
        if (!feof(ifp)) {
          fgets(line2, MAXLENGTH, ifp);
          line2[strlen(line2)-1] = '\0';
        }
        else
          error("MAIN: Last data set not extracted; input file may be damaged.", 2);
      } /* end while */

      strcpy(temp, infile);
      strcpy(casename, strtok(temp, EXTENSION));
      fixname(line1);
      *outfile = NULL;
      strcpy(outfile, casename);
      strcat(outfile, "..");
      strcat(outfile, line1);

      if ((ofp = fopen(outfile, "w")) == NULL)
        error("MAIN: Unable to open output file.", 3);
      while ((line2[0] != '\n') && !feof(ifp)) {
        fgets(line2, MAXLENGTH, ifp);
        adjustleft(line2);
        fputs(line2, ofp);
      } /* end while */
      fclose(ofp);
      printf("++++++++++ %s ++++++++++  created successfully.\n", outfile);
    
    } /* end while */

  } /* end for( go through argv ) */

} /* end main */

/*
fixname(s) takes a string and removes all spaces following an "=" sign,
and converts runs of 1 to n spaces to "_".
*/
int fixname(s)
char *s;
{
char *p;

 while ((p = index(s, ' ')) != NULL) {
  if (*(p-1) == '=')
    adjustleft(p);
  else if (p[1] == ' ')
    adjustleft(&p[1]);
  else
    p[0] = '_';
 } /* end while */

} /* end fixname */

/*
adjustleft(s) lops prepended spaces off a character string.
*/
int adjustleft(s)
char *s;
{
int i;

  for (i=0;s[i] == ' ';i++)
    ;
  strcpy(s, &s[i]);
} /* end adjustleft */

/*
error() prints error message, s, and an exit status code to the
screen and exits the current program.
*/
int error(s, err)
char *s;
int err;
{
  printf("ERROR HANDLER-- %s, exit status: %d\n", s, err);
  exit(err);
} /* end error */
