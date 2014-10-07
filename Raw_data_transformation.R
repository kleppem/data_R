#Load data
SCbMigR1Raw<-read.table("HealthybulkRAWchip53.txt", check.names=TRUE, header=TRUE)

#Make data frame
data.frame(sdMigR1Raw,xMigR1Raw)
SCMigR1Rowdf<-data.frame(SCbMigR1Raw)

#Calculate mean of columns
colMeans(SCMigR1Rowdf, na.rm = TRUE)

#Calculate average and 2*STDEV for each row
colMeans(SCMigR1Rowdf, na.rm = TRUE)
colStdevs(SCMigR1Rowdf, na.rm = FALSE, dims = 1, unbiased = TRUE, SumSquares = FALSE, (xMiweights = NULL, freq = NULL, n = NULL)
          
#Assign standard variation from columns 
sdMigR1Raw<-colSds(SCMigR1Rowdf)

#Dataframe
sdxdf<-data.frame(sdMigR1Raw)
          
#Make table containing two different columns (combine data tables)
xsdMigR1raw<-data.frame(sdMigR1Raw,xMigR1Raw)

#Delete column/row
xsdMigR1raw = xsdMigR1raw[-1,]

# Assign new column names
colnames(xsdMigR1raw)<-c("sd","mean")

#Multiply STDEV column with X
v<-c(2,1)
sdMigR1Raw<-t(t(xsdMigR1raw)*v)

#Sum of sd and mean
df <- transform(sdMigR1Raw, new = sd + mean)

#Assign new column names
colnames(df)<-c("sd","mean", "threshold")

#calculate threshold
TR<-t(df$threshold)

#Assing new column names
colnames(TR)<-c("Cxcl1", "Tnf","Il6", "Il10","Cxcl9", "Ccl3", "Ccl4", "Ccl2","Il12","Ccl5")

#Subset table - remove column SC
SCMigR1RowdfCORR<-subset(SCMigR1Rowdf, select=-c(SC))

#Matrix of threshold
Mtr<-as.matrix(TR)

# Substract threshold values from data table
MigR1TR<-apply(SCMigR1RowdfCORR,c(1),"-",Mtr)

#Data frame
MigR1TRdf<-as.data.frame(MigR1TR)

#write table with all values below 0 = 
rm.neg<-colwise(function(x){return(ifelse(x < 0, 0, x))})
write.csv(MigR1TRdf0,"MigR1TRdf0.csv",na="0")

#Transform table (switch column/row)
MigR1TRdf0t<-t(MigR1TRdf0)

#Delete column/row 
MigR1 = MigR1TRdf0t[-1,]

#Change column names
colnames(MigR1TRdf0t)<-c("Cxcl1","Tnf", "Il6","Il10","Cxcl9","Ccl3", "Ccl4","Ccl2","Il12","Ccl5")

#Remove row names
MigR1<-data.frame(MigR1TRdf0t, row.names=NULL)

#Log transfor data
MigR1Log<-log(MigR1+1)


