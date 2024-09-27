#!/usr/bin/env bash

INP_DIR="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/STAR/star_res_5"
OUT_DIR="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/feature_counts/FC_res_5"
LOG_DIR="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/feature_counts/log"
SCRIPT="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/feature_counts/featurecounts_PE.sh"
GTF="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/STAR/gencode.v46.chr_patch_hapl_scaff.annotation.gtf"
BAM_FILES=($(find "$INP_DIR" -type f -name "*.sortedByCoord.out.bam"))
FEATURE="gene_id"
STRAND_BED="/grid/bsr/data/data/utama/genome/GRCm39_M29_gencode/gencode.vM29.annotation_forStrandDetect_geneID.bed"

start_index=$1
end_index=$2

for (( index = start_index; index <= end_index; index++ )); do
    bam_file="${BAM_FILES[index]}"

    BASENAME=$(basename "$bam_file" ".sortedByCoord.out.bam")

    qsub -l m_mem_free=1G -pe threads 16 -cwd \
         -o "${LOG_DIR}/${BASENAME}_log_output_FC.txt" \
         -e "${LOG_DIR}/${BASENAME}_error_FC.txt" \
         -V "$SCRIPT" "$bam_file" "$GTF" "$FEATURE" "${OUT_DIR}/${BASENAME}" "$STRAND_BED"
done
