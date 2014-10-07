#Upload data into space
MEP.MPL<-read.table("MEP.MPL.txt", check.names=TRUE, header=TRUE)

#load threshold values
threshold.MEP.MPL<-read.table("Threshold.MEP.MPL.txt", check.names=TRUE, header=FALSE)

#transpose data
threshold.MEP.MPL<-t(threshold.MEP.MPL)

#delete row.names
threshold.MEP.MPL<-data.frame(threshold.MEP.MPL, row.names=NULL)

#assign column names
colnames(threshold.MEP.MPL)<-c("KC", "TNF", "IL6", "IL10", "IL12p40",	"IL12p70",	"MCP1",	"MIP1a",	"MIP1b",	"RANTES",	"MIG",	"IL2",	"GMCSF")

#delete row 1
threshold.MEP.MPL = threshold.MEP.MPL[-1,]

#check data structure
str(MEP.MPL)

#look at top 6 rows
head(MEP.MPL)

#pull out full column
IL6<-MEP.MPL$IL6

#show histogram of data
hist(IL6)

#log transform data, base 2
hist(log(IL6, base=2))

#define threshold for a specific cytokine (here IL6)
trIL6 <- threshold.MEP.MPL[1,2]

#Threshold a data column for a specific value (here IL6 for 633)
IL6.filtered=MEP.MPL[which(MEP.MPL$IL6 >= 633),]

#Convert data.frame into matrix
M<-as.matrix(MEP.MPL)
Mtr<-as.matrix(threshold.MEP.MPL)

#substracting threshold from MFI
Mfl<-apply(M,c(1),"-",Mtr)

#CONVERT MATRIX AFTER FILTERING BACK TO DATAFRAME
MEP.MPL.Fl<-as.data.frame(Mfl)

#open up data table to adjust column header (read)
fix(threshold.MEP.MPL)

#Sum of column named.IL6
sum(MEP.MPL$IL6)

#number of rows
nrow(MEP.MPL)

#Average MFI for each column excluding <=0 values
colMeans(Mfl.transpose, na.rm = TRUE)

#define subsets (all values in column IL6 > 633)
csc <- subset(MEP.MPL,  IL6 >= 633)

#Convert values <0 to NA
Mfl.transpose[which(Mfl.transpose<0)] = NA

#convert values (TRUE/FALSE)
Positive = Mfl.transpose > 0

# Replace values below threshold with 0 or NA
indx <- mapply("<",as.data.frame(M),Mtr)
M[indx] <- NA`
