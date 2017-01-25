#/bin/bash

while read line;
do
    echo $line
    echo $line >> request.txt
done
