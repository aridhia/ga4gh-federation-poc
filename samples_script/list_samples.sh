#!/usr/bin/env bash
#
# A convenience script to extract sample IDs from a VCF file, typically one of the 1000 genomes data set.
#

if [[ $# < 2 ]]; 
then
    echo "Usage: $0 </path/to/sample VCF file> </path/to/sample list file>"
    # exit 1
else
    bcftools query -l $1 >$2
fi