#
# setup.com
# This program controls the execution of the panda2 pre-processor.
# It is assumed that all of the interactive input data
# have been stored on a file called {casename}.ALL.

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
