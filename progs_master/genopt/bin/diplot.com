#
# diplot.com: executes the GENOPT plotting software.  PostScript files
# called $case.$n.ps will be created and optionally printed on the local
# PostScript printer.

if ($#argv) then
  set case = $1
else
  echo -n "Enter the specific case name: "
  set case = $<
endif

if ($?PRINTER) then
  echo -n "Print the plot file on the printer called: <$PRINTER> (y or n)? "
  set answer = $<
  if (($answer:q == "y") || ($answer:q == "Y")) then
    foreach n (3 4 5 6 7 8 9 10)
      if (!(-z $case.PL$n)) then
        $BIN/plotps.$MACHINE < $case.PL$n | lpr
      endif
    end # foreach
  else
    goto noprint
  endif
else
  noprint:
    foreach n (3 4 5 6 7 8 9 10)
    if (!(-z $case.PL$n)) then
      $BIN/plotps.$MACHINE < $case.PL$n >$case.$n.ps
    endif
    end # foreach
    echo "The PostScript files, $case.3.ps through $case.10.ps, contain the"
    echo "graphics for your plot.  They can be printed on any PostScript"
    echo "printer or viewed on the console with a PostScript previewing"
    echo "software program."
endif

