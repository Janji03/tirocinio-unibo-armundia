#!/bin/bash

read v1 v2
if test $v1 -gt $v2; then
	echo "$v1 è maggiore"
elif test $v1 -lt $v2; then
	echo "$v2 è magggiore"
else
	echo "sono uguali"
fi
