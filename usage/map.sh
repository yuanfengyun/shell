#!/bin/bash

declare -A map=(["sunjun"]="a" ["jason"]="b" ["lee"]="c") #定义时初始化一些值

echo "输出所有元素"
echo ${map[*]}

echo "输出所有key"
echo ${!map[@]}

map[hello]=3

map[4]=5
map[4]=

echo "输出所有元素"
echo ${map[@]}
