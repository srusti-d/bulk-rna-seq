module load EBModules
module load RSeQC
module load Subread

infer_experiment.py -r $5 -i $1 > $4_strand.txt

fw=$(awk 'NR==5 {print $NF}' $4_strand.txt)
rv=$(awk 'NR==6 {print $NF}' $4_strand.txt)

diff=$(echo "scale=3 ;($fw - $rv)*100/($fw + $rv)" | bc)

if (( $(echo "${diff#-} < 20" | bc -l) ));then
        strand=unstranded
        strand_idx=0
elif (( $(echo "$diff > 0" | bc -l) ));then
        strand=forward
        strand_idx=1
else
    	strand=reverse
        strand_idx=2
fi

suffix=counts.txt

featureCounts -a $2 \
        -T 16 \
        -p --countReadPairs \
        -t "exon" \
        -g $3 \
        -s ${strand_idx} \
        -Q 12 \
        --minOverlap 1 \
        -C \
        -o $4_${suffix} \
        $1

