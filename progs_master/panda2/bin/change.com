#
# change.com: Modifies a case without going back to BEGIN.

if (-e PROMPT.DAT) 'rm' PROMPT.DAT
if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.change$$
  assign -a ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
else
  ln -s ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
endif
echo -n "Please enter PANDA2 case name: "
set case = $<
${PANDA2}/execute/change.${MACHINE} $case
if ($MACHINE == "cray") then
  'rm' -f $FILENV
else
  'rm' -f PROMPT.DAT >& /dev/null
endif
