#
# choosetemp.com: Allows the user to choose which material properties vary
# with temperature and the variation of those properties with temperature.

echo -n "Please enter PANDA2 case name: "
set case = $<
if (-e PROMPT.DAT) 'rm' PROMPT.DAT
if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.ctemp$$
  assign -a ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
  ${PANDA2}/execute/choosetemp.${MACHINE} $case
  'rm' -f $FILENV
else
  ln -s ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
  ${PANDA2}/execute/choosetemp.${MACHINE} $case
  'rm' -f PROMPT.DAT
endif
