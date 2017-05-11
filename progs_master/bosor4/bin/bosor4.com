#
# THIS IS THE BOSOR4 COM FILE...

set BIN = ${BOSOR4}/bin

alias a alias
a  help4      ${BIN}/help4.com
a  input      ${BIN}/input.com
a  assemble   ${BIN}/assemble.com
a  bosorall   ${BIN}/bosorall.com
a  bosorplot  ${BIN}/bosorplot.com
a  resetup    ${BIN}/resetup.com
a  restart    ${BIN}/restart.com
a  cleanup    ${BIN}/cleanup.com
a  getsegs    ${BIN}/getsegs.com
a  modify     ${BIN}/modify.com

a  HELP4      ${BIN}/help4.com
a  INPUT      input
a  ASSEMBLE   assemble
a  BOSORALL   bosorall
a  BOSORPLOT  bosorplot
a  RESETUP    resetup
a  RESTART    restart
a  CLEANUP    cleanup
a  GETSEGS    getsegs
a  MODIFY     modify
unalias a

   echo    ""
   echo   BOSOR4 COMMANDS HAVE BEEN ACTIVATED.
   echo    ""
   echo  The BOSOR4 commands, in the general order in which
   echo  you would probably use them, are:
   echo    ""
   echo    "help4		(get information on BOSOR4.)"
   echo    "input		(you provide segment-by-seg. input)"
   echo    "assemble	(concatenates segment data files)"
   echo    "bosorall	(batch run of pre, main, post proc.)"
   echo    "bosorplot	(batch run for generating plot files)"
   echo    "resetup		(input for restart run, same model)"
   echo    "restart		(batch run of main & postprocessors)"
   echo    "cleanup		(delete all except for .DOC file)"
   echo    "getsegs		(generate segment files from .DOC)"
   echo    "modify		(modify a segment file)"
   echo    ""
   echo  Please consult the following sources for more
   echo  information about BOSOR4:
   echo    ""
   echo    "1.  help4 file	(type help4)"
   echo    "2.  bosor4st.ory	(good idea to print this file)"
   echo    "3.  b4unix.doc	(supplement to bosor4st.ory for UNIX version)"
   echo    "4.  Documents listed under HELP4 OVERVIEW DOC"
echo ""

# Add the user's name to the user.list file at the top level
# directory.  This is done so that an administrator can keep track of
# who uses what program, etc. so that he/she might notify these users of
# upgrades and changes.
if (-e ${BUSHNELL}/user.list) then
  echo -n "${USER}@" >> ${BUSHNELL}/user.list
  echo -n "`hostname` " >> ${BUSHNELL}/user.list
  echo -n "$MACHINE " >> ${BUSHNELL}/user.list
  echo -n "BOSOR4 " >> ${BUSHNELL}/user.list
  echo  "`date`" >> ${BUSHNELL}/user.list
endif
