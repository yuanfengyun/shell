#!/bin/bash

# -r 只读
declare -r const_a=1

const_a=2

# -i 整数
declare -i n
n=3
n=3+1
echo $n

# -a 数组
declare -a array

array[0]=0
array[1]=1
array[2]=2

echo ${array[@]}

# -x export



