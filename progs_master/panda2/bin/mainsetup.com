#
# mainsetup.com: Sets up a strategy for Panda2 analysis.

echo -n "Please enter PANDA2 case name: "
set case = $<
if (-e PROMPT.DAT) 'rm' PROMPT.DAT
if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.mains$$
  assign -a ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
else
  ln -s ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
endif
${PANDA2}/execute/mainsetup.${MACHINE} $case
#dbx ${PANDA2}/execute/mainsetup.${MACHINE}
if ($MACHINE == "cray") then
  'rm' -f $FILENV
else
  'rm' -f PROMPT.DAT >& /dev/null
endif

