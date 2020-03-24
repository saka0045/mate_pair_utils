#!/bin/bash

read -r -d '' DOCS <<DOCS

Script to concatenate the fastq files from a NovaSeq S4 flowcell and to make it ready for BMD pipeline
This script expects 4 lanes of fastq file with R1 and R2 (8 total fastq files)

<DEFINE PARAMETERS>
Parameters:
	-i [required] input-directory - full path to the directory with fastq files
	-h [optional] debug - option to print this menu option

Usage:
$0 -s {sample_txt_file} -o {output_dir} -r {remote_path}
DOCS

##################################################
#GLOBAL VARIABLES
##################################################

INPUT_DIR=""
L001_R1=""
L001_R2=""
L002_R1=""
L002_R2=""
L003_R1=""
L003_R2=""
L004_R1=""
L004_R2=""

##################################################
#BEGIN PROCESSING
##################################################

while getopts "hi:" OPTION
do
    case $OPTION in
        h) echo "${DOCS}" ; exit ;;
        i) INPUT_DIR=${OPTARG} ;;
        ?) echo "${DOCS}" ; exit ;;
    esac
done

if [[ -z ${INPUT_DIR} ]]; then
    echo "Need to supply -i, the input directory"
    exit 1
fi

# Remove any trailing "/" from INPUT_DIR
INPUT_DIR=${INPUT_DIR%/}

# Define the different fastq files
L001_R1=${INPUT_DIR}/*L001*R1*.fastq.gz
L001_R2=${INPUT_DIR}/*L001*R2*.fastq.gz
L002_R1=${INPUT_DIR}/*L002*R1*.fastq.gz
L002_R2=${INPUT_DIR}/*L002*R2*.fastq.gz
L003_R1=${INPUT_DIR}/*L003*R1*.fastq.gz
L003_R2=${INPUT_DIR}/*L003*R2*.fastq.gz
L004_R1=${INPUT_DIR}/*L004*R1*.fastq.gz
L004_R2=${INPUT_DIR}/*L004*R2*.fastq.gz

echo "Concatenating" ${L001_R1} "and" ${L003_R1}