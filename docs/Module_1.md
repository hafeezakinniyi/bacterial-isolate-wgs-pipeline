------------------------------------------------------------------------

# Module 1 – Getting Started

## Module Overview

In this module, you will become familiar with the organization of the bacterial WGS project and the sequencing data that will be analyzed throughout this workshop. Before performing any bioinformatics analysis, it is important to understand the structure of the project directory, the location of input files, and the characteristics of the sequencing data.

By the end of this module, you should be comfortable navigating the project directory and identifying the input files required for the subsequent analyses.

------------------------------------------------------------------------

# Exercise 1.1 – Exploring the Project Directory

## Objective

After completing this exercise, you should be able to:

- Navigate to the project directory.
- Identify the major folders used throughout the workflow.
- Understand the purpose of each folder.
- Locate the scripts and configuration files used during the workshop.

------------------------------------------------------------------------

## Background

A well-organized project directory is essential for reproducible bioinformatics analyses. Separating raw data, scripts, configuration files, documentation, and analysis results makes workflows easier to understand, maintain, and reproduce. Throughout this workshop, every command will be executed from the project directory, making it your central working location.

------------------------------------------------------------------------

## Commands

### Step 1. Navigate to the project directory

``` bash
cd ~/bacterial-isolate-wgs-pipeline
```

------------------------------------------------------------------------

### Step 2. Confirm your current working directory

``` bash
pwd
```

------------------------------------------------------------------------

### Step 3. Display the project contents

``` bash
ls
```

------------------------------------------------------------------------

### Step 4. Display the project structure

``` bash
tree -L 2
```

> If `tree` is not installed, simply use:

``` bash
ls -R
```

------------------------------------------------------------------------

## Expected Output

Your project should resemble the following structure:

``` text
bacterial-isolate-wgs-pipeline/
├── config/
├── data/
├── docs/
├── envs/
├── results/
├── scripts/
├── .gitignore
├── LICENSE
└── README.md
```

------------------------------------------------------------------------

## Verify Your Results

Confirm that the following directories are present.

| Directory  | Purpose                                            |
|------------|----------------------------------------------------|
| `config/`  | Pipeline configuration files                       |
| `data/`    | Input sequencing reads                             |
| `docs/`    | Documentation and workshop materials               |
| `envs/`    | Conda environment files                            |
| `results/` | Analysis output generated during the workshop      |
| `scripts/` | Analysis scripts comprising the automated pipeline |

------------------------------------------------------------------------

## Checkpoint

Before continuing, ensure that:

- ✅ You are inside the project directory.
- ✅ You can view all project folders.
- ✅ You understand the purpose of each directory.

------------------------------------------------------------------------

# Exercise 1.2 – Exploring the Sequencing Data

## Objective

After completing this exercise, you should be able to:

- Locate the input sequencing files.
- Recognize paired-end sequencing data.
- Inspect compressed FASTQ files without extracting them.
- Estimate the size of the sequencing dataset.

------------------------------------------------------------------------

## Background

All downstream analyses depend on the quality and integrity of the sequencing reads. Before beginning the analysis, it is good practice to verify that the expected files are present and to inspect their contents. Throughout this workshop, we will analyze a single paired-end bacterial sequencing dataset generated using Illumina sequencing technology.

The example dataset used in this workshop is:

``` text
10-0213-20-0000_S42
```

------------------------------------------------------------------------

## Commands

### Step 1. View the sequencing files

``` bash
ls data/
```

------------------------------------------------------------------------

### Step 2. Display file sizes

``` bash
ls -lh data/
```

------------------------------------------------------------------------

### Step 3. View the first few lines of the forward reads

``` bash
zcat data/10-0213-20-0000_S42_R1_001.fastq.gz | head -20
```

------------------------------------------------------------------------

### Step 4. View the first few lines of the reverse reads

``` bash
zcat data/10-0213-20-0000_S42_R2_001.fastq.gz | head -20
```

------------------------------------------------------------------------

### Step 5. Count the number of sequencing reads

Forward reads

``` bash
echo $(( $(zcat data/10-0213-20-0000_S42_R1_001.fastq.gz | wc -l) / 4 ))
```

Reverse reads

``` bash
echo $(( $(zcat data/10-0213-20-0000_S42_R2_001.fastq.gz | wc -l) / 4 ))
```

------------------------------------------------------------------------

### Step 6. Count reads with SeqFu (Optional)

SeqFu is a package of utilities for FASTA and FASTQ files. It handles compression, paired-end awareness, and produces tabular summaries.

Install SeqFu

``` bash
conda install -y -c conda-forge -c bioconda "seqfu>1.10"
```

Usage

``` bash
seqfu stats data/10-0213-20-0000_S42_R1_001.fastq.gz
```

------------------------------------------------------------------------

## Expected Output

Participants should observe:

- Two compressed FASTQ files.
- Read identifiers beginning with `@`.
- DNA nucleotide sequences.
- Corresponding quality score strings.
- Similar numbers of forward and reverse reads.

------------------------------------------------------------------------

## Verify Your Results

Confirm that:

- Both paired-end FASTQ files are present.
- The files can be viewed without decompression.
- The read headers are visible.
- DNA sequences are displayed.
- Quality score lines are present.
- The number of forward and reverse reads is approximately equal.

------------------------------------------------------------------------

## Checkpoint

Before moving to Module 2, ensure that:

- ✅ You can identify the paired-end sequencing files.
- ✅ You successfully viewed the contents of both FASTQ files.
- ✅ You understand that every sequencing read consists of four lines in FASTQ format.
- ✅ You confirmed that the forward and reverse read files contain matching datasets.

------------------------------------------------------------------------
