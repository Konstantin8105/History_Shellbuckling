#
# diplot.com: executes the GENOPT plotting software.  A PostScript file
# called metafile.ps will be created and optionally printed on the local
# PostScript printer.

echo -n "Enter SPECIFIC case name: "
set casename = $<

ln -s ${casename}.NAM fort.12
ln -s ${GENOPT}/execute GENOPT
#exit 99
diplot.${MACHINE} >! metafile.ps
/bin/rm GENOPT fort.12 >>& /dev/null

echo -n "Print the plot file on the printer called: <$PRINTER> (y or n)? "
set answer = $<
if (($answer:q == "y") || ($answer:q == "Y")) then
  lpr metafile.ps
endif

