# README

# Introduction

This project collects a number of utilities related to the 'Federated Analysis Proof of Concept' collaborative project as part of the [Global Alliance for Genomics and Health](https://genomicsandhealth.org/) initiative.

# Pre-requisites

This package of scripts has been tested on CentOS Linux (version 6.x). Current requirements are:

- Linux CentOS6 2.6.32-573.7.1 or compatible. (try ```uname -a```)
- bash 4.1.2(1)-release
- bcftools 1.2 Using htslib 1.2.1

# Working Notes

The structure of the projects files is:

- 'samples_script' - scripts for preparing sample data for the tet/
- 'test_script' - the script
- 'docs' - background project docs
- 'setup' - details on reference site installation from a Centos point of view 

# Obtaining and organising test data

This PoC uses test data from the 1000 genomes, but any other source of VCF could be used. In our design, each site participating in the PoC hosts a subset of the participants in the 1000 genomes project. The files we are using are publicly available, but organised by chromosome rather than sample.

The following procedure sets up the subset sample for a given list of sample ids, downloads the VCF data from 1000 genomes and creates sample VCFs to test with.

1. Download the desired chromosomes from 1000 genomes and stage in an archive folder (```OUTPUT_FOLDER```). The ```download.sh``` script will do this.

    ```
    $ cd samples_script
    $ ./download.sh 
    ```

    This will read the file ```samples_script/1000genomes-urls.txt``` and process each URL, saving files under a 'per-chromosome' name in ```OUTPUT_FOLDER```. By default OUTPUT_FOLDER is set to ```/OpenDataArea/tmp-ga4gh-storage```

2. If no list of sample IDs  has been provided to you, you can generate one by running the ```list_samples.sh``` script. 

    ```
    $ cd samples_script
    $ ./list_samples.sh $OUTPUT_FOLDER/chrNN.vcf.gz $OUTPUT_FOLDER/samples.txt
    ```

    This assumes you downloaded at least one file called ```chrNN.vcf.gz``` for some NNN (e.g. chr12, chrX)

3. Each group participating in the test will be assigned a subset of samples/ The ```distribute_samples.sh``` script will take the list of sample IDs and split into N files containing the lists of IDs for a given participating group. Each list should have a maximum of M IDs. Some randomisation of the list is  undertaken. By default N = 3 and M = 20.    

    ```
    $ cd samples_script
    $ ./distribute_samples.sh $OUTPUT_FOLDER/samples.txt
    ```
    This will create a file calls ```$OUTPUT_FOLDER/sample-subset-N.txt``` for each subset requested. Each file should have a header and M items in it.

4. Finally, to split the files from 1000Genomes into per-sample per-chromosome VCFs, then to merge into per-sample VCFs, run the ```split_merge.sh``` script for a given subset. For example for subset 1:

    ```
    $ cd samples_script
    $ ./split_merge.sh $OUTPUT_FOLDER/sample-subset-1.txt
    ```

# Installing the server

The PoC will use the GA4GH [reference implementation server](https://github.com/ga4gh/server). Additional documentation is available on [github](https://github.com/ga4gh/server) and at the project's [documentation pages](http://ga4gh-reference-implementation.readthedocs.org/en/develop)

TODO - See instructions in the 'setup' folder when ready

# Running the test script

The test script has been conceived as a representative workflow of a researcher wishing to interrogate repositories held at different sites operating the GA4GH server.

TODO - the test script is being written

# Contact

For any questions please contact [Aridhia Informatics](https://github.com/aridhia)