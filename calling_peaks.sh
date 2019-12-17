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
OUTPUT=$4
RSCRIPT=$5
SAMPLEDIR=$6

#Callpeak function

cd $WD/results

## Macs2 for creating the peakAnnotation file

I=1

while [ $I -le $NC ]
do
   macs2 callpeak -t $WD/samples/chip/chip$I/chip_sorted_${I}.bam -c $WD/samples/input/input$I/input_sorted_${I}.bam -n 'peaks_'$I --outdir . -f BAM
   ((I++))
done

## Rscript


cp $SAMPLEDIR/$RSCRIPT $WD/results
Rscript peak_analysis.R $WD/results/peaks_1_peaks.narrowPeak $WD/results/peaks_2_peaks.narrowPeak $PROMOTER ./


## HOMER for finding motifs

cd $WD/results

I=1

while [ $I -le $NC ]
do
   findMotifsGenome.pl peaks_${I}_summits.bed tair10 ./HOMER_$I -size 65
   ((I++))
done

