#
# decide.com - executes decide

ln -s ${GENOPT}/execute GENOPT
./decide.${MACHINE}
/bin/rm -f GENOPT

