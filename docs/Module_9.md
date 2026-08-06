---

# Module 9 – Using the Bacterial WGS Pipeline

## Module Overview

Throughout this workshop, you manually performed each step of a bacterial whole genome sequencing analysis, gaining an understanding of the purpose and output of every software tool. You also learned how these individual analyses can be automated using the Bacterial Isolate Whole Genome Sequencing Pipeline.

In this final module, you will learn how to obtain the pipeline from GitHub, configure the required software and reference databases, and execute the complete workflow on your own computer or server. These are the same steps you would follow when using the pipeline in a research laboratory or bioinformatics environment.

By the end of this module, you will be able to install, configure, and run the complete pipeline independently.

---

# Exercise 9.1 – Obtain the Pipeline from GitHub

## Objective

After completing this exercise, you should be able to:

* Understand what GitHub is.
* Clone a GitHub repository to your computer.
* Navigate into the project directory.

---

## Background

GitHub is an online platform used to host and share software projects. Rather than downloading individual scripts, users typically obtain the complete project by **cloning** the repository. Cloning creates an exact copy of the repository on your local computer, including all scripts, documentation, configuration files, and version history.

Once cloned, you have everything needed to configure and run the pipeline.

---

## Commands

### Step 1. Clone the repository

```bash
git clone https://github.com/hafeezakinniyi/bacterial-isolate-wgs-pipeline.git
```

---

### Step 2. Enter the project directory

```bash
cd bacterial-isolate-wgs-pipeline
```

---

### Step 3. View the project structure

```bash
tree -L 2
```

---

## Expected Output

The project structure should resemble:

```text
bacterial-isolate-wgs-pipeline/
├── config/
├── data/
├── docs/
├── envs/
├── results/
├── scripts/
├── LICENSE
└── README.md
```

---

## Verify Your Results

Confirm that:

* The repository was cloned successfully.
* You are inside the project directory.
* The expected project folders are present.

---

## Checkpoint

Before continuing, ensure that:

* ✅ Git is installed.
* ✅ The repository was successfully cloned.
* ✅ You are working inside the project directory.

---

# Exercise 9.2 – Configure the Pipeline

## Objective

After completing this exercise, you should be able to:

* Create the required Conda environments.
* Configure the reference databases.
* Review the main configuration file.

---

## Background

Before running the pipeline, the required software and reference databases must be installed. The pipeline uses Conda environments to manage software dependencies, while the locations of databases and analysis settings are defined in a single configuration file.

Once these steps have been completed, the pipeline is ready to analyse bacterial whole genome sequencing datasets.

---

## Commands

### Step 1. Create the Conda environments

```bash
conda env create -f envs/bacwgs_env.yml

conda env create -f envs/checkm_env.yml

conda env create -f envs/mlst_env.yml
```

---

### Step 2. Install the required databases

Refer to the project documentation:


```text
docs/checkm_installation.md
```

---

### Step 3. Review the configuration file

```bash
nano config/config.sh
```

Review important variables including:

```bash
RAW_READS_DIR
THREADS

KRAKEN_DB
BRACKEN_DB
AMRFINDER_DB

MAIN_ENV
CHECKM_ENV
MLST_ENV
```

---

## Verify Your Results

Confirm that:

* All Conda environments were created successfully.
* Database locations are correctly configured.
* The configuration file reflects your computing environment.

---

## Checkpoint

Before proceeding, ensure that:

* ✅ Software environments have been installed.
* ✅ Databases are available.
* ✅ The configuration file is correctly configured.

---

# Exercise 9.3 – Run the Pipeline

## Objective

After completing this exercise, you should be able to:

* Execute the complete workflow.
* Monitor pipeline progress.
* Locate the generated output files.

---

## Background

The pipeline integrates every analysis performed manually during this workshop into a single automated workflow. It automatically processes each sample through quality control, taxonomic classification, genome assembly, quality assessment, genome characterization, and sequencing coverage estimation.

Because each step has already been explored individually, the pipeline should now be viewed as an efficient way to perform the same analyses reproducibly across multiple samples.

---

## Commands

### Execute the pipeline

```bash
bash scripts/run_pipeline.sh
```

---

### Monitor the pipeline log

```bash
less results/logs/pipeline_*.log
```

---

### View the output directories

```bash
tree results
```

---

## Expected Output

The workflow will execute the following analyses automatically:

```text
Quality Control
        ↓
Read Trimming
        ↓
Taxonomic Classification
        ↓
Genome Assembly
        ↓
Assembly Quality Assessment
        ↓
MLST
        ↓
AMRFinderPlus
        ↓
ABRicate
        ↓
Coverage Estimation
```

At completion, the terminal should display a message indicating that the pipeline finished successfully.

---

## Verify Your Results

Confirm that:

* The pipeline completed without errors.
* All expected output directories were created.
* Log files were generated.
* The outputs match those obtained during the manual exercises.

---

## Checkpoint

Before completing the workshop, ensure that:

* ✅ You can obtain the pipeline from GitHub.
* ✅ You know how to install the required software.
* ✅ You know where to configure database paths.
* ✅ You can execute the complete workflow using a single command.
* ✅ You know where to find the generated results and log files.

---

# End of Module Summary

Congratulations! You have completed the **Workshop Guide: Step-by-Step Bacterial WGS Bioinformatics**.

During this workshop, you learned how to:

* Explore bacterial whole genome sequencing datasets.
* Assess sequencing read quality.
* Trim low-quality reads.
* Perform taxonomic classification.
* Assemble bacterial genomes.
* Evaluate genome quality and completeness.
* Determine sequence types using MLST.
* Detect antimicrobial resistance genes.
* Screen genomes against specialized databases.
* Estimate sequencing coverage.
* Interpret bioinformatics results.
* Install, configure, and execute an automated bacterial WGS pipeline.

You are now equipped to perform bacterial whole genome sequencing analyses both manually and using an automated, reproducible workflow. The skills gained in this workshop provide a strong foundation for genomic surveillance, antimicrobial resistance research, public health microbiology, and comparative bacterial genomics.

---

