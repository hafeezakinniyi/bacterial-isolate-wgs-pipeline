# Module 8 – Review and Interpret the Analysis

## Module Overview

Throughout this workshop, you have generated a variety of outputs describing different aspects of a bacterial whole genome sequencing dataset. Individually, each result provides useful information; collectively, they provide a comprehensive picture of the organism, its genome quality, antimicrobial resistance profile, and sequencing performance.

In this module, you will revisit the outputs generated throughout the workshop and interpret them together. Rather than focusing on running commands, this module emphasizes understanding how each analysis contributes to answering biological and technical questions about the bacterial isolate.

By the end of this module, you should be able to summarize the complete analysis and explain the significance of each result.

---

# Exercise 8.1 – Review the Complete Analysis

## Objective

After completing this exercise, you should be able to:

* Review the outputs generated throughout the workflow.
* Interpret the biological and technical significance of each analysis.
* Summarize the overall characteristics of the bacterial isolate.
* Explain how different bioinformatics analyses complement one another.

---

## Background

Bioinformatics analyses are rarely interpreted in isolation. Genome assembly, quality assessment, taxonomic classification, antimicrobial resistance detection, and coverage estimation each answer different questions about the same organism.

By reviewing the outputs together, you can evaluate whether the sequencing experiment was successful, whether the genome assembly is reliable, and what important biological information can be inferred from the genome.

---

## Commands

Throughout this exercise, you will inspect the output files generated in previous modules.

---

### Step 1. Review FastQC Reports

```bash
ls results/qc/raw

ls results/qc/trimmed
```

Questions to consider:

* Were the raw sequencing reads of good quality?
* Did trimming improve the read quality?
* Were adapter sequences removed?
* Were most reads retained after trimming?

---

### Step 2. Review Taxonomic Classification

```bash
cat results/taxonomy/kraken2/10-0213-20-0000_S42.kraken.report

cat results/taxonomy/bracken/10-0213-20-0000_S42.bracken.species
```

Questions to consider:

* Which bacterial species was identified?
* Was one organism dominant?
* Is the result consistent with expectations?

---

### Step 3. Review the Genome Assembly

```bash
cat results/quast/10-0213-20-0000_S42/report.tsv
```

Questions to consider:

* How many contigs were assembled?
* What is the estimated genome size?
* Is the N50 relatively high?
* Does the GC content appear reasonable for the organism?

---

### Step 4. Review Genome Completeness

```bash
checkm qa \
results/checkm/output/lineage.ms \
results/checkm/output \
-o 2
```

Questions to consider:

* Is genome completeness high?
* Is contamination low?
* Is this assembly suitable for downstream analyses?

---

### Step 5. Review MLST Results

```bash
cat results/mlst/10-0213-20-0000_S42_mlst.tsv
```

Questions to consider:

* What sequence type (ST) was assigned?
* Why is sequence typing important in epidemiological investigations?

---

### Step 6. Review AMRFinderPlus Results

```bash
head results/amrfinder/10-0213-20-0000_S42.tsv
```

Questions to consider:

* Which antimicrobial resistance genes were identified?
* Which antimicrobial classes might be affected?
* Which resistance genes appear most clinically relevant?

---

### Step 7. Review ABRicate Results

```bash
cat results/abricate/card/summary.tsv
```

Questions to consider:

* How many resistance genes were detected?
* Do the ABRicate results agree with AMRFinderPlus?
* Why might different databases report slightly different results?

---

### Step 8. Review Sequencing Coverage

```bash
awk '{sum+=$3} END {print "Average depth:", sum/NR}' \
results/coverage/10-0213-20-0000_S42/depth.tsv
```

Questions to consider:

* Was sequencing depth sufficient?
* Would you trust this assembly for downstream analyses?
* How might low coverage affect genome assembly?

---

## Putting the Results Together

At this point, you should be able to answer the following questions about the bacterial isolate.

| Question                                              | Which analysis provides the answer? |
| ----------------------------------------------------- | ----------------------------------- |
| What organism is this?                                | Kraken2 / Bracken                   |
| How good is the sequencing data?                      | FastQC                              |
| Was trimming successful?                              | FastQC (trimmed reads)              |
| Is the genome assembly reliable?                      | QUAST                               |
| Is the genome complete?                               | CheckM                              |
| What is the sequence type?                            | MLST                                |
| Which antimicrobial resistance genes are present?     | AMRFinderPlus                       |
| Are additional resistance or virulence genes present? | ABRicate                            |
| How well do the reads support the assembly?           | Bowtie2 + SAMtools                  |

---

## Interpreting the Workflow

The complete workflow can now be viewed as a connected analysis rather than a collection of independent tools.

```text
Raw sequencing reads
          │
          ▼
Quality assessment
          │
          ▼
Read trimming
          │
          ▼
Taxonomic classification
          │
          ▼
Genome assembly
          │
          ▼
Assembly evaluation
          │
          ▼
Genome characterization
          │
          ▼
Coverage estimation
          │
          ▼
Biological interpretation
```

Each step depends on the outputs generated in previous steps, highlighting the importance of a well-organized and reproducible workflow.

---

## Verify Your Results

By the end of this exercise, you should be able to answer the following questions:

* What organism was sequenced?
* Was the sequencing data of acceptable quality?
* Was the genome assembly of good quality?
* Was the genome complete and free from significant contamination?
* What sequence type was identified?
* Which antimicrobial resistance genes were detected?
* Was sequencing coverage sufficient to support the assembly?

---

## Checkpoint

Before proceeding to the final module, ensure that you can confidently:

* ✅ Explain the purpose of every analysis performed during the workshop.
* ✅ Identify the major output file generated by each software tool.
* ✅ Describe how the outputs from one module become inputs for the next.
* ✅ Interpret the biological significance of the results rather than simply locating the output files.

---

# End of Module Summary

Congratulations! You have completed the manual analysis of a bacterial whole genome sequencing dataset.

Over the course of this workshop, you have:

* ✔ Assessed raw sequencing read quality.
* ✔ Trimmed low-quality bases and reads.
* ✔ Identified the bacterial species.
* ✔ Assembled the bacterial genome.
* ✔ Evaluated assembly quality and completeness.
* ✔ Determined the sequence type (MLST).
* ✔ Identified antimicrobial resistance genes.
* ✔ Screened the genome against specialized databases.
* ✔ Estimated sequencing coverage.
* ✔ Interpreted the complete set of analytical results.

You have now performed each step manually, gaining an understanding of the purpose, commands, inputs, and outputs associated with every stage of a bacterial whole genome sequencing analysis. In the final module, you will see how these individual analyses are integrated into a single automated pipeline, enabling reproducible and scalable analysis of multiple bacterial genomes.

---

Complete a **one-page genome analysis summary**:

| Analysis         | Your Result | Interpretation |
| ---------------- | ----------- | -------------- |
| Species          | __________  | __________     |
| Genome size      | __________  | __________     |
| N50              | __________  | __________     |
| Completeness     | __________  | __________     |
| Contamination    | __________  | __________     |
| Sequence Type    | __________  | __________     |
| Major AMR genes  | __________  | __________     |
| Average coverage | __________  | __________     |

