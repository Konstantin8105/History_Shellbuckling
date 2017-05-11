#
# helpan.com:  Runs the interactive Panda2 help program.
# $1 - topic
# $2 - sub-topic

if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.help$$
  assign -a ${PANDA2}/doc/panda2.hlp PANDA2.HLP
else
  ln -s ${PANDA2}/doc/panda2.hlp PANDA2.HLP
endif
${PANDA2}/execute/helpan.${MACHINE} $1 $2
if ($MACHINE == "cray") then
  'rm' -f $FILENV
else
  'rm' -f PANDA2.HLP
endif
