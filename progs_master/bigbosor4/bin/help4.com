#
# PURPOSE IS TO EXECUTE HELP4.EXE

if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.help$$
  assign -a ${BIGBOSOR4}/execute/BOSOR4.HLP BOSOR4.HLP
else
  ln -s ${BIGBOSOR4}/execute/BOSOR4.HLP BOSOR4.HLP
endif

${BIGBOSOR4}/execute/help4.${MACHINE} $1 $2

if ($MACHINE == "cray") then
  'rm' -f $FILENV
else
  'rm' -f BOSOR4.HLP
endif

