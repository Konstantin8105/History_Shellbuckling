#
# optimize.bat

set case = $1
echo ""
echo "Running GENOPT: optimize, case: $case"
echo ""
'rm' ${case}.OPM >& /dev/null
'rm' ${case}.ERR >& /dev/null
'rm' ${case}.WAV >& /dev/null
'rm' ${case}.BLK >& /dev/null
'rm' ${case}.OUT >& /dev/null
'rm' ${case}.LAB >& /dev/null
'rm' ${case}.PLT2 >& /dev/null
'rm' ${case}.ALL >& /dev/null
'rm' ${case}.RES >& /dev/null
'rm' ${case}.DOC >& /dev/null
'rm' ${case}.RAN >& /dev/null
if (-e PROMPT4.DAT) 'rm' PROMPT4.DAT
if (-e PROMPT.DAT) 'rm' PROMPT.DAT
if (-e PROMPT2.DAT) 'rm' PROMPT2.DAT
if (-e PROMPT3.DAT) 'rm' PROMPT3.DAT
if (-e URPROMPT.DAT) 'rm' URPROMPT.DAT
ln -s ${case}.RAN fort.11
ln -s ${case}.NAM fort.12
ln -s ${case}.RAN ftn11
ln -s ${case}.NAM ftn12
if ($cwd == ${GENOPT}) then
   echo "GENOPT= ${GENOPT}"
   echo "case  = ${case}"
   echo "Bad error: about to copy to self."
   exit 1
endif
cp ${GENOPT}/execute/PROMPT4.DAT .
cp ${GENOPT}/execute/PROMPT.DAT . 
cp ${GENOPT}/execute/PROMPT2.DAT . 
cp ${GENOPT}/execute/PROMPT3.DAT . 
cp ${GENOPT}/execute/URPROMPT.DAT . 
#ln -s ${GENOPT}/execute GENOPT
echo  Executing optimize
#exit 99
./optimize.${MACHINE}  >! tempfile
set stat = $status
if ($stat == 0) then
   echo  Normal termination: optimize
else
   echo  Abnormal termination: optimize
   echo  "Exit status: $stat"
   exit 2
   goto nearend
endif

cat ${case}.OPT ${case}.OPM >! ${case}.TOT
mv ${case}.TOT ${case}.OPM

echo  Executing store
#exit 99
./store.${MACHINE}
set stat = $status
if ($stat == 0) then
   echo  Normal termination: store
else
   echo  Abnormal termination: store
   echo  "Exit status: $stat"
   exit 2
endif
#cp ${case}.PL2 ${case}.PL1
echo ""
echo "Job finished."
echo "Inspect the output files ${case}.OPM ${case}.OPP"
echo ""
echo "Menu: chooseplot, change, mainsetup, optimize, helpg"
echo ""
nearend:
#/bin/rm GENOPT >>& /dev/null
/bin/rm fort.* ftn* >>& /dev/null	
if (-e PROMPT4.DAT) 'rm' PROMPT4.DAT
if (-e PROMPT.DAT) 'rm' PROMPT.DAT
if (-e PROMPT2.DAT) 'rm' PROMPT2.DAT
if (-e PROMPT3.DAT) 'rm' PROMPT3.DAT
if (-e URPROMPT.DAT) 'rm' URPROMPT.DAT
if (-e ${case}.RAN) 'rm' ${case}.RAN
# end of script
