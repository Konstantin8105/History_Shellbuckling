# THIS IS THE MODIFY COM FILE...

# PURPOSE IS TO MODIFY DATA IN A 'NAME'.SEG FILE

if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.modfy$$
  assign -a ${BOSOR4}/execute/PROMPT.DAT PROMPT.DAT
  assign -a ${BOSOR4}/execute/PROMPT2.DAT PROMPT2.DAT
  assign -a ${BOSOR4}/execute/PROMPT3.DAT PROMPT3.DAT
else
  ln -s ${BOSOR4}/execute/PROMPT.DAT   PROMPT.DAT
  ln -s ${BOSOR4}/execute/PROMPT2.DAT   PROMPT2.DAT
  ln -s ${BOSOR4}/execute/PROMPT3.DAT   PROMPT3.DAT
endif

echo -n "Please enter case name: "
set case = $<
${BOSOR4}/execute/modify.${MACHINE} $case

if ($MACHINE == "cray") then
  'rm' -f $FILENV
else
  'rm' -f {PROMPT,PROMPT2,PROMPT3}.DAT
endif

