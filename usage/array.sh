#!/bin/bash

a=(0 1 2 3 4 5 6 7)

a[8]=8

len=${#a[*]}

echo "for loop"
for ((i=0; len-i; i=i+1)); do
	echo "a[${i}] = ${a[i]}";
done

echo "for loop"
i=0
for n in ${a[*]}; do
	echo "a[${i}] = ${n}";
	let i=i+1
done
