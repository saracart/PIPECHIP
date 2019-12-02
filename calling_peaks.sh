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
NUMCHIP=$4
PROMOTER=$2
OUTPUT=$3

#Callpeak function

cd $WD/results

##Macs2 for creating the peakAnnotation file

I=1

while [ $I -le $NC ]
do
   macs2 callpeak -t $WD/samples/chip$I/chip_sorted_${I}.bam -c $WD/samples/input$I/input_sorted_${I}.bam -n 'Picos_$I' --outdir . -f BAM
   ((I++))
done


## Rscript

qsub -N peak_processing.R -o $WD/logs/peak_processing /home/sarajorge/PIPECHIP/target_genes.R Peaks$ID.narrowPeak $PROMOTER $OUTPUT

