#
# panel2.com:  Generates files {casename}.ALL for input to a BOSOR4 run.
#              multi-module discretized skin-ring cylindrical shell.

if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.panel2$$
  assign -a ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
else
  ln -s ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
endif
echo -n "Please enter PANDA2 case name: "
set case = $<
${PANDA2}/execute/bospn2.${MACHINE} $case
if ($MACHINE == "cray") then
  'rm' -f $FILENV
else
  'rm' -f PROMPT.DAT
endif
