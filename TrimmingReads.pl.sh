#!/bin/sh
 
#$ -S /bin/bash
#$ -cwd

Read1=$1
Read2=$2
QV=$3
BpNum=$4
Out=$5

perl /home/maedat/bin/NGSQCToolkit_v2.3/Trimming/TrimmingReads.pl \
-i \
$Read1 \
-irev \
$Read2 \
-q $QV \
-n $BpNum \
-o $Out