#!/bin/bash
topic=$(echo $1 | sed -r 's/[ ,]+/|/g')
echo $topic
echo -n "Searching"
while ! echo "$article" | grep -E -qi $topic; do
    article=$(wikipedia2text -r)
    echo -ne "."
done
echo -e "$article"
