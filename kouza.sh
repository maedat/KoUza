#!/bin/sh
 
#$ -S /bin/bash
#$ -v PATH
#$ -cwd

#Core pipeline of KoUza
#kouza.sh　{Read1 file path} {Read1 file path} {output file path} {Number of index}
#
#
#out_folder ---------
#                 ┣----fastqc (fastQC data of raw fastq data)
#                 ┣----NGSQCtoolkit( internal data file of QC)
#                 ┣----trim_26_100 (result data)


#Input data set
Read1=$1
Read1_name=`basename ${Read1}`
Read2=$2
Read2_name=`basename ${Read2}`
outfol=$3
indx_num=$4
QC=$5
length=$6

#make folder for output
mkdir ${outfol}
mkdir ${outfol}/fastqc
mkdir ${outfol}/fastqc_trimed
mkdir ${outfol}/trim_${QC}_${length}


#fastQC analysis of raw data
qsub -v PATH ~/bin/Kouza/fastQC.sh $Read1 $outfol/fastqc
qsub -v PATH ~/bin/Kouza/fastQC.sh $Read2 $outfol/fastqc


#triming adapter by NGSQCToolkit_v2.3
#wait the end of trim26 command
qsub -v PATH -v PERL5LIB -N QC26 ~/bin/Kouza/IlluQC_PRLL.pl.sh \
$Read1 \
$Read2 \
$indx_num \
${outfol}/NGSQCtoolkit \
$QC \
$length


#fastQC analysis of trim adapter cutted file _read1
qsub -v PATH -hold_jid QC26 ~/bin/Kouza/fastQC.sh \
${outfol}/NGSQCtoolkit/${Read1_name}_filtered \
${outfol}/fastqc_trimed

#fastQC analysis of trim adapter cutted file _read2
qsub -v PATH -hold_jid QC26 ~/bin/Kouza/fastQC.sh \
${outfol}/NGSQCtoolkit/${Read2_name}_filtered \
${outfol}/fastqc_trimed


#marged trim fileter file
qsub -v PATH -N marge26 -hold_jid QC26 ~/bin/Kouza/end_pair_marge.pl.sh \
${outfol}/NGSQCtoolkit/${Read1_name}_filtered \
${outfol}/NGSQCtoolkit/${Read2_name}_filtered \
${outfol}/trim_${QC}_${length}/trimed_paired_marged.fastq \








