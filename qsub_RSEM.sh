#!/usr/bin/env bash

INP_DIR="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/STAR/star_res_5"
OUT_DIR="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/RSEM/RSEM_res_5"
STRAND_FILES="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/feature_counts/FC_res_5"
LOG_DIR="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/RSEM/log"
SCRIPT="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/RSEM/RSEM_PE.sh"
GTF="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/STAR/gencode.v46.chr_patch_hapl_scaff.annotation.gtf"
BAM_FILES=($(find "$INP_DIR" -type f -name "*.toTranscriptome.out.bam"))
FEATURE="gene_id"
STRAND_BED="/grid/bsr/data/data/utama/genome/GRCm39_M29_gencode/gencode.vM29.annotation_forStrandDetect_geneID.bed"
GENCODE_INDEX="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/RSEM/gencode_v46_rsem_index/human_gencode"

start_index=$1
end_index=$2

for (( index = start_index; index <= end_index; index++ )); do
    bam_file="${BAM_FILES[index]}"

    BASENAME=$(basename "$bam_file" ".toTranscriptome.out.bam")

    qsub -l m_mem_free=15G -pe threads 16 -cwd \
         -o "${LOG_DIR}/${BASENAME}_log_output_FC.txt" \
         -e "${LOG_DIR}/${BASENAME}_error_FC.txt" \
         -V "$SCRIPT" "$bam_file" "$GENCODE_INDEX" "$FEATURE" "${OUT_DIR}/${BASENAME}" "$STRAND_BED" "$bam_file" "$STRAND_FILES"
done


