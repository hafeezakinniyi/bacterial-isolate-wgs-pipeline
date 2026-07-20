#!/usr/bin/env bash

###############################################################################
# Step 06: Coverage Estimation
#
# Description:
#   Estimates the average sequencing depth of each assembled bacterial genome
#   by mapping quality-controlled reads back to the corresponding assembly.
#
# Workflow:
#   1. Build Bowtie2 index
#   2. Map trimmed reads to assembled contigs
#   3. Convert SAM to BAM
#   4. Sort and index BAM
#   5. Calculate average sequencing depth
#   6. Generate coverage summary table
#
# Input:
#   results/trimmed_reads/<sample>_R1_P.fastq.gz
#   results/trimmed_reads/<sample>_R2_P.fastq.gz
#   results/assemblies/<sample>/contigs.fasta
#
# Output:
#   results/coverage/
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
# Start
###############################################################################

START_TIME=$(date +%s)

print_header "Step 06: Coverage Estimation"

###############################################################################
# Create Output Directory
###############################################################################

create_directory "${COVERAGE_DIR}"

###############################################################################
# Validate Input
###############################################################################

check_directory "${ASSEMBLY_DIR}"
check_directory "${TRIMMED_READS_DIR}"

###############################################################################
# Activate Environment
###############################################################################

conda activate "${MAIN_ENV}"

###############################################################################
# Validate Required Tools
###############################################################################

check_tool bowtie2-build
check_tool bowtie2
check_tool samtools

###############################################################################
# Discover Assemblies
###############################################################################

mapfile -t ASSEMBLIES < <(

    find "${ASSEMBLY_DIR}" \
        -mindepth 1 \
        -maxdepth 1 \
        -type d \
        | sort

)

TOTAL_ASSEMBLIES=${#ASSEMBLIES[@]}

if [[ ${TOTAL_ASSEMBLIES} -eq 0 ]]; then

    log_error "No genome assemblies were found."
    exit 1

fi

log_info "Assemblies detected: ${TOTAL_ASSEMBLIES}"

###############################################################################
# Process Each Assembly
###############################################################################

for DIR in "${ASSEMBLIES[@]}"
do

    SAMPLE=$(basename "${DIR}")

    print_header "Coverage Estimation: ${SAMPLE}"

    CONTIGS="${DIR}/contigs.fasta"

    READ1="${TRIMMED_READS_DIR}/${SAMPLE}_R1_P.fastq.gz"
    READ2="${TRIMMED_READS_DIR}/${SAMPLE}_R2_P.fastq.gz"

    check_file "${CONTIGS}"
    check_file "${READ1}"
    check_file "${READ2}"

    SAMPLE_DIR="${COVERAGE_DIR}/${SAMPLE}"

    create_directory "${SAMPLE_DIR}"

    DEPTH_FILE="${SAMPLE_DIR}/average_depth.txt"

    ###########################################################################
    # Skip Completed Sample
    ###########################################################################

    if skip_step "Coverage Estimation (${SAMPLE})" "${DEPTH_FILE}"
    then
        continue
    fi

    ###########################################################################
    # File Names
    ###########################################################################

    INDEX_PREFIX="${SAMPLE_DIR}/contigs_index"

    SAM_FILE="${SAMPLE_DIR}/mapping.sam"

    BAM_FILE="${SAMPLE_DIR}/mapping.bam"

    SORTED_BAM="${SAMPLE_DIR}/mapping.sorted.bam"

    ###########################################################################
    # Build Bowtie2 Index
    ###########################################################################

    if [[ ! -f "${INDEX_PREFIX}.1.bt2" ]]; then

    log_info "Building Bowtie2 index..."

    run_command \
        bowtie2-build \
        "${CONTIGS}" \
        "${INDEX_PREFIX}"

    else

    log_info "Existing Bowtie2 index found."

    fi

    ###########################################################################
    # Read Mapping
    ###########################################################################

    log_info "Mapping reads..."

    run_command \
        bowtie2 \
        -x "${INDEX_PREFIX}" \
        -1 "${READ1}" \
        -2 "${READ2}" \
        -p "${THREADS}" \
        -S "${SAM_FILE}"

    ###########################################################################
    # SAM → BAM
    ###########################################################################

    log_info "Converting SAM to BAM..."

	samtools view \
	    -@ "${THREADS}" \
	    -b \
	    "${SAM_FILE}" \
	    > "${BAM_FILE}"

    ###########################################################################
    # Sort BAM
    ###########################################################################

    log_info "Sorting BAM..."

    run_command \
        samtools sort \
        -@ "${THREADS}" \
        -o "${SORTED_BAM}" \
        "${BAM_FILE}"

    ###########################################################################
    # Index BAM
    ###########################################################################

    log_info "Indexing BAM..."

    run_command \
        samtools index \
        "${SORTED_BAM}"

    ###########################################################################
    # Calculate Average Depth
    ###########################################################################

    log_info "Calculating average sequencing depth..."

    samtools depth "${SORTED_BAM}" | \
    awk '
    {
        sum += $3
    }
    END {
        if (NR > 0)
            print sum / NR
        else
            print 0
    }' > "${DEPTH_FILE}"

    ###########################################################################
    # Remove Intermediate Files
    ###########################################################################

    log_info "Removing temporary files..."

    run_command rm -f "${SAM_FILE}" "${BAM_FILE}"

    log_success "${SAMPLE} completed."

done

###############################################################################
# Generate Coverage Summary
###############################################################################

print_header "Generating Coverage Summary"

SUMMARY="${COVERAGE_DIR}/coverage_summary.tsv"

echo -e "Sample\tAverage_Depth" > "${SUMMARY}"

for DIR in "${COVERAGE_DIR}"/*
do

    [[ -d "${DIR}" ]] || continue

    SAMPLE=$(basename "${DIR}")

    DEPTH="${DIR}/average_depth.txt"

    if [[ -f "${DEPTH}" ]]
    then

        VALUE=$(cat "${DEPTH}")

        echo -e "${SAMPLE}\t${VALUE}" >> "${SUMMARY}"

    fi

done

log_success "Coverage summary written to ${SUMMARY}"

###############################################################################
# Finish
###############################################################################

report_runtime "Step 06: Coverage Estimation" "${START_TIME}"
