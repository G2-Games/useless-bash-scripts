#!/bin/bash

source randcolor.sh

topic=$1
echo -n "Searching"

while [[ $success -lt 1 ]]; do
    article=$(wikipedia2text -r)
    if echo "$article" | grep -qi $topic; then
        success=1
    fi
    echo -ne "$(randcolor 150 20)."
done
echo
echo -e "$(randcolor 180 20)$article"
