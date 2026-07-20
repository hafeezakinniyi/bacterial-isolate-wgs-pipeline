#!/usr/bin/env bash

###############################################################################
# Step 05: Genome Characterization
#
# Description:
#   Characterizes assembled bacterial genomes by:
#     1. Multi-Locus Sequence Typing (MLST)
#     2. Detection of antimicrobial resistance genes using AMRFinderPlus
#     3. Genome screening against multiple databases using ABRicate
#
# Input:
#   results/assemblies/<sample>/contigs.fasta
#
# Output:
#   results/genome_characterization/
#       ├── mlst/
#       ├── amrfinder/
#       └── abricate/
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

print_header "Step 05: Genome Characterization"

###############################################################################
# Create Output Directories
###############################################################################

create_directory \
    "${CHARACTERIZATION_DIR}" \
    "${MLST_DIR}" \
    "${AMRFINDER_DIR}" \
    "${ABRICATE_DIR}"

###############################################################################
# Validate Input
###############################################################################

check_directory "${ASSEMBLY_DIR}"

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
# Validate Required Tools
###############################################################################

conda activate "${MAIN_ENV}"
check_tool amrfinder
check_tool abricate

conda activate "${MLST_ENV}"
check_tool mlst

###############################################################################
# Retrieve ABRicate Databases
###############################################################################

conda activate "${MAIN_ENV}"

mapfile -t ABRICATE_DATABASES < <(
    abricate --list | awk 'NR>1 {print $1}'
)

###############################################################################
# Characterize Each Genome
###############################################################################

for DIR in "${ASSEMBLIES[@]}"
do

    SAMPLE=$(basename "${DIR}")
    CONTIGS="${DIR}/contigs.fasta"

    check_file "${CONTIGS}"

    print_header "Genome Characterization: ${SAMPLE}"

    ###########################################################################
    # MLST
    ###########################################################################

    conda activate "${MLST_ENV}"

    MLST_OUTPUT="${MLST_DIR}/${SAMPLE}_mlst.tsv"

    if ! skip_step "MLST (${SAMPLE})" "${MLST_OUTPUT}"
    then

        log_info "Running MLST..."

        mlst \
    	    "${CONTIGS}" \
    	    > "${MLST_OUTPUT}"

    fi

    ###########################################################################
    # AMRFinderPlus
    ###########################################################################

    conda activate "${MAIN_ENV}"

    AMRFINDER_OUTPUT="${AMRFINDER_DIR}/${SAMPLE}_amrfinder.tsv"

    if ! skip_step "AMRFinderPlus (${SAMPLE})" "${AMRFINDER_OUTPUT}"
    then

        log_info "Running AMRFinderPlus..."

        run_command \
            amrfinder \
            -n "${CONTIGS}" \
            -o "${AMRFINDER_OUTPUT}"

    fi

    ###########################################################################
    # ABRicate
    ###########################################################################

    for DB in "${ABRICATE_DATABASES[@]}"
    do

        DB_DIR="${ABRICATE_DIR}/${DB}"

        create_directory "${DB_DIR}"

        OUTPUT="${DB_DIR}/${SAMPLE}_${DB}.tsv"

        if skip_step "ABRicate (${DB}) - ${SAMPLE}" "${OUTPUT}"
        then
            continue
        fi

        log_info "Running ABRicate (${DB})..."

        abricate \
    		--db "${DB}" \
    		--minid "${ABRICATE_MIN_IDENTITY}" \
    		--mincov "${ABRICATE_MIN_COVERAGE}" \
    		"${CONTIGS}" \
    		> "${OUTPUT}"

    done

done

###############################################################################
# Generate ABRicate Summary Tables
###############################################################################

print_header "Generating ABRicate Summary Tables"

for DB in "${ABRICATE_DATABASES[@]}"
do

    DB_DIR="${ABRICATE_DIR}/${DB}"

    SUMMARY="${DB_DIR}/summary.tsv"

    FILES=("${DB_DIR}"/*.tsv)

    if [[ ! -e "${FILES[0]}" ]]; then
        continue
    fi

    log_info "Generating summary for ${DB}..."

    abricate \
    	--summary \
    	"${DB_DIR}"/*.tsv \
    	> "${SUMMARY}"

done

###############################################################################
# Finish
###############################################################################

report_runtime "Step 05: Genome Characterization" "${START_TIME}"
