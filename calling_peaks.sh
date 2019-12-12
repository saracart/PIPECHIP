## Author: Sara Cartan Moya and Jorge Dominguez Barragan
## Date: November 2019
## Contact: saracartanmoya@gmail.com or jodombar@gmail.com

#$ -S /bin/bash
#$ -N calling_peaks
#$ -V
#$ -cwd
#$ -j yes
#$ -o calling_peaks

#! /bin/bash

## Loading parameters

WD=$1
NC=$2
PROMOTER=$3

#Callpeak function

cd $WD/results

##Macs2 for creating the peakAnnotation file

I=1

while [ $I -le $NC ]
do
   macs2 callpeak -t $WD/samples/chip/chip$I/chip_sorted_${I}.bam -c $WD/samples/input/input$I/input_sorted_${I}.bam -n 'peaks_'$I --outdir . -f BAM
   ((I++))
done

## HOMER for finding motifs

cd $WD

qsub -N HOMER -o $WD/logs/HOMER /home/sarajorge/PIPECHIP/HOMER.sh $WD $NC


## Rscript

Rscript peak_analysis.R $WD/results/peaks1_peaks.narrowpeak $WD/results/peaks2_peaks.narrowPeak $WD/R_results $PROMOTOR

