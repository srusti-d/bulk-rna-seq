#!/bin/sh

module load EBModules
module load cutadapt/4.4-GCCcore-12.2.0

# Untrimmed R1 and R2 files
input_R1="$1"
input_R2="$2"
output_dir="$3"

output_R1="${output_dir}/$(basename "${input_R1%.fastq.gz}.fastq.gz")"
output_R2="${output_dir}/$(basename "${input_R2%.fastq.gz}.fastq.gz")"

# Run cutadapt
cutadapt -j 16 -m 20 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -o "$output_R1" -p "$output_R2" "$input_R1" "$input_$

chmod a+rwx "${output_R1}"
chmod a+rwx "${output_R2}"
