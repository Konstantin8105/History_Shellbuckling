# THIS IS THE CLEANUP COM FILE...

# THIS PROCEDURE IS FOR CLEARING OUT OLD FILES DURING TESTING. DO NOT
# USE IT UNLESS YOUR 'NAME'.DOC FILE IS GOOD!!!
 
   echo  "   "
   echo  "This procedure clears out old files and replaces"
   echo  "the 'NAME'.ALL file with the most recent 'NAME'.DOC"
   echo  "file."
   echo  "     "
   echo  "WARNING:  DO NOT USE THIS PROCEDURE UNLESS YOU ARE"
   echo  "          SURE THAT YOU HAVE A COMPLETE, GOOD "
   echo  "          'NAME'.DOC FILE."
   echo  "    "
   echo -n  "Enter case name: "
   set case = $<
/bin/rm -f ${case}.BLK >& /dev/null
/bin/rm -f ${case}.LAB >& /dev/null
/bin/rm -f ${case}.OUT >& /dev/null
/bin/rm -f ${case}.PLT2 >& /dev/null
/bin/rm -f ${case}.RAN >& /dev/null
/bin/rm -f ${case}.WAV >& /dev/null
/bin/rm -f ${case}.m.ERR >& /dev/null
   'rm'  $case FOR0* fort.* HUGEBOSOR4 >& /dev/null
   'cp'  ${case}.DOC  ${case}.ALL
   echo  "    "
   echo  "You now have the following files with the name"
   echo  "${case}.* :"
   'ls' -al  ${case}.*
   echo  "If you want to get ${case}.SEG files, please type"
   echo  ""
   echo  "          getsegs"

