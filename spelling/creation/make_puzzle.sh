#!/bin/bash


CENTER=`echo $1 | awk '{print substr($1,1,1)}'`
OTHERS=`echo $1 | awk '{print substr($1,2)}'`

RESULTS=`egrep -i "^[$1]*$CENTER[$1]*$" enable.txt | awk '{ if (length($1) > 3) { wordCtr++; score+=length($1)-3 }} END { print wordCtr " words,", " total score " score} '`

echo $RESULTS

echo "puzzleData = function() {" > puzzleData.js
echo "  return { letters: \"$1\"," >> puzzleData.js
echo "    creation_date: \""`date`"\"," >> puzzleData.js
echo "    total_words: "`echo $RESULTS | sed -e 's/ words.*//'`"," >> puzzleData.js
echo "    highest_score: "`echo $RESULTS | sed -e 's/.*score//'`"," >> puzzleData.js
echo "    words: [" >> puzzleData.js

echo "Puzzle letters" $1 > puzzleWords.txt
echo "Puzzle date" `date` >> puzzleWords.txt

FLAG=0
for i in `egrep -i "^[$1]*$CENTER[$1]*$" enable.txt | awk '{ if (length($1) > 3) { print toupper($1) } } '`
do
echo -n $i | md5 | awk -v flag=$FLAG '{if (flag>0) {print ",\"" $1 "\"" } else { print  "\"" $1  "\""} }' >> puzzleData.js
echo $i >> puzzleWords.txt
FLAG=1
done
echo "    ]};" >> puzzleData.js
echo "}" >> puzzleData.js

