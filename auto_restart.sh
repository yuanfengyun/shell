#!/bin/bash
                              
exe=$1
conf=$2

nohup $exe $conf &           
last=$!

while(true)
do
    c=`ps -x | awk '{print $1}' | grep $last | grep -v grep | wc -l`
    echo $c                   
    if [ $c -lt 1 ]; then     
        nohup $exe $conf &    
        last=$!               
    fi

    sleep 10
done
