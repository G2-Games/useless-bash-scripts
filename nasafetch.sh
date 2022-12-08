version=0.1.0
link=https://apod.nasa.gov/apod/
out=0
descout=0
silent=0
origurl=0

trap ctrl_c INT

ctrl_c() {
	echo "Exiting..."
}

usage() { echo -e "\033[32;4mUsage:\033[0m
   $0 [options]
   By default gets latest image link.

\033[32;4mOptions:\033[0m
  -D [YYMMDD]   : Get image from <date>
  -d            : Get description
  -k            : Output original page link
  -l [link]     : Direct link to APOD page
  -o [filename] : Output image to file (filename optional)
  -O [filename] : Output description to file
  -s            : Silent. Surpress fancy headers.
  -v            : Output version" 1>&2;
  exit 1;
}

getdesc() {
	d1=$(echo "$result" | grep -n 'Explanation:' | cut -d ':' -f1)
	d2=$(echo "$result" | grep -n '<p> <center>' | cut -d ':' -f1)
	if [ -z $d2 ]; then
		d2=$(echo "$result" | grep -n '<center>' | tail -1 | cut -d ':' -f1)
	fi
	df=$((d2 - d1))
	description=$(echo "$result" | grep 'Explanation:' -A $df)
	description=$(echo $description | sed 's/<[^>]*>//g')
}

while getopts l:D:dhkoO:s?v opts; do
	case ${opts} in
		h,?) usage ;;
		l) link=${OPTARG} ;;
		D) date=${OPTARG} && date=$(date -d"$date" "+%y%m%d") ;;
		d) desc=1 ;;
		o) out=1; outfile=${OPTARG} ;;
		O) descout=1; descfile=${OPTARG} ;;
		s) silent=1 ;;
		k) origurl=1 ;;
		v) echo -e "\033[34;1mNASAFetch\033[0m - Get latest NASA Astronomy Picture of the Day!\n\033[35mv\033[36m$version\n\033[32;3mhttps://apod.nasa.gov/apod/\033[0m"; exit 0 ;;
		*) usage ;;
	esac
done

if ! [ -z $date ]; then
	link=https://apod.nasa.gov/apod/ap$date.html
	nicedate=$(date -d"$date" "+%b %d, %Y")
else
	nicedate=$(date "+%b %d, %Y")
fi

result=$(curl -s $link)

if ! [ -z $desc ]; then
	getdesc
	if ! [ $silent -eq 1 ]; then
	echo -en "\033[35;4;1mExplanation\033[0m: "
	fi
	echo $description | cut -d ' ' -f2-
	if ! [ $silent -eq 1 ]; then
		echo
	fi
fi
image=$(echo "$result" | grep -m 1 -i 'href="image' | cut -d '"' -f2 | cut -d '"' -f1 | cut -d '/' -f2-3)
image="https://apod.nasa.gov/apod/image/$image"

if ! [ $silent -eq 1 ]; then
	echo -en "\033[32;4;1mImage Link\033[0m: "
fi
echo $image
if [ $origurl -eq 1 ]; then
	if ! [ $silent -eq 1 ]; then
		echo -en "\033[33;4;1mPage Link\033[0m: "
	fi
	echo $link
fi
if ! [ $silent -eq 1 ]; then
	echo -en "\033[34;4;1mDate\033[0m: "
fi
echo "$nicedate"


if [ $out -eq 1 ]; then
	echo $outfile
	if ! [ $silent -eq 1 ]; then
		echo -en "Downloading image to "
	fi
	if [ -z $outfile ]; then
		if ! [ $silent -eq 1 ]; then
			echo -e "\"\033[32m$(echo $image | cut -d '/' -f7)\033[0m\"..."
		fi
		curl $image -O -#
	else
		if ! [ $silent -eq 1 ]; then
			echo -e "\"$outfile\033[0m\"..."
		fi
		curl -# $image -o $outfile
	fi
fi

if [ $descout -eq 1 ]; then
	getdesc
	if ! [ $silent -eq 1 ]; then
		echo -e "\033[32mOutput description to: $descfile\033[0m"
	fi
	echo $description > $descfile
fi
