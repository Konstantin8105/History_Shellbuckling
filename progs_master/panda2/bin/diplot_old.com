#
# diplot.com: executes the PANDA2 plotting software.  A PostScript file
# called metafile.ps will be created and optionally printed on the local
# PostScript printer.

echo -n "Enter the PANDA2 case name: "
set case = $<
if (-e PROMPT.DAT) 'rm' PROMPT.DAT
if ($MACHINE == "cray") then
  setenv FILENV /tmp/ass.dplot$$
#  assign -a ${case}.NAM fort.12
  assign -a ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
else
#  ln -s ${case}.NAM fort.12
  ln -s ${PANDA2}/execute/PROMPT.DAT PROMPT.DAT
endif

#dbx ${PANDA2}/execute/diplot.${MACHINE}
${PANDA2}/execute/diplot.${MACHINE} $case >! metafile.ps
if ($MACHINE == "cray") then
  'rm' -f $FILENV
else
  'rm' -f fort.12 PROMPT.DAT
  if (-e ftn00) 'rm' ftn00
endif

if ($?PRINTER) then
  echo -n "Print the plot file on the printer called: <$PRINTER> (y or n)? "
  set answer = $<
  if (($answer:q == "y") || ($answer:q == "Y")) then
    lpr metafile.ps
  endif
else
  echo "The PostScript file, metafile.ps, contains the graphics for your plot."
  echo "It can be printed on any PostScript printer or viewed on the console"
  echo "with a PostScript previewing software program."
endif

