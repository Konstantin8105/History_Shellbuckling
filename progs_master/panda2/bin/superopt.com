# 
# superopt.com: Prepares for multiple execution of 
# combinations of (autochange,setup,decide,pandaopt,pandaopt...)

set name = "superopt"
echo "The purpose of SUPEROPT is to launch the batch run which performs"
echo "multiple executions of the panda2 processors in the order:"
echo "  autochange  setup  pandaopt  pandaopt  pandaopt . . . ."
echo "The processor autochange automatically changes the decision variables"
echo "as follows:"
echo "           y(i) = x(i)*(1. + dx(i))   (i = 1,2,3,...no. of dec. var)"
echo "in which x(i) is the old value of the ith decision variable, y(i)"
echo "is the new value, and dx(i) is a random number between -0.5 and +1.5"
echo "The purpose of the successive cycles of"
echo "  autochange  setup  pandaopt  pandaopt  pandaopt . . . ."
echo "is to try to find a global optimum design by redesigning in each"
echo "cycle from a different starting point. The user should use a"
echo "small maximum number of design iterations (such as 5) in the file"
echo "case.OPT, where case is the user-specified name of the case."
echo "" 
echo -n  "Enter case name: "
set casename = $<
echo  "Enter number of executions of pandaopt"
echo -n "for each execution of autochange (5 or 6 or 7 or 8 or 9 or 10):"
set pandaopts = $<
echo -n  "B (background), F (foreground), or Q (NQS - network queue system): "
set ground = $<

if ($MACHINE == "cray") then
  alias mail mailx
endif

if (($ground:q == "B") || ($ground:q == "b")) then
  echo -n  "H (high) or L (low) priority: "
  set priority = $<
  if (($priority:q == "H") || ($priority:q == "h")) then
     set  p = 5
  else
     set  p = 15
  endif
   echo "Diagnostics will be mailed to you upon program termination."
  (nice +$p time csh ${PANDA2}/bin/${name}.bat $casename $pandaopts) \
                                                          |& mail $USER &
#                                                         |& /dev/null &
else if (($ground:q == "Q") || ($ground:q == "q")) then

  echo -n "Please enter a CPU time limit in seconds (CR for default): "
  set cpulimit = $<
  if ($cpulimit:q == "") then
    set cpulimit = 900
  endif
   echo "pandaopt diagnostics will be mailed to you upon program termination."
  echo "NQS diagnostics will be written to file: ${casename}.Qerr"
  if (-e ${casename}.Qerr) then
    'rm' ${casename}.Qerr
  endif
  qsub -r "superopt: $casename" -e ${casename}.Qerr \
       -o /dev/null -lT $cpulimit << EOF
    set timestamp
    set echo
    setenv MACHINE $MACHINE
    setenv PANDA2 $PANDA2
    setenv BOSOR4 $BOSOR4
    if ($MACHINE == "cray") then
      alias mail mailx
    endif
    cd `pwd`
    ja /tmp/jacct$$
    ${PANDA2}/bin/${name}.bat $casename $pandaopts >& /tmp/popt.diag$$
    ja -st /tmp/jacct$$ >! /tmp/jacct.sr$$
    cat /tmp/popt.diag$$ /tmp/jacct.sr$$ | \
      mail -s "PANDA2: pandaopt diagnostics; Case: $casename" $USER
    'rm' /tmp/popt.diag$$ /tmp/jacct.sr$$
EOF
else
  time ${PANDA2}/bin/${name}.bat $casename $pandaopts
endif
