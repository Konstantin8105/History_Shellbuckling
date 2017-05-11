# 
# pandaopt.com: Prepares for execution of Panda2 optimization.

set name = "pandaxdb"
echo The purpose of PANDAOPT is to launch the batch run which performs 
echo optimization or buckling according to the strategy parameters
echo established the last time you did a MAINSETUP.  Output from PANDAOPT
echo is stored in a file called {casename}.OPM, in which {casename} is
echo the name of the case.  You will want to examine {casename}.OPM as soon
echo as PANDAOPT is finished.
echo "" 
echo -n  "Enter case name: "
set casename = $<
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
  (nice +$p time csh ${PANDA2}/bin/${name}.bat $casename) |& mail $USER &

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
  qsub -r "pandaopt: $casename" -e ${casename}.Qerr \
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
    ${PANDA2}/bin/${name}.bat $casename >& /tmp/popt.diag$$
    ja -st /tmp/jacct$$ >! /tmp/jacct.sr$$
    cat /tmp/popt.diag$$ /tmp/jacct.sr$$ | \
      mail -s "PANDA2: pandaopt diagnostics; Case: $casename" $USER
    'rm' /tmp/popt.diag$$ /tmp/jacct.sr$$
EOF
else
  time ${PANDA2}/bin/${name}.bat $casename
endif
