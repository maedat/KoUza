#!/bin/sh
 
#$ -S /bin/bash
#$ -cwd
 
/home/maedat/bin/FastQC/fastqc $1 -o $2