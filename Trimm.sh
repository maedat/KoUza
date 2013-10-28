#!/bin/sh

#$ -S /bin/bash
#$ -cwd
 
INDX=$1
P1=$2
P2=$3
QS=$4
MinL=$5
OUTFOLT=$6

#Quality triming
java -classpath ~/bin/trimmomatic-0.22.jar org.usadellab.trimmomatic.TrimmomaticPE -threads 8 -phred33 \
$P1 $P2 \
${OUTFOLT}/trimed_paired_R1.fastq ${OUTFOLT}/trimed_Unpaired_R1.fastq \
${OUTFOLT}/trimed_paired_R2.fastq ${OUTFOLT}/trimed_Unpaired_R2.fastq \
ILLUMINACLIP:/home/maedat/bin/Kouza/Adapter/truseq_adapter_ind${INDX}.fasta:2:40:15 \
LEADING:$QS \
TRAILING:$QS \
MINLEN:$MinL