#!/bin/bash
ETH=$(vnstat -i eth0 | grep "today" | awk '{print $8}')


if [ -z "$ETH" ]; then ETH=0.0; fi


if [ $(vnstat -i eth0 | grep "today" | awk '{print substr ($9, 1, 1)}') == 'G' ]; then ETH=$(bc -l <<< "scale=2; ($ETH * 1048576)"); fi

if [ $(vnstat -i eth0 | grep "today" | awk '{print substr ($9, 1, 1)}') == 'M' ]; then ETH=$(bc -l <<< "scale=2; ($ETH * 1024)"); fi

TOTAL=$(awk "BEGIN {print $ETH; exit}")
TOTAL=${TOTAL%.*}	# trim to 2 decimal places

if [ $TOTAL -gt 1048576 ]
then
	NOTA='GB'
	TOTAL=$(bc -l <<< "scale=2; ($TOTAL / 1048576)")
elif [ $TOTAL -gt 1024 ]
then
	NOTA='MB'
	TOTAL=$(bc -l <<< "scale=2; ($TOTAL / 1024)")
else 
	NOTA='KB'
fi

echo "$TOTAL $NOTA"
exit
