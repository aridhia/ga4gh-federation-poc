#!/usr/bin/env bash
#
# Use this script to download samples
#
INPUT_FILE_URL_LIST=1000genomes-urls.txt
# STORAGE_FOLDER=/OpenDataArea/tmp-ga4gh-storage
STORAGE_FOLDER=/datadrive0/ga4gh/tmp-output

now() {
    date +%Y%m%d%H%M%S
}

echo "$(now) Reading sample URLs from $INPUT_FILE_URL_LIST"

while read chr url; 
do
    echo "$(now) $chr - VCF file: $url"
    
    # Check the VCF file is available
    status_code=`curl -o /dev/null --silent --head --write-out '%{http_code}' "$url"`
    echo "$(now) $chr - VCF file status: $status_code"
    if [ $status_code == 200 ]; then
        echo "$(now) $chr - Downloading VCF file..."
        curl -# -o $STORAGE_FOLDER/$chr.vcf.gz $url
        echo "$(now) $chr - Downloading VCF file... Done"
    fi

    # Check the index file is available
    index_url="$url.tbi"
    status_code=`curl -o /dev/null --silent --head --write-out '%{http_code}' "$index_url"`
    echo $status_code
    if [ $status_code == 200 ]; then
        echo "$(now) $chr - Downloading VCF index file (tbi)..."
        curl -#  -o $STORAGE_FOLDER/$chr.vcf.gz.tbi $url.tbi
        echo "$(now) $chr -Downloading VCF index file (tbi)... Done"
    fi    
done < "$INPUT_FILE_URL_LIST"
