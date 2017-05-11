#
# cleanpan.com: Deletes temporary case-specific files.
echo -n "Enter the case name: "
set case = $<

/bin/rm -f ${case}.ALL >& /dev/null
/bin/rm -f ${case}.AL2 >& /dev/null
/bin/rm -f ${case}.AL3 >& /dev/null
/bin/rm -f ${case}.NAM >& /dev/null
/bin/rm -f ${case}.DOC >& /dev/null
/bin/rm -f ${case}.BL1 >& /dev/null
/bin/rm -f ${case}.BL2 >& /dev/null
/bin/rm -f ${case}.BL3 >& /dev/null
/bin/rm -f ${case}.BL4 >& /dev/null
/bin/rm -f ${case}.BLK >& /dev/null
/bin/rm -f ${case}.CBL >& /dev/null
/bin/rm -f ${case}.RN1 >& /dev/null
/bin/rm -f ${case}.RN2 >& /dev/null
/bin/rm -f ${case}.RN3 >& /dev/null
/bin/rm -f ${case}.RN4 >& /dev/null
/bin/rm -f ${case}.RAN >& /dev/null
/bin/rm -f ${case}.LAB >& /dev/null
/bin/rm -f ${case}.PLT >& /dev/null
/bin/rm -f ${case}.BOS >& /dev/null
/bin/rm -f ${case}.OPM >& /dev/null
/bin/rm -f ${case}.OPD >& /dev/null
/bin/rm -f ${case}.OPC >& /dev/null
/bin/rm -f ${case}.OPB >& /dev/null
/bin/rm -f ${case}.OUT >& /dev/null
/bin/rm -f ${case}.ERR >& /dev/null
/bin/rm -f ${case}.DAT >& /dev/null
/bin/rm -f ${case}.PL* >& /dev/null
/bin/rm -f ${case}.SL* >& /dev/null
/bin/rm -f ${case}.P1* >& /dev/null
/bin/rm -f ${case}.P2* >& /dev/null
/bin/rm -f ${case}.L1* >& /dev/null
/bin/rm -f ${case}.L2* >& /dev/null
/bin/rm -f ${case}.OPP >& /dev/null
/bin/rm -f ${case}.OPI >& /dev/null
/bin/rm -f ${case}.DIP >& /dev/null
/bin/rm -f ${case}.ODI >& /dev/null
/bin/rm -f ${case}.OPL >& /dev/null
/bin/rm -f ${case}.TIT >& /dev/null
/bin/rm -f ${case}.TTT >& /dev/null
/bin/rm -f ${case}.003 >& /dev/null
/bin/rm -f ${case}.PAR >& /dev/null
/bin/rm -f ${case}.INP >& /dev/null
/bin/rm -f ${case}.ELE >& /dev/null
/bin/rm -f ${case}.PPN >& /dev/null
/bin/rm -f ${case}.010 >& /dev/null
/bin/rm -f ${case}.TUT >& /dev/null
/bin/rm -f ${case}.OPA >& /dev/null
/bin/rm -f ${case}.SUP >& /dev/null
/bin/rm -f ${case}.OPTEMP >& /dev/null
/bin/rm -f $case >& /dev/null
/bin/rm -f fort.* >& /dev/null
/bin/rm -f FOR0* >& /dev/null
/bin/rm -f PANDA2 >& /dev/null
/bin/rm -f BOSOR4 >& /dev/null
'rm' -f PROMPT*.DAT >& /dev/null
'rm' -f TUTOR*.DAT >& /dev/null
/bin/rm -f metafile.ps >& /dev/null
/bin/rm -f ${case}.ps >& /dev/null
/bin/rm -f ${case}.ppn >& /dev/null
/bin/rm -f ${case}.inp >& /dev/null
/bin/rm -f ${case}.out1 >& /dev/null
/bin/rm -f ${case}.out2* >& /dev/null
/bin/rm -f ${case}.pout >& /dev/null
/bin/rm -f ${case}.*res >& /dev/null
/bin/rm -f ${case}.*rst >& /dev/null
/bin/rm -f ${case}.sav >& /dev/null
/bin/rm -f ${case}.*imp >& /dev/null
/bin/rm -f ${case}.*egv >& /dev/null
/bin/rm -f ${case}.log >& /dev/null
#/bin/rm -f ${case}.bin >& /dev/null
'rm' -f ${case}.Qerr >& /dev/null

echo You now have the following case ${case} files in your directory:
/bin/ls -CF ${case}.*

