#!/bin/sh
 
#$ -S /bin/bash
#$ -v PATH
#$ -cwd

###############################
#KoUza is a pipeline for data triming of illumia sequencing data.
###############################

#Core pipeline of KoUza
#kouza.sh　{Read1 file path} {Read2 file path} {output file path} {Number of index;TruSeq} {Threshold of QC} {Threshold of length (%)}
#
#output folder structure
#out_file_path ---
#                 ┣----fastqc (fastQC data of raw fastq data)
#                 ┣----fastqc_trimed (fastQC data of trimed fastq data)
#                 ┣----NGSQCtoolkit (internal data file of QC)
#                 ┣----trim_<QC>_<length> (result data)




#Geting of input file paths
Read1=$1
Read2=$2
#Getting of input file name
Read1_name=`basename ${Read1}`
Read2_name=`basename ${Read2}`
#Getting of output file path
outfol=$3
#Getting of index data
indx_num=$4
#Getting of trimming setting
QC=$5
length=$6

#make folder for output
mkdir ${outfol}
mkdir ${outfol}/fastqc
mkdir ${outfol}/fastqc_trimed
mkdir ${outfol}/trim_${QC}_${length}


#fastQC analysis of raw data
qsub -v PATH ./KoUza/fastQC.sh $Read1 $outfol/fastqc
qsub -v PATH ./KoUza/fastQC.sh $Read2 $outfol/fastqc


#triming adapter by NGSQCToolkit_v2.3
qsub -v PATH -v PERL5LIB -N ${Read1_name}_${QC}_${length} ./KoUza/IlluQC_PRLL.pl.sh \
$Read1 \
$Read2 \
$indx_num \
${outfol}/NGSQCtoolkit \
$QC \
$length


#fastQC analysis of trimed file read1
qsub -v PATH -hold_jid ${Read1_name}_${QC}_${length} ./KoUza/fastQC.sh \
${outfol}/NGSQCtoolkit/${Read1_name}_filtered \
${outfol}/fastqc_trimed

#fastQC analysis of trim adapter cutted file _read2
qsub -v PATH -hold_jid ${Read1_name}_${QC}_${length} ./KoUza/fastQC.sh \
${outfol}/NGSQCtoolkit/${Read2_name}_filtered \
${outfol}/fastqc_trimed


#marged trim fileter file
qsub -v PATH -N marge26 -hold_jid ${Read1_name}_${QC}_${length} ./KoUza/end_pair_marge.pl.sh \
${outfol}/NGSQCtoolkit/${Read1_name}_filtered \
${outfol}/NGSQCtoolkit/${Read2_name}_filtered \
${outfol}/trim_${QC}_${length}/trimed_paired_marged.fastq \

