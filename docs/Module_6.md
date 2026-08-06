# Module 6 – Characterize the Genome

## Module Overview

Once a high-quality genome assembly has been generated and evaluated, the next step is to characterize its biological features. Genome characterization provides insight into the identity, epidemiological significance, and antimicrobial resistance potential of the bacterial isolate.

In this module, you will determine the isolate's **sequence type (MLST)**, identify **antimicrobial resistance genes using AMRFinderPlus**, and screen the assembled genome against specialized databases using **ABRicate**. Together, these analyses provide a comprehensive overview of the genetic characteristics of the bacterial isolate.

By the end of this module, you will have identified the sequence type of the isolate and characterized its antimicrobial resistance profile and other important genomic features.

------------------------------------------------------------------------

# Exercise 6.1 – Determine Sequence Type (MLST)

## Objective

After completing this exercise, you should be able to:

- Determine the sequence type (ST) of a bacterial isolate.
- Understand the purpose of multilocus sequence typing (MLST).
- Interpret the MLST output.

------------------------------------------------------------------------

## Background

Multilocus Sequence Typing (MLST) is a standardized approach for characterizing bacterial isolates based on the sequences of conserved housekeeping genes. Each unique combination of allele numbers is assigned a **Sequence Type (ST)**, allowing researchers to compare isolates across laboratories and countries.

MLST is widely used in molecular epidemiology to investigate outbreaks, monitor pathogen evolution, and compare bacterial populations.

------------------------------------------------------------------------

## Input for this Exercise

This exercise uses the assembled genome generated in **Module 4**:

``` text
results/assembly/10-0213-20-0000_S42/contigs.fasta
```

------------------------------------------------------------------------

## Commands

### Step 1. Activate the MLST environment

``` bash
conda activate mlst_env
```

------------------------------------------------------------------------

### Step 2. Create an output directory

``` bash
mkdir -p results/mlst
```

------------------------------------------------------------------------

### Step 3. Run MLST

``` bash
mlst \
results/assembly/10-0213-20-0000_S42/contigs.fasta \
> results/mlst/10-0213-20-0000_S42_mlst.tsv
```

------------------------------------------------------------------------

### Step 4. View the results

``` bash
cat results/mlst/10-0213-20-0000_S42_mlst.tsv
```

------------------------------------------------------------------------

## Expected Output

The output will resemble:

``` text
contigs.fasta     ecoli_achtman_4 10      adk(10) fumC(11)        gyrB(4) icd(8)  mdh(8)  purA(8) recA(2)
```

------------------------------------------------------------------------

## Understanding the Output

| Column             | Description                           |
|--------------------|---------------------------------------|
| Genome             | Input assembly                        |
| Scheme             | MLST scheme used                      |
| Sequence Type (ST) | Assigned sequence type                |
| Alleles            | Allele numbers for housekeeping genes |

------------------------------------------------------------------------

## Verify Your Results

Confirm that:

- The MLST analysis completed successfully.
- A sequence type (ST) was assigned.
- The output file was generated.

------------------------------------------------------------------------

## Output Generated

``` text
results/mlst/10-0213-20-0000_S42_mlst.tsv
```

This result summarizes the sequence type of the bacterial isolate.

------------------------------------------------------------------------

## Checkpoint

Before continuing, ensure that:

- ✅ MLST completed successfully.
- ✅ The isolate was assigned a sequence type.
- ✅ You understand the purpose of MLST in bacterial epidemiology.

------------------------------------------------------------------------

# Exercise 6.2 – Detect Antimicrobial Resistance Genes (AMRFinderPlus)

## Objective

After completing this exercise, you should be able to:

- Detect antimicrobial resistance genes.
- Interpret AMRFinderPlus results.
- Understand the relationship between resistance genes and antimicrobial resistance phenotypes.

------------------------------------------------------------------------

## Background

AMRFinderPlus identifies acquired antimicrobial resistance genes and selected resistance-associated mutations by comparing genome sequences against the curated **NCBI Reference Gene Catalog**. The tool provides high-confidence resistance gene predictions and is widely used for bacterial genome characterization.

The results can help predict resistance to different classes of antimicrobial agents and support surveillance of antimicrobial resistance.

------------------------------------------------------------------------

## Input for this Exercise

Input assembly:

``` text
results/assembly/10-0213-20-0000_S42/contigs.fasta
```

------------------------------------------------------------------------

## Commands

### Step 1. Activate the main environment

``` bash
conda activate bacwgs_env
```

*(Replace with your environment name if different.)*

------------------------------------------------------------------------

### Step 2. Create an output directory

``` bash
mkdir -p results/amrfinder
```

------------------------------------------------------------------------

### Step 3. Run AMRFinderPlus

``` bash
amrfinder \
-n results/assembly/10-0213-20-0000_S42/contigs.fasta \
-o results/amrfinder/10-0213-20-0000_S42.tsv
```

------------------------------------------------------------------------

### Step 4. View the results

``` bash
head results/amrfinder/10-0213-20-0000_S42.tsv
```

------------------------------------------------------------------------

## Expected Output

The output table contains columns similar to:

``` text
Protein id
Contig id
Element symbol
Element name
Scope
Subclass
Method
Reference sequence length
% Coverage
% Identity
```

------------------------------------------------------------------------

## Understanding the Output

Important columns include:

| Column         | Description                                 |
|----------------|---------------------------------------------|
| Element Symbol | Resistance gene identified                  |
| Subclass       | Antimicrobial class affected                |
| Method         | Detection method                            |
| \% Identity    | Percentage similarity to reference sequence |
| \% Coverage    | Percentage of reference sequence covered    |

------------------------------------------------------------------------

## Verify Your Results

Confirm that:

- The AMRFinderPlus analysis completed successfully.
- The output table contains one or more resistance genes.
- Drug classes are reported.

------------------------------------------------------------------------

## Output Generated

``` text
results/amrfinder/10-0213-20-0000_S42.tsv
```

This table summarizes the antimicrobial resistance genes identified in the assembled genome.

------------------------------------------------------------------------

## Checkpoint

Before continuing, ensure that:

- ✅ AMRFinderPlus completed successfully.
- ✅ Resistance genes were identified.
- ✅ You understand how AMRFinderPlus predicts antimicrobial resistance.

------------------------------------------------------------------------

# Exercise 6.3 – Screen Against Specialized Databases with ABRicate

## Objective

After completing this exercise, you should be able to:

- Screen bacterial genomes against specialized genomic databases.
- Identify antimicrobial resistance genes, virulence genes, plasmids, and other genomic features.
- Interpret ABRicate results.

------------------------------------------------------------------------

## Background

ABRicate screens assembled genomes against multiple reference databases. Unlike AMRFinderPlus, which focuses on antimicrobial resistance, ABRicate supports several databases, allowing users to identify resistance genes, virulence factors, plasmids, insertion sequences, and other genomic elements.

Using multiple databases provides a broader picture of the biological characteristics of a bacterial isolate.

------------------------------------------------------------------------

## Input for this Exercise

Input assembly:

``` text
results/assembly/10-0213-20-0000_S42/contigs.fasta
```

------------------------------------------------------------------------

## Commands

### Step 1. Create an output directory

``` bash
mkdir -p results/abricate/card
```

------------------------------------------------------------------------

### Step 2. Run ABRicate using the CARD database

``` bash
abricate \
--db card \
--minid 90 \
--mincov 80 \
results/assembly/10-0213-20-0000_S42/contigs.fasta \
> results/abricate/card/10-0213-20-0000_S42_card.tsv
```

------------------------------------------------------------------------

### Step 3. View the results

``` bash
head results/abricate/card/10-0213-20-0000_S42_card.tsv
```

------------------------------------------------------------------------

### Step 4. Generate a summary table

``` bash
abricate \
--summary \
results/abricate/card/*.tsv
```

------------------------------------------------------------------------

## Expected Output

The output contains information such as:

``` text
SEQUENCE
START
END
GENE
%COVERAGE
%IDENTITY
DATABASE
ACCESSION
PRODUCT
RESISTANCE
```

The summary table will report the number of genes detected in each sample.

------------------------------------------------------------------------

## Understanding the Output

Important columns include:

| Column     | Description                              |
|------------|------------------------------------------|
| Gene       | Identified gene                          |
| %Coverage  | Percentage of the reference gene covered |
| %Identity  | Percentage sequence identity             |
| Database   | Database searched                        |
| Product    | Predicted gene function                  |
| Resistance | Antimicrobial class affected             |

------------------------------------------------------------------------

## Verify Your Results

Confirm that:

- ABRicate completed successfully.
- The output table was generated.
- The summary table was produced.
- One or more genes were identified.

------------------------------------------------------------------------

## Output Generated

``` text
results/abricate/card/10-0213-20-0000_S42_card.tsv
```

and

``` text
results/abricate/card/summary.tsv
```

These files summarize the genes detected against the selected database.

------------------------------------------------------------------------

## Checkpoint

Before moving to Module 7, ensure that:

- ✅ MLST completed successfully.
- ✅ AMRFinderPlus identified antimicrobial resistance genes.
- ✅ ABRicate successfully screened the genome against the CARD database.
- ✅ You understand the complementary roles of MLST, AMRFinderPlus, and ABRicate.

------------------------------------------------------------------------

# End of Module Summary

Congratulations! You have completed the biological characterization of your assembled bacterial genome.

At this stage of the workflow, you have:

- ✔ Determined the isolate's **Sequence Type (ST)** using MLST.
- ✔ Identified antimicrobial resistance genes using **AMRFinderPlus**.
- ✔ Screened the genome against the **CARD** database using ABRicate.
- ✔ Generated outputs that can be used for epidemiological investigations and antimicrobial resistance surveillance.

In the next module, you will estimate sequencing coverage by aligning the trimmed sequencing reads back to the assembled genome. This final analytical step provides an additional measure of assembly quality by evaluating the depth and uniformity of read coverage across the genome.

------------------------------------------------------------------------
