#!/usr/bin/env bash

# Inputs
bam_file=$1
rsem_index=$2
feature=$3
count_prefix=$4
strand_bed=$5
transcript_bam=$6
strand_files=$7

# Extract strand information
basename=$(basename "$count_prefix")
strand_file_path="${strand_files}/${basename}_strand.txt"

echo "basename: $basename, strand_file_path: $strand_file_path"


#Debugging
#if [[ ! -f "$strand_file_path" ]]; then
#    echo "Error: Strand file $strand_file_path does not exist."
#    exit 1
#fi


fw=$(awk 'NR==5 {print $NF}' "$strand_file_path")
rv=$(awk 'NR==6 {print $NF}' "$strand_file_path")

echo "fw: $fw, rv: $rv"

diff=$(echo "scale=3 ;($fw - $rv)*100/($fw + $rv)" | bc)

if (( $(echo "${diff#-} < 50" | bc -l) ));then
        strand=none
        strand_idx=0
elif (( $(echo "$diff > 0" | bc -l) ));then
        strand=forward
        strand_idx=1
else
    	strand=reverse
        strand_idx=2
fi

echo "strand:$strand"

############ RSEM ################

module load EBModules
module load STAR/2.7.10a-GCC-10.3.0
module load RSEM/1.3.3-foss-2019b
module load SAMtools/1.16.1-GCC-11.3.0

ulimit -n 10000

# Output directory path for RSEM
output_dir="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/RSEM/RSEM_res_5"


# Check if input BAM file exists
if [[ ! -f "$bam_file" ]]; then
    echo "Error: BAM file $bam_file does not exist."
    exit 1
fi

rsem-calculate-expression --paired-end -p 8 --strandedness ${strand} \
        --bam "$bam_file" \
        --no-bam-output \
        "${rsem_index}" \
        "${output_dir}/$basename"

# Check if RSEM command was successful
if [[ $? -ne 0 ]]; then
    echo "Error: rsem-calculate-expression command failed."
    exit 1
fi

rm -rf "${basename}.transcript.bam"
rm -rf "${basename}.stat"

#################################

