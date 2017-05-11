# ASSEMBLE COM DECK FOLLOWS..

# PURPOSE OF THIS PROCEDURE IS TO ASSEMBLE THE 'CASE'.SEG* FILES
# FOR A BOSOR BATCH RUN.

echo -n "Please enter case name: "
set case = $<
echo -n "How many segments in the model (excluding global data)? "
set nseg = $<
${BIGBOSOR4}/execute/assemble.${MACHINE} $case $nseg

