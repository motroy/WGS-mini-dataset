#!/bin/bash

#download SR and LR data of 2 Kp isolates that share a plasmid

#install fastq-dl
pip3 install fastq-dl
 
#create directories for download

#mkdir -p fastq/{SAMEA3357337,SAMEA3357346}/{SR,LR}
mkdir -p fastq/{SAMEA3181514,SAMEA3726392}/{SR,LR}

#download data

#fastq-dl -a ERR1023640 -o fastq/SAMEA3357337/SR/ERR1023640
#fastq-dl -a ERR10367379 -o fastq/SAMEA3357337/LR/ERR10367379
#fastq-dl -a ERR1023649 -o fastq/SAMEA3357346/SR/ERR1023649
#fastq-dl -a SRR5665595 -o fastq/SAMEA3357346/LR/SRR5665595
#fastq-dl -a ERR10367381 -o fastq/SAMEA3357346/LR/ERR10367381
fastq-dl -a ERR885453 -o fastq/SAMEA3181514/SR/ERR885453
fastq-dl -a ERR1341571 -o fastq/SAMEA3181514/LR/ERR1341571
fastq-dl -a ERR1341570 -o fastq/SAMEA3181514/LR/ERR1341570
fastq-dl -a ERR1539195 -o fastq/SAMEA3726392/SR/ERR1539195
fastq-dl -a ERR1341573 -o fastq/SAMEA3726392/LR/ERR1341573
fastq-dl -a ERR1341572 -o fastq/SAMEA3726392/LR/ERR1341572
