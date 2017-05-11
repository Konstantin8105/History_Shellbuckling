#
# cleanspec.com - End user cleans up specific case files.

echo ""
echo -n "Enter specific case name: "
set case = $<

/bin/rm -f $case >& /dev/null
/bin/rm -f ${case}.NAM >& /dev/null
/bin/rm -f ${case}.CBL >& /dev/null
/bin/rm -f ${case}.OPM >& /dev/null
/bin/rm -f ${case}.OPD >& /dev/null
/bin/rm -f ${case}.OPC >& /dev/null
/bin/rm -f ${case}.OPB >& /dev/null
/bin/rm -f ${case}.DAT >& /dev/null
/bin/rm -f ${case}.OPP >& /dev/null
/bin/rm -f ${case}.OPL >& /dev/null
/bin/rm -f ${case}.PL1 >& /dev/null
/bin/rm -f ${case}.PL2 >& /dev/null
/bin/rm -f ${case}.PL3 >& /dev/null
/bin/rm -f ${case}.PL4 >& /dev/null
/bin/rm -f ${case}.PL5 >& /dev/null
/bin/rm -f ${case}.DIP >& /dev/null
/bin/rm -f ${case}.ODI >& /dev/null
/bin/rm -f ${case}.OPA >& /dev/null
/bin/rm -f ${case}.ERR >& /dev/null
/bin/rm -f ${case}.BLK >& /dev/null
/bin/rm -f ${case}.LAB >& /dev/null
/bin/rm -f ${case}.RAN >& /dev/null
/bin/rm -f ${case}.PLT >& /dev/null
/bin/rm -f ${case}.PLT2 >& /dev/null
/bin/rm -f ${case}.WAV >& /dev/null
/bin/rm -f ${case}.DOC >& /dev/null
/bin/rm -f ${case}.ALL >& /dev/null
/bin/rm -f ${case}.RES >& /dev/null
/bin/rm -f PLT2.DAT >& /dev/null
/bin/rm -f fort.* >& /dev/null
/bin/rm -f FOR0*.DAT >& /dev/null
/bin/rm -f tempfile >& /dev/null
/bin/ls -ltF

