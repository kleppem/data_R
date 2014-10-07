#read table
dp<-read.table("LINposGFPpos", check.names=TRUE, header=TRUE)

#convert into data frame
dfdp<-data.frame(dp)

#convert data frame into matrix
Mdp<-as.matrix(dfdp)

#Convert values =0 to NA
Mfl.transpose[which(Mfl.transpose<=0)] = NA

#Average of specific column excluding NA
colMeans(Mfl.transpose, na.rm = TRUE)