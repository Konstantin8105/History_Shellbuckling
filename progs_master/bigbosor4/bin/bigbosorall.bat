#
# BIGBOSORALL BAT FILE...

# THIS PROCEDURE IS FOR INTERACTIVE EXECUTION OF BIGBOSOR4
# It is assumed that all of the interactive input data
# have been stored on a file called "NAME".ALL.

set case = $1
echo ""
echo "Running BIGBOSOR4: bigbosorall, case: $case"
echo ""
#'rm' ${case}.OPM >& /dev/null
'rm' ${case}.ERR >& /dev/null
'rm' ${case}.WAV >& /dev/null
'rm' ${case}.BLK >& /dev/null
'rm' ${case}.OUT >& /dev/null
'rm' ${case}.LAB >& /dev/null
#'rm' ${case}.PLT2 >& /dev/null
#'rm' ${case}.ALL >& /dev/null
#'rm' ${case}.RES >& /dev/null
'rm' ${case}.DOC >& /dev/null
'rm' ${case}.RAN >& /dev/null
/bin/rm fort.* FOR0* >>& /dev/null	
if (-e fort.11) then
  'rm' fort.11
endif
if (-e fort.12) then
  'rm' fort.12
endif
if (-e ${case}.r.ERR) then
  'rm' ${case}.r.ERR
endif
if (-e ${case}.m.ERR) then
  'rm' ${case}.m.ERR
endif
if (-e ${case}.p.ERR) then
  'rm' ${case}.p.ERR
endif
if (-e ${case}.OUT) then
  'rm' ${case}.OUT
endif
if (-e ${case}.LAB) then
  'rm' ${case}.LAB
endif
if (-e ${case}.PLT) then
  'rm' ${case}.PLT
endif
if (-e ${case}.BLK) then
  'rm' ${case}.BLK
endif
if (-e ${case}.RAN) then
  'rm' ${case}.RAN
endif

#if (!( -e ${case}.ALL)) then
#  if (-e ${case}.DOC) then
#    cp ${case}.DOC ${case}.ALL
#  else
#    echo "To run bosorall you need a ${case}.ALL or ${case}.DOC file."
#    exit 1
#  endif
#endif

if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.b4all$$
  assign -a ${BIGBOSOR4}/execute/PROMPT.DAT PROMPT.DAT
  assign -a ${BIGBOSOR4}/execute/PROMPT2.DAT PROMPT2.DAT
  assign -a ${BIGBOSOR4}/execute/PROMPT3.DAT PROMPT3.DAT
  if (-e ${case}.RAN) then
    'cp' ${case}.RAN fort.11
  endif
else
  ln -s ${case}.RAN fort.11 
  ln -s ${case}.NAM fort.12
  ln -s ${case}.NAM FOR012.DAT
  ln -s ${BIGBOSOR4}/execute/PROMPT.DAT PROMPT.DAT
  ln -s ${BIGBOSOR4}/execute/PROMPT2.DAT PROMPT2.DAT
  ln -s ${BIGBOSOR4}/execute/PROMPT3.DAT PROMPT3.DAT
endif

echo  Executing bigbosorall
#dbx -I ../dbx_sources ${BIGBOSOR4}/execute/bigbosor4.${MACHINE}
#exit 99
${BIGBOSOR4}/execute/bigbosor4.${MACHINE} $case >${case}.m.ERR
set stat = $status
if ($stat == 0) then
   echo  Normal termination: bigbosorall
else
   echo  Abnormal termination: bigbosorall
   echo  "Exit status: $stat"
   exit 2
endif
#prof -x ${BIGBOSOR4}/execute/bigbosor4.${MACHINE} >! main.prof

echo "Job finished."
echo "Inspect the output file ${case}.OUT"
echo ""
echo "Menu: bosorplot, resetup, cleanup, getsegs, modify, input, help4"
echo ""
#cat  ${case}.p.ERR   >>${case}.OUT

#'rm' -f ${case}.[rmp].ERR
if ($MACHINE == "cray") then
  'rm' -f $FILENV
  'mv' fort.11 ${case}.RAN
else
  'rm' -f {PROMPT,PROMPT2,PROMPT3}.DAT
  'rm' -f fort.* FOR0* 
endif

