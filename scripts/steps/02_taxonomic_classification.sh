#!/usr/bin/env bash

###############################################################################
# Step 02: Taxonomic Classification
#
# Description:
#   Performs taxonomic classification of trimmed paired-end reads using
#   Kraken2 and refines taxonomic abundance estimates at the genus and
#   species levels using Bracken.
# 
# Input:
#   results/trimmed_reads/<sample>_R1_P.fastq.gz
#   results/trimmed_reads/<sample>_R2_P.fastq.gz
#
# Output:
#   results/taxonomy/kraken/
#   results/taxonomy/bracken/
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

READ1="${TRIMMED_READS_DIR}/${SAMPLE}_R1_P.fastq.gz"
READ2="${TRIMMED_READS_DIR}/${SAMPLE}_R2_P.fastq.gz"

KRAKEN_OUTPUT="${KRAKEN_DIR}/${SAMPLE}_kraken_output.txt"
KRAKEN_REPORT="${KRAKEN_DIR}/${SAMPLE}_kraken_report.txt"

BRACKEN_GENUS="${BRACKEN_DIR}/${SAMPLE}_bracken_genus.tsv"
BRACKEN_SPECIES="${BRACKEN_DIR}/${SAMPLE}_bracken_species.tsv"

###############################################################################
# Start
###############################################################################

START_TIME=$(date +%s)

print_header "Step 02: Taxonomic Classification"

log_info "Sample: ${SAMPLE}"

###############################################################################
# Create output directories
###############################################################################

create_directory \
    "${KRAKEN_DIR}" \
    "${BRACKEN_DIR}"

###############################################################################
# Skip completed analysis
###############################################################################

if skip_step "Step 02: Taxonomic Classification" "${KRAKEN_REPORT}"
then
    exit 0
fi

###############################################################################
# Validate input
###############################################################################

check_file "${READ1}"
check_file "${READ2}"

check_directory "${KRAKEN_DB}"

###############################################################################
# Activate conda environment
###############################################################################

conda activate "${MAIN_ENV}"

###############################################################################
# Validate required tools
###############################################################################

check_tool kraken2
check_tool bracken

###############################################################################
# Kraken2 Classification
###############################################################################

log_info "Running Kraken2..."

run_command \
    kraken2 \
    --paired \
    --threads "${THREADS}" \
    --db "${KRAKEN_DB}" \
    --output "${KRAKEN_OUTPUT}" \
    --report "${KRAKEN_REPORT}" \
    "${READ1}" \
    "${READ2}"

###############################################################################
# Bracken - Genus Level
###############################################################################

log_info "Estimating genus abundance with Bracken..."

run_command \
    bracken \
    -d "${KRAKEN_DB}" \
    -i "${KRAKEN_REPORT}" \
    -o "${BRACKEN_GENUS}" \
    -r "${KRAKEN_READ_LENGTH}" \
    -l G

###############################################################################
# Bracken - Species Level
###############################################################################

log_info "Estimating species abundance with Bracken..."

run_command \
    bracken \
    -d "${KRAKEN_DB}" \
    -i "${KRAKEN_REPORT}" \
    -o "${BRACKEN_SPECIES}" \
    -r "${KRAKEN_READ_LENGTH}" \
    -l S

###############################################################################
# Finish
###############################################################################

report_runtime "Step 02: Taxonomic Classification" "${START_TIME}"
