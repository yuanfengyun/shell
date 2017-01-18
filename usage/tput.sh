#!/bin/bash

tput clear # 清屏
tput sc # 保存当前光标位置 
tput cup 10 13 # 将光标移动到 row col 
tput civis # 光标不可见 
tput cnorm # 光标可见 
tput rc # 显示输出 exit 0
