CC     = gcc
CFLAGS = -O2
LIBS   = -lm
PROG   = fsplit
SRC    = fsplit.c
OBJ    = $(SRC:.c=.o)
$(PROG):$(OBJ)
	$(CC) $(CFLAGS) -o $(PROG) $(OBJ) $(LIBS)

%.o:%.c
	$(CC) $(CFLAGS) -c $*.c

clean :
	rm -f *.o

