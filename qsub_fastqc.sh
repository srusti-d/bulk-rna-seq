#!/usr/bin/env bash

module load EBModules-LegacyBNB
module load FastQC/0.11.8-Java-1.8

INP_DIR="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/rna_batch_4"
OUT_DIR="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/FastQC/fastqc_results"
SCRIPT="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/FastQC/fastqc.sh"
LOG="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/FastQC/log"

FASTQ_FILES=($(find "$INP_DIR" -type f -name "*.fastq.gz"))

for i in $(seq $1 1 $2); do
    FASTQ="${FASTQ_FILES[i]}"  
    qsub -l m_mem_free=1G -pe threads 16 -cwd -N job_$(basename "$FASTQ" .fastq.gz) \
         -o "$LOG/output_$(basename "$FASTQ" .fastq.gz).txt" \
         -e "$LOG/error_$(basename "$FASTQ" .fastq.gz).txt" \
         -V "$SCRIPT" "$FASTQ" "$OUT_DIR"
done

