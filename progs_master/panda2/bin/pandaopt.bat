#
# pandaopt.bat
# This program controls the execution of the panda2 optimizer.
# It is assumed that all of the interactive input data
# have been stored on a file called {casename}.OPT.

set case = $1
echo ""
echo "Running PANDA2: pandaopt, case: $case"
echo ""
'rm' ${case}.OPM >& /dev/null
'rm' ${case}.ERR >& /dev/null
if (-e PROMPT.DAT) 'rm' PROMPT.DAT
if (-e TUTORMAIN.DAT) 'rm' TUTORMAIN.DAT

if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.main$$
# assign -a ${case}.RN1 fort.11
# assign -a ${case}.RN2 fort.10
  'cp' ${case}.RN2 fort.10
  'cp' ${case}.RN1 fort.11
  assign -a ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
  assign -a ${PANDA2}/execute/TUTORMAIN.DAT TUTORMAIN.DAT
else
  'rm' fort.* FOR0* >& /dev/null
  ln -s ${case}.RN2 fort.10 
  ln -s ${case}.RN1 fort.11 
  ln -s ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
  ln -s ${PANDA2}/execute/TUTORMAIN.DAT TUTORMAIN.DAT
endif

echo  Executing main
#${PANDA2}/execute/main.${MACHINE} $case < ${case}.OPT 
${PANDA2}/execute/main.${MACHINE} $case < ${case}.OPT >& ${case}.ERR
#ddd ${PANDA2}/execute/main.${MACHINE} $case
#exit 99
set stat = $status
if ($stat == 0) then
   echo  Normal termination: main
   echo  still processing... Please wait.
else
   echo  Abnormal termination: main
   echo  "Exit status: $stat"
   exit $stat
endif
cat ${case}.OPT ${case}.OPM > ${case}.TOT
'mv' ${case}.TOT ${case}.OPM
if ($MACHINE == "cray") then
  'mv' fort.10 ${case}.RN2
  'mv' fort.11 ${case}.RN1
# 'rm' ${case}.ERR >& /dev/null
  'rm' -f $FILENV
  unsetenv FILENV
else
  'rm' fort.* FOR0* >& /dev/null
  'rm' ${case}.ERR >& /dev/null
endif
#prof -x ${PANDA2}/execute/main.cray >! main.prof
#exit 1

# Commented out Feb. 1991
#/bin/rm ${case}.OPP ${case}.OPI >& /dev/null
# End Feb. 1991

if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.main$$
  assign -a ${case}.NAM fort.10
else
  ln -s ${case}.NAM fort.10
  ln -s ${case}.NAM FOR010
  ln -s ${case}.NAM FOR010.DAT
endif

echo  Executing store
#exit 99
${PANDA2}/execute/store.${MACHINE} $case
set stat = $status
if ($stat == 0) then
   echo  Normal termination: store
   echo  still processing... Please wait.
else
   echo  Abnormal termination: store
   echo  "Exit status: $stat"
   exit $stat
endif
# Commmented out Feb. 1991
#cp ${case}.PLD ${case}.PL2
# End Feb. 1991
if ($MACHINE == "cray") then
  'rm' -f $FILENV
else
  'rm' fort.* FOR0* >& /dev/null
  'rm' *.DAT >& /dev/null
endif

echo "${case} mainprocessor run completed successfully."
echo "Menu: PANDAOPT, CHOOSEPLOT, MAINSETUP, CHANGE"
echo "Please examine the files: ${case}.OPM, ${case}.OPP, and ${case}.OPI"
echo "If ITYPE=1, print the file called ${case}.OPP"
echo "If ITYPE=3 or 4, print the file called ${case}.OPI"
echo "Run PANDAOPT several times for optimization."
echo ""

