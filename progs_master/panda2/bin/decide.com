#
# decide.com: This procedure generates a file for establishing parameters
# to be used in an optimization analysis.

echo -n "Please enter PANDA2 case name: "
set case = $<
if (-e PROMPT.DAT) 'rm' PROMPT.DAT
if (-e TUTORDEC.DAT) 'rm' TUTORDEC.DAT
if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.dec$$
  assign -a ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
  assign -a ${PANDA2}/execute/TUTORDEC.DAT TUTORDEC.DAT
else
  ln -s ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
  ln -s ${PANDA2}/execute/TUTORDEC.DAT TUTORDEC.DAT
endif
${PANDA2}/execute/decide.${MACHINE} $case
if ($MACHINE == "cray") then
  'rm' -f $FILENV
else
  'rm' -f {TUTORDEC,PROMPT}.DAT >& /dev/null
endif

