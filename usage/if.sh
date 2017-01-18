#!/bin/bash

echo "please input a number:"

read i

if [[ $i -lt 0 ]]; then
	echo "${i} lt 0"
elif [[ $i -lt 10 ]]; then
	echo "${i} lt 10"
else
	echo "${i} gt 10"
fi
