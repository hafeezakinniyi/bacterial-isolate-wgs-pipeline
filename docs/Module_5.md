------------------------------------------------------------------------

# Module 5 – Evaluate Genome Assembly

## Module Overview

Producing a genome assembly is only the first step in genome reconstruction. Before using an assembly for downstream analyses, it is essential to evaluate its quality. Assembly evaluation helps determine whether the genome is complete, whether contamination is present, and whether the assembly is sufficiently contiguous for further analysis.

In this module, you will assess your assembled genome using **QUAST** and **CheckM**. QUAST summarizes assembly statistics such as genome size, number of contigs, and N50, while CheckM estimates genome completeness and contamination using lineage-specific marker genes.

By the end of this module, you will have determined whether your assembly is suitable for downstream genome characterization.

------------------------------------------------------------------------

# Exercise 5.1 – Assess Assembly Statistics with QUAST

## Objective

After completing this exercise, you should be able to:

- Evaluate the quality of a bacterial genome assembly.
- Generate assembly statistics using QUAST.
- Interpret commonly reported assembly metrics.
- Locate the QUAST summary report.

------------------------------------------------------------------------

## Background

Genome assemblies vary in quality depending on sequencing depth, read quality, genome complexity, and assembly parameters. QUAST (Quality Assessment Tool for Genome Assemblies) summarizes several important assembly metrics that help determine whether an assembly is suitable for downstream analyses.

Commonly reported statistics include:

- Number of contigs
- Total assembly length
- Largest contig
- GC content
- N50
- L50

Together, these metrics provide an overview of assembly contiguity and completeness.

------------------------------------------------------------------------

## Commands

### Step 1. Create an output directory

``` bash
mkdir -p results/quast
```

------------------------------------------------------------------------

### Step 2. Run QUAST

``` bash
quast.py \
results/assembly/10-0213-20-0000_S42/contigs.fasta \
-o results/quast/10-0213-20-0000_S42 \
--threads 8
```

------------------------------------------------------------------------

### Step 3. View the output files

``` bash
ls -lh results/quast/10-0213-20-0000_S42
```

------------------------------------------------------------------------

### Step 4. View the summary report

``` bash
cat results/quast/10-0213-20-0000_S42/report.tsv
```

------------------------------------------------------------------------

## Expected Output

The QUAST output directory should contain files similar to:

``` text
icarus.html
report.html
report.pdf
report.tsv
report.txt
transposed_report.tsv
```

The report will contain metrics similar to:

``` text
Assembly
# contigs
Largest contig
Total length
GC (%)
N50
L50
```

*(Values will vary depending on the dataset.)*

------------------------------------------------------------------------

## Understanding Key Assembly Metrics

| Metric | Meaning |
|-----------------|-------------------------------------------------------|
| **Number of contigs** | Total number of assembled sequences. Fewer contigs generally indicate a more contiguous assembly. |
| **Total length** | Combined length of all assembled contigs. This approximates the genome size. |
| **Largest contig** | Length of the longest assembled contig. |
| **GC content** | Percentage of guanine (G) and cytosine (C) bases in the assembly. |
| **N50** | The contig length at which 50% of the assembly is contained in contigs of that length or longer. Higher values generally indicate better assembly contiguity. |
| **L50** | Number of contigs required to reach 50% of the total assembly length. Lower values generally indicate better assemblies. |

------------------------------------------------------------------------

## Verify Your Results

Confirm that:

- QUAST completed successfully.
- The `report.tsv` file was generated.
- Assembly statistics are displayed.
- You can identify the N50 and total assembly size.

------------------------------------------------------------------------

## Checkpoint

Before continuing, ensure that:

- ✅ QUAST completed successfully.
- ✅ You located the summary report.
- ✅ You understand the meaning of N50, L50, and genome size.
- ✅ Your assembly statistics appear reasonable for a bacterial genome.

------------------------------------------------------------------------

# Exercise 5.2 – Assess Genome Completeness with CheckM

## Objective

After completing this exercise, you should be able to:

- Assess genome completeness.
- Detect potential contamination.
- Interpret CheckM quality metrics.
- Determine whether an assembly is suitable for downstream analyses.

------------------------------------------------------------------------

## Background

Assembly statistics alone do not indicate whether a genome is biologically complete. An assembly may have an excellent N50 while still missing essential genomic regions or containing contaminating DNA.

CheckM evaluates genome quality using lineage-specific single-copy marker genes. It estimates:

- Genome completeness
- Genome contamination
- Strain heterogeneity

These metrics are widely used to assess bacterial genome quality before comparative genomics and genome annotation.

------------------------------------------------------------------------

## Commands

### Step 1. Activate the CheckM environment

``` bash
conda activate checkm_env
```

------------------------------------------------------------------------

### Step 2. Create the working directories

``` bash
mkdir -p results/checkm/bins
mkdir -p results/checkm/output
```

------------------------------------------------------------------------

### Step 3. Copy the assembled genome

``` bash
cp \
results/assembly/10-0213-20-0000_S42/contigs.fasta \
results/checkm/bins/10-0213-20-0000_S42.fasta
```

------------------------------------------------------------------------

### Step 4. Run CheckM lineage workflow

``` bash
checkm lineage_wf \
-x fa \
-t 8 \
results/checkm/bins \
results/checkm/output
```

> **Note:** Depending on your computer, this analysis may take several minutes.

------------------------------------------------------------------------

### Step 5. Generate the quality summary

``` bash
checkm qa \
results/checkm/output/lineage.ms \
results/checkm/output \
-o 2
```

------------------------------------------------------------------------

## Expected Output

The output will contain information similar to:

``` text
Bin ID           	Marker lineage   		Completeness    Contamination   Strain_heterogeneity    Genome_size
10-0213-20-0000_S42    f__Enterobacteriaceae (UID5124)  99.97       	0.04        	0.00            	5183799
```

*(Values shown are examples only.)*

------------------------------------------------------------------------

## Understanding CheckM Metrics

| Metric | Meaning |
|------------------|------------------------------------------------------|
| **Completeness** | Percentage of expected marker genes detected. Higher values indicate a more complete genome. |
| **Contamination** | Percentage of duplicated marker genes, suggesting contamination or mixed assemblies. Lower values are preferred. |
| **Strain heterogeneity** | Indicates whether duplicated marker genes likely originate from closely related strains. |
| **Marker lineage** | Taxonomic lineage used by CheckM for quality assessment. |

------------------------------------------------------------------------

## Verify Your Results

Confirm that:

- CheckM completed successfully.
- Completeness was estimated.
- Contamination was estimated.
- The assembly appears suitable for downstream analysis.

------------------------------------------------------------------------

## Checkpoint

Before moving to Module 6, ensure that:

- ✅ CheckM completed successfully.
- ✅ Genome completeness was estimated.
- ✅ Genome contamination was estimated.
- ✅ You understand the difference between assembly statistics (QUAST) and genome quality assessment (CheckM).

------------------------------------------------------------------------

# End of Module Summary

Congratulations! You have successfully evaluated the quality of your assembled genome.

At this stage of the workflow, you have:

- ✔ Assessed assembly contiguity using QUAST.
- ✔ Examined genome size, GC content, and N50.
- ✔ Estimated genome completeness using CheckM.
- ✔ Evaluated contamination and strain heterogeneity.
- ✔ Confirmed that the assembly is suitable for downstream genome characterization.

The assembled genome is now ready for biological interpretation. In the next module, you will characterize the genome by determining its **sequence type (MLST)** and identifying **antimicrobial resistance genes** using **AMRFinderPlus** and **ABRicate**.

------------------------------------------------------------------------
