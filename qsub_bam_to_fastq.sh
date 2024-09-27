DIR="/mnt/grid/tuveson/macmillan/data/pass1/tuveson_rna"
INP_DIR="/mnt/grid/tuveson/macmillan/data/pass1/tuveson_rna"
OUT_DIR="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/rna_batch_5"
SCRIPT="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/bam_to_fastq.sh"

BAM_FILES=($(find "$DIR" -type f -name "*.bam"))

# First argument is the start index of the bam files for conversion
# Second argument is the ending index of the bam files for conversion

for i in $(seq $1 1 $2); do
    BAM="${BAM_FILES[i]}"  
    qsub -l m_mem_free=1G -pe threads 16 -cwd -N job_$(basename "$BAM" .bam) "$SCRIPT" "$BAM" "$OUT_DIR"
done
