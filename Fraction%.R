# convert in long data
Mdplong<-melt(Mdp, id=c("Cells"), variable.name="cytokine", value.name="cytokine.level")

# create counts table
cellsNA<-Mdplong$Cells
cytokineNA<-Mdplong$cytokine
Mdp.counts<-table(cellsNA, cytokineNA)
View(MEP.countsNA)

#remove ID column
dfdp.ID<-data.frame(dp, row.names=dp$id)
row.names(dfdp.ID)<-dfdp$id
MEP.corrNA$id<-NULL