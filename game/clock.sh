#!/bin/bash

asciinumber=(
    '    .XEEEEb           ,:LHL          :LEEEEEG        .CNEEEEE8                bMNj       NHKKEEEEEX           1LEEE1    KEEEEEEEKNMHH       8EEEEEL.         cEEEEEO    '
    '   MEEEUXEEE8       jNEEEEE         EEEEHMEEEEU      EEEELLEEEEc             NEEEU      7EEEEEEEEEK        :EEEEEEN,    EEEEEEEEEEEEE     OEEEGC8EEEM      1EEELOLEEE3  '
    '  NEE.    OEEC      EY" MEE         OC      LEEc     :"      EEE            EEGEE3      8EN               MEEM.                  :EE.    1EEj     :EEO    1EE3     DEEc '
    ' ,EEj      EEE          HEE                  EEE             cEE:          EEU EEJ      NEC              EEE                     EEJ     EEE       EEE    EEN       KEE '
    ' HEE       jEE1         NEE                  EEE             EEE          EEM  EEJ      EE              LEE   ..                EEK      DEEj     :EE7   ,EE1       jEE '
    ' EEH        EEZ         KEE                 :EE1       .::jZEEG          EEU   EEJ     .EEEEEENC        EE77EEEEEEL            NEE        UEENj  bEE7    .EEX       :EE.'
    '.EEZ        EEM         KEE                 EEK        EEEEEEC         .EEc    EEC     :X3DGMEEEEU     3EEEED.".GEEE.         CEE.          EEEEEEE       EEEj     :EEE '
    ' EEZ        EEM         KEE               :EEK            "jNEEZ      :EE      EE7             MEEU    LEEb       EEE        .EE8         DEEL:.8EEEM      NEEENMEEEHEE '
    ' EEN       .EEG         KEE              bEEG                7EEM    jEEN738ODDEEM3b            EEE    MEE        8EE,       EEE         EEE      ,EEE      .bEEEEC XEE '
    ' LEE       3EE:         KEE            .EEE,                  EEE    LEEEEEEEEEEEEEE            XEE    8EE        cEE:      NEE         7EE1       jEE1            :EE: '
    ' .EEc      EEE          KEE           bEED                    EEE              EE1              EEE     EEX       EEE      3EE:         cEEc       7EEj           CEEG  '
    '  MEE7    NEE.          EEE         jEEK             C       EEE1              EEC     j      :EEE      CEEG     LEEj     .EEU           EEE:     .EEE          1EEEJ   '
    '   bEEEEEEEE.           EEE        NEEEEEEEEEEEE    bEEEEEEEEEE7               EEd    JEEEEEEEEEN        jEEEEEEEEE7     .EEE             KEEEEHEEEEL      8EEEEEEX     '
    '     DEEEL7             CGD        3GD3DOGGGGGUX     :DHEEEN8.                 bUd     7GNEEEMc            7LEEEX:       1XG                JHEEEM1        COLIN"       '
);

len=${#asciinumber[@]};

function print_dot {
    local y=$1
	local x=$2

	echo -ne "\033[$((y+3));${x}H\e[1;32m @@ \e[0m";
	echo -ne "\033[$((y+4));${x}H\e[1;32m @@ \e[0m";
	echo -ne "\033[$((y+10));${x}H\e[1;32m @@ \e[0m";
	echo -ne "\033[$((y+11));${x}H\e[1;32m @@ \e[0m";
}

#共有三个参数, 
#第一个是所要打印的数字, 
#第二个是数字的y，
#第三个是数字的x
function print_number {
    local number=$1
	local y=$2
	local x=$3
	local start=$(( number * 17 ));
	local str=""

	for (( i = 0; i < len; i++ )); do
		y=$(($2 + i))
	    str=${asciinumber[$i]:$start:17}
		echo -ne "\e[${y};${x}H\e[1;32m${str}\e[0m"
	done
}

function print_time(){
	local hour=`date +%H`
	local hour_high=`expr $hour / 10`
	local hour_low=`expr $hour % 10`
	
	local minute=`date +%M`
	local minute_high=`expr $minute / 10`
	local minute_low=`expr $minute % 10`

	local second=`date +%S`
	local second_high=`expr $second / 10`
	local second_low=`expr $second % 10`
	
	local y=$1
	local x=$2
	print_number $hour_high $y $[ x + 1 ]
	print_number $hour_low $y $[ x + 18 ]
	print_dot $y $[ x + 35 ]
	print_number $minute_high $y $[ x + 39 ]
	print_number $minute_low $y $[ x + 56 ]
	print_dot $y $[ x + 73 ]
	print_number $second_high $y $[ x + 77 ]
	print_number $second_low $y $[ x + 94 ]
}

function in_rectangle(){
	local y=$1
	local x=$2

	local min_y=$3
	local max_y=$4

	local min_x=$5
	local max_x=$6

	if [ $y -lt $min_y -o $y -gt $max_y ]; then
		return 0
	fi

	if [ $x -lt $min_x -o $x -gt $max_x ]; then
		return 0
	fi

	return 1
}

#清除屏幕，擦除原来有，现在没有的格子
function clear_screen(){
	local old_y=$1
	local old_x=$2

	if [ $old_y -eq 0 -a $old_x -eq 0 ]; then
		clear
		return
	fi

	local new_y=$3
	local new_x=$4

	local py=0
	local px=0

	local y=0
	local x=0
	for (( y=0; len-y; y=y+1 )); do
		for ((x=0; 112-x; x=x+1 )); do
			py=`expr $old_y + $y`
			px=`expr $old_x + $x`

			in_rectangle $py $px $new_y $[new_y + len] $new_x $[new_x + 112]

			# 在新框中，不需要擦除
			if [ $? -eq 1 ]; then
				continue
			fi

			#擦除一个字符
			tput cup $(( py - 1 )) $(( px -1))
			echo -n " "
		done
	done
}

function main(){
	# 隐藏光标
	tput civis

	local row=`expr $LINES - $len`
	local col=`expr $COLUMNS - 112`
	local y=100
	local x=100
	local dy=`expr $RANDOM % 100`
	local dx=`expr $RANDOM % 100`
	
	local py=0
	local px=0
	local old_py=0
	local old_px=0
	while [ 1 ]; do
		sleep 0.01
		y=`expr $y + $dy`
		x=`expr $x + $dx`
		py=`expr $y / 100`
		px=`expr $x / 100`
		if [ $py -eq $old_py -a $px -eq $old_px ]; then
			continue
		fi
		clear_screen $old_py $old_px $py $px
		#clear
		old_py=$py
		old_px=$px
		print_time $py $px
		echo "$py $px $dy $dx" >> a.txt
		if [ $py -lt 1 -o $py -gt $row ]; then
			dy=`expr 0 - $dy`
		fi

		if [ $px -lt 1 -o $px -gt $col ]; then
			dx=`expr 0 - $dx`
		fi
	done
}

main
