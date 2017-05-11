#
# chooseplot.com - executes chooseplot

ln -s ${GENOPT}/execute GENOPT
./chooseplot.${MACHINE}
/bin/rm -f GENOPT

