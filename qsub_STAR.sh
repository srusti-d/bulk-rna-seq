#!/usr/bin/env bash

INP_DIR="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/cutadapt_PE/cutadapt_res_5"
OUT_DIR="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/STAR/star_res_5"
LOG_DIR="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/STAR/log"
SCRIPT="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/STAR/run_STAR.sh"
GENOME_DIR="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/STAR/gencode_v46_star_index"

start_index=$1 
end_index=$2   

FASTQ_FILES=($(find "$INP_DIR" -type f -name "*.fastq.gz"))

# Arrays to store _R1 and _R2 files
declare -a R1_FILES
declare -a R2_FILES

for (( index = start_index; index <= end_index; index++ )); do
    fastq_file="${FASTQ_FILES[index]}"
    if [[ "$fastq_file" == *_R1.fastq.gz ]]; then
        R1_FILES+=("$fastq_file")
    elif [[ "$fastq_file" == *_R2.fastq.gz ]]; then
        R2_FILES+=("$fastq_file")
    fi
done

for (( i = 0; i < ${#R1_FILES[@]}; i++ )); do
    input_R1="${R1_FILES[i]}"
    BASENAME=$(basename "$input_R1" "_R1.fastq.gz")

    # Find corresponding R2 file
    input_R2=""
    for (( j = 0; j < ${#R2_FILES[@]}; j++ )); do
        if [[ $(basename "${R2_FILES[j]}" "_R2.fastq.gz") == "$BASENAME" ]]; then
            input_R2="${R2_FILES[j]}"
            break
        fi
    done

    if [[ -n "$input_R2" ]]; then
        qsub -l m_mem_free=50G -pe threads 16 -cwd -N job_${BASENAME} \
             -o "$OUT_DIR/output_star_${BASENAME}.txt" \
             -e "$LOG_DIR/error_star_${BASENAME}.txt" \
             -V "$SCRIPT" "${OUT_DIR}/${BASENAME}" "$GENOME_DIR" "$input_R1" "$input_R2"
    else
        echo "Warning: No matching _R2 file found for $input_R1"
    fi
done

