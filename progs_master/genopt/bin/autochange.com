#
# autochange.com - executes chauto

ln -s ${GENOPT}/execute GENOPT
./autochange.${MACHINE}
/bin/rm -f GENOPT

