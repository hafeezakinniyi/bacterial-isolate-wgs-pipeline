------------------------------------------------------------------------

# About this Workshop

## Welcome

Welcome to the **Workshop Guide: Step-by-Step Bacterial WGS Bioinformatics**.

This hands-on workshop is designed to introduce participants to the complete bioinformatics workflow for bacterial whole genome sequencing (WGS) analysis. Rather than treating bioinformatics as a collection of software tools, this workshop guides participants through a logical sequence of analyses, demonstrating how raw sequencing reads are transformed into biologically meaningful information.

Throughout the workshop, participants will perform every major step of a bacterial WGS analysis using real sequencing data. Each exercise combines practical command-line experience with concise explanations, enabling participants to understand not only *how* to perform each analysis but also *why* it is performed and *how* the results should be interpreted.

The workshop concludes by demonstrating how these individual analyses are integrated into an automated pipeline, illustrating how reproducible bioinformatics workflows are developed for routine bacterial genome analysis.

------------------------------------------------------------------------

# Who Should Attend?

This workshop is intended for:

- Undergraduate and postgraduate students in microbiology, molecular biology, veterinary medicine, biotechnology, and related disciplines.
- Researchers beginning bacterial genomics or microbial bioinformatics.
- Laboratory scientists interested in bacterial whole genome sequencing analysis.
- Public health and clinical microbiologists involved in pathogen surveillance.
- Anyone with basic Linux command-line familiarity seeking practical experience in bacterial genome analysis.

No prior experience with bacterial WGS analysis is assumed, although basic familiarity with the Linux terminal will be helpful.

------------------------------------------------------------------------

# Learning Objectives

By the end of this workshop, participants will be able to:

- Explore and organize bacterial whole genome sequencing datasets.
- Assess sequencing read quality using FastQC.
- Perform read trimming using Trimmomatic.
- Identify bacterial species using Kraken2 and Bracken.
- Assemble bacterial genomes using SPAdes.
- Evaluate genome assembly quality using QUAST and CheckM.
- Determine bacterial sequence types using MLST.
- Detect antimicrobial resistance genes using AMRFinderPlus.
- Screen assembled genomes against specialized databases using ABRicate.
- Estimate sequencing depth using Bowtie2 and SAMtools.
- Interpret the biological significance of each analytical result.
- Execute an automated bacterial whole genome sequencing pipeline for reproducible analysis.

------------------------------------------------------------------------

# Workshop Structure

The workshop is organized into nine modules that mirror a typical bacterial WGS analysis workflow.

| Module   | Topic                             |
|----------|-----------------------------------|
| Module 1 | Getting Started                   |
| Module 2 | Read Quality Control              |
| Module 3 | Taxonomic Classification          |
| Module 4 | Genome Assembly                   |
| Module 5 | Evaluate Genome Assembly          |
| Module 6 | Characterize the Genome           |
| Module 7 | Estimate Sequencing Coverage      |
| Module 8 | Review and Interpret the Analysis |
| Module 9 | Using the Automated Pipeline      |

Each module consists of practical exercises that follow a consistent structure:

- **Objective** – What you will accomplish.
- **Background** – Why the analysis is important.
- **Commands** – Ready-to-run Linux commands.
- **Expected Output** – Typical results you should observe.
- **Verify Your Results** – Simple checks to confirm successful completion.
- **Checkpoint** – Key concepts to review before continuing.

------------------------------------------------------------------------

# Software Used

During this workshop, participants will gain hands-on experience with widely used bioinformatics software for bacterial genome analysis, including:

- FastQC
- Trimmomatic
- Kraken2
- Bracken
- SPAdes
- QUAST
- CheckM
- MLST
- AMRFinderPlus
- ABRicate
- Bowtie2
- SAMtools

All analyses are performed using the Linux command line, providing practical experience with tools commonly used in research and public health laboratories.

------------------------------------------------------------------------

# Training Dataset

The workshop uses a paired-end Illumina sequencing dataset from a bacterial isolate:

**Sample ID**

``` text
10-0213-20-0000_S42
```

Using the same dataset throughout the workshop allows participants to observe how each analytical step contributes to the final biological interpretation.

------------------------------------------------------------------------

# How to Use This Guide

This guide is intended to be followed sequentially. Each module builds upon the outputs generated in the previous module, reflecting a real bacterial WGS analysis workflow.

Participants are encouraged to:

- Type each command themselves whenever possible rather than copying and pasting.
- Carefully examine the output produced after every command.
- Compare their results with the expected outputs provided in the guide.
- Complete the verification checks before moving to the next exercise.
- Ask questions and discuss the biological significance of each result during the practical sessions.

By actively engaging with each exercise, participants will develop confidence in both using bioinformatics tools and interpreting bacterial whole genome sequencing data.

------------------------------------------------------------------------

# What You Will Achieve

By the end of this workshop, you will have progressed from working with raw sequencing reads to producing a comprehensive genomic characterization of a bacterial isolate. More importantly, you will understand how each analytical step contributes to the overall workflow and how these individual analyses can be combined into a reproducible bioinformatics pipeline.

The practical skills gained through this workshop provide a strong foundation for bacterial genomics, antimicrobial resistance surveillance, public health microbiology, and microbial bioinformatics research.

------------------------------------------------------------------------
