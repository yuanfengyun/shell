#!/bin/bash

PS3="select option:"
select option in "one" "two"
do
	case $option in
		"one")
			echo "one"
			break
			;;
		"two")
			echo "two"
			break
			;;
		*)
			echo "wrong"
			break
			;;
	esac
done
