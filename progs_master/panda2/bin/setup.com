#
# setup.com
# This program controls the execution of the panda2 pre-processor.
# It is assumed that all of the interactive input data
# have been stored on files called:
# {casename}.ALL = skin-stringer module {casename}.RN1 (setup,pandaread(1))
# {casename}.BOS = entire panel width with smeared stringers
#                                       {casename}.RN2 (setup,pandaread(2),globst)
# {casename}.AL2 = "skin"-ring   module {casename}.RN3 (setup2,pandaread(3),glbst2)
# {casename}.AL3 = skin-substringer module {casename}.RN4 (setup3,pandaread(4))

echo -n  "Enter case name: "
set case = $<
echo ""
echo "Running PANDA2: setup, case: $case"
echo ""
'rm' fort.* FOR0*     >>& /dev/null
'rm' ${case}.ERR >>& /dev/null
if (-e PROMPT.DAT) 'rm' PROMPT.DAT
if (-e PROMPT2.DAT) 'rm' PROMPT2.DAT
if (-e PROMPT3.DAT) 'rm' PROMPT3.DAT
if (-e $case.RN1) 'rm' $case.RN1
if (-e $case.RN2) 'rm' $case.RN2
if (-e $case.RN3) 'rm' $case.RN3
if (-e $case.RN4) 'rm' $case.RN4
if (-e $case.DOC) 'rm' $case.DOC
if (-e $case.OUT) 'rm' $case.OUT
 
if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.setup$$
  assign -a ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
else
  ln -s ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
endif

echo "----------------------------"
echo  Executing setup
${PANDA2}/execute/setup.${MACHINE} $case
set stat = $status
echo "----------------------------"
if ($stat == 0) then
   echo  Normal termination: setup
   echo  still processing... Please wait.
else
   echo  Abnormal termination: setup
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null	
  'rm' PROMPT*.DAT >>& /dev/null
   exit 1
endif

echo "----------------------------"
echo  Executing setup2
${PANDA2}/execute/setup2.${MACHINE} $case
set stat = $status
echo "----------------------------"
if ($stat == 0) then
   echo  Normal termination: setup2
   echo  still processing... Please wait.
else
   echo  Abnormal termination: setup2
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null	
  'rm' PROMPT*.DAT >>& /dev/null
   exit 1
endif

echo "----------------------------"
echo  Executing setup3
${PANDA2}/execute/setup3.${MACHINE} $case
set stat = $status
echo "----------------------------"
if ($stat == 0) then
   echo  Normal termination: setup3
   echo  still processing... Please wait.
else
   echo  Abnormal termination: setup3
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null
  'rm' PROMPT*.DAT >>& /dev/null
   exit 1
endif

echo "----------------------------"
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
echo  Executing pandaread - 1st pass | tee -a $case.ERR
set pass = 1
${PANDA2}/execute/pandaread.${MACHINE} $case $pass < ${case}.ALL \
   >> $case.ERR
#xdb ${PANDA2}/execute/pandaread.${MACHINE}
set stat = $status
if ($stat == 0) then
   echo  Normal termination: pandaread 1
   echo  Skin-stringer panel module templates finished.
   echo  still processing... Please wait.
#   'rm' $case.ERR
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

echo "----------------------------"
if ($MACHINE == "cray") then
else
  ln -s ${case}.RN2 fort.11 
endif
echo  Executing pandaread - 2nd pass | tee -a $case.ERR
set pass = 2
${PANDA2}/execute/pandaread.${MACHINE} $case $pass < ${case}.BOS \
   >> $case.ERR
set stat = $status
if ($stat == 0) then
   echo  Normal termination: pandaread 2
   echo  Entire smeared panel templates finished.
   echo  still processing... Please wait.
#   'rm' $case.ERR
else
   echo  Abnormal termination: pandaread 2
   echo  Smeared panel templates NOT finished.
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null	
  'rm' PROMPT*.DAT >>& /dev/null
   exit 2
endif

echo "----------------------------"
echo  Executing globst | tee -a $case.ERR
${PANDA2}/execute/globst.${MACHINE} $case < ${case}.BOS >> $case.ERR
#xdb ${PANDA2}/execute/globst.${MACHINE}
set stat = $status
if ($stat == 0) then
   echo  Normal termination: globst
   echo  Global model common blocks stored.
   'rm' $case.ERR
else
   echo  Abnormal termination: globst
   echo  Global model common blocks NOT stored.
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null	
  'rm' PROMPT*.DAT >>& /dev/null
   exit 3
endif

echo "----------------------------"

if ($MACHINE == "cray") then
  'mv' fort.11 ${case}.RN2
else
  'rm' fort.11 FOR011 >& /dev/null
endif

echo "----------------------------"
if ($MACHINE == "cray") then
else
  ln -s ${case}.RN3 fort.11 
endif
echo  Executing pandaread - 3rd pass | tee -a $case.ERR
set pass = 3
${PANDA2}/execute/pandaread.${MACHINE} $case $pass < ${case}.AL2 \
   >> $case.ERR
set stat = $status
if ($stat == 0) then
   echo  Normal termination: pandaread 3
   echo  skin-ring panel module templates finished.
   echo  still processing... Please wait.
#   'rm' $case.ERR
else
   echo  Abnormal termination: pandaread 3
   echo  skin-ring panel module templates NOT finished.
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null	
  'rm' PROMPT*.DAT >>& /dev/null
   exit 4
endif

echo "----------------------------"
echo  Executing glbst2 | tee -a $case.ERR
${PANDA2}/execute/glbst2.${MACHINE} $case < ${case}.AL2 >> $case.ERR
#xdb ${PANDA2}/execute/glbst2.${MACHINE}
set stat = $status
if ($stat == 0) then
   echo  Normal termination: glbst2
   echo  skin-ring panel module common blocks stored.
   'rm' $case.ERR
else
   echo  Abnormal termination: glbst2
   echo  skin-ring panel module common blocks NOT stored.
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null	
  'rm' PROMPT*.DAT >>& /dev/null
   exit 5
endif

echo "----------------------------"

if ($MACHINE == "cray") then
  'mv' fort.11 ${case}.RN3
  'rm' -f $FILENV
else
  'rm' fort.* >>& /dev/null	
endif

echo "----------------------------"
if ($MACHINE == "cray") then
else
  ln -s ${case}.RN4 fort.11
endif
echo  Executing pandaread - 4th pass | tee -a $case.ERR
set pass = 4
${PANDA2}/execute/pandaread.${MACHINE} $case $pass < ${case}.AL3 \
   >> $case.ERR
set stat = $status
if ($stat == 0) then
   echo  Normal termination: pandaread 4
   echo  skin-substringer panel module templates finished.
   echo  still processing... Please wait.
#   'rm' $case.ERR
else
   echo  Abnormal termination: pandaread 4
   echo  skin-substringer panel module templates NOT finished.
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null
  'rm' PROMPT*.DAT >>& /dev/null
   exit 6
endif

echo "----------------------------"
echo  Executing glbst3 | tee -a $case.ERR
${PANDA2}/execute/glbst3.${MACHINE} $case < ${case}.AL3 >> $case.ERR
#xdb ${PANDA2}/execute/glbst3.${MACHINE}
set stat = $status
if ($stat == 0) then
   echo  Normal termination: glbst3
   echo  skin-substringer panel module common blocks stored.
   'rm' $case.ERR
else
   echo  Abnormal termination: glbst3
   echo  skin-substringer panel module common blocks NOT stored.
   echo  "Exit status: $stat"
  'rm' fort.* >>& /dev/null
  'rm' PROMPT*.DAT >>& /dev/null
   exit 7
endif

if ($MACHINE == "cray") then
  'mv' fort.11 ${case}.RN4
  'rm' -f $FILENV
else
  'rm' fort.* >>& /dev/null
  'rm' PROMPT*.DAT >>& /dev/null
endif

echo "Pandaread pre-processor complete."
echo "Next give the command: DECIDE or MAINSETUP."

