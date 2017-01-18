#!/bin/bash

echo "calculate a + b"
echo "please input a:"
read a
echo "please input b:"
read b

let c=a+b
echo "${a} + ${b} = ${c}"
