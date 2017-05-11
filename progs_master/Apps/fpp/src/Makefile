# @(#)Makefile.common 1.10 96/07/24
#
# ====================================================
# Copyright (C) 1995 by Sun Microsystems, Inc. All rights reserved.
#
# Developed at SunSoft, a Sun Microsystems, Inc. business.
# Permission to use, copy, modify, and distribute this
# software is freely granted, provided that this notice
# is preserved.
# ====================================================
# Modified July 2000 by Frank C. Weiler / Antone Micro Systems
#
# Cleaned up source code by removing 8-character tabs,
# and replacing with 2-character spaces.  This allows
# for easy printing, and keeping indents still on the
# page, without causing line wrap arounds, etc.  Also
# simplified 'Makefile' for dependicies & other stuff.
# ====================================================
 
#ifdef unix
CC         = cc
COPTS      = -w
#else
CC         = gcc
COPTS      = -ansi -O -w
#endif 

EXTRA_DEF  = "-DRELEASE=\"v1.1\""

OBJ        = fpp.o proc.o lex.o error.o rgram.o symtab.o service.o 
OBJ1       = y.tab.o

ALL_OPTS   = $(COPTS) $(EXTRA_DEF) $(EXTRA_INC)
 
# ====================================================

all:    fpp

fpp:	$(OBJ) $(OBJ1) $(EXTRA_LIB)
	$(CC) $(COPTS) -o $@ $(OBJ) $(OBJ1) $(EXTRA_LIB)

clean:
	$(RM) fpp *.o y.tab.c

# ====================================================

fpp.o:		fpp.c      fpp.h   service.h
service.o:	service.c  fpp.h   service.h
proc.o:		proc.c     fpp.h   service.h   lex.h   symtab.h   rgram.h   sb.h
lex.o:		lex.c      fpp.h   service.h   lex.h   symtab.h   rgram.h   sb.h
symtab.o:	symtab.c   fpp.h   service.h           symtab.h
error.o:	error.c    fpp.h
y.tab.o:	y.tab.c    fpp.h   service.h           symtab.h   rgram.h   sb.h
rgram.o:	rgram.c    fpp.h                                  rgram.h

# =========================================================
# C-compile rules ( using flags defined above)
# =========================================================

.c.o:
	${CC} ${ALL_OPTS} -c $<
   
y.tab.o: y.tab.c
	$(CC) $(ALL_OPTS) -c y.tab.c

y.tab.c: eval.y
	$(YACC) eval.y


