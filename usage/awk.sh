#/bin/bash

# 内置变量
#ARGC               命令行参数个数
#ARGV               命令行参数排列
#ENVIRON            支持队列中系统环境变量的使用
#FILENAME           awk浏览的文件名
#FNR                浏览文件的记录数
#FS                 设置输入域分隔符，等价于命令行 -F选项
#NF                 浏览记录的域的个数
#NR                 已读的记录数
#OFS                输出域分隔符
#ORS                输出记录分隔符
#RS                 控制记录分隔符

a='aabb'

cat /etc/passwd | awk -F : '
BEGIN {}
	{print $1}
END { 
	print NR,NF
}
'
