#
# stagsmodel.com is for generating files {case}.INP for input to a STAGS run.

echo -n "Please enter PANDA2 case name: "
set case = $<
if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.stagm$$
  assign -a ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
  ${PANDA2}/execute/stagsmod.${MACHINE} $case
  'rm' -f $FILENV
else
  ln -s ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
  ${PANDA2}/execute/stagsmodel.${MACHINE} $case
  'rm' -f PROMPT.DAT
endif

