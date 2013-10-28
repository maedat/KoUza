#!/bin/sh
 
#$ -S /bin/bash
#$ -cwd

export HOME=/home/maedat
source ~/perl5/perlbrew/etc/bashrc
perlbrew use perl-5.16.2_t

Read1=$1
Read2=$2
Idx=$3
out=$4

perl /home/maedat/bin/NGSQCToolkit_v2.3/QC/IlluQC_PRLL.pl \
-pe \
$Read1 \
$Read2 \
/home/maedat/doc/test/adaptor/Truseq_ntonly_idx${Idx}.txt 1 \
-c 8 \
-l 90 \
-s 20 \
-o $out 