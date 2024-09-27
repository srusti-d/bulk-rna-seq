#!/usr/bin/env bash

INP_DIR="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/rna_batch_5"
OUT_DIR="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/cutadapt_PE/cutadapt_res_5"
LOG="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/cutadapt_PE/log"

start_index="$1"
end_index="$2"

files_R1=("${INP_DIR}"/*_R1.fastq.gz)

for (( index = start_index; index <= end_index; index++ )); do
    if [ "$index" -lt 0 ] || [ "$index" -ge "${#files_R1[@]}" ]; then
        echo "Index $index is out of range."
        continue
    fi

    input_R1="${files_R1[index]}"
    input_R2="${input_R1/_R1/_R2}"

#    if [ ! -f "$input_R2" ]; then
#        echo "Corresponding _R2 file not found for $input_R1, skipping."
#        continue
#    fi

    base_name=$(basename "$input_R1" "_R1.fastq.gz")

#    if [ -f "${LOG}/output_${base_name}.txt" ] && [ -f "${LOG}/error_${base_name}.txt" ]; then
#        echo "Output files already exist for ${base_name}, skipping."
#        continue
#    fi

    qsub -l m_mem_free=1G -pe threads 16 -cwd -N job_${base_name} \
         -o "${LOG}/output_${base_name}.txt" \
         -e "${LOG}/error_${base_name}.txt" \
         -V ./cutadapt_PE.sh "$input_R1" "$input_R2" "$OUT_DIR"
done
