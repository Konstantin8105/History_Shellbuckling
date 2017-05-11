# 
# superduperopt.com: Prepares for multiple execution of 
# combinations of (autochange,optimize,optimize,optimize...)

# beg July 8, 2011
set name = "superduperopt"
# end july 8, 2011
echo "The purpose of SUPERDUPEROPT is to launch the batch run which performs"
echo "multiple executions of the genopt processors, SUPEROPT/CHOOSEPLOT."
echo "" 
echo -n  "Enter specific case name: "
set casename = $<
echo  "Enter number of executions of OPTIMIZE"
echo -n "for each execution of AUTOCHANGE (5 or 6 or 7 or 8 or 9 or 10 or ....15): "
set optimizes = $<
# beg July 8, 2011
echo  "Enter number of executions of SUPEROPT/CHOOSEPLOT"
echo -n "must be greater than 1 and less than or equal to 20: "
set superopts = $<
# end July 8, 2011
echo -n  "B (background), F (foreground): "
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
  (nice +$p time csh ${GENOPT}/bin/${name}.bat $casename $optimizes $superopts) \
                                                          |& mail $USER &
else
  time ${GENOPT}/bin/${name}.bat $casename $optimizes $superopts
endif
