
#install.packages(c("Biostrings","ShortRead","dplyr","tibble","tidyverse"))

library(Biostrings)
library(ShortRead)
library(dplyr)
library(tibble)
library(tidyverse)


####################################### DOSYA OKUMASI ################################################


#29903 uzunlukta dizilerimiz var fakat alttaki dizilerin çogunda N okuma dizileri bozuk oldugu için filtre kullanip sadece 82 adet diziyi aliyorum.
#Alinan birinci dizinin REF dizi oldugu biliniyor.

sars <- readDNAStringSet(file ="sequences.fasta",format = "fasta",use.names = TRUE,seek.first.rec = TRUE)
sars <- sars[nFilter()(sars)] #N okumasi olan dosyalari atar. onlar bize lazim degil. 
sars

#Sondaki dizilerde TAG'ler etiketler olacagi için trimliyorum. Sizin de göreceginiz okumanin son dizileri genelde poliA ile bitmis.
#Trimlemede önemli olan trim sonrasi kalan width'in üçe bölünmesi çünkü AA çevirecegimiz zaman sikinti olmasin.

sars <- DNAStringSet(sars,start = 97,end = 29805)
sars

################################# SARS DATAFRAME OLUSTURULMASI ####################################################

fasta_seq_names <- names(sars)
fasta_seq_names[2]
accession <- gsub(pattern = "\\s.*",replacement = "",fasta_seq_names)

genome <- gsub(pattern = "(.*isolate)(.*,.)",replacement = "",fasta_seq_names) 
###genome <- gsub(pattern = ".*,.",replacement = "",fasta_seq_names)

where_genome <- gsub(pattern = "(.*isolate)|(,.*)",replacement = "",fasta_seq_names)
###where_genome <- gsub(pattern = "(.*human\\/)|(\\/.*)",replacement = "",fasta_seq_names)

sars_df <- data.frame(accession = accession,Seq = sars,genome = genome, where = where_genome,row.names = NULL)
head(sars_df)

#################################### PAIR WISE ALIGMENT  #####################################################


ref_genome <- DNAStringSet(sars_df$Seq[1])

pwa_df <- data.frame(ref_id = "NA",ref_seq = "NA",alig_id = "NA",alig_seq = "NA")

#Bu asama yavas çalisacaktir çünkü tüm elimizde bulunan sekanslarin pairwise'ini yapiyoruz.

for (i in 1:nrow(sars_df)){
  y <- DNAStringSet(sars_df$Seq[i])
  x <- pairwiseAlignment(y,ref_genome,type= "local")
  x <- consensusString(x)
  pwa_df <- pwa_df %>% add_row(ref_id =sars_df$accession[1],ref_seq = sars_df$Seq[1],alig_id=sars_df$accession[i],alig_seq = x)
}

pwa_df <- pwa_df[-1,] #ilk koydugumuz NA satirlarini siliyoruz.
row.names(pwa_df) <- NULL #Row isimlerini siliyoruz.


################## Calculate Mismatch ###########################################

base_mismatch_table <- data.frame(Genome = "NA", Ref="NA", BC="NA",Pos=NA)

ref1 <- pwa_df$ref_seq %>% strsplit(split = '') #genomlari split ederek hepsini harf harf ayiriyoruz.
seq1 <- pwa_df$alig_seq %>% strsplit(split = '') #genomlari split ederek hepsini harf harf ayiriyoruz.

for (i in 1:length(seq1)){
  which_gene <- pwa_df$alig_id[i]
  pos <- which(ref1[[i]] != seq1[[i]])
  a <- ref1[[i]][which(ref1[[i]] != seq1[[i]])]
  b <- seq1[[i]][which(ref1[[i]] != seq1[[i]])]
  
  for (x in 1:length(pos)){
    base_mismatch_table <- base_mismatch_table %>% add_row(Genome = which_gene,Ref = a[x],BC = b[x],Pos=pos[x] )
  }
}

base_mismatch_table <- base_mismatch_table[-1,] #Gaplari ve ilk satirlari atar.
row.names(base_mismatch_table) <- NULL # Index yeniden siralar. 

#----------------------------------------------------------------------------------------------#
  
################## AA Degisim Hesaplanmasi #################################

## AA Seq Tablosu olusturulmasi

aa_trans <-  translate(sars,getGeneticCode("11"),if.fuzzy.codon = "X") # Geneticcode table 11 (standart), codon X is if you see fuzzy change X

aa_df <- data.frame(AA_Seq = aa_trans, row.names = NULL)

sars_df <- sars_df %>% add_column(AA_seq = aa_df$AA_Seq, .after="Seq")


###### AA mismatch table olusturulmasi ###############################

aa_mismatch_table <- data.frame(Genome = "NA", Ref_AA="NA", AA_change="NA",Pos_AA=NA)

ref_aa1 <- sars_df$AA_seq[1] %>% strsplit(split = '')
seq_aa1 <- sars_df$AA_seq %>% strsplit(split = '')


for (i in 1:length(seq_aa1)){
  which_AA <- sars_df$accession[i]
  pos <- which(ref_aa1[[1]] != seq_aa1[[i]])
  a <- ref_aa1[[1]][which(ref_aa1[[1]] != seq_aa1[[i]])]
  b <- seq_aa1[[i]][which(ref_aa1[[1]] != seq_aa1[[i]])]
  
  for (x in 1:length(pos)){
    aa_mismatch_table <- aa_mismatch_table %>% add_row(Genome = which_AA,Ref_AA = a[x],AA_change = b[x],Pos_AA=pos[x] )
  }
}

aa_mismatch_table <- aa_mismatch_table[-1,] #Gaplari ve ilk Satirlari atar.
row.names(aa_mismatch_table) <- NULL #Index yeniden siralar. 



############################## Mismatch Tablosu yaratma


aa_mm_table <- aa_mismatch_table
bs_mm_table <- base_mismatch_table


bs_mm_table <- bs_mm_table %>% add_column(ref_aa = NA,c_aa = NA, pos_aa = NA)


i <- 1

while (i <= nrow(aa_mm_table)){
  t <- which(aa_mm_table$Genome[i] == bs_mm_table$Genome)
  z <- which(aa_mm_table$Genome[i] == aa_mm_table$Genome)
  a1 <- ceiling((bs_mm_table$Pos[t])/3)  #Yukari yuvarlar
  l_a1 <- floor((bs_mm_table$Pos[t])/3)  #Asagi yuvarlar
  b1 <- aa_mm_table$Pos_AA[z]
  for (x in b1){
    q <- which(x == a1)
    y <- which(x == l_a1)
    if (length(q) !=0){
      bs_mm_table$ref_aa[t[q]] <- aa_mm_table$Ref_AA[z[which(x == b1)]]
      bs_mm_table$c_aa[t[q]] <- aa_mm_table$AA_change[z[which(x == b1)]]
      bs_mm_table$pos_aa[t[q]] <- aa_mm_table$Pos_AA[z[which(x == b1)]]

    }
    else if (length(y) != 0){
      bs_mm_table$ref_aa[t[q]] <- aa_mm_table$Ref_AA[z[which(x == b1)][1]]
      bs_mm_table$c_aa[t[q]] <- aa_mm_table$AA_change[z[which(x == b1)][1]]
      bs_mm_table$pos_aa[t[q]] <- aa_mm_table$Pos_AA[z[which(x == b1)][1]]
    }
  }
  
  i = z[length(z)] + 1
  
}

last_table <- bs_mm_table 

########################################## Mismatch Frekans Hesabi

wt_outna <- last_table %>% drop_na()
wt_outna <- wt_outna %>% add_column(frequency = NA)

for (i in 1 : nrow(wt_outna)){
  if (is.na(wt_outna$frequency[i])){
    w1 <- which(wt_outna$Pos[i] == wt_outna$Pos)
    w1_l <- length(w1)
    ff <- (w1_l / nrow(wt_outna)) * 100
    wt_outna$frequency[w1] <- ff
    
  }
  
}

wt_outna

############################################### Protein Bölgelerini Alma

cod_reg <- readDNAStringSet(file ="cod_region.fasta",format = "fasta",use.names = TRUE,seek.first.rec = TRUE)
cod_reg_name <- names(cod_reg)
pro_name <- gsub(pattern = "(.*\\|)|(.\\[.*)",replacement = "",cod_reg_name)
pro_range_st <- as.numeric(gsub(pattern = "(\\..*)|(.*:)",replacement = "",cod_reg_name))
pro_range_fn <- as.numeric(gsub(pattern = "(.\\|.*)|(.*\\.)",replacement = "",cod_reg_name))

pr_df <- data.frame(pro_name = pro_name,start = as.numeric(pro_range_st), end = as.numeric(pro_range_fn), width = as.numeric(pro_range_fn) - as.numeric(pro_range_st))
pr_df <- distinct(pr_df)
pr_df$layer_id <- "l_1"
pr_df$layer_id[12] <- "l_2"

pr_df <- drop_na(pr_df)

############################################# Genome Plot ###########

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("trackViewer")
library(trackViewer)

group_df2 <- wt_outna %>% group_by(pos_aa)
group_df2 <- group_df2 %>% summarise(fre = mean(frequency)) %>% filter(fre > 0.5)


l_genome <- width(ref_genome)
bb_change <- as.vector(group_df2$pos_aa)
bb_score <- as.vector(group_df2$fre)

sample.gr <- GRanges("chr1", IRanges(bb_change, width=1, names=paste0("bc_", bb_change)))
features <- GRanges("chr1", IRanges(as.vector(pr_df$start), 
                                    width=as.vector(pr_df$width),
                                    names=pr_df$pro_name))

features$featureLayerID <- as.vector(pr_df$layer_id)
features$fill <- sample.int(1000,length(features),replace = TRUE)
features$fill[12] <- 0
features$height <- 0.05


sample.gr$color <- sample.int(29, length(bb_change), replace=TRUE)
sample.gr$border <- sample(c("gray80", "gray30"), length(bb_change), replace=TRUE)
sample.gr$alpha <- sample(100:255, length(bb_change), replace = TRUE)/255
sample.gr$score <- bb_score * 10 #Yüzde oranini bine genislettik.


lolliplot(sample.gr, features)

lolliplot(sample.gr, features, ranges = GRanges("chr1", IRanges(1, 20000)))












































