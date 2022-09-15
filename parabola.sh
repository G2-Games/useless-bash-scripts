loops=1
while [ $loops -lt 64 ]; do
	./graph.sh 1 $loops
	loops=$((loops + 1))
done
