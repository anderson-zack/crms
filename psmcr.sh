#!/bin/bash
#SBATCH --job-name=psmcr
#SBATCH --output=psmcr.out
#SBATCH --error=psmcr.err
#SBATCH --time=0-06:00:00
#SBATCH --mail-user=anderson.za@northeastern.edu
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --mail-type=ALL
#SBATCH --mem=40G
#SBATCH --cpus-per-task=8

# Load R
module load R

# Move to our working directory
cd /home/anderson.za/crms/psmc

# Set paths to input/output data
VCF_FILE="/courses/EEMB5538.202530/data/Zm_TomBod_MAF01MM85INDM30_AllChr.recode.vcf.gz"
REF_GENOME="/courses/EEMB5538.202530/data/Zmarina_668_v2.0.fa"
OUTPUT_DNABIN="output_dnabin.rds"
R_SCRIPT="run_vcf2dnabin.R"

# Write R script
cat > $R_SCRIPT <<EOF
library(psmcr)

# Convert VCF to fasta files
dnabin_obj <- VCF2DNAbin("$VCF_FILE",
                         refgenome="$REF_GENOME",
                         individual = 121)

# Save DNAbin object
saveRDS(dnabin_obj, file="$OUTPUT_DNABIN")

# Run psmcr
psmcr_result <- psmc(dnabin_obj, niters = 5, B = 30, mc.cores = 8)

# Save psmc model
saveRDS(psmcr_result, file="psmcr.rds")
EOF

# Run the R script
Rscript $R_SCRIPT