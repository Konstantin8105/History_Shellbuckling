#
# optimize.com

set name = "optimize"
echo -n  "Enter specific case name: "
set casename = $<
echo -n  "B (background) or F (foreground): "
set ground = $<
if (($ground:q == "B") || ($ground:q == "b")) then
  echo -n  "H (high) or L (low) priority: "
  set priority = $<
  if (($priority:q == "H") || ($priority:q == "h")) then
     set  p = 5
  else
     set  p = 15
  endif
  echo "Diagnostics will be mailed to you upon program termination."
  (nice +$p time ${GENOPT}/bin/${name}.bat $casename) |& mail $USER \
   >& /dev/null &
else
  time ${GENOPT}/bin/${name}.bat $casename
endif
