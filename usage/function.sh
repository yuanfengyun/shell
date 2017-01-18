#!/bin/bash

function add()
{
	return $(( $1 + $2  ))
}

function sum()
{
	echo "argc = $#"
	local sum=0
	for i in $@; do
		let sum=sum+i
	done

    return $sum	
}

add 1 2
echo "1 + 2 = $?"

sum 1 2 3 4 5
echo "sum of (1 2 3 4 5) = $?"
