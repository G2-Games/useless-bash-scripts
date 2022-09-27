#!/bin/bash
row=0
column=0

files=($1)

if ! [ -f $1 ]; then
        echo "$1: File not found"
        exit 1
fi

if ! grep -q MVC-.*M\.JPG <<< ${files[0]}; then
        echo "Not a valid seqeuence!"
        echo "USAGE: cvmult [MULTI...]"
        exit 1
fi

width=$(identify -format '%w' ${files[0]} 2>/dev/null)
height=$(identify -format '%h' ${files[0]} 2>/dev/null)

if [ $width -ne 960 ] && [ $height -ne 720 ]; then
        echo "Not a valid seqeuence!"
        echo "USAGE: cvmult [MULTI...]"
        exit 1
fi

if [ $(df -PB1 . | tail -1 | awk '{print $4}') -lt 430000 ] || ! [ -f $filename.GIF ] && [ $(df -PB1 . | tail -1 | awk '{print $4}') -lt 130000 ]; then
        echo "Not enough disk space! Need at least 430kb"
        exit 1
fi

sequence=0
filename=$(echo ${files[0]} | sed 's/.JPG//')

if [ -f $filename.GIF ]; then
        echo "Reconstructing $filename.GIF..."
else
        echo "Converting $filename..."
fi

arrlen=$((${#files[@]} * 9))

for i in $( eval echo {1..$arrlen} ); do
        convert -extract 320x240+$column+$row ${files[$sequence]} -quality 85 img_frame${i}.jpg
        column=$((column + 320))
        if [ $((i%3)) -eq 0 ] && ! [ $((i%9)) -eq 0 ]; then
                row=$((row + 240))
                column=0
        elif [ $((i%9)) -eq 0 ]; then
                sequence=$((sequence + 1))
                row=0
                column=0
        fi
        tput sc
        echo -n img_frame${i}.jpg
        echo
        for i in $( eval echo {1..$i} ); do
                echo -n "."
        done
        tput rc
done
#ffmpeg -loglevel quiet -y -framerate 4 -i img_frame%d.jpg -loop 0 ${filename}-ffmpeg1.gif
#ffmpeg -loglevel quiet -y -framerate 4 -i img_frame%d.jpg -vf "split[s0][s1];[s0]palettegen=stats_mode=single[p];[s1][p]paletteuse=new=1" -loop 0 ${filename}-ffmpeg2.gif
#ffmpeg -loglevel quiet -y -framerate 4 -i img_frame%d.jpg -c:v libx264 -pix_fmt yuv420p ${filename}-ffmpeg2.mp4
convert -delay 25 -dither None -colors 200 img_frame*.jpg -loop 0 -layers OptimizeFrame ${filename}.GIF

rm img_frame*.jpg

echo
tput el
echo "Done!"
