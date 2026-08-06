------------------------------------------------------------------------

# Module 2 – Read Quality Control

## Module Overview

Raw sequencing data often contain low-quality bases, sequencing adapters, and other technical artifacts that can negatively affect downstream analyses such as taxonomic classification, genome assembly, and antimicrobial resistance gene detection. Quality control is therefore one of the most important steps in any bacterial whole genome sequencing workflow.

In this module, you will assess the quality of the raw sequencing reads using **FastQC**, remove low-quality bases using **Trimmomatic**, and evaluate the quality of the cleaned reads to determine whether trimming improved the dataset.

At the end of this module, you will have a set of high-quality paired-end reads ready for downstream analysis.

------------------------------------------------------------------------

# Exercise 2.1 – Assess Raw Read Quality

## Objective

After completing this exercise, you should be able to:

- Perform quality assessment of raw Illumina sequencing reads.
- Generate FastQC reports.
- Identify common sequencing quality metrics.
- Locate the FastQC output files.

------------------------------------------------------------------------

## Background

Sequencing errors are not distributed evenly across sequencing reads. Illumina reads generally exhibit decreasing quality toward the 3′ end, and datasets may also contain duplicated reads, adapter contamination, or unusual GC content. FastQC provides a rapid overview of sequencing quality by summarizing these characteristics into an interactive HTML report.

------------------------------------------------------------------------

## Commands

### Step 1. Create an output directory

``` bash
mkdir -p results/qc/raw
```

------------------------------------------------------------------------

### Step 2. Run FastQC on the raw reads

``` bash
fastqc \
data/10-0213-20-0000_S42_R1_001.fastq.gz \
data/10-0213-20-0000_S42_R2_001.fastq.gz \
--threads 8 \
--outdir results/qc/raw
```

------------------------------------------------------------------------

### Step 3. View the generated files

``` bash
ls -lh results/qc/raw
```

------------------------------------------------------------------------

## Expected Output

The directory should contain four files.

``` text
10-0213-20-0000_S42_R1_001_fastqc.html
10-0213-20-0000_S42_R1_001_fastqc.zip
10-0213-20-0000_S42_R2_001_fastqc.html
10-0213-20-0000_S42_R2_001_fastqc.zip
```

During execution, FastQC will also display its analysis progress.

------------------------------------------------------------------------

## Verify Your Results

Open either HTML report in your web browser.

``` bash
xdg-open results/qc/raw/10-0213-20-0000_S42_R1_001_fastqc.html
```

Review the following sections:

- Basic Statistics
- Per Base Sequence Quality
- Per Sequence Quality Scores
- Per Base GC Content
- Sequence Duplication Levels
- Adapter Content

------------------------------------------------------------------------

## Checkpoint

Before proceeding, confirm that:

- ✅ FastQC completed successfully.
- ✅ Four FastQC output files were generated.
- ✅ You opened at least one HTML report.
- ✅ You understand that FastQC evaluates sequencing quality without modifying the reads.

------------------------------------------------------------------------

# Exercise 2.2 – Trim Low-Quality Reads

## Objective

After completing this exercise, you should be able to:

- Remove low-quality bases from sequencing reads.
- Understand paired-end trimming.
- Interpret the Trimmomatic summary statistics.
- Identify the trimmed read files.

------------------------------------------------------------------------

## Background

Although Illumina sequencing generally produces high-quality data, read quality frequently decreases toward the ends of reads. Low-quality bases may interfere with genome assembly and read alignment. Trimmomatic improves downstream analyses by removing poor-quality regions while preserving high-quality sequence information.

------------------------------------------------------------------------

## Commands

### Step 1. Create an output directory

``` bash
mkdir -p results/trimmed_reads
```

------------------------------------------------------------------------

### Step 2. Run Trimmomatic

``` bash
trimmomatic PE \
-threads 8 \
data/10-0213-20-0000_S42_R1_001.fastq.gz \
data/10-0213-20-0000_S42_R2_001.fastq.gz \
results/trimmed_reads/10-0213-20-0000_S42_R1_P.fastq.gz \
results/trimmed_reads/10-0213-20-0000_S42_R1_UP.fastq.gz \
results/trimmed_reads/10-0213-20-0000_S42_R2_P.fastq.gz \
results/trimmed_reads/10-0213-20-0000_S42_R2_UP.fastq.gz \
SLIDINGWINDOW:4:20 \
MINLEN:50
```

------------------------------------------------------------------------

### Step 3. View the output files

``` bash
ls -lh results/trimmed_reads
```

------------------------------------------------------------------------

## Expected Output

The following files should be generated.

``` text
10-0213-20-0000_S42_R1_P.fastq.gz
10-0213-20-0000_S42_R1_UP.fastq.gz
10-0213-20-0000_S42_R2_P.fastq.gz
10-0213-20-0000_S42_R2_UP.fastq.gz
```

At the end of the run, Trimmomatic will also report a summary similar to:

``` text
Input Read Pairs:
Both Surviving:
Forward Only Surviving:
Reverse Only Surviving:
Dropped:
```

------------------------------------------------------------------------

## Verify Your Results

Compare the sizes of the raw and trimmed FASTQ files.

``` bash
ls -lh data
```

``` bash
ls -lh results/trimmed_reads
```

Observe that the paired trimmed files are slightly smaller than the original raw sequencing files.

------------------------------------------------------------------------

## Checkpoint

Before proceeding, confirm that:

- ✅ Trimmomatic completed successfully.
- ✅ Four trimmed FASTQ files were generated.
- ✅ You understand the difference between paired and unpaired reads.
- ✅ The trimming summary was displayed.

------------------------------------------------------------------------

# Exercise 2.3 – Evaluate Trimmed Reads

## Objective

After completing this exercise, you should be able to:

- Assess the quality of trimmed sequencing reads.
- Compare sequencing quality before and after trimming.
- Confirm that trimming improved the dataset.

------------------------------------------------------------------------

## Background

Quality control does not end after trimming. It is good practice to reassess the cleaned reads to verify that low-quality bases have been removed successfully. Comparing FastQC reports before and after trimming allows you to determine whether trimming improved sequence quality without unnecessarily discarding valuable sequencing data.

------------------------------------------------------------------------

## Commands

### Step 1. Create an output directory

``` bash
mkdir -p results/qc/trimmed
```

------------------------------------------------------------------------

### Step 2. Run FastQC on the trimmed reads

``` bash
fastqc \
results/trimmed_reads/10-0213-20-0000_S42_R1_P.fastq.gz \
results/trimmed_reads/10-0213-20-0000_S42_R2_P.fastq.gz \
--threads 8 \
--outdir results/qc/trimmed
```

------------------------------------------------------------------------

### Step 3. List the output files

``` bash
ls results/qc/trimmed
```

------------------------------------------------------------------------

## Expected Output

Four FastQC files should be generated.

``` text
10-0213-20-0000_S42_R1_P_fastqc.html
10-0213-20-0000_S42_R1_P_fastqc.zip
10-0213-20-0000_S42_R2_P_fastqc.html
10-0213-20-0000_S42_R2_P_fastqc.zip
```

------------------------------------------------------------------------

## Verify Your Results

Open both the raw and trimmed FastQC reports.

``` bash
xdg-open results/qc/raw/10-0213-20-0000_S42_R1_001_fastqc.html
```

``` bash
xdg-open results/qc/trimmed/10-0213-20-0000_S42_R1_P_fastqc.html
```

Compare:

- Per Base Sequence Quality
- Adapter Content
- Per Sequence Quality Scores
- Sequence Length Distribution

Determine whether trimming improved the sequencing quality.

------------------------------------------------------------------------

## Checkpoint

Before moving to Module 3, ensure that:

- ✅ FastQC successfully analyzed the trimmed reads.
- ✅ Trimmed FastQC reports were generated.
- ✅ You compared the raw and trimmed quality reports.
- ✅ You observed improvements in overall read quality.
- ✅ You now have high-quality paired-end reads ready for downstream analysis.

------------------------------------------------------------------------

**"Knowledge Check"**

1.  Why is quality control performed before genome assembly?
2.  What is the purpose of the `SLIDINGWINDOW:4:20` option in Trimmomatic?
3.  Why are there four output FASTQ files after paired-end trimming?
4.  Which FastQC metrics would you compare before and after trimming?
