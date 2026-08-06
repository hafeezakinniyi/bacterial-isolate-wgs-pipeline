------------------------------------------------------------------------

# Module 3 – Taxonomic Classification

## Module Overview

One of the first questions after obtaining high-quality sequencing reads is: **What organism was sequenced?** Taxonomic classification answers this question by comparing sequencing reads against a comprehensive reference database of microbial genomes. This step helps verify sample identity, detect contamination, and characterize the microbial composition of a sample.

In this module, you will classify the sequencing reads using **Kraken2** and refine abundance estimates using **Bracken**. By the end of this module, you will have identified the organism represented in the sequencing dataset and estimated its taxonomic abundance.

------------------------------------------------------------------------

# Exercise 3.1 – Identify the Organism

## Objective

After completing this exercise, you should be able to:

- Classify sequencing reads using Kraken2.
- Generate a Kraken2 classification report.
- Interpret the major taxonomic groups identified in the sample.
- Locate the Kraken2 output files.

------------------------------------------------------------------------

## Background

Kraken2 is a rapid taxonomic classification tool that assigns sequencing reads to organisms by matching short DNA sequences (k-mers) against a reference database. Each read is assigned to the lowest common ancestor (LCA) shared by all matching genomes, allowing accurate classification even when closely related organisms are present.

The primary outputs include a read classification file and a summary report showing the number and proportion of reads assigned to different taxonomic levels.

------------------------------------------------------------------------

## Commands

### Step 1. Create an output directory

``` bash
mkdir -p results/taxonomy/kraken
```

------------------------------------------------------------------------

### Step 2. Run Kraken2

> Replace `/path/to/kraken_database` with the location of your Kraken2 database.

``` bash
kraken2 \
--db /path/to/kraken_database \
--threads 8 \
--report results/taxonomy/kraken/10-0213-20-0000_S42.report \
--output results/taxonomy/kraken/10-0213-20-0000_S42.kraken \
--paired \
results/trimmed_reads/10-0213-20-0000_S42_R1_P.fastq.gz \
results/trimmed_reads/10-0213-20-0000_S42_R2_P.fastq.gz
```

------------------------------------------------------------------------

### Step 3. View the output files

``` bash
ls -lh results/taxonomy/kraken
```

------------------------------------------------------------------------

### Step 4. Display the beginning of the Kraken2 report

``` bash
head results/taxonomy/kraken/10-0213-20-0000_S42.report
```

------------------------------------------------------------------------

## Expected Output

The Kraken2 directory should contain:

``` text
10-0213-20-0000_S42.kraken
10-0213-20-0000_S42.report
```

The report will resemble:

``` text
 0.01  88      88      U       0       unclassified
 99.99  1606069 17061   R       1       root
 98.93  1589000 0       R1      131567    cellular organisms
 98.93  1589000 7999    R2      2           Bacteria
 98.43  1580952 3071    K       3379134       Pseudomonadati
 98.24  1577870 5639    P       1224            Pseudomonadota
 97.88  1572184 9029    C       1236              Gammaproteobacteria
 97.32  1563045 19007   O       91347               Enterobacterales
 96.12  1543783 1229272 F       543                   Enterobacteriaceae
 18.18  292065  27366   G       561                     Escherichia
 16.13  259075  233759  S       562                       Escherichia coli
```

*(The exact values will vary depending on the dataset and database version.)*

------------------------------------------------------------------------

## Verify Your Results

Confirm that:

- The `.kraken` classification file was generated.
- The `.report` summary file was generated.
- The report contains taxonomic classifications.
- Most reads have been successfully classified.

------------------------------------------------------------------------

## Checkpoint

Before continuing, ensure that:

- ✅ Kraken2 completed successfully.
- ✅ Both output files were generated.
- ✅ You understand that Kraken2 classifies individual sequencing reads.
- ✅ You identified the dominant organism in the sample.

------------------------------------------------------------------------

# Exercise 3.2 – Estimate Species Abundance

## Objective

After completing this exercise, you should be able to:

- Estimate species abundance using Bracken.
- Generate refined abundance estimates.
- Interpret the Bracken abundance table.
- Compare Bracken output with the Kraken2 report.

------------------------------------------------------------------------

## Background

Although Kraken2 accurately classifies sequencing reads, closely related organisms often share identical DNA sequences, causing some reads to be assigned to higher taxonomic levels rather than individual species. Bracken uses Bayesian re-estimation to redistribute these reads and produce more accurate estimates of species abundance.

Bracken therefore complements Kraken2 by improving quantitative estimates of the organisms present in a sample.

------------------------------------------------------------------------

## Commands

### Step 1. Create an output directory

``` bash
mkdir -p results/taxonomy/bracken
```

------------------------------------------------------------------------

### Step 2. Run Bracken

> Replace `/path/to/kraken_database` with your Kraken2 database.

``` bash
bracken \
-d /path/to/kraken_database \
-i results/taxonomy/kraken/10-0213-20-0000_S42.report \
-o results/taxonomy/bracken/10-0213-20-0000_S42_species.tsv \
-r 150 \
-l S
```

------------------------------------------------------------------------

### Step 3. View the output files

``` bash
ls -lh results/taxonomy/bracken
```

------------------------------------------------------------------------

### Step 4. Display the first few lines of the abundance table

``` bash
head results/taxonomy/bracken/10-0213-20-0000_S42_species.tsv
```

------------------------------------------------------------------------

## Expected Output

The Bracken directory should contain:

``` text
10-0213-20-0000_S42_species.tsv
```

Example output:

``` text
name    taxonomy_id     taxonomy_lvl    kraken_assigned_reads   added_reads     new_est_reads   fraction_total_reads
Escherichia coli        562     S       259075  1246459 1505534 0.93777
Escherichia albertii    208962  S       1644    91      1735    0.00108
Escherichia marmotae    1499973 S       1536    67      1603    0.00100
...
```

------------------------------------------------------------------------

## Verify Your Results

Confirm that:

- The Bracken abundance table was generated.
- Species-level abundance estimates are reported.
- The dominant species agrees with the Kraken2 classification.

------------------------------------------------------------------------

## Checkpoint

Before moving to Module 4, ensure that:

- ✅ Bracken completed successfully.
- ✅ A species abundance table was generated.
- ✅ You identified the dominant bacterial species.
- ✅ You understand the difference between Kraken2 classification and Bracken abundance estimation.

------------------------------------------------------------------------

## End of Module Summary

Congratulations! You have successfully identified the organism represented in your sequencing dataset.

At this stage of the workflow, you have:

- ✔ Performed quality control of the raw sequencing reads.
- ✔ Removed low-quality bases.
- ✔ Classified sequencing reads taxonomically using Kraken2.
- ✔ Estimated species abundance using Bracken.
- ✔ Confirmed the biological identity of the sequencing sample.

The sequencing reads are now ready for **de novo genome assembly**, which will be performed in the next module.

------------------------------------------------------------------------
