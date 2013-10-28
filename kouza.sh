#!/bin/sh
 
#$ -S /bin/bash
#$ -cwd

Read1=$1
Read1_name=$2
Read2=$3
Read2_name=$4
outfol=$5
indx_num=$6

mkdir ${outfol}
mkdir ${outfol}/fastqc


qsub -v PATH ~/bin/Kouza/fastQC.sh $Read1 $outfol/fastqc
qsub -v PATH ~/bin/Kouza/fastQC.sh $Read2 $outfol/fastqc


qsub -v PATH -v PERL5LIB -N trim26 ~/bin/Kouza/TrimmingReads.pl.sh $Read1 $Read2 26 100


qsub -v PATH -v PERL5LIB -N QC26 -hold_jid trim26 ~/bin/Kouza/IlluQC_PRLL.pl.sh \
${Read1}_trimmed \
${Read2}_trimmed \
$indx_num \
${outfol}/QC

qsub -v PATH -hold_jid QC26 ~/bin/Kouza/fastQC.sh \
${outfol}/QC/${Read1_name}_trimmed_filtered \
${outfol}/fastqc


qsub -v PATH -hold_jid QC26 ~/bin/Kouza/fastQC.sh \
${outfol}/QC/${Read2_name}_trimmed_filtered \
${outfol}/fastqc


mkdir ${outfol}/trim_26_100

qsub -v PATH -N marge26 -hold_jid QC26 ~/bin/Kouza/end_pair_marge.pl.sh \
${outfol}/QC/${Read1_name}_trimmed_filtered \
${outfol}/QC/${Read2_name}_trimmed_filtered \
${outfol}/trim_26_100/trimed_paired_marged.fastq \








