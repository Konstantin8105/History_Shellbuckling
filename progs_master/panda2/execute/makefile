# Makefile for panda2
#
HOME       = ${BUSHNELL}
PROG       = $(HOME)/panda2

# macro definitions
# =================

include    $(HOME)/Makefile.in

B4SRC      = $(BOSOR4)/sources
B4OBJ      = $(BOSOR4)/objects.$(MACHINE)

#----------------------------------------------------------------------------

.PRECIOUS:  $(EXE)/begin.$(MACHINE)\
	    $(EXE)/bospan.$(MACHINE)\
	    $(EXE)/bospn2.$(MACHINE)\
	    $(EXE)/bospn3.$(MACHINE)\
	    $(EXE)/change.$(MACHINE)\
	    $(EXE)/autochange.$(MACHINE)\
	    $(EXE)/chooseplot.$(MACHINE)\
	    $(EXE)/choosetemp.$(MACHINE)\
	    $(EXE)/decide.$(MACHINE)\
	    $(EXE)/getplot.$(MACHINE)\
	    $(EXE)/globst.$(MACHINE)\
	    $(EXE)/glbst2.$(MACHINE)\
	    $(EXE)/glbst3.$(MACHINE)\
	    $(EXE)/helpan.$(MACHINE)\
	    $(EXE)/main.$(MACHINE)\
	    $(EXE)/mainsetup.$(MACHINE)\
	    $(EXE)/pandaread.$(MACHINE)\
	    $(EXE)/setup.$(MACHINE)\
	    $(EXE)/setup2.$(MACHINE)\
	    $(EXE)/setup3.$(MACHINE)\
            $(EXE)/stagsunit.$(MACHINE)\
	    $(EXE)/stagsmodel.$(MACHINE)\
	    $(EXE)/store.$(MACHINE)\
            $(EXE)/zeritr.$(MACHINE)

panda2:	$(EXE)/begin.$(MACHINE)\
        $(EXE)/bospan.$(MACHINE)\
        $(EXE)/bospn2.$(MACHINE)\
        $(EXE)/bospn3.$(MACHINE)\
        $(EXE)/change.$(MACHINE)\
        $(EXE)/autochange.$(MACHINE)\
        $(EXE)/chooseplot.$(MACHINE)\
        $(EXE)/choosetemp.$(MACHINE)\
        $(EXE)/decide.$(MACHINE)\
        $(EXE)/getplot.$(MACHINE)\
        $(EXE)/globst.$(MACHINE)\
        $(EXE)/glbst2.$(MACHINE)\
        $(EXE)/glbst3.$(MACHINE)\
        $(EXE)/helpan.$(MACHINE)\
        $(EXE)/main.$(MACHINE)\
        $(EXE)/mainsetup.$(MACHINE)\
        $(EXE)/pandaread.$(MACHINE)\
        $(EXE)/setup.$(MACHINE)\
        $(EXE)/setup2.$(MACHINE)\
        $(EXE)/setup3.$(MACHINE)\
        $(EXE)/stagsmodel.$(MACHINE)\
        $(EXE)/stagsunit.$(MACHINE)\
        $(EXE)/store.$(MACHINE)\
        $(EXE)/zeritr.$(MACHINE)

$(EXE)/begin.$(MACHINE): $(LIB)/begin.a
	ar xv $(LIB)/begin.a begin.o
	$(FC) $(FFLAGS) -o $@ begin.o $(LIB)/begin.a
	/bin/rm -f begin.o

$(EXE)/bospan.$(MACHINE): $(LIB)/bospan.a
	ar xv $(LIB)/bospan.a bospan.o
	$(FC) $(FFLAGS) -o $@ bospan.o $(LIB)/bospan.a
	/bin/rm -f bospan.o

$(EXE)/bospn2.$(MACHINE): $(LIB)/bospn2.a
	ar xv $(LIB)/bospn2.a bospn2.o
	$(FC) $(FFLAGS) -o $@ bospn2.o $(LIB)/bospn2.a
	/bin/rm -f bospn2.o

$(EXE)/bospn3.$(MACHINE): $(LIB)/bospn3.a
	ar xv $(LIB)/bospn3.a bospn3.o
	$(FC) $(FFLAGS) -o $@ bospn3.o $(LIB)/bospn3.a
	/bin/rm -f bospn3.o


$(EXE)/change.$(MACHINE): $(LIB)/change.a
	ar xv $(LIB)/change.a change.o
	$(FC) $(FFLAGS) -o $@ change.o $(LIB)/change.a
	/bin/rm -f change.o

$(EXE)/autochange.$(MACHINE): $(LIB)/autochange.a
	ar xv $(LIB)/autochange.a chauto.o
	$(FC) $(FFLAGS) -o $@ chauto.o $(LIB)/autochange.a
	/bin/rm -f chauto.o

$(EXE)/chooseplot.$(MACHINE): $(LIB)/chooseplot.a
	ar xv $(LIB)/chooseplot.a chplot.o
	$(FC) $(FFLAGS) -o $@ chplot.o $(LIB)/chooseplot.a
	/bin/rm -f chplot.o

$(EXE)/choosetemp.$(MACHINE): $(LIB)/choosetemp.a
	ar xv $(LIB)/choosetemp.a chtemp.o
	$(FC) $(FFLAGS) -o $@ chtemp.o $(LIB)/choosetemp.a
	/bin/rm -f chtemp.o

$(EXE)/decide.$(MACHINE): $(LIB)/decide.a
	ar xv $(LIB)/decide.a decide.o
	$(FC) $(FFLAGS) -o $@ decide.o $(LIB)/decide.a
	/bin/rm -f decide.o

$(EXE)/getplot.$(MACHINE): $(LIB)/getplot.a
	ar xv $(LIB)/getplot.a getplot.o
	$(FC) $(FFLAGS) -o $@ getplot.o $(LIB)/getplot.a
	/bin/rm -f getplot.o

$(EXE)/globst.$(MACHINE): $(LIB)/globst.a
	ar xv $(LIB)/globst.a globst.o
	$(FC) $(FFLAGS) -o $@ globst.o $(LIB)/globst.a
	/bin/rm -f globst.o

$(EXE)/glbst2.$(MACHINE): $(LIB)/glbst2.a
	ar xv $(LIB)/glbst2.a glbst2.o
	$(FC) $(FFLAGS) -o $@ glbst2.o $(LIB)/glbst2.a
	/bin/rm -f glbst2.o

$(EXE)/glbst3.$(MACHINE): $(LIB)/glbst3.a
	ar xv $(LIB)/glbst3.a glbst3.o
	$(FC) $(FFLAGS) -o $@ glbst3.o $(LIB)/glbst3.a
	/bin/rm -f glbst3.o

$(EXE)/helpan.$(MACHINE): $(LIB)/helpan.a
	ar xv $(LIB)/helpan.a helpan.o
	$(FC) $(FFLAGS) -o $@ helpan.o $(LIB)/helpan.a
	/bin/rm -f helpan.o

$(EXE)/main.$(MACHINE): $(LIB)/main.a $(UTIL)/ieeexx_$(MACHINE).o
	ar xv $(LIB)/main.a main.o
	$(FC) $(FFLAGS) -o $@ main.o $(LIB)/main.a $(UTIL)/ieeexx_$(MACHINE).o -lm
	/bin/rm -f main.o

$(EXE)/mainsetup.$(MACHINE): $(LIB)/mainsetup.a
	ar xv $(LIB)/mainsetup.a mains.o
	$(FC) $(FFLAGS) -o $@ mains.o $(LIB)/mainsetup.a
	/bin/rm -f mains.o

$(EXE)/pandaread.$(MACHINE): $(LIB)/pandaread.a
	ar xv $(LIB)/pandaread.a b4read.o
	$(FC) $(FFLAGS) -o $@ b4read.o $(LIB)/pandaread.a
	/bin/rm -f b4read.o

$(EXE)/setup.$(MACHINE): $(LIB)/setup.a
	ar xv $(LIB)/setup.a setup.o
	$(FC) $(FFLAGS) -o $@ setup.o $(LIB)/setup.a
	/bin/rm -f setup.o

$(EXE)/setup2.$(MACHINE): $(LIB)/setup2.a
	ar xv $(LIB)/setup2.a setup2.o
	$(FC) $(FFLAGS) -o $@ setup2.o $(LIB)/setup2.a
	/bin/rm -f setup2.o

$(EXE)/setup3.$(MACHINE): $(LIB)/setup3.a
	ar xv $(LIB)/setup3.a setup3.o
	$(FC) $(FFLAGS) -o $@ setup3.o $(LIB)/setup3.a
	/bin/rm -f setup3.o

$(EXE)/stagsmodel.$(MACHINE): $(LIB)/stagsmodel.a
	ar xv $(LIB)/stagsmodel.a stagfe.o
	$(FC) $(FFLAGS) -o $@ stagfe.o $(LIB)/stagsmodel.a
	/bin/rm -f stagfe.o

$(EXE)/stagsunit.$(MACHINE): $(LIB)/stagsunit.a 
	ar xv $(LIB)/stagsunit.a stagun.o
	$(FC) $(FFLAGS) -o $@ stagun.o $(LIB)/stagsunit.a
	/bin/rm -f stagun.o

$(EXE)/store.$(MACHINE): $(LIB)/store.a
	ar xv $(LIB)/store.a store.o
	$(FC) $(FFLAGS) -o $@ store.o $(LIB)/store.a
	/bin/rm -f store.o

$(EXE)/zeritr.$(MACHINE): $(LIB)/zeritr.a
			  ar xv $(LIB)/zeritr.a zeritr.o
			  $(FC) $(FFLAGS) -o $@ zeritr.o $(LIB)/zeritr.a
			  /bin/rm -f zeritr.o

# Update libraries...

$(LIB)/begin.a: $(OBJ)/begin.a $(OBJ)/prompter.a $(OBJ)/stoget.a\
                $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/bospan.a: $(OBJ)/bospan.a $(OBJ)/prompter.a $(OBJ)/setup.a\
                 $(OBJ)/stoget.a $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?
	-ar ldv $@ setup.o && ranlib $@

$(LIB)/bospn3.a: $(OBJ)/bospn3.a $(OBJ)/prompter.a $(OBJ)/setup.a\
                 $(OBJ)/stoget.a $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?
	-ar ldv $@ setup.o && ranlib $@

$(LIB)/bospn2.a: $(OBJ)/bospn2.a $(OBJ)/prompter.a $(OBJ)/setup2.a\
                 $(OBJ)/stoget.a $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?
	-ar ldv $@ setup2.o && ranlib $@

$(LIB)/change.a: $(OBJ)/change.a $(OBJ)/prompter.a $(OBJ)/stoget.a\
                 $(OBJ)/util.a   $(OBJ)/conman.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/autochange.a: $(OBJ)/chauto.a $(OBJ)/prompter.a $(OBJ)/stoget.a\
                 $(OBJ)/util.a   $(OBJ)/conman.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/chooseplot.a: $(OBJ)/chplot.a $(OBJ)/prompter.a $(OBJ)/stoget.a\
                     $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/choosetemp.a: $(OBJ)/chtemp.a $(OBJ)/prompter.a $(OBJ)/stoget.a\
                     $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/decide.a: $(OBJ)/decide.a $(OBJ)/prompter.a $(OBJ)/stoget.a\
                 $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/getplot.a: $(OBJ)/getplot.a $(OBJ)/prompter.a $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/globst.a: $(OBJ)/gasp.a   $(OBJ)/globst.a   $(OBJ)/prompter.a\
                 $(OBJ)/stoget.a $(OBJ)/util.a     $(B4OBJ)/stoget.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/glbst2.a: $(OBJ)/gasp.a   $(OBJ)/glbst2.a   $(OBJ)/prompter.a\
                 $(OBJ)/stoget.a $(OBJ)/util.a     $(B4OBJ)/stoget.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/glbst3.a: $(OBJ)/gasp.a   $(OBJ)/glbst3.a   $(OBJ)/prompter.a\
                 $(OBJ)/stoget.a $(OBJ)/util.a     $(B4OBJ)/stoget.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/helpan.a: $(OBJ)/helpan.a $(B4OBJ)/felippa.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/main.a: $(OBJ)/ads.a     $(OBJ)/arrays.a    $(OBJ)/buckle.a\
               $(OBJ)/bucpan1.a $(OBJ)/bucpan2.a   $(OBJ)/conman.a\
               $(OBJ)/eband2.a  $(OBJ)/forces.a    $(OBJ)/gasp.a\
               $(OBJ)/getcij.a  $(OBJ)/koiter.a    $(OBJ)/koiter2.a\
               $(OBJ)/main.a    $(OBJ)/mainsetup.a $(OBJ)/mode.a\
               $(OBJ)/newtpn.a  $(OBJ)/pancom.a    $(OBJ)/prompter.a\
               $(OBJ)/smrcij.a  $(OBJ)/stoget.a    $(OBJ)/strain.a\
               $(OBJ)/struct.a  $(OBJ)/util.a      $(B4OBJ)/stoget.a\
               $(OBJ)/triang.a
	csh $(BIN)/updatelib $@ $?
	-ar ldv $@ mains.o && ranlib $@

$(LIB)/mainsetup.a: $(OBJ)/mainsetup.a $(OBJ)/prompter.a\
                    $(OBJ)/stoget.a    $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/pandaread.a: $(OBJ)/b4read.a   $(OBJ)/gasp.a       $(OBJ)/rfive.a\
                    $(B4OBJ)/geom.a   $(B4OBJ)/prompter.a $(B4OBJ)/rzlg.a\
                    $(B4OBJ)/stoget.a $(B4OBJ)/wall.a     $(B4OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/setup.a: $(OBJ)/prompter.a $(OBJ)/setup.a $(OBJ)/stoget.a\
                $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/setup2.a: $(OBJ)/prompter.a $(OBJ)/setup2.a $(OBJ)/stoget.a\
                $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/setup3.a: $(OBJ)/prompter.a $(OBJ)/setup3.a $(OBJ)/setup.a\
                 $(OBJ)/stoget.a $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/stagsmodel.a: $(OBJ)/prompter.a $(OBJ)/stagfe.a \
                     $(OBJ)/stoget.a   $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/stagsunit.a: $(OBJ)/prompter.a $(OBJ)/stagun.a \
                    $(OBJ)/stoget.a   $(OBJ)/util.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/store.a: $(OBJ)/prompter.a $(OBJ)/stoget.a $(OBJ)/store.a\
                $(OBJ)/util.a     $(OBJ)/conman.a
	csh $(BIN)/updatelib $@ $?

$(LIB)/zeritr.a: $(OBJ)/stoget.a $(OBJ)/zeritr.a
		 csh $(BIN)/updatelib $@ $?

# Update object archives...

$(OBJ)/ads.a: $(SRC)/ads.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/arrays.a: $(SRC)/arrays.src
	csh $(BIN)/updateobj $(FC) "$(OPTFFLAGS)" $? $@

$(OBJ)/b4read.a: $(SRC)/b4read.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/begin.a: $(SRC)/begin.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/bospan.a: $(SRC)/bospan.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/bospn2.a: $(SRC)/bospn2.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/bospn3.a: $(SRC)/bospn3.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/buckle.a: $(SRC)/buckle.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS0)" $? $@

$(OBJ)/bucpan1.a: $(SRC)/bucpan1.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/bucpan2.a: $(SRC)/bucpan2.src
	csh $(BIN)/updateobj $(FC) "$(OPTFFLAGS)" $? $@

$(OBJ)/change.a: $(SRC)/change.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/chauto.a: $(SRC)/chauto.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/chplot.a: $(SRC)/chplot.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/chtemp.a: $(SRC)/chtemp.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/conman.a: $(SRC)/conman.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/decide.a: $(SRC)/decide.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/eband2.a: $(SRC)/eband2.src
	csh $(BIN)/updateobj $(FC) "$(OPTFFLAGS)" $? $@

$(OBJ)/forces.a: $(SRC)/forces.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

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

$(OBJ)/getcij.a: $(SRC)/getcij.src
	csh $(BIN)/updateobj $(FC) "$(OPTFFLAGS)" $? $@

$(OBJ)/getplot.a: $(SRC)/getplot.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/globst.a: $(SRC)/globst.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/glbst2.a: $(SRC)/glbst2.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/glbst3.a: $(SRC)/glbst3.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/helpan.a: $(SRC)/helpan.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/koiter.a: $(SRC)/koiter.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/koiter2.a: $(SRC)/koiter2.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/main.a: $(SRC)/main.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/mainsetup.a: $(SRC)/mainsetup.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/mode.a: $(SRC)/mode.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/newtpn.a: $(SRC)/newtpn.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/pancom.a: $(SRC)/pancom.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/prompter.a: $(SRC)/prompter.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/rfive.a: $(SRC)/rfive.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/setup.a: $(SRC)/setup.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/setup2.a: $(SRC)/setup2.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/setup3.a: $(SRC)/setup3.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/smrcij.a: $(SRC)/smrcij.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/stagfe.a: $(SRC)/stagfe.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/stagun.a: $(SRC)/stagun.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/stoget.a: $(SRC)/stoget.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/store.a: $(SRC)/store.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/strain.a: $(SRC)/strain.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/struct.a: $(SRC)/struct.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS0)" $? $@

$(OBJ)/triang.a: $(SRC)/triang.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/util.a: $(SRC)/util.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(OBJ)/zeritr.a: $(SRC)/zeritr.src
		 csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(B4OBJ)/felippa.a: $(B4SRC)/felippa.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(B4OBJ)/geom.a: $(B4SRC)/geom.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(B4OBJ)/prompter.a: $(B4SRC)/prompter.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(B4OBJ)/rzlg.a: $(B4SRC)/rzlg.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(B4OBJ)/stoget.a: $(B4SRC)/stoget.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(B4OBJ)/wall.a: $(B4SRC)/wall.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS)" $? $@

$(B4OBJ)/util.a: $(B4SRC)/util.src
	csh $(BIN)/updateobj $(FC) "$(FFLAGS) -e" $? $@

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
