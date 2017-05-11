#
# PURPOSE IS TO EXECUTE HELPG

  ln -s  ${GENOPT}/execute GENOPT 
  GENOPT/helpg.${MACHINE} $1  $2
  /bin/rm GENOPT

