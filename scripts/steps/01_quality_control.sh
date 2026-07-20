#!/usr/bin/env bash

###############################################################################
# Step 01: Quality Control and Read Trimming
#
# Description:
#   - Performs quality assessment of raw paired-end reads using FastQC.
#   - Trims adapters and low-quality bases using Trimmomatic.
#
# Input:
#   data/<sample>_R1_001.fastq.gz
#   data/<sample>_R2_001.fastq.gz
#
# Output:
#   results/qc/raw/
#   results/qc/trimmed/
#   results/trimmed_reads/

###############################################################################

set -euo pipefail

###############################################################################
# Load configuration
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

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

READ1="${RAW_READS_DIR}/${SAMPLE}_R1_001.fastq.gz"
READ2="${RAW_READS_DIR}/${SAMPLE}_R2_001.fastq.gz"

TRIMMED_READ1="${TRIMMED_READS_DIR}/${SAMPLE}_R1_P.fastq.gz"
TRIMMED_READ2="${TRIMMED_READS_DIR}/${SAMPLE}_R2_P.fastq.gz"

UNPAIRED_READ1="${TRIMMED_READS_DIR}/${SAMPLE}_R1_UP.fastq.gz"
UNPAIRED_READ2="${TRIMMED_READS_DIR}/${SAMPLE}_R2_UP.fastq.gz"

###############################################################################
# Start
###############################################################################

START_TIME=$(date +%s)

print_header "Step 01: Quality Control and Read Trimming"

log_info "Sample: ${SAMPLE}"

###############################################################################
# Create output directories
###############################################################################

create_directory \
    "${RAW_QC_DIR}" \
    "${TRIMMED_QC_DIR}" \
    "${TRIMMED_READS_DIR}"

###############################################################################
# Skip completed analysis
###############################################################################

if skip_step "Step 01: Quality Control and Read Trimming" "${TRIMMED_READ1}"
then
    exit 0
fi

###############################################################################
# Validate input files
###############################################################################

check_file "${READ1}"
check_file "${READ2}"

###############################################################################
# Activate conda environment
###############################################################################

log_info "Activating ${MAIN_ENV} environment..."

conda activate "${MAIN_ENV}"

###############################################################################
# Validate required tools
###############################################################################

check_tool fastqc
check_tool trimmomatic

###############################################################################
# FastQC
###############################################################################

log_info "Running FastQC on raw reads..."

run_command \
    fastqc \
    "${READ1}" \
    "${READ2}" \
    --outdir "${RAW_QC_DIR}"

###############################################################################
# Trimmomatic
###############################################################################

log_info "Running Trimmomatic..."

run_command \
    trimmomatic \
    -Xms"${JAVA_INITIAL_MEMORY}" \
    -Xmx"${JAVA_MEMORY}" \
    PE \
    -threads "${THREADS}" \
    "${READ1}" \
    "${READ2}" \
    "${TRIMMED_READ1}" \
    "${UNPAIRED_READ1}" \
    "${TRIMMED_READ2}" \
    "${UNPAIRED_READ2}" \
    SLIDINGWINDOW:${SLIDING_WINDOW} \
    MINLEN:${MIN_READ_LENGTH}
    
###############################################################################
# FastQC on Trimmed Reads
###############################################################################

if [[ "${RUN_POST_TRIM_QC}" == true ]]
then

    log_info "Running FastQC on trimmed reads..."

    run_command \
        fastqc \
        "${TRIMMED_READ1}" \
        "${TRIMMED_READ2}" \
        --outdir "${TRIMMED_QC_DIR}"

fi

###############################################################################
# Finish
###############################################################################

report_runtime "Step 01: Quality Control and Read Trimming" "${START_TIME}"
