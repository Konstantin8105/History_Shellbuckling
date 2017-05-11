# 
# superopt.com: Prepares for multiple execution of 
# combinations of (autochange,optimize,optimize,optimize...)

set name = "superopt"
echo "The purpose of SUPEROPT is to launch the batch run which performs"
echo "multiple executions of the genopt processors in the order:"
echo "  autochange optimize optimize optimize . . . ."
echo "The processor autochange automatically changes the decision variables"
echo "as follows:"
echo "           y(i) = x(i)*(1. + dx(i))   (i = 1,2,3,...no. of dec. var)"
echo "in which x(i) is the old value of the ith decision variable, y(i)"
echo "is the new value, and dx(i) is a random number between -0.5 and +1.5"
echo "The purpose of the successive cycles of"
echo "  autochange optimize optimize optimize . . . ."
echo "is to try to find a global optimum design by redesigning in each"
echo "cycle from a different starting point. The user should use a"
echo "small maximum number of design iterations (such as 5) in the file"
echo "speccase.OPT, where speccase is the user-specified name of the "
echo "specific case."
echo "" 
echo -n  "Enter specific case name: "
set casename = $<
echo  "Enter number of executions of OPTIMIZE"
echo -n "for each execution of AUTOCHANGE (5 or 6 or 7 or 8 or 9 or 10 or ....15):"
set optimizes = $<
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
  (nice +$p time csh ${GENOPT}/bin/${name}.bat $casename $optimizes) \
                                                          |& mail $USER &
else
  time ${GENOPT}/bin/${name}.bat $casename $optimizes
endif
