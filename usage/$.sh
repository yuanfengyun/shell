#!/bin/bash

# $$ 当前bash进程号
echo "当前进程号为：$$"

ls / >> /dev/null &
echo "Shell最后运行的后台Process的PID: $!"

ls / >> /dev/null
echo "最后运行的命令的结束代码（返回值）: $?"


