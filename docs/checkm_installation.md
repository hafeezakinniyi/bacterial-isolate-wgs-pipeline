# CheckM Installation Guide

This document describes a verified installation procedure for CheckM that was successfully used during development and validation of the Bacterial Isolate WGS Pipeline.

---

## 1. Create the Conda Environment

```bash
conda create -n checkm_env python=3.9
conda activate checkm_env
```

---

## 2. Install Dependencies

```bash
conda install -c bioconda \
    numpy \
    matplotlib \
    pysam \
    hmmer \
    prodigal \
    pplacer
```

---

## 3. Install CheckM

```bash
pip install checkm-genome
```

Verify the installation:

```bash
checkm --version
```

---

## 4. Download the CheckM Data Package

```bash
wget https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_2015_01_16.tar.gz
```

Extract the archive:

```bash
mkdir checkm_data

tar -xvzf checkm_data_2015_01_16.tar.gz -C checkm_data
```

---

## 5. Configure the Database Path

Temporarily:

```bash
export CHECKM_DATA_PATH=~/checkm_data
```

To make this permanent:

```bash
echo 'export CHECKM_DATA_PATH=~/checkm_data' >> ~/.bashrc

source ~/.bashrc
```

Verify:

```bash
echo $CHECKM_DATA_PATH
```

---

## 6. Test the Installation

```bash
checkm data setRoot
```

or

```bash
checkm lineage_wf
```

If no database-related errors occur, the installation is complete.

---

## Notes

The pipeline expects the `checkm` executable to be available in the Conda environment specified in:

```text
config/config.sh
```

The CheckM data package location is obtained from the `CHECKM_DATA_PATH` environment variable.
