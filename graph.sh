#!/bin/bash

source randcolor.sh

round () {
    printf "%.${2:-0}f" "$1"
}

calc() { awk "BEGIN{ printf \"%.2f\n\", $* }"; }

rainbow () {
    scale=1
    divisor=16
    x=0

    if [[ $1 -ne 0 ]]; then
        scale=$1
    fi

    if [[ $2 -gt 0 ]]; then
        divisor=$2
    fi

    while [[ $x -lt $(echo "255/$scale" | bc) ]]; do

        #cr=$(echo "-sqrt($x^2)+255" | bc)
        #cg=$(echo "-sqrt(($x-85)^2)+255" | bc)
        #cb=$(echo "-sqrt(($x-170)^2)+255" | bc)

        #divisorf=$(echo "($divisor/$scale)" | bc)
        divisorf="$(calc $divisor/$scale)"

        cr=$(echo  "(-(($x-(020/$scale))^2)/$(calc $divisorf/$scale))+255" | bc)
        cg=$(echo  "(-(($x-(085/$scale))^2)/$(calc $divisorf/$scale))+255" | bc)
        cb=$(echo  "(-(($x-(170/$scale))^2)/$(calc $divisorf/$scale))+255" | bc)
        cr2=$(echo "(-(($x-(255/$scale))^2)/$(calc $divisorf/$scale))+255" | bc)

        if [[ $(round $cr) -ge 0 ]]; then
            crf=$cr
        else
            crf=""
        fi
        if [[ $(round $cg) -ge 0 ]]; then
            cgf=$cg
        else
            cgf=0
        fi
        if [[ $(round $cb) -ge 0 ]]; then
            cbf=$cb
        else
            cbf=0
        fi
        if [[ $(round $cr2) -ge 0 ]]; then
            crf=$cr2
        else
            crf2=""
        fi

        echo -ne "\e[38;2;${crf}${crf2};${cgf};${cbf}m█"

        x=$((x + 1))
    done
    echo -en "\e[0m"
}

loops=1

rainbow $1 $2
echo

