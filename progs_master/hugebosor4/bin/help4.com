#
# PURPOSE IS TO EXECUTE HELP4.EXE

if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.help$$
  assign -a ${HUGEBOSOR4}/execute/BOSOR4.HLP BOSOR4.HLP
else
  ln -s ${HUGEBOSOR4}/execute/BOSOR4.HLP BOSOR4.HLP
endif

${HUGEBOSOR4}/execute/help4.${MACHINE} $1 $2

if ($MACHINE == "cray") then
  'rm' -f $FILENV
else
  'rm' -f BOSOR4.HLP
endif

