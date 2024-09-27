#!/bin/bash

module load EBModules
module load BEDTools/2.30.0-GCC-11.3.0
module load SAMtools/1.16.1-GCC-11.3.0

bam_to_fastq() {
    bam_file=$1
    output_dir=$2
    base_name=$(basename "${bam_file%.bam}")
    fastq_file1="${output_dir}/${base_name}_R1.fastq.gz"
    fastq_file2="${output_dir}/${base_name}_R2.fastq.gz"
    sorted_bam_file="${output_dir}/${base_name}_sorted.bam"
    
    echo "Converting paired end $bam_file to $fastq_file1 and $fastq_file2"
    samtools sort -@16  -n -o "$sorted_bam_file" "$bam_file" 
    samtools fastq -@16 -1 "$fastq_file1" -2 "$fastq_file2" "$sorted_bam_file"
    #bedtools bamtofastq -i $sorted_bam_file -fq $fastq_file1 -fq2 $fastq_file2

    rm "$sorted_bam_file"
    chmod a+rwx mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/rna_batch_3/*
}

# Make sure there are 2 arguments
if [ "$#" -ne 2 ]; then
    echo "Need two arguments: input_bam_file, output_dir."
    exit 1
fi

bam_file=$1
output_dir=$2

# Make output directory if doesn't exist
mkdir -p "$output_dir"
bam_to_fastq "$bam_file" "$output_dir"

