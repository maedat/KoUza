#!/bin/sh
 
#$ -S /bin/bash
#$ -cwd

IN="$1" 
OUT="$1""$2"".count"
OUTH="$OUT"".hist"
KMER=$2
Cvalue=$3
HASH=$4
HIGH=$5

~/bin/jellyfish \
count \
-C \
-m $KMER \
-o $OUT \
-s $HASH \
-t 8 \
-c $Cvalue \
$IN

pid1=$!
wait $pid1

~/bin/jellyfish \
histo \
-h $HIGH \
-t 8 \
-o $OUTH \
"$OUT""_0"

