#
#     BOSORPLOT COM FILE...
# bosorplot.com performs all of the necessary processing of the {case}.PLT2
# file so that graphs can be produced using the Xwindows utility, xgraph.
# At the present time, only xgraph is supported.  Support for the UNIX utility,
# graph, may come at a future time.

if ($MACHINE == "cray") then
  echo "WARNING: Since CRAY have decided that filenames must be limited to a"
  echo "         ridiculously brief 14 characters, some plots will be"
  echo "         unobtainable.  I suggest you copy the {casename}.PLT2 and"
  echo "         {casename}.DOC files for your particular case to a different"
  echo "         machine and run bosorplot there."
endif

set GAWK = "${BUSHNELL}/bin/gawk.${MACHINE}"
echo -n 'Please enter the BOSOR4 case name: '
set case = $<

echo ""

if ($MACHINE == "rs6k") then
  set method = "p"
else
  echo -n 'Do you want to use Xgraph or create a PostScript file? (Choose X or P) '
  set method = $<
  if ($method:q == "") then
    set method = "p"
  endif
endif
echo ""

if !(-e ${case}.PLT2) then
  echo "ERROR: ${case}.PLT2 does not exist in the current working directory\!"
  exit (1)
endif

echo "One, maybe Two moments please..."
$GAWK -f ${BOSOR4}/bin/bosorplot.awk ${case}.PLT2

# Find all relevant plot files that should be split and sent to the plotter.
if ($MACHINE == "sgi" || \
    $MACHINE == "star" || \
    $MACHINE == "cray" || \
    $MACHINE == "hp700") then
  /bin/ls ${case}..* | nl >! /tmp/table$$
else
  /bin/ls -1 ${case}..* | cat -n >! /tmp/table$$
endif

while (1) 
  echo ""
  echo "Text file(s) have been created containing plot data.  The names of the"
  echo "files explain to a greater or lesser extent what the data represent."
  echo "Some plot files contain data for more than one plot."

  $GAWK '{printf "%d)\t%s\n", $1, $2}' /tmp/table$$

  echo "CR)     to QUIT"
  echo -n "Please choose the number of the file you wish to plot: "
  set choice = $<
  set npfiles = "`$GAWK 'END {print NR}' /tmp/table$$`"

# Check for exit condition
  $GAWK -v a=$choice 'BEGIN {found = 0; choice = a}; $1 == choice {found = 1}; END {exit found}' /tmp/table$$
  set stat = $status
  if !($stat) then
    /bin/rm ${case}..* /tmp/*$$ >& /dev/null
    exit($stat)
  endif

# Build command to extract name of plot file to split.
  echo -n "'$choice ==" >! /tmp/com$$
  echo -n ' $1 { print $2 }' >> /tmp/com$$
  echo "' /tmp/table$$" >> /tmp/com$$
  set command = "`cat /tmp/com$$`"
  set plotfile = "`$GAWK $command`"

# Call bosorplot.bat
  ${BOSOR4}/bin/bosorplot.bat $case $method $plotfile

end # while
