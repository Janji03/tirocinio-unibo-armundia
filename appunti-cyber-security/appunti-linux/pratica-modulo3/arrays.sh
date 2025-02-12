#!/bin/bash

# arrays
# definizione
array1=(x y z)
# lettura
echo ${array1[0]} ${array1[1]} ${array1[2]}

# altri metodi
echo ${array1[*]} o ${array1[@]}
echo ${#array1[@]}
echo ${!array1[@]}
unset array1[1]

