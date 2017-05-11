#
# cleangen.com - deletes generic case files

echo -n "Enter generic case name: "
set case = $<

/bin/rm -f $case >& /dev/null
/bin/rm -f ${case}.CHA >& /dev/null
/bin/rm -f ${case}.COM >& /dev/null
/bin/rm -f ${case}.CON >& /dev/null
/bin/rm -f ${case}.DAT >& /dev/null
/bin/rm -f ${case}.DEF >& /dev/null
/bin/rm -f ${case}.NEW >& /dev/null
/bin/rm -f ${case}.PRO >& /dev/null
/bin/rm -f ${case}.REA >& /dev/null
/bin/rm -f ${case}.SET >& /dev/null
/bin/rm -f ${case}.SUB >& /dev/null
/bin/rm -f ${case}.WRI >& /dev/null
/bin/rm -f ${case}.MOD >& /dev/null
/bin/rm -f INSERT.INP >& /dev/null
/bin/rm -f INSERT.INS >& /dev/null
/bin/rm -f begin.new >& /dev/null
/bin/rm -f stoget.new >& /dev/null
/bin/rm -f change.new >& /dev/null
/bin/rm -f fort.* >& /dev/null
/bin/rm -f FOR0*.DAT >& /dev/null
/bin/rm -rf *.${MACHINE} >& /dev/null
ls -ltF ${case}.* *.new

echo ""
echo "Next, you have the chance to save the FORTRAN source codes:"
echo ""
echo "         behavior.new      and/or      struct.new"
echo ""
echo "You may have done a lot of work modifying these libraries."
echo "Save them by copying them into other files."
echo ""
echo -n 'Do you want to copy "behavior.new"? (Y or N) '
set answer = $<

if ($answer:q != "N" && $answer:q != "n") then
   echo -n 'Name of file into which "behavior.new" will be copied: '
   set name = $<
   echo "behavior.new will be copied into $name"
   cp behavior.new $name
   ls -lt $name
endif

echo ""
echo -n 'Do you want to copy "struct.new"? (Y or N) '
set answer = $<

if ($answer:q != "N" && $answer:q != "n") then
   echo -n 'Name of file into which "struct.new" will be copied: '
   set name = $<
   echo "struct.new will be copied into $name"
   cp struct.new $name
   ls -lt $name
endif

echo ""
echo "Here are the files remaining in $cwd"
ls -ltF

