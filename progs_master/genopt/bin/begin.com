#
# begin.com - executes begin

ln -s ${GENOPT}/execute GENOPT
echo "GENOPT = ${GENOPT}"
./begin.${MACHINE}
/bin/rm -f GENOPT

