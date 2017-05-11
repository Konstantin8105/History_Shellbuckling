#
# panda2.com:  This script sets up the panda2 aliases and gives preliminary
# instructions for panda2 user.

set BIN = ${PANDA2}/bin

alias a alias
a helpan      ${BIN}/helpan.com
a begin       ${BIN}/begin.com
a decide      ${BIN}/decide.com
a setup       ${BIN}/setup.com
a mainsetup   ${BIN}/mainsetup.com
a pandaopt    ${BIN}/pandaopt.com
a superopt    ${BIN}/superopt.com
# beg July 8, 2011
a superduperopt    ${BIN}/superduperopt.com
# end July 8, 2011
a change      ${BIN}/change.com
a autochange  ${BIN}/autochange.com
a chooseplot  ${BIN}/chooseplot.com
a diplot      ${BIN}/diplot.com
a choosetemp  ${BIN}/choosetemp.com
a panel       ${BIN}/panel.com
a panel2      ${BIN}/panel2.com
a panel3      ${BIN}/panel3.com
a stagsmodel  ${BIN}/stagsmodel.com
a stagsunit   ${BIN}/stagsunit.com
a cleanpan    ${BIN}/cleanpan.com

a HELPAN      ${BIN}/helpan.com
a BEGIN       begin
a DECIDE      decide
a SETUP       setup
a MAINSETUP   mainsetup
a PANDAOPT    pandaopt
a SUPEROPT    superopt
a SUPERDUPEROPT  superduperopt
a CHANGE      change
a AUTOCHANGE  autochange
a CHOOSEPLOT  chooseplot
a DIPLOT      diplot
a CHOOSETEMP  choosetemp
a PANEL       panel
a PANEL2      panel2
a PANEL3      panel3
a STAGSMODEL  stagsmodel
a STAGSUNIT   stagsunit
a CLEANPAN    cleanpan
unalias a

echo ""
echo "PANDA2 commands have been activated."
echo ""
echo "PANDA2 commands are:"
#echo "helpan    - get information on Panda2"
echo "begin      - you provide a starting design, material properties, boundary conditions"
echo "choosetemp - choose temparature dependence"
echo "setup      - PANDA2 generates BOSOR4-type matrix skylines for use by PANDA2"
echo "decide     - you choose decision variables, lower and upper bounds, linking relationships"
echo "mainsetup  - you provide loading, imperfection amplitudes, fact.of safety, analysis type, strategy"
echo "pandaopt   - launch run of mainprocessor for a single set of design iterations"
echo "superopt   - launch run for multiple sets of design iterations (obtain a global optimum design)"
echo "superduperopt - launch run for automatic multiple sequential executions of SUPEROPT"
echo "change     - assign new values to parameters (or save an optimum design)"
echo "autochange - assign new vector of decision variables randomly (used in the superopt process)"
echo "chooseplot - choose which variables/margins to plot"
echo "diplot     - generate & print PostScript file containing plots"
echo "panel      - generate BOSOR4 input for a skin-stringer multi-module model"
echo "panel2     - generate BOSOR4 input for a skin-ring multi-module model"
echo "panel3     - generate BOSOR4 input for a skin-stringer + weld land multi-module model"
echo "stagsmodel - generate STAGS input for panel (element unit, no rings)"
echo "stagsunit  - generate STAGS input for panel (shell units, both rings and stringers permitted)"
echo "cleanpan   - delete temporary case-specific files"
echo ""
echo " A typical PANDA2 runstream is:"
echo "   begin"
echo "   setup"
echo "   decide"
echo "   mainsetup"
echo "   superopt  (or pandaopt)"
echo "   (several more pandaopts if the previous command is not superopt)"
echo "   chooseplot"
echo "   diplot"
echo "   change"
echo "   superopt or pandaopt or superduperopt"
echo "   etc."
echo "   cleanpan"
echo ""
echo "Please consult the files in .../panda2/doc for more information about PANDA2."
echo "Also review the sample cases in .../panda2/case."
echo "Also read the published papers listed in the file .../panda2/doc/panda2.ref."
echo "The file, .../panda2/doc/panda2.news contains updates and comments since 1987."
echo "Useful annotation appears in the *.OPM file when NPRINT = 2 in the *.OPT file."
echo ""
echo "USEFUL HINT PERTAINING TO THE INTERACTIVE INPUT YOU SHOULD PROVIDE DURING 'mainsetup':"
echo " After you type the command, 'mainsetup', try just hitting ENTER to obtain the default value"
echo " of any data entry that you are unsure about. PANDA2 will provide what its developer"
echo " usually chooses. Generally use 5 iterations/pandaopt; Generally use NPRINT = 0;"
echo " Generally use 'superopt'; Generally choose 5 pandaopts per autochange for superopt runs."
echo ""
echo "USEFUL HINT FOR SAVING OPTIMUM DESIGNS FOR FUTURE RUNS:"
echo " Once you have obtained a global optimum design that you are happy with, execute the"
echo " process called 'change' in order to save this global optimum design in a file called *.CHG"
echo " Then the global optimum design will be preserved in the *.CHG file after execution of 'cleanpan'."
echo " You can then execute 'change' immediately following 'begin' in order to re-establish"
echo " that same global optimum design at any time in the future."
echo ""
echo "FILES THAT ARE PRESERVED FOLLOWING EXECUTION OF THE COMMAND, 'cleanpan':"
echo " *.BEG (from 'begin'), *.DEC (from 'decide'), *.OPT (from 'mainsetup'), *.CHG (from 'change')"
echo " *.CPL (from 'chooseplot'), *.PAN (from 'panel' or 'panel2'), *.STG (from 'stagsunit'"
echo " or from 'stagsmodel'). These preserved files are valid input for the interactive processors,"
echo " begin, decide, mainsetup, change, chooseplot, panel or panel2, stagsunit or stagsmodel,"
echo " respectively."
# Add the user's name to the user.list file at the top level
# directory.  This is done so that an administrator can keep track of
# who uses what program, etc. so that he/she might notify these users of
# upgrades and changes.
if (-e ${BUSHNELL}/user.list) then
  echo -n "${USER}@" >> ${BUSHNELL}/user.list
  echo -n "`hostname` " >> ${BUSHNELL}/user.list
  echo -n "$MACHINE " >> ${BUSHNELL}/user.list
  echo -n "PANDA2 " >> ${BUSHNELL}/user.list
  echo  "`date`" >> ${BUSHNELL}/user.list
endif
