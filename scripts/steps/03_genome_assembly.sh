#!/usr/bin/env bash

###############################################################################
# Step 03: Genome Assembly
#
# Description:
#   Performs de novo genome assembly from quality-controlled paired-end
#   reads using SPAdes.
#
# Input:
#   results/trimmed_reads/<sample>_R1_P.fastq.gz
#   results/trimmed_reads/<sample>_R2_P.fastq.gz
#
# Output:
#   results/assemblies/<sample>/
#       ├── contigs.fasta
#       ├── scaffolds.fasta
#       ├── assembly_graph.fastg
#       └── other SPAdes output files
###############################################################################

set -euo pipefail

###############################################################################
# Load Configuration and Utilities
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "${SCRIPT_DIR}")")"

source "${PROJECT_ROOT}/config/config.sh"
source "${PROJECT_ROOT}/scripts/utils.sh"

###############################################################################
# Validate Arguments
###############################################################################

if [[ $# -ne 1 ]]; then
    log_error "Usage: $0 <sample_name>"
    exit 1
fi

###############################################################################
# Input
###############################################################################

SAMPLE="$1"

READ1="${TRIMMED_READS_DIR}/${SAMPLE}_R1_P.fastq.gz"
READ2="${TRIMMED_READS_DIR}/${SAMPLE}_R2_P.fastq.gz"

OUTDIR="${ASSEMBLY_DIR}/${SAMPLE}"

###############################################################################
# Start
###############################################################################

START_TIME=$(date +%s)

print_header "Step 03: Genome Assembly"

log_info "Sample: ${SAMPLE}"

###############################################################################
# Create Output Directory
###############################################################################

create_directory "${ASSEMBLY_DIR}"

###############################################################################
# Skip Completed Analysis
###############################################################################

if skip_step "Step 03: Genome Assembly" "${OUTDIR}/contigs.fasta"
then
    exit 0
fi

###############################################################################
# Validate Input Files
###############################################################################

check_file "${READ1}"
check_file "${READ2}"

###############################################################################
# Activate Conda Environment
###############################################################################

conda activate "${MAIN_ENV}"

###############################################################################
# Validate Required Tool
###############################################################################

check_tool spades.py

###############################################################################
# Run SPAdes
###############################################################################

log_info "Running SPAdes..."

log_info "Threads : ${THREADS}"
log_info "Memory  : ${SPADES_MEMORY} GB"

run_command \
    spades.py \
    -1 "${READ1}" \
    -2 "${READ2}" \
    -o "${OUTDIR}" \
    -t "${THREADS}" \
    -m "${SPADES_MEMORY}"

###############################################################################
# Finish
###############################################################################

report_runtime "Step 03: Genome Assembly" "${START_TIME}"
