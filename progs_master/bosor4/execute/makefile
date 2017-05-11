# Makefile for bosor4
#

HOME       = ${BUSHNELL}
PROG       = $(HOME)/bosor4

# macro definitions
# =================

include    $(HOME)/Makefile.in

#----------------------------------------------------------------------------

.PRECIOUS:  $(EXE)/assemble.$(MACHINE)\
	    $(EXE)/bosormain.$(MACHINE)\
	    $(EXE)/bosorpost.$(MACHINE)\
	    $(EXE)/bosorread.$(MACHINE)\
	    $(EXE)/getsegs.$(MACHINE)\
	    $(EXE)/help4.$(MACHINE)\
	    $(EXE)/input.$(MACHINE)\
	    $(EXE)/modify.$(MACHINE)\
	    $(EXE)/resetup.$(MACHINE)

bosor4: $(EXE)/assemble.$(MACHINE)\
        $(EXE)/bosormain.$(MACHINE)\
        $(EXE)/bosorpost.$(MACHINE)\
        $(EXE)/bosorread.$(MACHINE)\
        $(EXE)/getsegs.$(MACHINE)\
        $(EXE)/help4.$(MACHINE)\
        $(EXE)/input.$(MACHINE)\
        $(EXE)/modify.$(MACHINE)\
        $(EXE)/resetup.$(MACHINE)

$(EXE)/assemble.$(MACHINE): $(LIB)/assemble.a
	ar xv $(LIB)/assemble.a assmbl.o
	$(FC) $(FFLAGS) -o $@ assmbl.o $(LIB)/assemble.a
	/bin/rm assmbl.o

$(EXE)/bosormain.$(MACHINE): $(LIB)/bosormain.a \
                             $(UTIL)/ieeexx_$(MACHINE).o
	ar xv $(LIB)/bosormain.a b4main.o
	$(FC) $(FFLAGS) -o $@ b4main.o $(LIB)/bosormain.a \
                                       $(UTIL)/ieeexx_$(MACHINE).o
	/bin/rm b4main.o

$(EXE)/bosorpost.$(MACHINE): $(LIB)/bosorpost.a \
                             $(UTIL)/pakupk_$(MACHINE).o \
                             $(UTIL)/ieeexx_$(MACHINE).o
	ar xv $(LIB)/bosorpost.a b4post.o
	$(FC) $(FFLAGS) -o $@ b4post.o $(LIB)/bosorpost.a \
                                       $(UTIL)/pakupk_$(MACHINE).o \
                                       $(UTIL)/ieeexx_$(MACHINE).o
	/bin/rm b4post.o

$(EXE)/bosorread.$(MACHINE): $(LIB)/bosorread.a $(UTIL)/ieeexx_$(MACHINE).o
	ar xv $(LIB)/bosorread.a b4read.o
	$(FC) $(FFLAGS) -o $@ b4read.o $(LIB)/bosorread.a \
                                       $(UTIL)/ieeexx_$(MACHINE).o
	/bin/rm b4read.o

$(EXE)/getsegs.$(MACHINE): $(LIB)/getsegs.a
	ar xv $(LIB)/getsegs.a getseg.o
	$(FC) $(FFLAGS) -o $@ getseg.o $(LIB)/getsegs.a
	/bin/rm getseg.o

$(EXE)/help4.$(MACHINE): $(LIB)/help4.a
	ar xv $(LIB)/help4.a help4.o
	$(FC) $(FFLAGS) -o $@ help4.o $(LIB)/help4.a
	/bin/rm help4.o

$(EXE)/input.$(MACHINE): $(LIB)/input.a $(UTIL)/sig_$(MACHINE).o
	ar xv $(LIB)/input.a input.o
	$(FC) $(FFLAGS) -o $@ input.o $(LIB)/input.a \
                                    $(UTIL)/sig_$(MACHINE).o
	/bin/rm input.o

$(EXE)/modify.$(MACHINE): $(LIB)/modify.a $(UTIL)/sig_$(MACHINE).o
	ar xv $(LIB)/modify.a modify.o
	$(FC) $(FFLAGS) -o $@ modify.o $(LIB)/modify.a \
                                     $(UTIL)/sig_$(MACHINE).o
	/bin/rm modify.o

$(EXE)/resetup.$(MACHINE): $(LIB)/resetup.a $(UTIL)/sig_$(MACHINE).o
	ar xv $(LIB)/resetup.a reset.o
	$(FC) $(FFLAGS) -o $@ reset.o $(LIB)/resetup.a \
                                    $(UTIL)/sig_$(MACHINE).o
	/bin/rm reset.o

# Update $(LIB)/assemble.a
$(LIB)/assemble.a: $(OBJ)/assemble.a
	cp $(OBJ)/assemble.a $@

# Update $(LIB)/bosormain.a
$(LIB)/bosormain.a: $(OBJ)/arrays.a $(OBJ)/b4main.a $(OBJ)/buckle.a\
                    $(OBJ)/gasp.a   $(OBJ)/mode.a   $(OBJ)/pre.a\
                    $(OBJ)/stoget.a $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

# Update $(LIB)/bosorpost.a
$(LIB)/bosorpost.a: $(OBJ)/b4post.a $(OBJ)/gasp.a   $(OBJ)/mode.a\
                    $(OBJ)/plot.a   $(OBJ)/stoget.a $(OBJ)/util.a\
                    $(UTIL)/dattim_$(MACHINE).o
	csh $(BIN)/updatelib $@ $?

# Update $(LIB)/bosorread.a
$(LIB)/bosorread.a: $(OBJ)/b4read.a   $(OBJ)/gasp.a  $(OBJ)/geom.a\
                    $(OBJ)/prompter.a $(OBJ)/rfive.a $(OBJ)/rzlg.a\
                    $(OBJ)/stoget.a   $(OBJ)/util.a  $(OBJ)/wall.a
	csh $(BIN)/updatelib $@ $?

# Update $(LIB)/getsegs.a
$(LIB)/getsegs.a: $(OBJ)/getsegs.a
	cp $(OBJ)/getsegs.a $@

# Update $(LIB)/help4.a 
$(LIB)/help4.a: $(OBJ)/help4.a $(OBJ)/felippa.a
	csh $(BIN)/updatelib $@ $?

# Update $(LIB)/input.a
$(LIB)/input.a: $(OBJ)/input.a $(OBJ)/questions.a $(OBJ)/prompter.a\
                $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

# Update $(LIB)/modify.a
$(LIB)/modify.a: $(OBJ)/modify.a    $(OBJ)/input.a $(OBJ)/prompter.a\
                 $(OBJ)/questions.a $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?
	-ar dv $@ input.o

# Update $(LIB)/resetup.a
$(LIB)/resetup.a: $(OBJ)/prompter.a $(OBJ)/resetup.a $(OBJ)/stoget.a\
                  $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

# Update $(OBJ)/arrays.a
$(OBJ)/arrays.a: $(SRC)/arrays.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/arrays.src $@

# Update $(OBJ)/assemble.a
$(OBJ)/assemble.a: $(SRC)/assemble.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/assemble.src $@

# Update $(OBJ)/b4main.a
$(OBJ)/b4main.a: $(SRC)/b4main.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/b4main.src $@

# Update $(OBJ)/b4post.a
$(OBJ)/b4post.a: $(SRC)/b4post.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/b4post.src $@

# Update $(OBJ)/b4read.a
$(OBJ)/b4read.a: $(SRC)/b4read.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/b4read.src $@

# Update $(OBJ)/buckle.a
$(OBJ)/buckle.a: $(SRC)/buckle.src
	csh $(BIN)/updateobj $(FC) "$(OPTFFLAGS)" $(SRC)/buckle.src $@

# Update $(OBJ)/felippa.a
$(OBJ)/felippa.a: $(SRC)/felippa.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/felippa.src $@

# Update $(OBJ)/gasp.a
$(OBJ)/gasp.a: $(UTIL)/gasp.F $(UTIL)/bio.c
	cd $(UTIL) &&\
        /bin/rm -f gasp_$(MACHINE).f &&\
        fpp -P -D${MACHINE} gasp.F gasp_$(MACHINE).f &&\
        $(FC) $(FFLAGS) -c  gasp_$(MACHINE).f &&\
        cp -f bio.c bio_$(MACHINE).c &&\
        $(CC) $(CFLAGS) -c bio_$(MACHINE).c &&\
        ar rv $@ gasp_$(MACHINE).o bio_$(MACHINE).o &&\
        /bin/rm -f gasp_$(MACHINE).o bio_$(MACHINE).o &&\
        ranlib $@

# Update $(OBJ)/geom.a
$(OBJ)/geom.a: $(SRC)/geom.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/geom.src $@

# Update $(OBJ)/getsegs.a
$(OBJ)/getsegs.a: $(SRC)/getsegs.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/getsegs.src $@

# Update $(OBJ)/help4.a
$(OBJ)/help4.a: $(SRC)/help4.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/help4.src $@

# Update $(OBJ)/input.a
$(OBJ)/input.a: $(SRC)/input.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/input.src $@

# Update $(OBJ)/mode.a
$(OBJ)/mode.a: $(SRC)/mode.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/mode.src $@

# Update $(OBJ)/modify.a
$(OBJ)/modify.a: $(SRC)/modify.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/modify.src $@

# Update $(OBJ)/plot.a
$(OBJ)/plot.a: $(SRC)/plot.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/plot.src $@

# Update $(OBJ)/pre.a
$(OBJ)/pre.a: $(SRC)/pre.src
	csh $(BIN)/updateobj $(FC) "$(OPTFFLAGS)" $(SRC)/pre.src $@

# Update $(OBJ)/prompter.a
$(OBJ)/prompter.a: $(SRC)/prompter.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/prompter.src $@

# Update $(OBJ)/questions.a
$(OBJ)/questions.a: $(SRC)/questions.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/questions.src $@

# Update $(OBJ)/resetup.a
$(OBJ)/resetup.a: $(SRC)/resetup.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/resetup.src $@

# Update $(OBJ)/rfive.a
$(OBJ)/rfive.a: $(SRC)/rfive.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/rfive.src $@

# Update $(OBJ)/rzlg.a
$(OBJ)/rzlg.a: $(SRC)/rzlg.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/rzlg.src $@

# Update $(OBJ)/stoget.a
$(OBJ)/stoget.a: $(SRC)/stoget.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/stoget.src $@

# Update $(OBJ)/util.a
$(OBJ)/util.a: $(SRC)/util.src
	csh $(BIN)/updateobj $(FC) "$(OPTFFLAGS)" $(SRC)/util.src $@

# Update $(OBJ)/wall.a
$(OBJ)/wall.a: $(SRC)/wall.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/wall.src $@

$(UTIL)/dattim_$(MACHINE).o: $(UTIL)/dattim.c
	cd $(UTIL) && \
	$(CC) $(CFLAGS) -c dattim.c && \
	mv dattim.o dattim_$(MACHINE).o

$(UTIL)/ieeexx_$(MACHINE).o: $(UTIL)/ieeexx.c
	cd $(UTIL) && \
        $(CC) $(CFLAGS) -c ieeexx.c && \
        mv ieeexx.o ieeexx_$(MACHINE).o

$(UTIL)/pakupk_$(MACHINE).o: $(UTIL)/pakupk.c
	cd $(UTIL) && \
        $(CC) $(CFLAGS) -D$(MACHINE) -c pakupk.c && \
        mv pakupk.o pakupk_$(MACHINE).o

$(UTIL)/sig_$(MACHINE).o: $(UTIL)/sig.F
	cd $(UTIL) &&\
        /bin/rm -f sig_$(MACHINE).f &&\
        fpp -P -D${MACHINE} sig.F sig_$(MACHINE).f &&\
        $(FC) $(FFLAGS) -c sig_$(MACHINE).f &&\
        /bin/rm -f sig_$(MACHINE).f
