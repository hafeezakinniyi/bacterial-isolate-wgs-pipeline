---

# Module 7 – Estimate Sequencing Coverage

## Module Overview

Genome assembly provides a draft representation of the bacterial genome, but it is equally important to determine how well the sequencing reads support that assembly. This is achieved by aligning the original sequencing reads back to the assembled genome and calculating sequencing depth (coverage).

Coverage analysis helps assess the reliability of an assembly, identify regions with unusually high or low read support, and estimate the average sequencing depth across the genome.

In this module, you will build a Bowtie2 index from the assembled genome, align the trimmed reads back to the assembly, process the alignments using SAMtools, and calculate sequencing depth.

By the end of this module, you will have quantified the sequencing coverage supporting your assembled genome.

---

# Exercise 7.1 – Build a Bowtie2 Index

## Objective

After completing this exercise, you should be able to:

* Build a Bowtie2 reference index.
* Understand why indexing is required before alignment.
* Locate the generated index files.

---

## Background

Before sequencing reads can be aligned to a reference genome, the reference must first be indexed. Bowtie2 creates several index files that allow rapid searching during alignment. This indexing step only needs to be performed once for a given reference genome.

---

## Input for this Exercise

Input assembly generated in **Module 4**:

```text
results/assembly/10-0213-20-0000_S42/contigs.fasta
```

---

## Commands

### Step 1. Create an output directory

```bash
mkdir -p results/coverage/10-0213-20-0000_S42
```

---

### Step 2. Build the Bowtie2 index

```bash
bowtie2-build \
results/assembly/10-0213-20-0000_S42/contigs.fasta \
results/coverage/10-0213-20-0000_S42/reference
```

---

### Step 3. View the generated index files

```bash
ls results/coverage/10-0213-20-0000_S42
```

---

## Expected Output

Bowtie2 generates six index files.

```text
reference.1.bt2
reference.2.bt2
reference.3.bt2
reference.4.bt2
reference.rev.1.bt2
reference.rev.2.bt2
```

---

## Verify Your Results

Confirm that:

* All six Bowtie2 index files were generated.
* No errors occurred during indexing.

---

## Output Generated

The Bowtie2 index files will be used in **Exercise 7.2**.

---

## Checkpoint

Before continuing, ensure that:

* ✅ Bowtie2 indexing completed successfully.
* ✅ Six index files were generated.

---

# Exercise 7.2 – Align Reads to the Assembly

## Objective

After completing this exercise, you should be able to:

* Align paired-end reads to a reference genome.
* Generate a SAM alignment file.
* Interpret Bowtie2 alignment statistics.

---

## Background

Sequence alignment determines where each sequencing read originated within the assembled genome. Bowtie2 compares every read against the indexed reference and reports the best alignment. The resulting SAM file records the mapping position of every read.

---

## Input for this Exercise

Inputs:

```text
results/coverage/10-0213-20-0000_S42/reference.*
```

and

```text
results/trimmed_reads/
├── 10-0213-20-0000_S42_R1_P.fastq.gz
└── 10-0213-20-0000_S42_R2_P.fastq.gz
```

---

## Commands

### Run Bowtie2

```bash
bowtie2 \
-x results/coverage/10-0213-20-0000_S42/reference \
-1 results/trimmed_reads/10-0213-20-0000_S42_R1_P.fastq.gz \
-2 results/trimmed_reads/10-0213-20-0000_S42_R2_P.fastq.gz \
-p 8 \
-S results/coverage/10-0213-20-0000_S42/mapping.sam
```

---

## Expected Output

Bowtie2 will report statistics similar to:

```text
1677018 reads
99.4% overall alignment rate
```

The following file will be generated:

```text
mapping.sam
```

---

## Verify Your Results

```bash
head results/coverage/10-0213-20-0000_S42/mapping.sam
```

The first lines should begin with:

```text
@HD
@SQ
@PG
```

---

## Output Generated

```text
mapping.sam
```

This SAM file will be processed in the next exercise.

---

## Checkpoint

* ✅ Reads aligned successfully.
* ✅ A SAM file was generated.
* ✅ Alignment statistics were displayed.

---

# Exercise 7.3 – Convert, Sort and Index Alignments

## Objective

After completing this exercise, you should be able to:

* Convert SAM to BAM.
* Sort BAM files.
* Index BAM files.
* Generate alignment statistics.

---

## Background

SAM files are text-based and can be very large. BAM is the compressed binary equivalent of SAM and is much more efficient for downstream analyses. Sorting and indexing the BAM file allows rapid access to specific genomic regions.

---

## Input for this Exercise

```text
results/coverage/10-0213-20-0000_S42/mapping.sam
```

---

## Commands

### Step 1. Convert SAM to BAM

```bash
samtools view \
-bS \
results/coverage/10-0213-20-0000_S42/mapping.sam \
> results/coverage/10-0213-20-0000_S42/mapping.bam
```

---

### Step 2. Sort the BAM file

```bash
samtools sort \
-@ 8 \
-o results/coverage/10-0213-20-0000_S42/mapping.sorted.bam \
results/coverage/10-0213-20-0000_S42/mapping.bam
```

---

### Step 3. Index the sorted BAM

```bash
samtools index \
results/coverage/10-0213-20-0000_S42/mapping.sorted.bam
```

---

### Step 4. View alignment statistics

```bash
samtools flagstat \
results/coverage/10-0213-20-0000_S42/mapping.sorted.bam
```

---

## Expected Output

The directory should now contain:

```text
mapping.bam
mapping.sorted.bam
mapping.sorted.bam.bai
```

The alignment statistics will resemble:

```text
3354036 + 0 in total
3349000 mapped
99.4% mapped
```

---

## Verify Your Results

```bash
ls -lh results/coverage/10-0213-20-0000_S42
```

Confirm that the sorted BAM and index files were generated.

---

## Output Generated

```text
mapping.sorted.bam
mapping.sorted.bam.bai
```

These files are required for calculating sequencing depth.

---

## Checkpoint

* ✅ BAM conversion completed.
* ✅ BAM sorting completed.
* ✅ BAM indexing completed.
* ✅ Alignment statistics were generated.

---

# Exercise 7.4 – Calculate Sequencing Depth

## Objective

After completing this exercise, you should be able to:

* Calculate sequencing depth across the genome.
* Estimate average genome coverage.
* Interpret coverage statistics.

---

## Background

Sequencing depth (coverage) describes how many sequencing reads support each position in the genome. Regions with consistently high coverage provide greater confidence in the assembled sequence, whereas regions with little or no coverage may indicate assembly errors or repetitive regions.

---

## Input for this Exercise

```text
results/coverage/10-0213-20-0000_S42/mapping.sorted.bam
```

---

## Commands

### Step 1. Calculate per-base coverage

```bash
samtools depth \
results/coverage/10-0213-20-0000_S42/mapping.sorted.bam \
> results/coverage/10-0213-20-0000_S42/depth.tsv
```

---

### Step 2. View the first few lines

```bash
head results/coverage/10-0213-20-0000_S42/depth.tsv
```

---

### Step 3. Calculate the average sequencing depth

```bash
awk '{sum+=$3} END {print "Average depth:", sum/NR}' \
results/coverage/10-0213-20-0000_S42/depth.tsv
```

---

## Expected Output

The depth file contains three columns:

```text
Contig
Position
Depth
```

Example:

```text
NODE_1    1    82
NODE_1    2    81
NODE_1    3    84
```

The average depth command will produce output similar to:

```text
Average depth: 78.4
```

---

## Verify Your Results

Confirm that:

* The depth file was generated.
* Coverage values are reported for genomic positions.
* The average depth was successfully calculated.

---

## Output Generated

```text
depth.tsv
```

This file contains per-base sequencing depth across the assembled genome.

---

## Checkpoint

Before moving to the final module, ensure that:

* ✅ The Bowtie2 index was successfully built.
* ✅ Reads were aligned to the assembled genome.
* ✅ The alignments were converted, sorted, and indexed.
* ✅ Per-base sequencing depth was calculated.
* ✅ The average genome coverage was estimated.

---

# End of Module Summary

Congratulations! You have completed the analytical workflow for bacterial whole genome sequencing.

At this stage of the workflow, you have:

* ✔ Built a Bowtie2 index from the assembled genome.
* ✔ Aligned the sequencing reads back to the assembly.
* ✔ Processed the alignments using SAMtools.
* ✔ Generated sorted and indexed BAM files.
* ✔ Calculated per-base sequencing depth.
* ✔ Estimated the average sequencing coverage supporting the genome assembly.

These analyses provide confidence that the assembled genome is well supported by the original sequencing data and is suitable for downstream interpretation or publication.

---
