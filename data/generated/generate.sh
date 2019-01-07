#!/bin/bash
FLOOR=100
CEILING=999

for i in $( seq 1 20); do
	number=$RANDOM   #initialize
	while [ "$number" -le $FLOOR ] || [ "$number" -ge $CEILING ]
	do
	  number=$RANDOM
	done
	
	status="complete"
	if [[ "$i" =~ ^(3|5|11|18)$ ]]; then 
		status="incomplete"
	fi

	echo $(openssl rand -hex 6) '\t' $RANDOM '\t' $status > Result.${number}.txt
done
