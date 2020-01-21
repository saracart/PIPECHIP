# PIPECHIP
PIPECHIP is a computational tool which allows any user to perform a ChIP Seq analysis for any organism and any number of samples.

## Table of Contents
- ChIP Seq
- Usage
- Parameters
- Scripts
- Analysis
  - ChIP-Seq Analysis
  - Functional Analysis (Rscript)
  - Motifs finding (HOMER)
- Example given

## ChIP Seq
ChIP Seq combines methodolgy of High Troughput Sequecing of DNA plus Chromatin Immuno-precipitaion technique to study potential
places for Transcription Factors (TF) to bind DNA. By using PIPECHIP it may be possible to understand where the target TF bind
and what structures they conform.

## Usage
For carrying the study you migth need to create a parameters file in order to create those which they may find necessary.
To see an example, please check the test folder. Inside it there are two different paramteres files, one for an analysisis having
already downloaded the refference genome, the annotatio and samples and another one in case you have to download them all. For further information just __execute the pipechip.sh__ and a message of instructions will prompt.

## Params files
__PLEASE NOTICE THAT THIS TUTORIAL INCLUDES A `test` FOLDER WHERE THE PARAMS FILE IS AVAILABLE. PLEASE DECIDE WHETER YOU HAVER OR NOT DOWONLOADED YOUR REFFERENCE GENOME, ANNOTATION AND SAMPLES.__

__Please, when reading this section, take into account that all refferences to copied parameters (genome, annotation or samples) are performed using de script params_cp.txt__

In this section each parameter from the `params.txt` or `params_cp.txt` file is explained. Please read this section carefully in order to perform your analysis succesfully. __PLEASE MAKE SURE YOU LEAVE A SPACE BETWEEN THE `:` AND THE BEGINING OF THE PARAMETER IN THE PARAMS FILE!!__

- `Working_directory`: This parameter stablishes the directory where the analysis will be performed. We strongly reccommend the user to set it by default to the `$HOME` and create a folder called PIPECHIP (this is a suggestion) where you are going to paste the scripts and a folder called test where params file will be added. After that, add the right path to create the correct folder. In the example given the working directory is `/home/sarajorge/PIPECHIP/FRUITFULL` which means it will create a folder named `FRUITFULL` inside the PIPECHIP folder (__already created before the analysis inside the `$HOME`__).

- `Number_of_samples`: This parameter refers to the total number of samples (both chips and inputs). It must be a number GREATER THAN 0.

- `genome`: depending on having already downloaded or not the refference genome, there might be 2 possible options:
  - __HAVING ALREADY your genome DOWNLOADED.__ In this case, you shall __PASTE IT INTO THE `test` FOLDER__ inside PIPECHIP. Once you have done so, the param genome will be the path to the refference genome inside the test folder.
  - __NOT HAVING DOWNLOADED THE GENOME.__ In this case, all you need to do is paste in the genome param the link to the refference genome.
  
- `annotation`: depending on having already downloaded or not the annotation, there might be 2 possible options:
  - __HAVING ALREADY your genome ANNOTATION.__ In this case, you shall __PASTE IT INTO THE `test` FOLDER__ inside PIPECHIP. Once you have done so, the param genome will be the path to the annotation inside the test folder.
  - __NOT HAVING DOWNLOADED THE ANNOTATION.__ In this case, all you need to do is paste in the genome param the link to the refference genome.

- `chip_num`: This parameter refers to the number of chim samples.

- `input_num`: This parameter refers to the number of input samples.

This example is given for a test where 2 chip samples and 2 input samples are used.
Regarding the samples params, once, more, there might be 2 possible options here:

- __HAVING ALREADY DOWNLOADED THE SAMPLES.__ In this case, you should paste them as well into the `test` folder and add in this parameter, the path to this folder.
  - `chip_1`: paste the path to the chip 1 sample.
  - `chip_2`: paste the path to the chip 2 sample.
  - `input_1`: paste the path to the inpu 1 sample.
  - `input_2`: paste the path to the input 2 sample.

- __NOT HAVING DOWNLOADED THE SAMPLES.__ In this case, you must paste here the SRR accession number from NCBI.
  - `chip_1`: add the right SRR.
  - `chip_2`: add the right SRR.
  - `input_1`: add the right SRR.
  - `input_2`: add the right SRR.

__If you have more than 2 chip and input samples, all you have to do is add extra parameter following the previous order and make sure you write them as chip_n and input_n n reffering to the sample number.__

- `sample_dir`: paste the path to the `test` folder where yu have pasted the params file along with the genome, annotation and samples, given the case you have them already downloaded.

- `promoter`: This parameter refers to the length of the promotoer for the proccessing of picks obtained using macs2 function. 

- `output`: This parameter refers to the directory where you might want to save the peak proccessing file.

## Scripts
In this section we shall describe each script so as you know how the analysis work.

### `pipechip.sh`
This script is the general script and will launch the others when  needed. First of all it will create the working directory (WD) with the samples folders and subfolders. After that it will prompt a question whether you have or not already downloaded the genome. If yes, it will copy it from the test folder to the correc one inside the WD. If not, it will download it from the link given in the params file. After that the script will prompt another question on whether you have or not already downloaded the annotation. If yes, it will copy it from the test folder into the correct one inside the WD. If not, it will download it from the link given in the params file.
Once having downloaded both the genome and annotation it will create the index. After that the script will prompt a third message asking if the samples are downloaded or not. If yes, it will copy them from the test folder into the correct one taking into account chip and inputs samples (__you shall make sure you have added the input and chip samples correctly in the params file__). If not, it will download them using the SRR given in the params file. Once this is done, the script will launch the chip and input processing scripts.

### `chip_sample_processing.sh`
This script processes the samples. It creates the .sam, .bam, sorted.bam and sorted.bam.bai files of the chip samples.

### `input_sample_processing.sh`
This script processes the samples. It creates the .sam, .bam, sorted.bam and sorted.bam.bai files of the input samples.

### `calling_peaks.sh`
This scripts is launched once both chip_sample_processing. sh and input_sample:processing.sh are done. 

## Analysis
This pipeline performs a ChIP-Seq analysis along with a functional analysis of the peaks obtained in order to reveal which molecular functions are related to these peaks and a motif findinf to identify the family to which the transcription factor (TF) belogns.

### ChIP Seq
The first part of this pipeline performs the ChIP-Seq analysis which has already been explained early on this README file.

### Functional Analysis
Once the peaks are obtained they will be saved as peaks_n_peak.narrowPeak, among other files. These narrowPeak files will hold all the vital information for the analysys. In order to extract all the information from it, the script `peak_analysis.R` will be launched to the queue. To understand what it is done in this script, we invite you to open it and read the instructions and comment writen in hash. Please, make sure depending on the number of samples, one script or another will be launched (if you have more than 3 samples, thus 3 different .narroPeak files, check the comments on the Rscript).

### Motifs finding
To clarify to which family does the TF belong, a `HOMER` analysis using the findMotifsGenome.pl will be perform. It will perform as many analysis as summit.bed files there are. Each analysis will be saved into a folder named HOMER_n (n as the number of analysis depending on the number of peaks) inside the results folder.

## Example given
For further information about this tool you may like to perform the analysis using the example samples. You may find them in the NCBI accession number __GSE115358__. The genome and the annotation used were obtained from ensembl plants.

We hope this pipeline let you make a successful analysis. Enjoy it!
