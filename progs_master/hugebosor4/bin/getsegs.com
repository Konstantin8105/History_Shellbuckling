# GETSEGS COM DECK FOLLOWS..

# PURPOSE IS TO DIVIDE A 'NAME'.ALL DECK INTO 'NAME'.SEGn DECKS

echo -n "Please enter case name: "
set case = $<
${HUGEBOSOR4}/execute/getsegs.${MACHINE} $case

