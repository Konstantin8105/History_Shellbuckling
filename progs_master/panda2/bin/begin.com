#
# begin.com: Runs BEGIN to allow for user-supplied interactive input.

if (-e PROMPT.DAT) 'rm' PROMPT.DAT
if (-e TUTORBEG.DAT) 'rm' TUTORBEG.DAT
if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.begin$$
  assign -a ${PANDA2}/execute/TUTORBEG.DAT TUTORBEG.DAT
  assign -a ${PANDA2}/execute/PROMPT.DAT   PROMPT.DAT
else
  ln -s ${PANDA2}/execute/PROMPT.DAT   PROMPT.DAT
  ln -s ${PANDA2}/execute/TUTORBEG.DAT TUTORBEG.DAT
endif
echo -n "Please enter PANDA2 case name: "
set case = $<
#exit 99
${PANDA2}/execute/begin.${MACHINE} $case
if ($MACHINE == "cray") then
  'rm' -f $FILENV
else
  'rm' -f {TUTORBEG,PROMPT}.DAT >& /dev/null
endif


