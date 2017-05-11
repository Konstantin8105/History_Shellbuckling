#
# insert.com - allows the user to add parameters to a case.

echo ""
echo -n "Enter generic case name: "
set case = $<
echo "$case" >! fort.1
cp fort.1 FOR001.DAT

${GENOPT}/execute/insert.${MACHINE}

cp ${case}.INP ${case}.SAV
cp ${case}.MOD ${case}.INP
echo ""
echo "The old ${case}.INP file has been saved as ${case}.SAV"
echo "The new ${case}.MOD file has been copied to ${case}.INP"
echo ""
echo "Now choose a number from the menu below:"
echo ""
echo "   1)   DO NOT run GENTEXT now.  (Choose this option if you want"
echo "        to add further parameters.)"
echo ""
echo "   2)   DO run GENTEXT now.  (Choose this option if you are finished"
echo "        adding new parameters.)"
echo ""
echo -n "Choose 1 or 2: "
set answer = $<

if ($answer:q == "2") then
   cp ${GENOPT}/sources/*.tmpl .
   ${GENOPT}/execute/genprompt.${MACHINE}
   /bin/rm -f *.tmpl
   cp ${case}.DAT ${case}.INP
   echo ""
   echo "A new set of ${case}.* files has been created, including"
   echo "all added parameters.  Please list the new ${case}.INP"
   echo "and ${case}.DEF files.  DO NOT use an old list of the"
   echo "${case}.INP file for making further parameter additions."
   echo ""
endif

/bin/rm -f fort.* >& /dev/null
/bin/rm -f FOR001.DAT >& /dev/null

ls -lt ${case}.*

