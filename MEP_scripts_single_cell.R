#############
######With MEP DATA###

#Load data
MEP<-read.table("MEP.txt", check.names=TRUE, header=TRUE)
MEP<-data.frame(MEP)
#Load threshold values
MEP.TR<-read.table("tr.txt", check.names=TRUE, header=TRUE)
#or
MEP.TR1<-read.table("TR1.txt", check.names=TRUE, header=TRUE)
#Create matrix of values
M<-as.matrix(MEP[ ,3:15])
TR<-t(MEP.TR$Threshold)
TR1<-t(MEP.TR1$Threshold)

#Create index, apply to values

indx <- mapply("<",as.data.frame(M),TR) 
#or
indx <- mapply("<",as.data.frame(M),TR1) 


M[indx] <- NA #or 0
#or
M[indx] <- 1 #or NA #or 0



#Rename MEP to MEP Corrected

MEP.corrNA<-MEP
#or
MEP.1<-MEP

#Replace values with corrected values


MEP.corrNA[ , 3:15]<-M
#or 
MEP.1[ , 3:15]<-M

View(MEP.corrNA)

#Save

write.table(MEP.corrNA, "MEP.CorrectedNA.txt")


#######RESHAPE TO LONG DATA############
#load if not loaded###
MEP.corrNA<- read.table("MEP.CorrectedNA.txt")

#remove id column
MEP.corrNA<-data.frame(MEP.corrNA, row.names=MEP.corrNA$id)
row.names(MEP.corrNA)<-MEP.corrNA$id
MEP.corrNA$id<-NULL


head(MEP.corrNA)


library(reshape2)


MEP.corrNAlong<-melt(MEP.corrNA, id=c("Cells"), variable.name="cytokine", value.name="cytokine.level")

head(MEP.corrNAlong)
View(MEP.corrNAlong)

MEP.long<-na.omit(MEP.corrNAlong)



head(MEP.long)



#######MAKE COUNTS TABLE#########

cellsNA<-MEP.corrNAlong$Cells
cytokineNA<-MEP.corrNAlong$cytokine

MEP.countsNA<-table(cellsNA, cytokineNA)
View(MEP.countsNA)

MEP.countsNA<- as.data.frame(MEP.countsNA)

Cells<-MEP.long$Cells
cytokine<-MEP.long$cytokine


MEP.counts<-table(Cells, cytokine)

View(MEP.counts)

MEP.counts<- data.frame(MEP.counts)
MEP.countsNA<-data.frame(MEP.countsNA)

MEP.counts$n<-MEP.countsNA$Freq

View(MEP.counts)

percent<- (MEP.counts$Freq / MEP.counts$n)*100 

MEP.counts$percent<-percent

View(MEP.counts)

write.table(MEP.counts, "MEP.counts.txt")

#######GRaphing Counts#######
Cytokine<-MEP.counts$cytokine
Cell.type<-MEP.counts$cells
Percent<-MEP.counts$percent


p<-ggplot(MEP.counts, aes(x=Cytokine, y=Percent, fill=Cell.type)) + geom_bar(stat="identity") +theme_bw()+ ylab("Percent Expressing")+xlab("Cytokine") + guides(colour=guide_legend(title="Cell Type")) + ggtitle("Cytokine expression") + theme(axis.text.x=element_text(angle=30, hjust=1, vjust=1, size=rel(.75)))


p
library(ggplot2)





#####EXPRESSION LEVELS DATA STARTING FROM MEP LONG DATA, NA REMOVED##########

MEP.long<-read.table("MEP.long.txt")

head(MEP.long)


Cytokine<-MEP.long$cytokine
Cell.type<-MEP.long$Cells
Cytokine.level<-MEP.long$cytokine.level

MEP.long$log2.level<-log(Cytokine.level, base=2)
Log2.level<-MEP.long$log2.level



#GRAPHS OF EXPRESSION LEVELS#

p<-ggplot(MEP.long, aes(x=Cytokine, y=Log2.level, fill=Cell.type)) + geom_boxplot(outlier.size=1) +theme_bw()+ ylab("Log2 Cytokine Level")+xlab("Cytokine") + guides(colour=guide_legend(title="Cell Type")) + ggtitle("Cytokine expression") +theme(axis.text.x=element_text(angle=30, hjust=1, vjust=1, size=rel(1))) + scale_fill_brewer(palette="Set1")

p



#####EXPRESSION LEVELS DATA STARTING FROM MEP LONG DATA, NA NOT REMOVED##########

MEP.all<-data.frame(MEP.1)

#remove id column
MEP.all<-data.frame(MEP.1, row.names=MEP$id)
row.names(MEP.all)<-MEP.all$id
MEP.all$id<-NULL


head(MEP.all)



library(reshape2)


MEP.longAll<-melt(MEP.all, id=c("Cells"), variable.name="cytokine", value.name="cytokine.level")

head(MEP.longAll)


write.table(MEP.longAll, "MEP.long.all.txt")

head(MEP.longAll)

ML<-MEP.longAll

Cytokine<-ML$cytokine
Cell.type<-ML$Cells
Cytokine.level<-ML$cytokine.level

ML$log2.level<-log(Cytokine.level, base=2)
Log2.level<-ML$log2.level

View(ML)

#GRAPHS OF EXPRESSION LEVELS#

p<-ggplot(ML, aes(x=Cytokine, y=log2.level, fill=Cell.type)) + geom_boxplot(outlier.size=1) +theme_bw()+ ylab("Log2 Cytokine Level")+xlab("Cytokine") + guides(colour=guide_legend(title="Cell Type")) + ggtitle("Cytokine expression") +theme(axis.text.x=element_text(angle=30, hjust=1, vjust=1, size=rel(1))) + scale_fill_brewer(palette="Set1")

p


head(ML)

######
##Awesome use of plyr for applying functions in data frames#####
#####

library(plyr)
x <- ddply(ML, c("Cells", "cytokine"), summarize,
           mean = mean(cytokine.level))
head(x)

View(x)

xNAremoved<- ddply(MEP.long , c("Cells", "cytokine"), summarize,
                mean = mean(cytokine.level))

View(xNAremoved)

write.table(xNAremoved, "Corrected.Means.txt")


xNA<- ddply(MEP.corrNAlong, c("Cells", "cytokine"), summarize,
            mean = mean(cytokine.level, na.rm=TRUE))

View(xNA)


#NOW, MERGE THE CORRECTED MEANS WITH THE FRACTIONS DATA###
####

MEP.total <-  merge(xNA, MEP.counts, by=c("Cells","cytokine"))

write.table(MEP.total, "MEP.total.txt")

View(M.total)

#change name of columns as desired
fix(M.total)
