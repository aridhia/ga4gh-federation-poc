# GLOBAL ALLIANCE FOR GENOMIC HEALTH API

## Installation and setup instructions for reference implementation sites

Document author: Daniel Thornton, Aridhia Informatics
Document Date: 01/07/2015
Version: 1.0

## Introduction

The GA4GH Federated Analysis PoC will be coordinated from the Stratified Medicine Scotland Innovation Centre using one of the analytical workspaces within the AnalytiXagility platform, which will provide the coordination hub connecting to the other reference implementation sites.

AnalytixAgility is Aridhia’s platform for performing collaborative and scalable analytics in an IG compliant framework. Users are given access to secure workspaces to enable them to access authorised datasets and workfiles. 

The aims and objectives of this federated analysis proof of concept are detailed below; in the first instance we aim to do enough to understand the API, installation and possible issues with a coordinated analytical effort. We'll be using an R script deployed to AnalytiXagility to access the VCF data stored at each of the sites running the reference implementation API. The VCF data will be stored in native form, however the API requires a folder structure to be obeyed as detailed below in this document. We aim to simulate a real world scenario by taking a realistic analysis script and using the federated services to accumulate and analyse the data centrally. The data will be accessed via the GA4GH server API at each of the test sites, providing a unified means of accessing VCF data and transferring the data back to the workspace, where further analysis, storage and visualisation can occur.

## Aims and Objectives

1. To show the feasibility of setting up the conditions needed for federated analysis of data
2. Reporting the results of the analysis in real-time to participants
3. Understand the GA4GH API in practice and identify improvement areas
4. Understand the difficulties encountered during setup and implementation of the analysis

## Setup

In order to participate in the federated analysis PoC, each site will require the following:

1. A Linux server to run the GA4GH API. The server will run the web API which should be accessible to the other test sites across the internet. In practice this will mean opening the server firewall to HTTP traffic over port 8000 (#or other#).

2. Sufficient storage space to house the sample VCF data attached to same server

3. A level of comfort working with the Linux command line to set up and provide a secure server that’s externally accessible.

More specific installation details of the GA4GH API and also reference data are described below. Included are instructions and reference material for installing the API on CentOS, Debian and Ubuntu.

## System Requirements

--------------- ------- ----------------------------------------------- --------
Minimum         RAM     Disk space                                      OS 
--------------- ------- ----------------------------------------------- --------
GA4GH Server    2GB     Sufficient disk space to handle the VCF data    Linux 
--------------- ------- ----------------------------------------------- --------

Note that in production, you may wish to separate different parts of the stack. This recommendation is for a 

## Installation Details - Debian/Ubuntu

For Ubuntu and Debian OS, please see the official documentation on the GA4GH website:

http://ga4gh-reference-implementation.readthedocs.org/en/latest/installation.html#deployment-on-apache

## Installation Details - Centos 6

Dependencies

```
$  sudo yum install -y zlib-dev openssl-devel bzip2-devel gcc
```

Python

The API requires Python 2.7, therefore this needs to be specifically installed on Centos 6:

```
$  curl -O https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz
$  tar xzf Python-2.7.10.tgz
$  cd Python-2.7.10
$  ./configure
$  sudo make altinstall
$  curl -O https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz
$  tar -zxvf setuptools-1.4.2.tar.gz
$  cd setuptools-1.4.2
$  sudo /usr/local/bin/python2.7 setup.py install
```

Enable HTTP traffic by editing the ```iptables``` configuration file ...
```
$ vim /etc/sysconfig/iptables
```
...  add the following line:
```
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8000 -j ACCEPT
```

Restart the service
```
$  service iptables restart
```

Create a Python virtualenv
```
$  cd ~/workspace
$  curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | sudo /usr/local/bin/python2.7 -
$  sudo /usr/local/bin/pip2.7 install virtualenv
$  virtualenv ga4gh-env
$  source ga4gh-env/bin/activate
```

Install the server and download some sample data:
```
$  (ga4gh-env) pip install ga4gh --pre
$  (ga4gh-env) curl -O http://www.well.ox.ac.uk/~jk/ga4gh-example-data.tar
$  (ga4gh-env) tar -xvf ga4gh-example-data.tar
```

Now start the server and run a quick check of the API:
```
$  (ga4gh-env) ga4gh_server
$  curl --data '{"datasetIds":[], "name":null}' --header 'Content-Type: application/json' http://localhost:8000/v0.5.1/variantsets/search
```

## Download Test data

The data to be used for the PoC will be variant call format (VCF), which must be stored in a specific folder hierarchy. The top level fodler represents the name of the dataset. Beneath this folders can be created to house the reads and a separate folder contained the VCF data. These folders are calls /variants and /reads. We’ll be focussing on analysing the VCF data. Inside the variants folder can be stored different variant sets, or groups of VCF files. An example folder structure is shown below.

```
ga4gh-data/
    /variants/
        variantSet1/
            chr1.vcf.gz
            chr1.vcf.gz.tbi
            chr2.vcf.gz
            chr2.vcf.gz.tbi
            # More VCFs
        variantSet2/
            chr1.bcf
            chr1.bcf.csi
            chr2.bcf
            chr2.bcf.csi
            # More BCFs
    /reads/
        readGroupSet1
            sample1.bam
            sample1.bam.bai
            sample2.bam
            sample2.bam.bai
            # More BAMS
```

## Notes

During the proof of concept run of the federated analysis, we'll be calling the different test sites over a defined time period. It's therefore necessary to maintain a running GA4GH web server during this time period, which will be decided in due course. Once the analysis has been completed, results and conclusions will be fed back to the group.

In order to access the test sites, we’ll need the following details

-   The URL of the GA4GH Server web application, including the external IP address
-   A technical contact or the person that carried out the installation
-   The time zone and availability of the site (in terms of personnel and up time of the GA4GH server) 

This will enable us to keep a register of the sites involved in the test and the API endpoints we’ll be coordinating with.