#!/bin/bash

module load EBModules
module load STAR/2.7.10a-GCC-10.3.0
module load RSEM/1.3.3-foss-2019b

GTF="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/STAR/gencode.v46.chr_patch_hapl_scaff.annotation.gtf"
FASTA="/grid/bsr/data/data/utama/genome/hg38_p13_gencode/GRCh38.p13.chr_patch_hapl_scaff.fa"
GENOME_INDEX_OUT="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/RSEM/gencode_v46_rsem_index"

rsem-prepare-reference \
    --gtf $GTF \
    --star \
    $FASTA \
    $GENOME_INDEX_OUT/human_gencode

