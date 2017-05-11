#
# BOSORALL BAT FILE...

# THIS PROCEDURE IS FOR INTERACTIVE EXECUTION OF BOSOR4
# It is assumed that all of the interactive input data
# have been stored on a file called "NAME".ALL.

set case = $1
echo ""
echo "Running BOSOR4: bosorall, case: $case"
echo ""
if (-e fort.11) then
  'rm' fort.11
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

if (!( -e ${case}.ALL)) then
  if (-e ${case}.DOC) then
    cp ${case}.DOC ${case}.ALL
  else
    echo "To run bosorall you need a ${case}.ALL or ${case}.DOC file."
    exit 1
  endif
endif

if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.b4all$$
  assign -a ${BOSOR4}/execute/PROMPT.DAT PROMPT.DAT
  assign -a ${BOSOR4}/execute/PROMPT2.DAT PROMPT2.DAT
  assign -a ${BOSOR4}/execute/PROMPT3.DAT PROMPT3.DAT
  if (-e ${case}.RAN) then
    'cp' ${case}.RAN fort.11
  endif
else
  ln -s ${case}.RAN fort.11 
  ln -s ${BOSOR4}/execute/PROMPT.DAT PROMPT.DAT
  ln -s ${BOSOR4}/execute/PROMPT2.DAT PROMPT2.DAT
  ln -s ${BOSOR4}/execute/PROMPT3.DAT PROMPT3.DAT
endif

echo  Executing bosorread
#dbx -I ../dbx_sources ${BOSOR4}/execute/bosorread.${MACHINE}
#exit 99
${BOSOR4}/execute/bosorread.${MACHINE} $case < ${case}.ALL > ${case}.r.ERR 
set stat = $status
if ($stat == 0) then
   echo  Normal termination: bosorread
else
   echo  Abnormal termination: bosorread
   echo  "Exit status: $stat"
   exit 2
endif
#prof -x ${BOSOR4}/execute/bosorread.${MACHINE} >! read.prof

echo  Executing bosormain
#dbx -I ../dbx_sources ${BOSOR4}/execute/bosormain.${MACHINE}
#exit 99
${BOSOR4}/execute/bosormain.${MACHINE} $case >${case}.m.ERR
set stat = $status
if ($stat == 0) then
   echo  Normal termination: bosormain
else
   echo  Abnormal termination: bosormain
   echo  "Exit status: $stat"
   exit 2
endif
#prof -x ${BOSOR4}/execute/bosormain.${MACHINE} >! main.prof

cat ${case}.m.ERR  >>! ${case}.OUT

echo  Executing bosorpost
#cdbx -L -I ../dbx_sources ${BOSOR4}/execute/bosorpost.${MACHINE}
#exit 99
${BOSOR4}/execute/bosorpost.${MACHINE} $case >${case}.p.ERR
set stat = $status
if ($stat == 0) then
   echo  Normal termination: bosorpost
else
   echo  Abnormal termination: bosorpost
   echo  "Exit status: $stat"
   exit 2
endif
#prof -x ${BOSOR4}/execute/bosorpost.${MACHINE} >! post.prof

echo "Job finished."
echo "Inspect the output file ${case}.OUT"
echo ""
echo "Menu: bosorplot, resetup, cleanup, getsegs, modify, input, help4"
echo ""
cat  ${case}.p.ERR   >>${case}.OUT

'rm' -f ${case}.[rmp].ERR
if ($MACHINE == "cray") then
  'rm' -f $FILENV
  'mv' fort.11 ${case}.RAN
else
  'rm' -f {PROMPT,PROMPT2,PROMPT3}.DAT
  'rm' -f fort.* FOR0* 
endif

