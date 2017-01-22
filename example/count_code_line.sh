#/bin/bash

find $1 -name $2 | xargs grep -v ^$ | wc -l | cut -d\t -f1
