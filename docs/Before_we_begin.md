------------------------------------------------------------------------

# Before You Begin

Before starting the practical exercises, ensure that your computing environment is correctly configured. This section will guide you through verifying your software installation, activating the analysis environment, confirming the availability of the required datasets, and checking that all bioinformatics tools are accessible.

By the end of this section, you should be ready to begin the hands-on exercises without interruption.

------------------------------------------------------------------------

## Learning Outcomes

After completing this section, you should be able to:

- Navigate to the project directory.
- Activate the Conda analysis environment.
- Confirm that all required software is installed.
- Verify that the input sequencing files are available.
- Confirm that the required reference databases are correctly configured.
- Verify the project directory structure.

------------------------------------------------------------------------

## Prerequisites

Before proceeding, ensure that:

- Miniconda or Anaconda has been installed.
- The pipeline repository has been cloned.
- The required Conda environments have been created.
- Reference databases have been downloaded and configured.
- The example dataset has been placed inside the `data/` directory.

------------------------------------------------------------------------

## Step 1 — Navigate to the Project Directory

Open a terminal and move into the project directory.

``` bash
cd ~/bacterial-isolate-wgs-pipeline
```

Verify your current location.

``` bash
pwd
```

**Expected output**

``` text
/home/username/bacterial-isolate-wgs-pipeline
```

------------------------------------------------------------------------

## Step 2 — View the Project Structure

Display the contents of the project directory.

``` bash
ls
```

**Expected output**

``` text
config
data
docs
envs
results
scripts
LICENSE
README.md
```

------------------------------------------------------------------------

## Step 3 — Activate the Analysis Environment

Activate the Conda environment containing the primary bioinformatics software.

``` bash
conda activate bacwgs_env
```

Confirm that the environment is active.

``` bash
conda info --envs
```

The active environment should be marked with an asterisk (`*`).

Example:

``` text
base
bacwgs_env    *
checkm_env
mlst_env
```

------------------------------------------------------------------------

## Step 4 — Verify Software Installation

Confirm that the required software is available in your current environment.

### FastQC

``` bash
fastqc --version
```

------------------------------------------------------------------------

### Trimmomatic

``` bash
trimmomatic -version
```

------------------------------------------------------------------------

### Kraken2

``` bash
kraken2 --version
```

------------------------------------------------------------------------

### Bracken

``` bash
bracken -v
```

------------------------------------------------------------------------

### SPAdes

``` bash
spades.py --version
```

------------------------------------------------------------------------

### QUAST

``` bash
quast.py --version
```

------------------------------------------------------------------------

### Bowtie2

``` bash
bowtie2 --version
```

------------------------------------------------------------------------

### SAMtools

``` bash
samtools --version
```

------------------------------------------------------------------------

### AMRFinderPlus

``` bash
amrfinder --version
```

------------------------------------------------------------------------

### ABRicate

``` bash
abricate --version
```

------------------------------------------------------------------------

## Step 5 — Verify CheckM

Deactivate the primary environment.

``` bash
conda deactivate
```

Activate the CheckM environment.

``` bash
conda activate checkm_env
```

Confirm the installation.

``` bash
checkm -h
```

Verify that the CheckM data package has been configured.

``` bash
echo $CHECKM_DATA_PATH
```

The command should display the location of your CheckM data package.

Example:

``` text
/home/username/checkm_data
```

Return to the primary environment.

``` bash
conda deactivate

conda activate bacwgs_env
```

------------------------------------------------------------------------

## Step 6 — Verify MLST

Activate the MLST environment.

``` bash
conda deactivate

conda activate mlst_env
```

Check the installation.

``` bash
mlst --version
```

Return to the primary environment.

``` bash
conda deactivate

conda activate bacwgs_env
```

------------------------------------------------------------------------

## Step 7 — Confirm the Example Dataset

List the sequencing files.

``` bash
ls data/
```

You should see the paired-end sequencing files used throughout this workshop.

Example:

``` text
10-0213-20-0000_S42_R1_001.fastq.gz
10-0213-20-0000_S42_R2_001.fastq.gz
```

------------------------------------------------------------------------

## Step 8 — Check Available Computing Resources (Optional)

Display the number of available CPU cores.

``` bash
nproc
```

Display available memory.

``` bash
free -h
```

These commands are useful when choosing the number of processing threads for computationally intensive analyses.

------------------------------------------------------------------------

## Step 9 — You're Ready!

Congratulations! Your working environment is now ready for the practical exercises.

Before continuing, confirm that:

- ✅ You are in the project directory.
- ✅ The primary Conda environment is active.
- ✅ CheckM and MLST environments have been successfully tested.
- ✅ All required software is installed and accessible.
- ✅ The example dataset is present.
- ✅ No errors were encountered during the setup checks.

You are now ready to begin **Module 1 – Getting Started**.

------------------------------------------------------------------------
