#!/bin/bash
comic=$(curl -Ls https://c.xkcd.com/random/comic/ | grep image-orientation:none;)

comic=$(echo $comic | cut -d' ' -f-2 | cut -d' ' -f2-2 | cut -d'"' -f2-2)

echo "https:$comic"
