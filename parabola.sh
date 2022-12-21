loops=1
while [ $loops -lt 64 ]; do
	./rainbow.sh 1 $loops
	loops=$((loops + 1))
done
