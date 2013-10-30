#!/bin/sh
 
#$ -S /bin/bash
#$ -cwd
#$ -v PATH
#$ -v PERL5LIB


export HOME=/home/maedat
source ~/perl5/perlbrew/etc/bashrc
perlbrew use perl-5.16.2_t

Read1=$1
Read2=$2
Idx=$3
out=$4
QC=$5
length=$6


perl /home/maedat/bin/NGSQCToolkit_v2.3/QC/IlluQC_PRLL.pl \
-pe \
$Read1 \
$Read2 \
./KoUza/Adapter/truseq_adapter_ind${Idx}.fasta 1 5\
-c 8 \
-l $length \
-s $QC \
-o $out 