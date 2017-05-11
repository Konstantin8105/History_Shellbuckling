#
# pandaopt.bat
# This program controls the execution of the panda2 optimizer.
# It is assumed that all of the interactive input data
# have been stored on a file called {casename}.OPT.

set case = $1
echo ""
echo "Running PANDA2: pandaxdb, case: $case"
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

