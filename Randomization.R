install.packages("blockTools") 
install.packages("RItools")
library(blockTools) 

WBC<-read.table("Test.txt", check.names=TRUE, header=TRUE)

WBC_out <- block(WBC, id.vars = "ID", block.vars = c("WBC"), n.tr = 5)

createBlockIDs(WBC_out, WBC, id.var = "ID")

assg_WBC <- assignment(WBC_out, namesCol = c("Vehicle", "Treatment1", "Treatment2", "Combo1", "Combo2"))  ## assign one member of each pair to treatment/control

axb <- assg2xBalance(assg_WBC, WBC, id.var = "ID", bal.vars = c("WBC"), to.report = c("std.diffs", "adj.means"))

diag_WBC <- diagnose(assg_WBC, WBC, id.vars = "ID", suspect.var = "WBC", suspect.range = c(0,1)) 

outCSV(WBC_out)

outTeX(assg_WBC)
