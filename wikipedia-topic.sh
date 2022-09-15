#!/bin/bash

source randcolor.sh

topic=$1
topic=$(echo $topic | tr " " '|')
echo $topic
echo -n "Searching"

while [[ $success -lt 1 ]]; do
    article=$(wikipedia2text -r)
    if echo "$article" | grep -E -qi $topic; then
        success=1
    fi
    echo -ne "$(randcolor 150 20).\e[0m"
done
echo
echo -e "\e[0m$article"
