#!/bin/bash

read -r -d '' DOCS <<DOCS

Script to concatenate the fastq files from a NovaSeq S4 flowcell and to make it ready for BMD pipeline

<DEFINE PARAMETERS>
Parameters:
	-s [required] sample-text-file - full path to the samples.txt file
	-o [required] output-dir - local output directory to save files
	-r [required] remote-path - output directory to TSSS case with the metric files
	-h [optional] debug - option to print this menu option

Usage:
$0 -s {sample_txt_file} -o {output_dir} -r {remote_path}
DOCS
