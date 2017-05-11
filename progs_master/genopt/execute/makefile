# Makefile for genopt
#
HOME       = ${BUSHNELL}
PROG       = $(HOME)/genopt

# macro definitions
# =================

include    $(HOME)/Makefile.in

#----------------------------------------------------------------------------

.PRECIOUS:  $(EXE)/helpg.$(MACHINE)\
	    $(EXE)/insert.$(MACHINE)\
	    $(OBJ)/ads.a\
	    $(OBJ)/chplot.a\
	    $(OBJ)/conman.a\
	    $(OBJ)/decide.a\
            $(OBJ)/chauto.a\
	    $(OBJ)/felippa.a\
	    $(OBJ)/main.a\
	    $(OBJ)/mainsetup.a\
	    $(OBJ)/prompter.a\
	    $(OBJ)/store.a\
	    $(OBJ)/util.a\
            $(OBJ)/zeroit.a\
	    $(UTIL)/util_$(MACHINE).o\
	    $(UTIL)/ieeexx_$(MACHINE).o\
            $(EXE)/genprompt.$(MACHINE)

genopt: $(EXE)/helpg.$(MACHINE)\
        $(EXE)/insert.$(MACHINE)\
        $(OBJ)/ads.a\
        $(OBJ)/chplot.a\
        $(OBJ)/conman.a\
        $(OBJ)/decide.a\
        $(OBJ)/chauto.a\
        $(OBJ)/felippa.a\
        $(OBJ)/main.a\
        $(OBJ)/mainsetup.a\
        $(OBJ)/prompter.a\
        $(OBJ)/store.a\
        $(OBJ)/util.a\
        $(OBJ)/zeroit.a\
        $(UTIL)/util_$(MACHINE).o\
        $(UTIL)/ieeexx_$(MACHINE).o\
	$(UTIL)/sig_$(MACHINE).o\
        $(EXE)/genprompt.$(MACHINE)

$(EXE)/genprompt.$(MACHINE): $(LIB)/genprompt.a
	ar xv $(LIB)/genprompt.a gentxt.o
	$(FC) $(FFLAGS) -o $@ gentxt.o $(LIB)/genprompt.a $(UTIL)/sig_$(MACHINE).o
	/bin/rm -f gentxt.o

$(EXE)/helpg.$(MACHINE): $(LIB)/helpg.a
	ar xv $(LIB)/helpg.a helpg.o
	$(FC) $(FFLAGS) -o $@ helpg.o $(LIB)/helpg.a
	/bin/rm -f helpg.o

$(EXE)/insert.$(MACHINE): $(LIB)/insert.a
	ar xv $(LIB)/insert.a insert.o
	$(FC) $(FFLAGS) -o $@ insert.o $(LIB)/insert.a $(UTIL)/sig_$(MACHINE).o
	/bin/rm -f insert.o

# Update libraries ...

$(LIB)/genprompt.a: $(OBJ)/genprompt.a $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/helpg.a: $(OBJ)/helpg.a $(OBJ)/felippa.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/insert.a: $(OBJ)/insert.a $(OBJ)/genprompt.a $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?
	-ar ds $@ genprompt.o && ranlib $@

# Update objects ...

$(OBJ)/ads.a: $(SRC)/ads.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/ads.src $@

$(OBJ)/chplot.a: $(SRC)/chplot.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/chplot.src $@

$(OBJ)/conman.a: $(SRC)/conman.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/conman.src $@

$(OBJ)/decide.a: $(SRC)/decide.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/decide.src $@

$(OBJ)/chauto.a: $(SRC)/chauto.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/chauto.src $@

$(OBJ)/felippa.a: $(SRC)/felippa.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/felippa.src $@

$(OBJ)/genprompt.a: $(SRC)/genprompt.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/genprompt.src $@

$(OBJ)/helpg.a: $(SRC)/helpg.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/helpg.src $@

$(OBJ)/insert.a: $(SRC)/insert.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/insert.src $@

$(OBJ)/main.a: $(SRC)/main.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/main.src $@

$(OBJ)/mainsetup.a: $(SRC)/mainsetup.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/mainsetup.src $@

$(OBJ)/prompter.a: $(SRC)/prompter.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/prompter.src $@

$(OBJ)/store.a: $(SRC)/store.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/store.src $@

$(OBJ)/util.a: $(SRC)/util.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/util.src $@

$(OBJ)/zeroit.a: $(SRC)/zeroit.src
		 csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $(SRC)/zeroit.src $@

$(UTIL)/ieeexx_$(MACHINE).o: $(UTIL)/ieeexx.c
	cd $(UTIL) && \
        cc $(CFLAGS) -D$(MACHINE) -c ieeexx.c && \
        mv ieeexx.o ieeexx_$(MACHINE).o

$(UTIL)/sig_$(MACHINE).o: $(UTIL)/sig.F
	cd $(UTIL) &&\
        /bin/rm -f sig_$(MACHINE).f &&\
        fpp -P -D${MACHINE} sig.F sig_$(MACHINE).f &&\
        $(FC) $(FFLAGS) -c sig_$(MACHINE).f &&\
        /bin/rm -f sig_$(MACHINE).f

$(UTIL)/util_$(MACHINE).o: $(UTIL)/util.c
	cd $(UTIL) && \
        cc $(CFLAGS) -D$(MACHINE) -c util.c && \
        mv util.o util_$(MACHINE).o

