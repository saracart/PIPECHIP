## Author: Sara Cartan Moya and Jorge Dominguez Barragan
## Date: November 2019
## Contact: saracartanmoya@gmail.com or jodombar@gmail.com

#$ -S /bin/bash
#$ -N chip_sample_processing
#$ -V
#$ -cwd
#$ -j yes
#$ -o chip_sample_processing

#! /bin/bash

## Loading parameters

WD=$1
NUMCHIP=$3
PROMOTER=$2


#Callpeak function

cd $WD/results

##Macs2 for creating the peakAnnotation file

I=1

while [ $I -le $NC ]
do
   macs2 callpeak -t $WD/samples/chip/chip$I/chip_sorted_${I}.bam -c $WD/samples/input/input$I/input_sorted_${I}.bam -n 'peaks_$I' --outdir . -f BAM
   ((I++))
done

## HOMER for finding motifs

while [ $I -le $NC ]
do
   findMotifsGenome.pl peaks_{$I}_summits.bed tair10 ./HOMER_$I -size 65
   ((I++))
done


## Rscript

   qsub -N peak_processing.R -o $WD/logs/peak_processing /home/sarajorge/PIPECHIP/scriptR.sh peaks1_peaks.narrowpeak peaks2_peaks.narrowPeak $PROMOTER 

