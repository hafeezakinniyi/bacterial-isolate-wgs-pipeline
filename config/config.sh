#!/usr/bin/env bash

###############################################################################
# Bacterial Isolate WGS Pipeline
# Configuration File
###############################################################################

###############################################################################
# Conda
###############################################################################

CONDA_BASE="$HOME/miniconda3"
source "${CONDA_BASE}/etc/profile.d/conda.sh"

###############################################################################
# User Configuration
###############################################################################

# Number of CPU threads
THREADS=16

# Input directory containing paired-end FASTQ files
RAW_READS_DIR="data"

# Reference Databases
KRAKEN_DB="/path/to/kraken2/database"
# "/home/hafeezakinniyi/amr_project/standard_database_build"

# Genome Assembly
SPADES_MEMORY=64

# Java Memory
JAVA_MEMORY="32g"
JAVA_INITIAL_MEMORY="512m"

###############################################################################
# Conda Environments
###############################################################################

MAIN_ENV="amr_project"
CHECKM_ENV="checkm"
MLST_ENV="mlst_env"

###############################################################################
# Pipeline Output Directories
###############################################################################

RESULTS_DIR="results"

# Quality Control
QC_DIR="${RESULTS_DIR}/qc"
RAW_QC_DIR="${QC_DIR}/raw"
TRIMMED_QC_DIR="${QC_DIR}/trimmed"

# Trimmed reads
TRIMMED_READS_DIR="${RESULTS_DIR}/trimmed_reads"

# Taxonomic classification
TAXONOMY_DIR="${RESULTS_DIR}/taxonomy"
KRAKEN_DIR="${TAXONOMY_DIR}/kraken"
BRACKEN_DIR="${TAXONOMY_DIR}/bracken"

# Genome assembly
ASSEMBLY_DIR="${RESULTS_DIR}/assemblies"

# Assembly quality assessment
ASSEMBLY_QC_DIR="${RESULTS_DIR}/assembly_qc"
CHECKM_DIR="${ASSEMBLY_QC_DIR}/checkm"
QUAST_DIR="${ASSEMBLY_QC_DIR}/quast"

# Genome characterization
CHARACTERIZATION_DIR="${RESULTS_DIR}/genome_characterization"
MLST_DIR="${CHARACTERIZATION_DIR}/mlst"
AMRFINDER_DIR="${CHARACTERIZATION_DIR}/amrfinder"
ABRICATE_DIR="${CHARACTERIZATION_DIR}/abricate"

# Read mapping and coverage Estimation
COVERAGE_DIR="${RESULTS_DIR}/coverage"

# Logs
LOG_DIR="${RESULTS_DIR}/logs"

###############################################################################
# Analysis Parameters
###############################################################################

# Trimmomatic
MIN_READ_LENGTH=50
SLIDING_WINDOW="4:20"

# ABRicate
ABRICATE_MIN_IDENTITY=90
ABRICATE_MIN_COVERAGE=80

# Kraken2 / Bracken
KRAKEN_READ_LENGTH=150

###############################################################################
# Pipeline Modules
#
# Set to true or false to enable or disable pipeline steps.
###############################################################################

RUN_POST_TRIM_QC=true
RUN_TAXONOMY=true
RUN_ASSEMBLY=true
RUN_ASSEMBLY_QC=true
RUN_CHARACTERIZATION=true
RUN_COVERAGE=true


