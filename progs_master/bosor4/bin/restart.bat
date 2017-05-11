#
# RESTART BAT FILE...
# THIS PROCEDURE IS FOR BATCH EXECUTION OF TWO BOSOR4 PROCESSORS,
# USING THE RESTART CAPABILITY

set case = $1
echo ""
echo "Running BOSOR4: restart, case: $case"
echo ""
if (-e fort.11) then
  'rm' fort.11
endif
if (-e ${case}.OUT) then
  'rm' ${case}.OUT
endif

if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.b4res$$
  'cp' ${case}.RAN fort.11
else
  ln -s  ${case}.RAN  fort.11
endif

cp  ${case}.RES  ${case}.m.ERR
echo  Executing bosormain
${BOSOR4}/execute/bosormain.${MACHINE} $case >>${case}.m.ERR
if ($status == 0) then
   echo  Normal termination: bosormain
else
   echo  Abnormal termination: bosormain
   exit 2
endif
echo  Executing bosorpost
${BOSOR4}/execute/bosorpost.${MACHINE} $case >${case}.p.ERR
if ($status == 0) then
   echo  Normal termination: bosorpost
else
   echo  Abnormal termination: bosorpost
   exit 2
endif
echo "Job finished."
echo "Inspect the output file ${case}.OUT"
echo ""
echo "Menu: bosorplot, resetup, cleanup, getsegs, modify, input, help4"
echo ""
cat ${case}.m.ERR ${case}.p.ERR >${case}.OUT

'rm' -f ${case}.[rmp].ERR

if ($MACHINE == "cray") then
  'rm' -f $FILENV
  'mv' fort.11 ${case}.RAN
else
  'rm' -f fort.* FOR0*
endif

