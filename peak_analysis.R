## Script para determinar los genes dianas de un factor de transcripción
## a partir del fichero narrowPeak generado por MaCS2.

## Autor: Sara Cartan Moya y Jorge Domínguez Barragán
## Fecha: November 2019

##Setting woring directory

setwd(dir = "/home/sarajorge/PIPECHIP/R_results")

## Loading arguments

args <- commandArgs(trailingOnly = TRUE)

input.file.name1 <- args[[1]]
input.file.name2 <- args[[2]]
pe <- as.numeric(args[[3]])

library(ChIPseeker)
library(TxDb.Athaliana.BioMart.plantsmart28)
txdb <- TxDb.Athaliana.BioMart.plantsmart28

## Reading peak file

peaks1 <- readPeakFile(peakfile = input.file.name1,header=FALSE)
peaks2 <- readPeakFile(peakfile = input.file.name2,header=FALSE)
peaks <- intersect(peaks1, peaks2)

## Defining the region that is considered as a promoter 

promoter <- getPromoters(TxDb=txdb, 
                         upstream=promoter.length, 
                         downstream=promoter.length)

genes <- as.data.frame(genes(txdb))
genes_names <- genes$gene_id
length(genes_names)


## Annotating peaks

peakanno <- annotatePeak(peak = peaks, 
                         tssRegion=c(-promoter.length, promoter.length),
                         TxDb=anno)

## Peaks in each chromosome

covplot(peaks, weightCol="V5", title = "Chromosome peaks")

## Binding sites in specific regions of the genome

plotAnnoPie(peakanno)
vennpie(peakanno)

## Distribution of genomic loci relative to TSS

plotDistToTSS(peakanno,
              title="Distribution of genomic loci relative to TSS",
              ylab = "Genomic Loci (%) (5' -> 3')")


## Converting annotation to data frame and writing a table with target genes

annotation_dataframe <- as.data.frame(peakanno)

target_genes <- annotation_dataframe$geneId[annotation_dataframe$annotation == "Promoter"]

write(x = target_genes, file="target_genes.txt")

ath.genes<- as.data.frame(genes(txdb))

genes.chr1<- (ath.genes$gene_id)[ath.genes$seqnames == 1]
genes.chr1

genes.chr2<- (ath.genes$gene_id)[ath.genes$seqnames == 2]
genes.chr2

genes.chr3<- (ath.genes$gene_id)[ath.genes$seqnames == 3]
genes.chr3

genes.chr4<- (ath.genes$gene_id)[ath.genes$seqnames == 4]
genes.chr4

genes.chr5<- (ath.genes$gene_id)[ath.genes$seqnames == 5]
genes.chr5

lengths= c(length(genes.chr1), length(genes.chr2), length(genes.chr3), length(genes.chr4), length(genes.chr5))
lengths

ego.chr1<- enrichGO(gene = target_genes, OrgDb = org.At.tair.db, ont = "BP", pvalueCutoff = 1, qvalueCutoff = 1, universe = genes.chr1, keyType = "TAIR")
ego.chr2<- enrichGO(gene = target_genes, OrgDb = org.At.tair.db, ont = "BP", pvalueCutoff = 1, qvalueCutoff = 1, universe = genes.chr2, keyType = "TAIR")
ego.chr3<- enrichGO(gene = target_genes, OrgDb = org.At.tair.db, ont = "BP", pvalueCutoff = 1, qvalueCutoff = 1, universe = genes.chr3, keyType = "TAIR")
ego.chr4<- enrichGO(gene = target_genes, OrgDb = org.At.tair.db, ont = "BP", pvalueCutoff = 1, qvalueCutoff = 1, universe = genes.chr4, keyType = "TAIR")
ego.chr5<- enrichGO(gene = target_genes, OrgDb = org.At.tair.db, ont = "BP", pvalueCutoff = 1, qvalueCutoff = 1, universe = genes.chr5, keyType = "TAIR")

KEGG.chr1<- enrichKEGG(gene = target_genes, organism = "ath", universe = genes.chr1, pvalueCutoff = 1, qvalueCutoff = 1)
KEGG.chr2<- enrichKEGG(gene = target_genes, organism = "ath", universe = genes.chr2, pvalueCutoff = 1, qvalueCutoff = 1)
KEGG.chr3<- enrichKEGG(gene = target_genes, organism = "ath", universe = genes.chr3, pvalueCutoff = 1, qvalueCutoff = 1)
KEGG.chr4<- enrichKEGG(gene = target_genes, organism = "ath", universe = genes.chr4, pvalueCutoff = 1, qvalueCutoff = 1)
KEGG.chr5<- enrichKEGG(gene = target_genes, organism = "ath", universe = genes.chr5, pvalueCutoff = 1, qvalueCutoff = 1)

KEGG.chr1.res<- as.data.frame(KEGG.chr1)
KEGG.chr2.res<- as.data.frame(KEGG.chr2)
KEGG.chr3.res<- as.data.frame(KEGG.chr3)
KEGG.chr4.res<- as.data.frame(KEGG.chr4)
KEGG.chr5.res<- as.data.frame(KEGG.chr5)

head(KEGG.chr1.res)
head(KEGG.chr2.res)
head(KEGG.chr3.res)
head(KEGG.chr4.res)
head(KEGG.chr5.res)

library("pathview")

##Aquí es donde me daba error. En el script original la ultima funcion, la que pone
##my.universe[genes.chr4]<-1 en vez de genes.chr4 tiene target.genes, pero claro
##supuse que el error es que nosotros tenemos que especificar qué cromosoma queremos mirar
##y como todos están cargados arriba, pues he probado el 4 que es donde está uno de los genes SAUR.
target.genes<- read.table(file = "fruit_target_genes.txt", header = FALSE)
my.universe<- rep(0,length(genes.chr1))
names(my.universe)<- genes.chr1
my.universe[genes.chr4]<- 1



## Aquí se genera el gráfico ese to wapo to chulo. Lo que hay que ir cambiando es el pathway.id
## que eso se mira en el KEGG que se ha generado. automaticamente se generan los archivos pertinentes

pathview(gene.data = my.universe, pathway.id = "ath04075", species = "ath", gene.idtype = "TAIR")
pathview(gene.data = my.universe, pathway.id = "ath04712", species = "ath", gene.idtype = "TAIR")
pathview(gene.data = my.universe, pathway.id = "ath00330", species = "ath", gene.idtype = "TAIR")



