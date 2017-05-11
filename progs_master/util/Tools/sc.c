/*
sc.c strips C-style comments from C source code.
*/

#include <stdio.h>

main()
{
  char future, current;
  int iscomment = 0;

  current = getchar();
  future = getchar();

  while (current != EOF) {
    if ((current == '/') && (future == '*'))
      iscomment++;
    if ((current == '*') && (future == '/')) {
      current = future;
      future = getchar();
      current = future;
      future = getchar();
      iscomment--;
    }
    if (!iscomment) {
/*
Convert all non-printing characters to newline.
*/
      if ((current < 32) || (current > 126))
        current = '\n';
      putchar(current);
    }
    current = future;
    future = getchar();
  }
}
