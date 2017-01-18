#!/bin/bash

echo "please input a number:"
read a

case $a in
  1)
    echo "number is 1"
	;;
  2)
    echo "number is 2"
	;;
  *)
	echo "number is not 1 and not 2"
	;;
esac

