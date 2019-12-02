##○ Determination of the targets for FULL transcription factor

## Autor: Sara Cartan Moya and Jorge Domínguez Barragán
## Fecha: November 2019



args <- commandArgs(trailingOnly = TRUE)

input.file.name.1 <- args [[1]]
input.file.name.2 <- args [[2]]
promoter.length <- as.numeric (args [[3]]) 
output.file.name <- args [[4]]


library(ChIPseeker)
library(TxDb.Athaliana.BioMart.plantsmart28)
txdb <- TxDb.Athaliana.BioMart.plantsmart28


## Reading the narrow peak file

peak1_replica <- readPeakFile(peakfile = "Peaks1_peaks.narrowPeak",header=FALSE)
peak2_replica <- readPeakFile(peakfile = "Peaks2_peaks.narrowPeak", header=FALSE)

peaks<-intersect(peak1_replica,peak2_replica)

## Definir la región que se considera promotor entorno al TSS
promoter <- getPromoters(TxDb=txdb, 
                         upstream=-promoter.length, 
                         downstream=promoter.length)

## Anotación de los picos
peak.Anno <- annotatePeak(peak = peaks, 
                             tssRegion=c(-promoter.length, promoter.length),
                             TxDb=txdb)

plotAnnoPie(peak.Anno)
plotDistToTSS(peak.Anno,
              title="Distribution of genomic loci relative to TSS",
              ylab = "Genomic Loci (%) (5' -> 3')")

## Convertir la anotación a data frame
annotation.frame <- as.data.frame(prr5.peakAnno)
head(annotation.frame)

target.genes <- annotation.frame$geneId[annotation.frame$annotation == "Promoter"]

write(x = target.genes,file = "target_genes.txt")

