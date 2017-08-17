#!/bin/bash
#Emily Earl 7/12/2017
#getMeanConservation
#Will read files in folder dataConservation and make a table for the mean conservation
#No arguments. Need to run divideDNase and conservation before running this

START=$(date +%s)

data=~/dataConservation
echo "File" $'\t' "Mean Conservation" > meanConservation.csv

for index in {1..44}
do

	fileName=` ls $data | head -$index | tail -1 `
	file="$data/$fileName"
	
	fileName=`echo $fileName | sed ' s/-conserv//g'`

	echo $fileName $'\t' `cat $file | awk 'BEGIN{sum=0; lines=0;}
	{sum+=$5; lines++;}
	END{print (sum/lines)}'` >> meanConservation.csv


done

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds to do this script"
MINS=$(($DIFF / 60))
echo "It took $MINS minutes to do this script"