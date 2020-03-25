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
ORIGINAL_FASTQ_DIR=""
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

# Check to see if original_fastqs directory exists
# If it doesn't, create the directory and copy all the original fastqs
# If it does, exit the script
ORIGINAL_FASTQ_DIR=${INPUT_DIR}/original_fastqs

if [[ ! -d ${ORIGINAL_FASTQ_DIR} ]]; then
    echo "Creating ${ORIGINAL_FASTQ_DIR}"
    mkdir ${ORIGINAL_FASTQ_DIR}
else
    echo "${ORIGINAL_FASTQ_DIR} already exists. Aborting"
    exit 1
fi

# Copy the original fastq files
echo "Copying the original fastq files"
/bin/cp ${INPUT_DIR}/*.fastq.gz ${ORIGINAL_FASTQ_DIR}

# Define the different fastq files
L001_R1=${INPUT_DIR}/*L001*R1*.fastq.gz
L001_R2=${INPUT_DIR}/*L001*R2*.fastq.gz
L002_R1=${INPUT_DIR}/*L002*R1*.fastq.gz
L002_R2=${INPUT_DIR}/*L002*R2*.fastq.gz
L003_R1=${INPUT_DIR}/*L003*R1*.fastq.gz
L003_R2=${INPUT_DIR}/*L003*R2*.fastq.gz
L004_R1=${INPUT_DIR}/*L004*R1*.fastq.gz
L004_R2=${INPUT_DIR}/*L004*R2*.fastq.gz

# Get the unique identifier for the sample from the fastq file name
BASE_NAME=$(basename -- ${L001_R1})
UNIQUE_IDENTIFIER=$(cut -d "_" -f 1-2 <<< ${BASE_NAME})
echo "Unique identifier is: ${UNIQUE_IDENTIFIER}"

# Concatenate the L003 at the end of L001 fastq files
echo "Concatenating" ${L001_R1} "and" ${L003_R1}
/bin/cat ${L003_R1} >> ${L001_R1}
echo "Concatenating" ${L001_R2} "and" ${L003_R2}
/bin/cat ${L003_R2} >> ${L001_R2}

# Concatenate the L004 at the end of L002 fastq files
echo "Concatenating" ${L002_R1} "and" ${L004_R1}
/bin/cat ${L004_R1} >> ${L002_R1}
echo "Concatenating" ${L002_R2} "and" ${L004_R2}
/bin/cat ${L004_R2} >> ${L002_R2}

# Remove the L003 and L004 fastq files
echo "Removing" ${L003_R1} "and" ${L003_R2}
/bin/rm ${L003_R1} ${L003_R2}
echo "Removing" ${L004_R1} "and" ${L004_R2}
/bin/rm ${L004_R1} ${L004_R2}

# Make the L012 fastq files
L012_R1="${INPUT_DIR}/${UNIQUE_IDENTIFIER}_L012_R1_001.fastq.gz"
L012_R2="${INPUT_DIR}/${UNIQUE_IDENTIFIER}_L012_R2_001.fastq.gz"
echo "Concatenating" ${L001_R1} "and" ${L002_R1}
/bin/cat ${L001_R1} ${L002_R1} > ${L012_R1}
echo "Concatenating" ${L001_R2} "and" ${L002_R2}
/bin/cat ${L001_R2} ${L002_R2} > ${L012_R2}
