![Platform](https://img.shields.io/badge/platform-Linux-blue)  ![Bash](https://img.shields.io/badge/bash-5%2B-green)  ![License](https://img.shields.io/badge/license-MIT-orange)  ![Status](https://img.shields.io/badge/status-stable-success)

# Bacterial Isolate Whole Genome Sequencing Pipeline

A modular, reproducible, and fully automated Bash pipeline for bacterial isolate whole-genome sequencing (WGS) analysis from Illumina paired-end reads.

The pipeline performs quality control, taxonomic classification, de novo genome assembly, assembly quality assessment, genome characterization, and sequencing coverage estimation using widely adopted bioinformatics tools. It is designed for bacterial genomics, antimicrobial resistance (AMR) surveillance, molecular epidemiology, and comparative genomics studies.

---

## Overview

Whole-genome sequencing has become an indispensable tool for bacterial pathogen surveillance, antimicrobial resistance monitoring, outbreak investigation, and comparative genomics. Although numerous software packages exist for each stage of bacterial genome analysis, integrating them into a robust, reproducible workflow can be challenging.

This pipeline provides an end-to-end solution for bacterial isolate WGS analysis by combining quality assessment, genome assembly, taxonomic profiling, genome characterization, and sequencing coverage estimation into a single automated workflow. Emphasis has been placed on reproducibility, modularity, and ease of use, allowing both complete pipeline execution and independent execution of individual analysis steps. The pipeline automatically detects completed analyses and skips them during subsequent executions, allowing interrupted runs to be resumed without repeating finished steps.

---

## Design Principles

The pipeline was developed with the following objectives:

* Modular workflow with independently executable analysis steps
* Reproducible analyses through centralized configuration
* Automatic detection and skipping of completed analyses
* Comprehensive logging with timestamps and runtime reporting
* Consistent directory organization
* Easy customization through a single configuration file
* Minimal code duplication through shared utility functions
* ShellCheck-friendly scripting practices

---

## Features

* Quality assessment of raw sequencing reads (FastQC)
* Adapter trimming and quality filtering (Trimmomatic)
* Taxonomic classification (Kraken2)
* Species and genus abundance estimation (Bracken)
* De novo genome assembly (SPAdes)
* Assembly quality assessment (QUAST)
* Genome completeness and contamination estimation (CheckM)
* Multi-locus sequence typing (MLST)
* Antimicrobial resistance gene detection (AMRFinderPlus)
* Genome screening against multiple databases (ABRicate)
* Read mapping and sequencing depth estimation (Bowtie2 + SAMtools)
* Automatic logging
* Runtime reporting
* Resume interrupted analyses
* Modular execution of individual pipeline steps

---

## Pipeline Workflow

```text
                    Raw Illumina Reads
                           │
                           ▼
         Step 01 ─ Quality Control & Read Trimming
                           │
                           ▼
       Step 02 ─ Taxonomic Classification (Kraken2)
                           │
                           ▼
          Step 03 ─ Genome Assembly (SPAdes)
                           │
                ┌──────────┴──────────┐
                ▼                     ▼
 Step 04 ─ Assembly QC        Step 05 ─ Genome Characterization
     (QUAST, CheckM)     (MLST, AMRFinderPlus, ABRicate)
                │
                └──────────┬──────────┘
                           ▼
          Step 06 ─ Coverage Estimation
                           │
                           ▼
                     Final Results
```

---

## Pipeline Architecture

The workflow combines sample-level analyses with project-level analyses.

```text
Each Sample
│
├── Step 01  Quality Control
├── Step 02  Taxonomic Classification
├── Step 03  Genome Assembly
└── Step 06  Coverage Estimation

All Samples
│
├── Step 04  Assembly Quality Assessment
└── Step 05  Genome Characterization
```

---

## Repository Structure

```text
bacterial-isolate-wgs-pipeline/
│
├── config/
│   └── config.sh
│
├── scripts/
│   ├── run_pipeline.sh
│   ├── utils.sh
│   └── steps/
│       ├── 01_quality_control.sh
│       ├── 02_taxonomic_classification.sh
│       ├── 03_genome_assembly.sh
│       ├── 04_assembly_quality.sh
│       ├── 05_genome_characterization.sh
│       └── 06_coverage_estimation.sh
│
├── envs/
│   ├── bacwgs_env.yml
│   ├── checkm_env.yml
│   └── mlst_env.yml
│
├── docs/
│
├── data/
│
├── results/
│
├── LICENSE
└── README.md
```

---

## Software Requirements

The pipeline has been developed for Linux systems and requires Bash together with the following software.

| Software      | Purpose                        |
| ------------- | ------------------------------ |
| FastQC        | Read quality assessment        |
| Trimmomatic   | Adapter trimming               |
| Kraken2       | Taxonomic classification       |
| Bracken       | Abundance estimation           |
| SPAdes        | Genome assembly                |
| QUAST         | Assembly statistics            |
| CheckM        | Genome completeness assessment |
| MLST          | Sequence typing                |
| AMRFinderPlus | AMR gene identification        |
| ABRicate      | Genome screening for AMR gene, virulence factor and plasmid replicon              |
| Bowtie2       | Read mapping                   |
| SAMtools      | Alignment processing and coverage estimation        |

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/hafeezakinniyi/bacterial-isolate-wgs-pipeline.git

cd bacterial-isolate-wgs-pipeline
```

### 2. Create the Conda environments

```bash
conda env create -f envs/bacwgs_env.yml

conda env create -f envs/checkm_env.yml

conda env create -f envs/mlst_env.yml
```

### 3. Configure reference databases

The following databases should be installed before running the pipeline:

* Kraken2 database
* Bracken database files
* AMRFinderPlus database
* ABRicate databases

Before running the pipeline, edit:

```text
config/config.sh
```

and update the locations of your local reference databases.

---

## Conda Environments

To simplify dependency management, the pipeline uses three Conda environments.

| Environment  | Software                                                                                         |
| ------------ | ------------------------------------------------------------------------------------------------ |
| `MAIN_ENV`   | FastQC, Trimmomatic, Kraken2, Bracken, SPAdes, QUAST, Bowtie2, SAMtools, AMRFinderPlus, ABRicate |
| `CHECKM_ENV` | CheckM                                                                                           |
| `MLST_ENV`   | MLST                                                                                             |

Environment names are configured in `config/config.sh`.

---

## Input Data

The pipeline accepts paired-end Illumina FASTQ files.

Expected naming convention:

```text
Sample01_R1_001.fastq.gz
Sample01_R2_001.fastq.gz

Sample02_R1_001.fastq.gz
Sample02_R2_001.fastq.gz
```

Place all FASTQ files inside the `data/` directory.

---

## Configuration

All pipeline parameters are centralized in:

```text
config/config.sh
```

This file controls:

* CPU threads
* Memory allocation
* Conda environments
* Reference database locations
* Output directories
* Quality filtering parameters
* Optional pipeline modules

---

## Running the Pipeline

## Usage

### Run the complete pipeline

```bash
bash scripts/run_pipeline.sh
```

### Run an individual analysis step

```bash
bash scripts/steps/01_quality_control.sh Sample01
```

### Enable or disable pipeline modules

Pipeline modules can be enabled or disabled by editing:

```text
config/config.sh
```

using the following options:

```bash
RUN_POST_TRIM_QC=true
RUN_TAXONOMY=true
RUN_ASSEMBLY=true
RUN_ASSEMBLY_QC=true
RUN_CHARACTERIZATION=true
RUN_COVERAGE=true
```

---

## Pipeline Modules

### Step 01 — Quality Control and Read Trimming

**Purpose**

* Assess raw read quality
* Remove low-quality bases and adapters
* Perform post-trimming quality assessment

**Tools**

* FastQC
* Trimmomatic

---

### Step 02 — Taxonomic Classification

**Purpose**

* Assign taxonomy to sequencing reads
* Estimate genus and species abundance

**Tools**

* Kraken2
* Bracken

---

### Step 03 — Genome Assembly

**Purpose**

* Assemble bacterial genomes from quality-controlled reads

**Tool**

* SPAdes

---

### Step 04 — Assembly Quality Assessment

**Purpose**

* Evaluate assembly statistics
* Estimate genome completeness
* Estimate contamination

**Tools**

* QUAST
* CheckM

---

### Step 05 — Genome Characterization

**Purpose**

* Multi-locus sequence typing
* Screen genomes against multiple annotation databases to detect AMR genes, virulence factors and plasmid replicons

**Tools**

* MLST
* AMRFinderPlus
* ABRicate

---

### Step 06 — Coverage Estimation

**Purpose**

* Map reads back to assembled genomes
* Estimate average sequencing depth

**Tools**

* Bowtie2
* SAMtools

---

## Output Directory

```text
results/

├── qc/
├── trimmed_reads/
├── taxonomy/
│   ├── kraken/
│   └── bracken/
├── assemblies/
├── assembly_qc/
│   ├── quast/
│   └── checkm/
├── genome_characterization/
│   ├── mlst/
│   ├── amrfinder/
│   └── abricate/
├── coverage/
└── logs/
```

---

## Expected Outputs

Successful execution of the pipeline produces:

- Raw and trimmed FastQC reports
- Quality-filtered paired-end reads
- Kraken2 classification reports
- Bracken abundance estimates
- SPAdes genome assemblies
- QUAST assembly statistics
- CheckM genome quality metrics
- MLST sequence types
- AMRFinderPlus antimicrobial resistance gene annotations
- ABRicate antimicrobial resistance gene, virulence factor and plasmid annotations
- Average sequencing depth estimates
- Pipeline execution logs

---

## Logging and Reproducibility

The pipeline automatically:

* records execution logs
* timestamps each analysis
* reports runtime for every pipeline step
* skips completed analyses
* validates required inputs
* validates required software
* validates required directories
* stops immediately upon errors

These features improve reproducibility and facilitate recovery from interrupted analyses.

---

## Future Development

Planned enhancements include:

* MultiQC report generation
* Prokka genome annotation
* Snippy variant calling
* Snakemake implementation
* Nextflow implementation
* Docker support
* Singularity/Apptainer support
* Continuous Integration (GitHub Actions)

---

## Citation

If this pipeline contributes to your research, please cite:

> Akinniyi HT. 2026. Bacterial Isolate Whole Genome Sequencing Pipeline. GitHub repository.

A DOI will be assigned through Zenodo upon the first public release.

---

## License

This project is released under the MIT License.

---

## References

* Andrew, S. (2010). FastQC: A quality control tool for high throughput sequence data. In Babraham Bioinformatics.
* Bolger, A. M., Lohse, M., & Usadel, B. (2014). Trimmomatic: A flexible trimmer for Illumina sequence data. Bioinformatics, 30(15), 2114–2120.
* Danecek, P., Bonfield, J. K., Liddle, J., Marshall, J., Ohan, V., Pollard, M. O., Whitwham, A., Keane, T., McCarthy, S. A., Davies, R. M., & Li, H. (2021). Twelve years of SAMtools and BCFtools. GigaScience, 10(2). https://doi.org/10.1093/gigascience/giab008
* Feldgarden, M., Brover, V., Gonzalez-Escalona, N., Frye, J. G., Haendiges, J., Haft, D. H., Hoffmann, M., Pettengill, J. B., Prasad, A. B., Tillman, G. E., Tyson, G. H., & Klimke, W. (2021). AMRFinderPlus and the reference gene catalog facilitate examination of the genomic links among antimicrobial resistance, stress response, and virulence. Scientific Reports, 11(1). https://doi.org/10.1038/s41598-021-91456-0
* Gurevich, A., Saveliev, V., Vyahhi, N., & Tesler, G. (2013). Quast: Quality assessment tool for genome assemblies. Bioinformatics, 29(8), 1072–1075. http://dx.doi.org/10.1093/bioinformatics/btt086
* Langmead, B., & Salzberg, S. L. (2012). Fast gapped-read alignment with bowtie 2. Nature Methods, 9(4), 357–359. https://doi.org/10.1038/nmeth.1923
* Lu, J., Breitwieser, F. P., Thielen, P., & Salzberg, S. L. (2017). Bracken: Estimating species abundance in metagenomics data. PeerJ Computer Science, 3, e104. https://doi.org/10.7717/peerj-cs.104
* Parks, D. H., Imelfort, M., Skennerton, C. T., Hugenholtz, P., & Tyson, G. W. (2015). CheckM: Assessing the quality of microbial genomes recovered from isolates, single cells, and metagenomes. Genome Research, 25(7), 1043–1055. https://doi.org/10.1101/gr.186072.114
* Prjibelski, A., Antipov, D., Meleshko, D., Lapidus, A., & Korobeynikov, A. (2020). Using SPAdes de novo assembler. Current Protocols in Bioinformatics, 70(1). https://doi.org/10.1002/cpbi.102
* Seemann, T. (2016). Mass screening of contigs for antimicrobial and virulence genes. GitHub. https://github.com/tseemann/abricate
* Seemann, T. (2018). mlst. GitHub. https://github.com/tseemann/mlst
* Wood, D. E., Lu, J., & Langmead, B. (2019). Improved metagenomic analysis with kraken 2. Genome Biology, 20(1). https://doi.org/10.1186/s13059-019-1891-0

---

## Contact

Hafeez T. Akinniyi

DVM | MSc, Molecular Biology & Genomics

Research Interests:

* Bacterial genomics
* Antimicrobial resistance
* Host-Pathogen Interaction
* One Health
* Bioinformatics


Email: akinniyitoluwalope@gmail.com

GitHub: https://github.com/hafeezakinniyi

For questions, suggestions, or collaborations, please open an issue or submit a pull request.

