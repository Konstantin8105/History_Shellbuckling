#
# panel.com:  Generates files {casename}.ALL for input to a BOSOR4 run.
#             multi-module skin-stringer discretized model.

if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.panel$$
  assign -a ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
else
  ln -s ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
endif
echo -n "Please enter PANDA2 case name: "
set case = $<
${PANDA2}/execute/bospan.${MACHINE} $case
if ($MACHINE == "cray") then
  'rm' -f $FILENV
else
  'rm' -f PROMPT.DAT
endif
