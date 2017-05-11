#
# mainsetup.com - executes mainsetup

ln -s ${GENOPT}/execute GENOPT
./mainsetup.${MACHINE}
/bin/rm -f GENOPT

