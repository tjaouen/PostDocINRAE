rm(list=ls())

wd<-"C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/"
nYear<<-5
yearMin<<-2012
yearMax<<-2016

station1<-"M8144020" # Proportion d'assec = 18.5%
station2<-"H1503910" # Proportion d'assec = 15%
station3<-"V2934010" # Proportion d'assec = 23.5%
station4<-"Y3414005" # Proportion d'assec = 13.6%

####################
# HER 1
HYDRO1<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Pred Station HYDRO/Freq_FAR_ANN/Freq_NonDep_FULL_station_HYDRO_",station1,"_HER2_58_sans_zero.csv",sep=""), header = T, sep=";")
rep1<-which(HYDRO1[,2] < 1)
HYDRO1[rep1,3]<-0
HYDRO1<-as.matrix(HYDRO1$FDC); HYDRO1<-as.vector(HYDRO1)
ANN1<-read.table(paste( wd, 'ANN/J30_FRANCE_2012_2016_station_HYDRO/Output_ANN_station_HYDRO_',station1,'_HER2_58.csv', sep=""), header = T, sep=";")
ANN1<-as.matrix(ANN1$Prediction);ANN1<-as.vector(ANN1); 
LASSO1<-read.table(paste( wd, 'LASSO/J30_FRANCE_2012_2016_station_HYDRO/Output_lasso_station_HYDRO_',station1,'_HER2_58.csv', sep=""), header = T, sep=";")
LASSO1<-as.matrix(LASSO1$Prediction); LASSO1<-as.vector(LASSO1)
RF1<-read.table(paste( wd, 'Random_Forest/J30_FRANCE_2012_2016_station_HYDRO/Output_RF_station_HYDRO_',station1,'_HER2_58.csv', sep=""), header = T, sep=";")
RF1<-as.matrix(RF1$Prediction); RF1<-as.vector(RF1)
BM1<-read.table(paste( wd, 'BENCHMARK_MODEL/France_Stations_HYDRO/Output_BM_station_HYDRO_',station1,'.csv', sep=""), header = T, sep=";")
BM1<-as.matrix(BM1$PRED); BM1<-as.vector(BM1)

# HER 2
HYDRO2<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Pred Station HYDRO/Freq_FAR_ANN/Freq_NonDep_FULL_station_HYDRO_",station2,"_HER2_38_sans_zero.csv",sep=""), header = T, sep=";")
rep2<-which(HYDRO2[,2] < 1)
HYDRO2[rep2,3]<-0
HYDRO2<-as.matrix(HYDRO2$FDC); HYDRO2<-as.vector(HYDRO2)
ANN2<-read.table(paste( wd, 'ANN/J30_FRANCE_2012_2016_station_HYDRO/Output_ANN_station_HYDRO_',station2,'_HER2_38.csv', sep=""), header = T, sep=";")
ANN2<-as.matrix(ANN2$Prediction);ANN2<-as.vector(ANN2); 
LASSO2<-read.table(paste( wd, 'LASSO/J30_FRANCE_2012_2016_station_HYDRO/Output_lasso_station_HYDRO_',station2,'_HER2_38.csv', sep=""), header = T, sep=";")
LASSO2<-as.matrix(LASSO2$Prediction); LASSO2<-as.vector(LASSO2)
RF2<-read.table(paste( wd, 'Random_Forest/J30_FRANCE_2012_2016_station_HYDRO/Output_RF_station_HYDRO_',station2,'_HER2_38.csv', sep=""), header = T, sep=";")
RF2<-as.matrix(RF2$Prediction); RF2<-as.vector(RF2)
BM2<-read.table(paste( wd, 'BENCHMARK_MODEL/France_Stations_HYDRO/Output_BM_station_HYDRO_',station2,'.csv', sep=""), header = T, sep=";")
BM2<-as.matrix(BM2$PRED); BM2<-as.vector(BM2)

################
# HER 3
HYDRO3<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Pred Station HYDRO/Freq_FAR_ANN/Freq_NonDep_FULL_station_HYDRO_",station3,"_HER2_85.csv",sep=""), header = T, sep=";")
rep3<-which(HYDRO3[,2] < 1)
HYDRO3[rep3,3]<-0
HYDRO3<-as.matrix(HYDRO3$FDC); HYDRO3<-as.vector(HYDRO3)
ANN3<-read.table(paste( wd, 'ANN/J30_FRANCE_2012_2016_station_HYDRO/Output_ANN_station_HYDRO_',station3,'_HER2_85.csv', sep=""), header = T, sep=";")
ANN3<-as.matrix(ANN3$Prediction);ANN3<-as.vector(ANN3); 
LASSO3<-read.table(paste( wd, 'LASSO/J30_FRANCE_2012_2016_station_HYDRO/Output_lasso_station_HYDRO_',station3,'_HER2_85.csv', sep=""), header = T, sep=";")
LASSO3<-as.matrix(LASSO3$Prediction); LASSO3<-as.vector(LASSO3)
RF3<-read.table(paste( wd, 'Random_Forest/J30_FRANCE_2012_2016_station_HYDRO/Output_RF_station_HYDRO_',station3,'_HER2_85.csv', sep=""), header = T, sep=";")
RF3<-as.matrix(RF3$Prediction); RF3<-as.vector(RF3)
BM3<-read.table(paste( wd, 'BENCHMARK_MODEL/France_Stations_HYDRO/Output_BM_station_HYDRO_',station3,'.csv', sep=""), header = T, sep=";")
BM3<-as.matrix(BM3$PRED); BM3<-as.vector(BM3)

# HER 4
HYDRO4<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Pred Station HYDRO/Freq_FAR_ANN/Freq_NonDep_FULL_station_HYDRO_",station4,"_HER2_105_sans_zero.csv",sep=""), header = T, sep=";")
rep4<-which(HYDRO4[,2] < 1)
HYDRO4[rep4,3]<-0
HYDRO4<-as.matrix(HYDRO4$FDC); HYDRO4<-as.vector(HYDRO4)
ANN4<-read.table(paste( wd, 'ANN/J30_FRANCE_2012_2016_station_HYDRO/Output_ANN_station_HYDRO_',station4,'_HER2_105.csv', sep=""), header = T, sep=";")
ANN4<-as.matrix(ANN4$Prediction);ANN4<-as.vector(ANN4); 
LASSO4<-read.table(paste( wd, 'LASSO/J30_FRANCE_2012_2016_station_HYDRO/Output_lasso_station_HYDRO_',station4,'_HER2_105.csv', sep=""), header = T, sep=";")
LASSO4<-as.matrix(LASSO4$Prediction); LASSO4<-as.vector(LASSO4)
RF4<-read.table(paste( wd, 'Random_Forest/J30_FRANCE_2012_2016_station_HYDRO/Output_RF_station_HYDRO_',station4,'_HER2_105.csv', sep=""), header = T, sep=";")
RF4<-as.matrix(RF4$Prediction); RF4<-as.vector(RF4)
BM4<-read.table(paste( wd, 'BENCHMARK_MODEL/France_Stations_HYDRO/Output_BM_station_HYDRO_',station4,'.csv', sep=""), header = T, sep=";")
BM4<-as.matrix(BM4$PRED); BM4<-as.vector(BM4)

decade<-cbind(BM4, LASSO4, RF4, ANN4, HYDRO4, BM3, LASSO3, RF3, ANN3, HYDRO3, BM2, LASSO2, RF2, ANN2, HYDRO2, BM1, LASSO1, RF1, ANN1, HYDRO1)
decade2<-decade

for (c in 1:ncol(decade)){
  for (r in 1:nrow(decade)){
    if (c==5 | c==10 | c==15 | c==20){
      if(decade[r,c]==0){
        decade2[r,c]<-5
      } else if (decade[r,c] > 0 & decade[r,c] < 0.1){
        decade2[r,c]<-4
      } else if (decade[r,c] > 0.1 & decade[r,c] < 0.2){
        decade2[r,c]<-3
      } else if (decade[r,c] > 0.2 & decade[r,c] < 0.5){
        decade2[r,c]<-2
      } else if (decade[r,c] > 0.5){
        decade2[r,c]<-1
      }
    } else {
      if(decade[r,c]==1){
        decade2[r,c]<-5
      } else if(decade[r,c]==0){
        decade2[r,c]<-1
      }
    }
  }
}
unique(decade2[,20])

col.palette  <- colorRampPalette(c("white","#fef0d9","#fdcc8a","#fc8d59","#d7301f"),space="Lab");
 ccol        <- col.palette(5);

# col.palette2  <- colorRampPalette(c("white","red"),space="Lab");
# ccol2         <- col.palette2(2);

layout(matrix(c(0,1,0), 1, 3, byrow = F), width = c(1,20,2));
# grid_decade2_fn(mat,nYear,yearMin,yearMax);
# image(x=1:(153*nYear),y=1:5,xlab='',ylab='',z=(decade[1:(153*nYear),1:5]),col=ccol,axes=FALSE, main=paste(" "), line=+3)
image(x=1:(153*nYear),y=1:20,xlab='',ylab='',z=(decade2[1:(153*nYear),1:20]),col=ccol,axes=FALSE, main=paste(" "), line=+3)

# image(x=1:(153*nYear),y=1:10,xlab='',ylab='',z=(decade2[1:(153*nYear),1:10]),col=ccol,axes=FALSE, main=paste(" "), line=+4)

axis(side=1,at=c((31-14), (62-14), (91-14), (122-14), (153-14), (153+31-14), (153+62-14), (153+91-14), (153+122-14), (153+153-14), (2*153+31-14), (2*153+62-14), (2*153+91-14), (2*153+122-14), (2*153+153-14), (3*153+31-14), (3*153+62-14), (3*153+91-14), (3*153+122-14), (3*153+153-14), (4*153+31-14), (4*153+62-14), (4*153+91-14), (4*153+122-14), (4*153+153-14)),
     labels=rep(c('M','J','J','A','S'),5),cex.axis=1,tick=FALSE);

# axis(side=1,at=c(31, 62, 91, 122, 153, 153+31, 153+62, 153+91, 153+122, 153+153, 2*153+31, 2*153+62, 2*153+91, 2*153+122, 2*153+153, 3*153+31, 3*153+62, 3*153+91, 3*153+122, 3*153+153, 4*153+31, 4*153+62, 4*153+91, 4*153+122, 4*153+153),
     # labels=rep(c('M','J','J','A','S'),5),cex.axis=1,tick=FALSE);

axis(side=1,at=c(1, 31, 62, 91, 122, 153, 153+31, 153+62, 153+91, 153+122, 153+153, 2*153+31, 2*153+62, 2*153+91, 2*153+122, 2*153+153, 3*153+31, 3*153+62, 3*153+91, 3*153+122, 3*153+153, 4*153+31, 4*153+62, 4*153+91, 4*153+122, 4*153+153),labels=rep('',26),cex.axis=0.65,tick=TRUE);
# axis(side=1,at=(1:((153*nYear)+1))-0.5,labels=rep('',(153*nYear)+1),cex.axis=0.65,tick=TRUE);
axis(side=3,at= c(1,153,(153*2),(153*3),(153*4),(153*5))-0.5,labels=rep('',6),cex.axis=0.65,tick=T);
axis(side=3,at= c((153/2),((153*1)+153/2),((153*2)+153/2),((153*3)+153/2),((153*4)+153/2)),labels=(yearMin:yearMax),cex.axis=1,tick=F);
axis(side=2,las=1,at=1:25,labels= paste(rep(c("BM","LASSO","RF","ANN","OBS"),5),sep=""),cex.axis=0.75,tick=F);
axis(side=2,las=1,at=(1:25)-0.5,labels= rep('',25),cex.axis=1,tick=T);
axis(side=4,at= c(1,6,11,16,21)-0.5, labels = rep("", 5));
axis(side=4,at= c(6,11,16,21)-3, labels = c('HER4', 'HER3', 'HER2', 'HER1'))
abline(v=(c(153,(153*2),(153*3),(153*4),(153*5))-0.5), lty=2, cex.axis=1)
abline(h=(c(6,11,16,21)-0.5), lty=1)
par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE);  plot(0, 0, type = "n", col="white",bty = "n", xaxt = "n", yaxt = "n");  par(mai=c(0,0,0,0));
# legend("top",legend=paste(bviSTAT,sep=""),bty="n",cex=1.5,xpd = TRUE,horiz=FALSE)
legend("bottom","center",legend=c("Flow - F > 0.5", "0.4 < F < 0.5", "0.2 < F < 0.4","0 < F < 0.2","Drying"),pch=15,cex=1,col=c("white","#fef0d9","#fdcc8a","#fc8d59","#d7301f"),bty="n",xpd = TRUE,horiz=TRUE,inset = c(0,0))
