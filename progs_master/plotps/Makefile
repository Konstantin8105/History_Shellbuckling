#***********************************************************************
# Makefile PLOTPS
#***********************************************************************
# special dependencies
# ====================


.SUFFIXES:
.SUFFIXES: .c .o

#***********************************************************************
# macro definitions
# =================

# Intel X86 PC (Linux)
# ====================

#CPP      =  /usr/local/bin/cpp

DEBUG = -g
#DEBUG = -g

#set CM32 = -m32 for _amd64_ and _ia64_ machines
#CPPFLAGS = -D_linux_
#CM32     = -m32
CM32 =

CFLAGS   = ${CM32}
CFLAGS0  = ${CM32}

#CFLAGS   = ${CM32}
#CFLAGS0  = ${CM32}

PPU      =

LINK     = ${CM32}

LIBS     = -lm


RM       =  /bin/rm
RMFLAGS  =  -f

# define the Library Modules
# --------------------------

OBJSC =              \
	plotps.o     \
	di2ps.o      \
	util.o

# define the Object dependicies
# -----------------------------

#plotps.o: di2ps.h       \
#          names.h       \
#          paramlength.h \
#          util.h

#di2ps.o:  axes.h        \
#          colors.h      \
#          curves.h      \
#          di2ps.h       \
#          dutils.h      \
#          ndutils.h     \
#          legends.h     \
#          names.h       \
#          paramlength.h \
#          util.h        \
#          axes.cseg     \
#          colors.cseg   \
#          curves.cseg   \
#          dutils.cseg   \
#          legends.cseg  \
#          ndutils.cseg

#util.o:   utill.h

# define the make rule(s)
# -----------------------

plotps:	$(OBJSC)
	$(CC) $(DEBUG) $(LINK) -o plotps $(OBJSC) \
	$(BIG_MEMORY) $(LIBS)

# ================================================================
# C-compile rules ( using flags defined above)
# ================================================================

.c.o:
	$(CC) $(CFLAGS) $(CPPFLAGS) $(DEBUG) -c $<

# ================================================================
# end of rules
# ================================================================

clean:
	$(RM) $(RMFLAGS) $(OBJFC)
	$(RM) $(RMFLAGS) plotps
	$(RM) $(RMFLAGS) *.o
