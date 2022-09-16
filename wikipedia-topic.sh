#!/bin/bash
topic=$(echo $1 | sed -r 's/[ ,]+/|/g')
if [[ -z "$1" ]]; then echo -e "Usage: wikipedia-topic \"[TOPICS]...\"" && exit 1; fi
echo "Searching for \"$(echo $topic | sed -r 's/[|]+/, /g')\""
while ! echo "$article" | grep -E -qi $topic; do
    article=$(wikipedia2text -r)
    echo -ne "."
done
echo -e "$article"
