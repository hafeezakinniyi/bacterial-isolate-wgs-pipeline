#!/usr/bin/env bash

###############################################################################
# Step 04: Assembly Quality Assessment
#
# Description:
#   Assesses the quality of assembled genomes by:
#     1. Evaluating assembly statistics using QUAST.
#     2. Estimating genome completeness and contamination using CheckM.
#
# Input:
#   results/assemblies/<sample>/contigs.fasta
#
# Output:
#   results/assembly_qc/
#       ├── quast/
#       └── checkm/
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

print_header "Step 04: Assembly Quality Assessment"

###############################################################################
# Create Output Directories
###############################################################################

create_directory \
    "${ASSEMBLY_QC_DIR}" \
    "${CHECKM_DIR}" \
    "${CHECKM_DIR}/bins" \
    "${CHECKM_DIR}/output" \
    "${QUAST_DIR}"

###############################################################################
# Validate Input Directory
###############################################################################

check_directory "${ASSEMBLY_DIR}"

###############################################################################
# Validate Required Tools
###############################################################################

conda activate "${MAIN_ENV}"

check_tool quast.py

conda activate "${CHECKM_ENV}"

check_tool checkm

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
# Prepare CheckM Input
###############################################################################

print_header "Preparing CheckM Input"

for DIR in "${ASSEMBLIES[@]}"
do

    SAMPLE=$(basename "${DIR}")

    CONTIGS="${DIR}/contigs.fasta"

    check_file "${CONTIGS}"

    DESTINATION="${CHECKM_DIR}/bins/${SAMPLE}.fasta"

    if [[ ! -f "${DESTINATION}" ]]
    then

        log_info "Preparing ${SAMPLE}"

        run_command \
            cp \
            "${CONTIGS}" \
            "${DESTINATION}"

    fi

done

###############################################################################
# QUAST Assembly Assessment
###############################################################################

print_header "Running QUAST"

conda activate "${MAIN_ENV}"

for DIR in "${ASSEMBLIES[@]}"
do

    SAMPLE=$(basename "${DIR}")

    CONTIGS="${DIR}/contigs.fasta"

    OUTDIR="${QUAST_DIR}/${SAMPLE}"

    if skip_step "QUAST (${SAMPLE})" "${OUTDIR}/report.tsv"
    then
        continue
    fi

    log_info "Assessing assembly: ${SAMPLE}"

    run_command \
        quast.py \
        "${CONTIGS}" \
        -o "${OUTDIR}"

done

###############################################################################
# CheckM Genome Quality Assessment
###############################################################################

print_header "Running CheckM"

conda activate "${CHECKM_ENV}"

if ! skip_step \
    "CheckM" \
    "${CHECKM_DIR}/clean.tsv"
then

    run_command \
        checkm \
        lineage_wf \
        -x fasta \
        -t "${THREADS}" \
        "${CHECKM_DIR}/bins" \
        "${CHECKM_DIR}/output"

    log_info "Generating CheckM summary..."

	checkm qa \
	    "${CHECKM_DIR}/output/lineage.ms" \
	    "${CHECKM_DIR}/output" \
	    -o 2 \
	    > "${CHECKM_DIR}/summary.tsv"

    log_info "Formatting CheckM summary..."

	awk '
	BEGIN{
	    OFS="\t";
	    print "Sample","Completeness","Contamination","Strain_heterogeneity","Genome_size"
	}

	/^-/ || /^$/ || /^\[/ || /^  Bin Id/ {next}

	{
	    print $1,$7,$8,$9,$10
	}
	' "${CHECKM_DIR}/summary.tsv" \
	> "${CHECKM_DIR}/clean.tsv"

fi

###############################################################################
# Finish
###############################################################################

report_runtime "Step 04: Assembly Quality Assessment" "${START_TIME}"
