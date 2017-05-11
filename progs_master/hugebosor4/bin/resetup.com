# THIS IS THE RESETUP COM FILE...

# PROCEDURE FOR SETTING UP CASE FOR A RESTART.

if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.reset$$
  assign -a ${HUGEBOSOR4}/execute/PROMPT.DAT PROMPT.DAT
  assign -a ${HUGEBOSOR4}/execute/PROMPT2.DAT PROMPT2.DAT
  assign -a ${HUGEBOSOR4}/execute/PROMPT3.DAT PROMPT3.DAT
else
  ln -s ${HUGEBOSOR4}/execute/PROMPT.DAT PROMPT.DAT
  ln -s ${HUGEBOSOR4}/execute/PROMPT2.DAT PROMPT2.DAT
  ln -s ${HUGEBOSOR4}/execute/PROMPT3.DAT PROMPT3.DAT
endif

echo -n "Please enter case name: "
set case = $<
#dbx -I ../dbx_sources ${HUGEBOSOR4}/execute/resetup.${MACHINE}
${HUGEBOSOR4}/execute/resetup.${MACHINE} $case

if ($MACHINE == "cray") then
  'rm' -f $FILENV
else
  'rm' -f {PROMPT,PROMPT2,PROMPT3}.DAT
endif
