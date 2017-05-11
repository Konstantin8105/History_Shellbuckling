#
# change.com - executes change

ln -s ${GENOPT}/execute GENOPT
./change.${MACHINE}
/bin/rm -f GENOPT

