#!/bin/bash

array=(1 2 3)

echo "print item in array"
for i in ${array[*]}; do
	echo $i;
done

echo "ls current dir:"
for f in `ls`; do
	echo $f
done


echo "echo 10 to 1"
for (( a=10; a; a=a-1 )); 
do
	echo $a ;
done
