#
# chooseplot.com:  Allows the user to choose which design variables and 
# design margins to plot.

echo -n "Please enter PANDA2 case name: "
set case = $<
if (-e $case.PL3)  'rm' $case.PL3
if (-e $case.PL4)  'rm' $case.PL4
if (-e $case.PL5)  'rm' $case.PL5
if (-e $case.PL6)  'rm' $case.PL6
if (-e $case.PL7)  'rm' $case.PL7
if (-e $case.PL8)  'rm' $case.PL8
if (-e $case.PL9)  'rm' $case.PL9
if (-e $case.PL10) 'rm' $case.PL10
if (-e PROMPT.DAT) 'rm' PROMPT.DAT
if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.cplot$$
  assign -a ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
  ${PANDA2}/execute/chplot.${MACHINE} $case
  'rm' -f $FILENV
else
  ln -s ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
  ${PANDA2}/execute/chooseplot.${MACHINE} $case
  'rm' PROMPT.DAT
endif

