# BIGBOSORALL.COM

set name = "bigbosorall"
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
  (nice +$p time ${HUGEBOSOR4}/bin/${name}.bat $casename) |& mail $USER &

else if (($ground:q == "Q") || ($ground:q == "q")) then

  echo -n "Please enter a CPU time limit in seconds (CR for default): "
  set cpulimit = $<
  if ($cpulimit:q == "") then
    set cpulimit = 60
  endif
  echo "bigbosorall diagnostics will be mailed to you upon program termination."
  echo "NQS diagnostics will be written to file: ${casename}.Qerr"
  if (-e ${casename}.Qerr) then
    'rm' ${casename}.Qerr
  endif
  qsub -r "HUGEBOSOR4 (all): $casename" -e ${casename}.Qerr \
       -o /dev/null -lT $cpulimit << EOF
    set timestamp
    set echo
    setenv MACHINE $MACHINE
    setenv HUGEBOSOR4 $HUGEBOSOR4
    if ($MACHINE == "cray") then
      alias mail mailx
    endif
    cd `pwd`
    ja /tmp/jacct$$
    ${HUGEBOSOR4}/bin/${name}.bat $casename >& /tmp/popt.diag$$
    ja -st /tmp/jacct$$ >! /tmp/jacct.sr$$
    cat /tmp/popt.diag$$ /tmp/jacct.sr$$ | \
     mail -s "HUGEBOSOR4: bigbosorall diagnostics; Case: $casename" $USER
    'rm' /tmp/popt.diag$$ /tmp/jacct.sr$$
EOF

else

  time ${HUGEBOSOR4}/bin/${name}.bat $casename

endif
