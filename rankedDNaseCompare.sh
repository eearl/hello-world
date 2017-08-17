#!/bin/bash
#Emily 7/6/17
#rankedDNaseCompare
#Sort DNase peaks by highest P-value. Look at 5000 peaks at a time and find the
# % of peaks that are proximal (overlap with TSS.Filtered.4K.bed)
#Can change the numbers of peaks it splits into at the comments. 
#Used to be just one script that was edited to switch between comparing ATAC-seq or DNase to TSS.Filtered, but now they are separate
#NO arguments. Will draw from Data-List.txt

START=$(date +%s)
path="/data/projects/rusers/Emily-2017/DNase-ATAC-Comparison"
list="$path/Data-List.txt"
prox="$path/TSS.Filtered.4K.bed"
#CHANGE LABELS

echo "Tissue-Timepoint, DNase, `echo {5000..100000..5000}, `" > proximityDNase5000.csv #CHANGE NUM
#CHANGE THIS NAME
for outerInd in {2..13}
do
        file=`cat $list | head -$outerInd | tail -1 | cut -f 3` #CHANGE THIS - 2 for ATAC, 3 for DNASE
        description=`cat $list | head -$outerInd | tail -1 | cut -f 1`
        fileName="$path/$file.Mod.bed" #CHANGE THIS
        cat $fileName | sort -k7,7rg > ~/tempHelper/workingInfo #CHANGE COLUMN. 8 FOR ATAC, 5 OR 7 FOR DNASE
        echo > ~/tempHelper/numerators

        echo $description > ~/tempHelper/numerators
        echo $file >> ~/tempHelper/numerators

        for index in {5000..100000..5000} #CHANGE NUM
        do
                head -$index ~/tempHelper/workingInfo | tail -5000 > ~/tempHelper/subset #CHANGE NUM
        echo $index: `bedtools intersect -u -a ~/tempHelper/subset -b $prox | wc -l` >> ~/tempHelper/numerators
        done

        cat ~/tempHelper/numerators | awk 'BEGIN{FS=": "; \
        ORS=", "} 
        {if(NF==1) \
                {print $1} \
        else{ \
                print ($2/5000) \
        } \
        }       
        END{ ORS=""; \
        print "\n"}' >> proximityDNase5000.csv #CHANGE THIS
        echo Done with $outerInd
done

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds to do this script"
MINS=$(($DIFF / 60))
echo "It took $MINS minutes to do this script"