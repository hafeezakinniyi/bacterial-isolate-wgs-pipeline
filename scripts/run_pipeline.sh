#!/usr/bin/env bash

###############################################################################
# Bacterial Isolate WGS Pipeline
# Master Pipeline Script
###############################################################################

set -euo pipefail

###############################################################################
# Determine Project Root
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

###############################################################################
# Load Configuration and Utilities
###############################################################################

source "${PROJECT_ROOT}/config/config.sh"
source "${PROJECT_ROOT}/scripts/utils.sh"

###############################################################################
# Initialize Logging
###############################################################################

initialize_logger "${LOG_DIR}"

PIPELINE_START=$(date +%s)

log_info "Pipeline started."

print_header "Bacterial Isolate Whole Genome Sequencing Pipeline"

###############################################################################
# Validate Input Directory
###############################################################################

check_directory "${RAW_READS_DIR}"

check_directory "${KRAKEN_DB}"

###############################################################################
# Create Output Directories
###############################################################################

create_directory \
    "${QC_DIR}" \
    "${RAW_QC_DIR}" \
    "${TRIMMED_QC_DIR}" \
    "${TRIMMED_READS_DIR}" \
    "${TAXONOMY_DIR}" \
    "${KRAKEN_DIR}" \
    "${BRACKEN_DIR}" \
    "${ASSEMBLY_DIR}" \
    "${ASSEMBLY_QC_DIR}" \
    "${CHECKM_DIR}" \
    "${QUAST_DIR}" \
    "${CHARACTERIZATION_DIR}" \
    "${MLST_DIR}" \
    "${AMRFINDER_DIR}" \
    "${ABRICATE_DIR}" \
    "${COVERAGE_DIR}"

###############################################################################
# Discover Samples
###############################################################################

mapfile -t SAMPLES < <(
    find "${RAW_READS_DIR}" \
        -name "*_R1_*.fastq.gz" \
        -printf "%f\n" |
    sed 's/_R1_.*//' |
    sort
)

TOTAL_SAMPLES=${#SAMPLES[@]}

if [[ ${TOTAL_SAMPLES} -eq 0 ]]; then
    log_error "No paired-end FASTQ files found in '${RAW_READS_DIR}'."
    exit 1
fi

###############################################################################
# Pipeline Summary
###############################################################################

log_info "Samples detected : ${TOTAL_SAMPLES}"
log_info "CPU threads      : ${THREADS}"

log_info "Enabled modules:"

[[ "${RUN_POST_TRIM_QC}" == true ]] && log_info "  ✓ Post-trimming quality assessment"
[[ "${RUN_TAXONOMY}" == true ]] && log_info "  ✓ Taxonomic classification"
[[ "${RUN_ASSEMBLY}" == true ]] && log_info "  ✓ Genome assembly"
[[ "${RUN_ASSEMBLY_QC}" == true ]] && log_info "  ✓ Assembly quality assessment"
[[ "${RUN_CHARACTERIZATION}" == true ]] && log_info "  ✓ Genome characterization"
[[ "${RUN_COVERAGE}" == true ]] && log_info "  ✓ Coverage estimation"

###############################################################################
# Process Samples
###############################################################################

COUNT=1

for SAMPLE in "${SAMPLES[@]}"
do

    print_header "Processing Sample ${COUNT}/${TOTAL_SAMPLES}: ${SAMPLE}"

    bash "${SCRIPT_DIR}/steps/01_quality_control.sh" "${SAMPLE}"

    if [[ "${RUN_TAXONOMY}" == true ]]; then
        bash "${SCRIPT_DIR}/steps/02_taxonomic_classification.sh" "${SAMPLE}"
    fi

    if [[ "${RUN_ASSEMBLY}" == true ]]; then
        bash "${SCRIPT_DIR}/steps/03_genome_assembly.sh" "${SAMPLE}"
    fi

    if [[ "${RUN_COVERAGE}" == true ]]; then
        bash "${SCRIPT_DIR}/steps/06_coverage_estimation.sh" "${SAMPLE}"
    fi

    ((COUNT++))

done

###############################################################################
# Global Analyses
###############################################################################

print_header "Running Global Analyses"

if [[ "${RUN_ASSEMBLY_QC}" == true ]]; then
    bash "${SCRIPT_DIR}/steps/04_assembly_quality.sh"
fi

if [[ "${RUN_CHARACTERIZATION}" == true ]]; then
    bash "${SCRIPT_DIR}/steps/05_genome_characterization.sh"
fi

###############################################################################
# Pipeline Completion
###############################################################################

report_runtime "Entire pipeline" "${PIPELINE_START}"

pipeline_complete
