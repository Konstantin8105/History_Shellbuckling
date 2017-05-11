#
# autochange.com
echo "The processor autochange automatically changes the decision variables"
echo "as follows: "
echo "          y(i) = x(i)*(1. + dx(i))   (i = 1,2,3,...no. of dec. var)"
echo "in which x(i) is the old value of the ith decision variable, y(i)"
echo "is the new value, and dx(i) is a random number between -0.5 and +1.5"
echo -n "Please enter PANDA2 case name: "
set case = $<
if (-e PROMPT.DAT) 'rm' PROMPT.DAT
if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.autochange$$
  assign -a ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
else
  ln -s ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
endif
${PANDA2}/execute/autochange.${MACHINE} $case
if ($MACHINE == "cray") then
  'rm' -f $FILENV
else
  'rm' -f {PROMPT}.DAT >& /dev/null
endif

