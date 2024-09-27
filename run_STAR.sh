#!/bin/bash

### Paths for Genome Index Creation

#GENOME_INDEX_OUT="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/STAR/gencode_v46_star_index"
#GTF="/mnt/grid/tuveson/macmillan/data/srusti/srusti_scripts/STAR/gencode.v46.chr_patch_hapl_scaff.annotation.gtf"
#FASTA="/grid/bsr/data/data/utama/genome/hg38_p13_gencode/GRCh38.p13.chr_patch_hapl_scaff.fa"

module load EBModules
module load STAR/2.7.10a-GCC-10.3.0
module load SAMtools/1.11-GCC-9.3.0 

ulimit -n 10000

STAR --runThreadN 4 \
--quantMode TranscriptomeSAM \
       --outFileNamePrefix $1 \
       --genomeLoad NoSharedMemory \
       --genomeDir $2 \
       --outSAMtype BAM SortedByCoordinate \
       --outFilterMismatchNmax "2" \
       --outFilterMultimapNmax "2" \
       --outSAMunmapped None \
       --outSAMstrandField None \
       --readFilesCommand zcat \
       --readFilesIn $3 $4


### Command for STAR Genome index
#STAR --runThreadN 32 \
#--runMode genomeGenerate \
#--genomeDir $GENOME_INDEX_OUT \
#--genomeFastaFiles $FASTA \
#--sjdbGTFfile $GTF \
#--sjdbOverhang 99 \
#--limitGenomeGenerateRAM 200000000000

