#
# gentext.com - sets up a prompt file and performs other modifications
# on the template files provided.

cp ${GENOPT}/sources/*.tmpl .
${GENOPT}/execute/genprompt.${MACHINE}
/bin/rm -f *.tmpl
