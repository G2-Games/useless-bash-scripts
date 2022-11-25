#!/bin/bash

# Syntax: ./randcolor.sh <luma range low> <luma range high>

# For random colors; this will only generate colors with sufficient
# perceptual luma to be readable on a dark background... you may have
# to modify it for light
cluma=0
loops=0
range=$(echo "$2/2" | bc)
range=$(printf %.0f $range)
while [[ $(printf %.0f $cluma) -le $(echo "$1 $range" | awk '{print $1 - $2}') ]] || [[ $(printf %.0f $cluma) -ge $(echo "$1 $range" | awk '{print $1 + $2}') ]];
do
  cr=$((0 + $RANDOM % 255))
  crl=$(echo "$cr 0.299" | awk '{print ( $1 / 255 ) * $2}')
  cg=$((0 + $RANDOM % 255))
  cgl=$(echo "$cg 0.587" | awk '{print ( $1 / 255 ) * $2}')
  cb=$((0 + $RANDOM % 255))
  cbl=$(echo "$cb 0.114" | awk '{print ( $1 / 255 ) * $2}')
  cluma=$(echo "$crl $cgl $cbl" | awk '{print $1 + $2 + $3}')
  cluma=$(echo "$cluma 255" | awk '{print $1 * $2}')
  loops=$((loops+1))
done
echo -n "\e[38;2;${cr};${cg};${cb}m"


