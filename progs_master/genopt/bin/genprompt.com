#
# genopt.com - sets up aliases for GENOPT and gives the user some 
#              preliminary instructions.

set BIN = ${GENOPT}/bin
set EXE = ${GENOPT}/execute

alias a alias
a begin       ${BIN}/begin.com
a change      ${BIN}/change.com
a chooseplot  ${BIN}/chooseplot.com
a cleangen    ${BIN}/cleangen.com
a cleanspec   ${BIN}/cleanspec.com
a decide      ${BIN}/decide.com
a diplot      ${BIN}/diplot.com
a genprograms ${BIN}/genprograms.com
a gentext     ${BIN}/gentext.com
a getlib      ${BIN}/getlib.com
a helpg       ${BIN}/helpg.com
a insert      ${BIN}/insert.com
a mainsetup   ${BIN}/mainsetup.com
a optimize    ${BIN}/optimize.com
a autochange  ${BIN}/autochange.com
a superopt    ${BIN}/superopt.com
# beg July 8, 2011
a superduperopt    ${BIN}/superduperopt.com
# end July 8, 2011
a BEGIN       begin
a CHANGE      change
a CHOOSEPLOT  chooseplot
a CLEANGEN    cleangen
a CLEANSPEC   cleanspec
a DECIDE      decide
a DIPLOT      diplot
a GENPROGRAMS genprograms
a GENTEXT     gentext
a GETLIB      getlib
a HELPG       helpg
a INSERT      insert
a MAINSETUP   mainsetup
a OPTIMIZE    optimize
a AUTOCHANGE  autochange
a SUPEROPT    superopt
a SUPERDUPEROPT  superduperopt
unalias a

echo ""
echo "GENOPT commands have been activated."
echo ""
#echo "  helpg        get information on GENOPT"
echo "  gentext      GENOPT user generates a prompt file."
echo "  genprograms  GENOPT user generates (makes) executables:"
echo "               begin, decide, mainsetup, optimize,"
echo "               change, chooseplot, and diplot."
echo "  begin        End user provides starting data."
echo "  decide       End user chooses decision variables, bounds,"
echo "               linked variables, and inequality constraints."
echo "  mainsetup    End user sets up strategy parameters."
echo "  optimize     End user performs optimization."
echo "  change       End user changes some parameters."
echo "  autochange   New values for decision variables randomly"
echo "  superopt     End user find global optimum (autochange/optimize)..."
echo "  superduperopt     End user executes superopt/chooseplot x times..."
echo "  chooseplot   End user chooses which variable to plot vs."
echo "               iterations."
echo "  diplot       End user plots variables vs. iterations."
echo "  insert       GENOPT user adds parameters to the problem."
echo "  cleangen     GENOPT user cleans up GENeric case files."
echo "  cleanspec    End user cleans up SPECific case files."
echo ""
echo "Please consult the following sources for more about GENOPT:"
echo "  1.  genopt.story, howto.run, and genopt.news (in the"
echo "      .../genopt/doc directory)"
echo "  2.  Sample cases, plate.cas and panel.cas (in the"
echo "      .../genopt/case directory)"
echo "  3.  NAME.DEF file, where NAME is the generic case name."
echo '  4.  GENOPT.HLP file   (Type "helpg".)'
echo ""

# Add the user's name to the user.list file at the top level
# directory.  This is done so that an administrator can keep track of
# who uses what program, etc. so that he/she might notify these users of
# upgrades and changes.
if (-e ${BUSHNELL}/user.list) then
  echo -n "${USER}@" >> ${BUSHNELL}/user.list
  echo -n "`hostname` " >> ${BUSHNELL}/user.list
  echo -n "$MACHINE " >> ${BUSHNELL}/user.list
  echo -n "GENOPT " >> ${BUSHNELL}/user.list
  echo  "`date`" >> ${BUSHNELL}/user.list
endif
