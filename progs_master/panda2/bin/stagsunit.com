#
# stagsunit.com is for generating files {case}.INP for input to a STAGS run.

echo -n "Please enter PANDA2 case name: "
set case = $<
if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.stagsu$$
  assign -a ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
  ${PANDA2}/execute/stagsunit.${MACHINE} $case
  'rm' -f $FILENV
else
  ln -s ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
  ${PANDA2}/execute/stagsunit.${MACHINE} $case
  'rm' -f PROMPT.DAT
endif

