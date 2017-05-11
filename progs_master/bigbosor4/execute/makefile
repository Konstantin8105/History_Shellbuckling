# Makefile for bigbosor4
#
HOME       = ${BUSHNELL}
PROG       = $(HOME)/bigbosor4

# macro definitions
# =================

include    $(HOME)/Makefile.in

#----------------------------------------------------------------------------

.PRECIOUS:  $(EXE)/assemble.$(MACHINE)\
	    $(EXE)/bigbosor4.$(MACHINE)\
            $(EXE)/bigrestart.$(MACHINE)\
	    $(EXE)/getsegs.$(MACHINE)\
	    $(EXE)/help4.$(MACHINE)\
	    $(EXE)/input.$(MACHINE)\
	    $(EXE)/modify.$(MACHINE)\
	    $(EXE)/resetup.$(MACHINE)

bigbosor4: $(EXE)/assemble.$(MACHINE)\
           $(EXE)/bigbosor4.$(MACHINE)\
           $(EXE)/bigrestart.$(MACHINE)\
           $(EXE)/getsegs.$(MACHINE)\
           $(EXE)/help4.$(MACHINE)\
           $(EXE)/input.$(MACHINE)\
           $(EXE)/modify.$(MACHINE)\
           $(EXE)/resetup.$(MACHINE)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++
# rules for building executables ( ******.$(MACHINE) )
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++

$(EXE)/assemble.$(MACHINE): $(LIB)/assemble.a
	ar xv $(LIB)/assemble.a assmbl.o
	$(FC) $(FFLAGS) -o $@ assmbl.o $(LIB)/assemble.a
	/bin/rm assmbl.o

$(EXE)/bigbosor4.$(MACHINE): $(LIB)/bigbosor4.a $(UTIL)/ieeexx_$(MACHINE).o \
                             $(UTIL)/dattim_$(MACHINE).o
	ar xv $(LIB)/bigbosor4.a mainb4.o
	$(FC) $(FFLAGS) -o $@ mainb4.o $(LIB)/bigbosor4.a \
                                       $(UTIL)/ieeexx_$(MACHINE).o \
                                       $(UTIL)/dattim_$(MACHINE).o
	/bin/rm mainb4.o

$(EXE)/bigrestart.$(MACHINE): $(LIB)/bigrestart.a $(UTIL)/ieeexx_$(MACHINE).o \
                              $(UTIL)/dattim_$(MACHINE).o
	ar xv $(LIB)/bigrestart.a restart.o
	$(FC) $(FFLAGS) -o $@ restart.o $(LIB)/bigrestart.a \
                                        $(UTIL)/ieeexx_$(MACHINE).o \
                                        $(UTIL)/dattim_$(MACHINE).o
	/bin/rm restart.o

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
	$(FC) $(FFLAGS) -s -o $@ reset.o $(LIB)/resetup.a \
                                    $(UTIL)/sig_$(MACHINE).o
	/bin/rm reset.o

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++
# rules for building libraries ( ******.a )
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Update $(LIB)/assemble.a
$(LIB)/assemble.a: $(OBJ)/assemble.a
	cp $(OBJ)/assemble.a $@
#	ranlib $@

# Update $(LIB)/bigbosor4.a
$(LIB)/bigbosor4.a: $(OBJ)/opngen.a $(OBJ)/mainb4.a $(OBJ)/addbosor4.a\
                    $(OBJ)/gasp.a   $(OBJ)/b4plot.a $(OBJ)/b4util.a\
                    $(OBJ)/prompter.a
	csh $(BIN)/updatelib $@ $?

# Update $(LIB)/bigrestart.a
$(LIB)/bigrestart.a: $(OBJ)/opngen.a $(OBJ)/restart.a $(OBJ)/addbosor4.a\
                    $(OBJ)/gasp.a   $(OBJ)/b4plot.a   $(OBJ)/b4util.a\
                    $(OBJ)/prompter.a
	csh $(BIN)/updatelib $@ $?

# Update $(LIB)/getsegs.a
$(LIB)/getsegs.a: $(OBJ)/getsegs.a
	cp $(OBJ)/getsegs.a $@
#	ranlib $@

# Update $(LIB)/help4.a 
$(LIB)/help4.a: $(OBJ)/help4.a $(OBJ)/felippa.a
	csh $(BIN)/updatelib $@ $?

# Update $(LIB)/input.a
$(LIB)/input.a: $(OBJ)/input.a $(OBJ)/questions.a $(OBJ)/prompter.a\
                $(OBJ)/b4util.a
	csh $(BIN)/updatelib $@ $?

# Update $(LIB)/modify.a
$(LIB)/modify.a: $(OBJ)/modify.a    $(OBJ)/input.a $(OBJ)/prompter.a\
                 $(OBJ)/questions.a $(OBJ)/b4util.a
	csh $(BIN)/updatelib $@ $?
	-ar dv $@ input.o
#	ranlib $@

# Update $(LIB)/resetup.a
$(LIB)/resetup.a: $(OBJ)/prompter.a $(OBJ)/resetup.a $(OBJ)/addbosor4.a\
                  $(OBJ)/b4util.a   $(OBJ)/gasp.a
	csh $(BIN)/updatelib $@ $?

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++
# # rules for building objects ( ******.a )
# # +++++++++++++++++++++++++++++++++++++++++++++++++++++++
#

# Update $(OBJ)/opngen.a
$(OBJ)/opngen.a: $(SRC)/opngen.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/opngen.src $@

# Update $(OBJ)/assemble.a
$(OBJ)/assemble.a: $(SRC)/assemble.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/assemble.src $@

# Update $(OBJ)/mainb4.a
$(OBJ)/mainb4.a: $(SRC)/mainb4.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/mainb4.src $@

# Update $(OBJ)/restart.a
$(OBJ)/restart.a: $(SRC)/restart.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/restart.src $@

# Update $(OBJ)/addbosor4.a
$(OBJ)/addbosor4.a: $(SRC)/addbosor4.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/addbosor4.src $@

# Update $(OBJ)/felippa.a
$(OBJ)/felippa.a: $(SRC)/felippa.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/felippa.src $@

# Update $(OBJ)/gasp.a
$(OBJ)/gasp.a: $(UTIL)/gasp.F $(UTIL)/bio.c
	cd $(UTIL) &&\
        /bin/rm -f gasp_$(MACHINE).f &&\
        fpp -P -D${MACHINE} gasp.F gasp_$(MACHINE).f &&\
        $(FC) $(FFLAGS) -c  gasp_$(MACHINE).f &&\
        /bin/rm -f gasp_$(MACHINE).f &&\
        cp -f bio.c bio_$(MACHINE).c &&\
        $(CC) $(CFLAGS) -c bio_$(MACHINE).c &&\
        ar rv $@ gasp_$(MACHINE).o bio_$(MACHINE).o &&\
        /bin/rm -f gasp_$(MACHINE).o bio_$(MACHINE).o &&\
        ranlib $@

# Update $(OBJ)/getsegs.a
$(OBJ)/getsegs.a: $(SRC)/getsegs.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/getsegs.src $@

# Update $(OBJ)/help4.a
$(OBJ)/help4.a: $(SRC)/help4.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/help4.src $@

# Update $(OBJ)/input.a
$(OBJ)/input.a: $(SRC)/input.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/input.src $@

# Update $(OBJ)/b4plot.a
$(OBJ)/b4plot.a: $(SRC)/b4plot.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/b4plot.src $@

# Update $(OBJ)/modify.a
$(OBJ)/modify.a: $(SRC)/modify.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/modify.src $@

# Update $(OBJ)/b4util.a
$(OBJ)/b4util.a: $(SRC)/b4util.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/b4util.src $@

# Update $(OBJ)/prompter.a
$(OBJ)/prompter.a: $(SRC)/prompter.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/prompter.src $@

# Update $(OBJ)/questions.a
$(OBJ)/questions.a: $(SRC)/questions.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/questions.src $@

# Update $(OBJ)/resetup.a
$(OBJ)/resetup.a: $(SRC)/resetup.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/resetup.src $@

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++
# rules for building object files ( ******.o )
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++

$(UTIL)/dattim_$(MACHINE).o: $(UTIL)/dattim.c
	cd $(UTIL) && \
	$(CC) $(CFLAGS) -c dattim.c && \
	mv dattim.o dattim_$(MACHINE).o

$(UTIL)/ieeexx_$(MACHINE).o: $(UTIL)/ieeexx.c
	cd $(UTIL) && \
	$(CC) $(CFLAGS) -c ieeexx.c && \
	mv ieeexx.o ieeexx_$(MACHINE).o

$(UTIL)/sig_$(MACHINE).o: $(UTIL)/sig.F
	cd $(UTIL) &&\
        /bin/rm -f sig_$(MACHINE).f &&\
        fpp -P -D${MACHINE} sig.F sig_$(MACHINE).f &&\
        $(FC) $(FFLAGS) -c sig_$(MACHINE).f &&\
        /bin/rm -f sig_$(MACHINE).f
