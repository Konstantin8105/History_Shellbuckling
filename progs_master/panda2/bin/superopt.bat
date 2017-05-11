# 
# superopt.bat: Performs multiple execution of 
# combinations of (autochange,setup,decide,pandaopt,pandaopt,pandaopt...)
#
set case = $1
@ pandaopts = `echo $2`
echo "Number of pandaopts for each autochange= $pandaopts"
# begin July 19, 2011
# zeritr
# This program resets the total number of iterations to zero.
# There are no input data.
echo ""
echo "Running GENOPT: zeritr, case: $case"
echo ""
'rm' fort.* FOR0*     >>& /dev/null
'rm' ${case}.ERR >>& /dev/null
echo "----------------------------"
echo  Executing zeritr
ln -s ${case}.NAM fort.12
ln -s ${case}.NAM ftn12
${PANDA2}/execute/zeritr.${MACHINE} $case
set stat = $status
echo "----------------------------"
if ($stat == 0) then
   echo  Normal termination: zeritr
   echo  still processing... Please wait.
else
   echo  Abnormal termination: zeritr
   echo  "Exit status: $stat"
  'rm' fort.* ftn* >>& /dev/null
   exit 1
   goto nearend
endif
# end July 19, 2011
@ count = 0
goto start0
start:
@ count = $count + 1
echo -n " Loop thru autochange $count"
# autochange
# This program automatically changes the decision variables x(i).
echo ""
echo "Running PANDA2: autochange, case: $case"
echo ""
'rm' fort.* FOR0*     >>& /dev/null
'rm' ${case}.ERR >>& /dev/null
if (-e PROMPT.DAT) 'rm' PROMPT.DAT
if (-e PROMPT2.DAT) 'rm' PROMPT2.DAT
if (-e PROMPT3.DAT) 'rm' PROMPT3.DAT

if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.autochange$$
  assign -a ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
else
  ln -s ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
endif

echo "----------------------------"
echo  Executing autochange
${PANDA2}/execute/autochange.${MACHINE} $case
set stat = $status
#echo "----------------------------"
if ($stat == 0) then
#  echo  Normal termination: autochange
#  echo  still processing... Please wait.
else
   echo  Abnormal termination: autochange
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null	
  'rm' PROMPT*.DAT >>& /dev/null
   exit 1
endif
#
start0:
#
# setup.com
# This program controls the execution of the panda2 pre-processor.
#echo ""
#echo "Running PANDA2: setup, case: $case"
#echo ""
'rm' fort.* FOR0*     >>& /dev/null
'rm' ${case}.ERR >>& /dev/null
if (-e PROMPT.DAT) 'rm' PROMPT.DAT
if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.setup$$
  assign -a ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
else
  ln -s ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
endif
#echo "----------------------------"
echo  Executing setup
${PANDA2}/execute/setup.${MACHINE} $case
set stat = $status
#echo "----------------------------"
if ($stat == 0) then
#  echo  Normal termination: setup
#  echo  still processing... Please wait.
else
   echo  Abnormal termination: setup
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null	
  'rm' PROMPT*.DAT >>& /dev/null
   exit 1
endif
#echo "----------------------------"
echo  Executing setup2
${PANDA2}/execute/setup2.${MACHINE} $case
set stat = $status
#echo "----------------------------"
if ($stat == 0) then
#  echo  Normal termination: setup2
#  echo  still processing... Please wait.
else
   echo  Abnormal termination: setup2
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null	
  'rm' PROMPT*.DAT >>& /dev/null
   exit 1
endif
#echo "----------------------------"
if ($MACHINE == "cray") then
  assign -a ${BOSOR4}/execute/PROMPT.DAT PROMPT.DAT
  assign -a ${BOSOR4}/execute/PROMPT2.DAT PROMPT2.DAT
  assign -a ${BOSOR4}/execute/PROMPT3.DAT PROMPT3.DAT
else
  ln -s ${case}.RN1 fort.11 
  'rm' PROMPT.DAT
  ln -s ${BOSOR4}/execute/PROMPT.DAT PROMPT.DAT
  ln -s ${BOSOR4}/execute/PROMPT2.DAT PROMPT2.DAT
  ln -s ${BOSOR4}/execute/PROMPT3.DAT PROMPT3.DAT
endif
echo  Executing pandaread - 1st pass
set pass = 1
${PANDA2}/execute/pandaread.${MACHINE} $case $pass < ${case}.ALL \
   > $case.ERR
set stat = $status
if ($stat == 0) then
#  echo  Normal termination: pandaread 1
#  echo  Skin-stringer panel module templates finished.
#  echo  still processing... Please wait.
#  'rm' $case.ERR
else
   echo  Abnormal termination: pandaread 1
   echo  Skin-stringer panel module templates NOT finished.
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null	
  'rm' PROMPT*.DAT >>& /dev/null
   exit 1
endif
if ($MACHINE == "cray") then
  'mv' fort.11 ${case}.RN1
else
  'rm' fort.11 FOR011 >& /dev/null
endif
#echo "----------------------------"
if ($MACHINE == "cray") then
else
  ln -s ${case}.RN2 fort.11 
endif
echo  Executing pandaread - 2nd pass
set pass = 2
${PANDA2}/execute/pandaread.${MACHINE} $case $pass < ${case}.BOS \
   >> $case.ERR
set stat = $status
if ($stat == 0) then
#  echo  Normal termination: pandaread 2
#  echo  Entire smeared panel templates finished.
#  echo  still processing... Please wait.
#  'rm' $case.ERR
else
   echo  Abnormal termination: pandaread 2
   echo  Smeared panel templates NOT finished.
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null	
  'rm' PROMPT*.DAT >>& /dev/null
   exit 2
endif
#echo "----------------------------"
echo  Executing globst
${PANDA2}/execute/globst.${MACHINE} $case < ${case}.BOS >> $case.ERR
set stat = $status
if ($stat == 0) then
#  echo  Normal termination: globst
#  echo  Global model common blocks stored.
   'rm' $case.ERR
else
   echo  Abnormal termination: globst
   echo  Global model common blocks NOT stored.
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null	
  'rm' PROMPT*.DAT >>& /dev/null
   exit 3
endif
#echo "----------------------------"
if ($MACHINE == "cray") then
  'mv' fort.11 ${case}.RN2
else
  'rm' fort.11 FOR011 >& /dev/null
endif
#echo "----------------------------"
if ($MACHINE == "cray") then
else
  ln -s ${case}.RN3 fort.11 
endif
echo  Executing pandaread - 3rd pass
set pass = 3
${PANDA2}/execute/pandaread.${MACHINE} $case $pass < ${case}.AL2 \
   > $case.ERR
set stat = $status
if ($stat == 0) then
#  echo  Normal termination: pandaread 3
#  echo  skin-ring panel module templates finished.
#  echo  still processing... Please wait.
#  'rm' $case.ERR
else
   echo  Abnormal termination: pandaread 3
   echo  skin-ring panel module templates NOT finished.
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null	
  'rm' PROMPT*.DAT >>& /dev/null
   exit 4
endif
#echo "----------------------------"
echo  Executing glbst2
${PANDA2}/execute/glbst2.${MACHINE} $case < ${case}.AL2 >> $case.ERR
#xdb ${PANDA2}/execute/glbst2.${MACHINE}
set stat = $status
if ($stat == 0) then
#  echo  Normal termination: glbst2
#  echo  skin-ring panel module common blocks stored.
   'rm' case.ERR
else
   echo  Abnormal termination: glbst2
   echo  skin-ring panel module common blocks NOT stored.
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null	
  'rm' PROMPT*.DAT >>& /dev/null
   exit 5
endif
#echo "----------------------------"
if ($MACHINE == "cray") then
  'mv' fort.11 ${case}.RN3
  'rm' -f $FILENV
else
  'rm' fort.* >>& /dev/null	
  'rm' PROMPT*.DAT >>& /dev/null
endif
echo "Pandaread pre-processor complete."
#
# pandaopt.bat
# This program controls the execution of the panda2 optimizer.
# It is assumed that all of the interactive input data
# have been stored on a file called {casename}.OPT.
@ countp = 0
pandaloop:
@ countp = $countp + 1
#echo ""
echo "Running PANDA2: pandaopt, case: $case"
#echo ""
'rm' ${case}.OPM >& /dev/null
'rm' ${case}.ERR >& /dev/null
if (-e PROMPT.DAT) 'rm' PROMPT.DAT
if (-e TUTORMAIN.DAT) 'rm' TUTORMAIN.DAT
if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.main$$
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
${PANDA2}/execute/main.${MACHINE} $case < ${case}.OPT >& ${case}.ERR
set stat = $status
if ($stat == 0) then
#  echo  Normal termination: main
#  echo  still processing... Please wait.
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
  'rm' -f $FILENV
  unsetenv FILENV
else
  'rm' fort.* FOR0* >& /dev/null
  'rm' ${case}.ERR >& /dev/null
endif
if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.main$$
  assign -a ${case}.NAM fort.10
else
  ln -s ${case}.NAM fort.10
  ln -s ${case}.NAM FOR010
  ln -s ${case}.NAM FOR010.DAT
endif
echo  Executing store
${PANDA2}/execute/store.${MACHINE} $case
set stat = $status
if ($stat == 0) then
#  echo  Normal termination: store
#  echo  still processing... Please wait.
else if ($stat == 2) then
   echo Maximum allowable number of design iterations reached.
   echo "Inspect ${case}.OPP and execute CHOOSEPLOT and DIPLOT next."
else
   echo  Abnormal termination: store
   echo  "Exit status: $stat"
   exit $stat
endif
if ($MACHINE == "cray") then
  'rm' -f $FILENV
else
  'rm' fort.* FOR0* >& /dev/null
  'rm' *.DAT >& /dev/null
endif
echo "${case} mainprocessor run completed successfully."
echo ""
if ($stat == 2) then
   goto nearend
endif
if ($countp == $pandaopts) then
   echo "Number of executions of pandaopt for each execution of autochange"
   echo "equals that specified by user. Next, execute autochange again."
   goto start
else
   echo "Number of executions of pandaopt since last autochange= $countp"
   goto pandaloop
endif
nearend:
