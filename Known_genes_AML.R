#set working directory
setwd("~/Documents/RProjects/AML samples")

#Upload data into space
AML1.14all<-read.table("AML1.14all.txt", check.names=TRUE, header=TRUE)
NYGC.combined<-read.table("NYGC.combined.txt", check.names=TRUE, header=TRUE)
#AML1.14oncogenes<-read.table("AML1.14oncogenes.txt", check.names=TRUE, header=TRUE)

# convert into data.frame
dfMSKCC<-data.frame(AML1.14all)
dfNYGC<-data.frame(NYGC.combined)
#dfoncogenes<-data.frame(AML1.14oncogenes)

# subset rows with gene name TET2 or DNMT3A
dfMSKCC.TET2<- dfMSKCC[dfMSKCC$Gene == "TET2", ]
dfMSKCC.DNMT3A<- dfMSKCC[dfMSKCC$Gene == "DNMT3A", ]

#Select rows of which gene column shows one of the genes listed in the vector!##
MSKCC.Select = dfMSKCC[which(dfMSKCC$Gene %in% c("TET2","DNMT3A","WT1", "FLT3", "EZH2", "IDH1", "IDH2", "SRSF2", "NRAS", "TP53", "ASXL1", "STATG2", "ZRSR2", "CBL", "NF1", "SF3B1", "KIT")),]
NYGC.Select = dfNYGC[which(dfNYGC$Gene %in% c("TET2","DNMT3A","WT1", "FLT3", "EZH2", "IDH1", "IDH2", "SRSF2", "NRAS", "TP53", "ASXL1", "STATG2", "ZRSR2", "CBL", "NF1", "SF3B1", "KIT")),]

#NYGC.Select contains NA values as well as a subset of amino.acid.change entries containing invalid data - to be removed
#write data frame
df.NYGC.Select<-data.frame(NYGC.Select)

# Remove row featuring NA in a specific column
df.NYGC.Select.na <- subset(df.NYGC.Select, Amino.acid.change!= "NA")

#export data to .txt
write.table(NYGC.Select.na, "NYGC.Select.txt")
write.table(MSKCC.Select, "MSKCC.Select.txt")
