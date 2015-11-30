#!/bin/bash

# Where are the source VCF files kept?
DEFAULT_OUTPUT_FOLDER=/OpenDataArea/tmp-ga4gh-output
# Where are putting the resulting files?
DEFAULT_STORAGE_FOLDER=/OpenDataArea/tmp-ga4gh-storage

now() {
    date +%Y%m%d%H%M%S
}

if [[ $# < 1 ]]; 
then
    echo "Usage: $0 <Selected sample ID list file> [</path/to/storage folder>] [</path/to/output folder>]"
    # exit 1
else
    # TODO - check $1 has some IDs in it an no blank lines
    SAMPLE_LIST_FILE=$1
    
    STORAGE_FOLDER=${2:-$DEFAULT_STORAGE_FOLDER}
    OUTPUT_FOLDER=${3:-$DEFAULT_OUTPUT_FOLDER}

    # TODO - check OUTPUT_FOLDER exists and is writeable

    # For each id in the selected sample ID list files, create a sub VCF file, per chromosome
    for sample_id in $(grep -v '^#' $SAMPLE_LIST_FILE); do
        echo "$(now) $sample_id - Start Processing ..."

        # for each chromosome
        for vcf_file in `ls /OpenDataArea/tmp-ga4gh-storage/*.vcf.gz`; do
            chr=`basename $vcf_file | cut -d'.' -f1`

            vcf_per_chr_file="extract-$sample_id-$chr.vcf"
            echo "$(now) $sample_id - Extract for chr: $chr -> $OUTPUT_FOLDER/$vcf_per_chr_file"

            if [ ! -f "$OUTPUT_FOLDER/$vcf_per_chr_file.gz" ]; then
                # Extract
                bcftools view --samples $sample_id $vcf_file > $OUTPUT_FOLDER/$vcf_per_chr_file
                # compress
                bgzip "$OUTPUT_FOLDER/$vcf_per_chr_file"
            else
                echo "$(now) $sample_id - Extract file exists: $vcf_per_chr_file"
            fi 

            if [ ! -f "$OUTPUT_FOLDER/$vcf_per_chr_file.gz.tbi" ]; then
                # index
                bcftools index -t "$OUTPUT_FOLDER/$vcf_per_chr_file.gz"
            else
                echo "$(now) $sample_id - Indexed file exists: $vcf_per_chr_file.gz.tbi"
            fi
        done

        echo "$(now) $sample_id - Merging ..."
        # Now merge the per-chr VCF into one per sample
        vcf_per_chr_file_list=`ls $OUTPUT_FOLDER/extract-$sample_id-chr*.vcf.gz`
        # concatenate
        bcftools concat -O z -o $OUTPUT_FOLDER/extract-$sample_id.vcf.gz $vcf_per_chr_file_list

        echo "$(now) $sample_id - Merging ... Created: $OUTPUT_FOLDER/extract-$sample_id.vcf.gz"

        echo "$(now) $sample_id - Indexing ... "

        # index the final result
        bcftools index -t $OUTPUT_FOLDER/extract-$sample_id.vcf.gz
        
        echo "$(now) $sample_id - Indexing ... Created: $OUTPUT_FOLDER/extract-$sample_id.vcf.gz.tbi"
        ls $OUTPUT_FOLDER/extract-$sample_id.*
        
        echo "$(now) $sample_id - Processing Complete"

        # Remove the intermediaries
        # rm $vcf_per_chr_file_list
    done
 
fi