# 
# superduperopt.com: Prepares for multiple execution of 
# combinations of (autochange,setup,decide,pandaopt,pandaopt...)

# beg July 8, 2011
set name = "superduperopt"
# end july 8, 2011
echo "The purpose of SUPERDUPEROPT is to launch the batch run which performs"
echo "multiple executions of the genopt processors, SUPEROPT/CHOOSEPLOT."
echo "" 
echo -n  "Enter case name: "
set casename = $<
echo  "Enter number of executions of pandaopt"
echo -n "for each execution of autochange (5 or 6 or 7 or 8 or 9 or 10):"
set pandaopts = $<
# beg July 8, 2011
echo  "Enter number of executions of SUPEROPT/CHOOSEPLOT"
echo -n "must be greater than 1 and less than or equal to 20: "
set superopts = $<
# end July 8, 2011
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
  (nice +$p time csh ${PANDA2}/bin/${name}.bat $casename $pandaopts $superopts) \
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
    ${PANDA2}/bin/${name}.bat $casename $pandaopts $superopts >& /tmp/popt.diag$$
    ja -st /tmp/jacct$$ >! /tmp/jacct.sr$$
    cat /tmp/popt.diag$$ /tmp/jacct.sr$$ | \
      mail -s "PANDA2: pandaopt diagnostics; Case: $casename" $USER
    'rm' /tmp/popt.diag$$ /tmp/jacct.sr$$
EOF
else
  time ${PANDA2}/bin/${name}.bat $casename $pandaopts $superopts
endif
