rm(list=ls(all=TRUE))
library(zoo)
# library(ASHE)
library(lubridate)

# Horizon proche (2021-2050)
# Horizon moyen (2041-2070)
# Horizon lointain (2071-2100)

# data_dir = paste0("C:\\Users\\esauquet\\Desktop\\Explore2\\Intermittence\\Tab_ChroniquesProba_LearnBrut_ByHer\\FDC_Projections\\ORCHIDEE_20231128\\ChroniquesCombinees_saf_hist_rcp85")
data_dir = paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/")
setwd(data_dir)
#tous les fichiers
all_chain_dirs <- dir(data_dir)
all_chain_dirs <- all_chain_dirs[grepl("ADAMONT",all_chain_dirs)]

x <- c()
xND <- c()
xEnd <- c()
xStart <- c()

for (ii in 1:length(all_chain_dirs)) {
  
  print(all_chain_dirs[ii])
  liste <- list.files(path=paste0(data_dir,"/",all_chain_dirs[ii],'/'),pattern=NULL,full.names=T)
  
  # read.table(liste,sep=";",header=T)
  
  dataInterm <- read.table(liste,sep=";",header=T)
  
  dataInterm<- dataInterm[which(dataInterm$Type!="Safran"),]
  dataInterm <- dataInterm[which(year(as.Date(dataInterm[,1]))>1975),]
  
  ### NB JOUR > 10%
  
  xMonth <- as.integer(month(as.Date(dataInterm[,1])))
  y <- zoo(dataInterm$X2,dataInterm$Date)
  dataIntermMonth <- format(time(aggregate(y,as.yearmon,mean)),"%Y-%m-%d")
  y0 <- ((sign(dataInterm[,(3:length(dataInterm[1,]))]-10)+1)/2) # nb jour > 10%
  for (ik in 3:length(dataInterm[1,])) {
    y <- zoo(y0[,(ik-2)],dataInterm$Date)
    dataIntermMonth <-cbind(dataIntermMonth,
                            round(as.vector(aggregate(y,as.yearmon,sum,na.rm=T)),4))
  }
  
  write.table(dataIntermMonth,
              paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/Test/TestEric20240329/",all_chain_dirs[ii],"-dataIntermMonth.csv"),sep=";",
              # paste0("C:/Users/esauquet/Desktop/Explore2/Intermittence/",all_chain_dirs[ii],"-dataIntermMonth.csv"),sep=";",
              quote=TRUE,row.names=F,
              col.names=c("Date",colnames(dataInterm)[3:length(dataInterm[1,])]))
  
  xYear <- as.integer(year(as.Date(dataIntermMonth[,1])))
  meanH0 <- rep(0,length(dataIntermMonth[1,]))
  meanH1 <- rep(0,length(dataIntermMonth[1,]))
  meanH2 <- rep(0,length(dataIntermMonth[1,]))
  meanH3 <- rep(0,length(dataIntermMonth[1,]))
  
  for (ik in 2:length(dataIntermMonth[1,])) {
    
    meanH0[ik] <- 12*mean(as.numeric(dataIntermMonth[which(xYear>=1976&xYear<=2005),ik]),na.rm=T)
    meanH1[ik] <- 12*mean(as.numeric(dataIntermMonth[which(xYear>=2021&xYear<=2050),ik]),na.rm=T)
    meanH2[ik] <- 12*mean(as.numeric(dataIntermMonth[which(xYear>=2041&xYear<=2070),ik]),na.rm=T)
    meanH3[ik] <- 12*mean(as.numeric(dataIntermMonth[which(xYear>=2070&xYear<=2098),ik]),na.rm=T)
    
  }
  
  xND <- rbind(xND,rbind(c(all_chain_dirs[ii],"H0",round(meanH0[2:length(dataIntermMonth[1,])],3)),
                         c(all_chain_dirs[ii],"H1",round(meanH1[2:length(dataIntermMonth[1,])],3)),
                         c(all_chain_dirs[ii],"H2",round(meanH2[2:length(dataIntermMonth[1,])],3)),
                         c(all_chain_dirs[ii],"H3",round(meanH3[2:length(dataIntermMonth[1,])],3))))
  
  
  #####
  
  xMonth <- as.integer(month(as.Date(dataInterm[,1])))
  dataInterm<- dataInterm[which(xMonth>3),]
  
  y <- zoo(dataInterm$X2,dataInterm$Date)
  x0 <- year(as.Date(dataInterm[,1]))
  dataIntermMonth <- format(time(aggregate(y,as.yearmon,mean)),"%Y-%m-%d")
  y0 <- ((sign(dataInterm[,(3:length(dataInterm[1,]))]-10)+1)/2) # nb jour > 10%
  dstartTot <- c()
  dendTot <- c()
  
  for (ik in 3:length(dataInterm[1,])) {
    dstart <- rep(0,(2099-2076+1))
    dend <- rep(0,(2099-2076+1))
    for (iy in 1976:2099) {
      x00 <- which(x0==iy&y0[,(ik-2)]>0)
      if (length(x00)>0) {
        dstart[(iy-1975)] <-
          as.Date(dataInterm[x00[1],1])-as.Date(paste0(iy,"-01-01")) # FAUT IL UN +1 ICI ? NON
        dend[(iy-1975)] <-
          as.Date(dataInterm[max(-x00),1])-as.Date(paste0(iy,"-01-01"))
      }
      else {
        dstart[(iy-1975)] <- NA
        dend[(iy-1975)] <- NA
      }
    }
    dstartTot <- cbind(dstartTot,dstart)
    dendTot <- cbind(dendTot,dend)
  }
  
  # data.frame(1976:2099,as.Date(dstartTot[,2]))
  
  write.table(cbind(1976:2099,dstartTot),
              paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/Test/TestEric20240329/",all_chain_dirs[ii],"-dataIntermDayStart.csv"),sep=";",
              # paste0("C:/Users/esauquet/Desktop/Explore2/Intermittence/",all_chain_dirs[ii],"-dataIntermDayStart.csv"),sep=";",
              quote=TRUE,row.names=F,
              col.names=c("Date",colnames(dataInterm)[3:length(dataInterm[1,])]))
  write.table(cbind(1976:2099,dendTot),
              paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/Test/TestEric20240329/",all_chain_dirs[ii],"-dataIntermDayEnd.csv"),sep=";",
              # paste0("C:/Users/esauquet/Desktop/Explore2/Intermittence/",all_chain_dirs[ii],"-dataIntermDayEnd.csv"),sep=";",
              quote=TRUE,row.names=F,
              col.names=c("Date",colnames(dataInterm)[3:length(dataInterm[1,])]))
  
  
  xYear <- 1976:2099
  meanH0 <- rep(0,length(dendTot[1,]))
  meanH1 <- rep(0,length(dendTot[1,]))
  meanH2 <- rep(0,length(dendTot[1,]))
  meanH3 <- rep(0,length(dendTot[1,]))
  
  for (ik in 1:length(dendTot[1,])) {
    
    meanH0[ik] <- median(as.numeric(dendTot[which(xYear>=1976&xYear<=2005),ik]),na.rm=T)
    meanH1[ik] <- median(as.numeric(dendTot[which(xYear>=2021&xYear<=2050),ik]),na.rm=T)
    meanH2[ik] <- median(as.numeric(dendTot[which(xYear>=2041&xYear<=2070),ik]),na.rm=T)
    meanH3[ik] <- median(as.numeric(dendTot[which(xYear>=2070&xYear<=2098),ik]),na.rm=T)
    
  }
  
  xEnd <- rbind(xEnd,rbind(c(all_chain_dirs[ii],"H0",round(meanH0,3)),
                           c(all_chain_dirs[ii],"H1",round(meanH1,3)),
                           c(all_chain_dirs[ii],"H2",round(meanH2,3)),
                           c(all_chain_dirs[ii],"H3",round(meanH3,3))))
  
  for (ik in 1:length(dendTot[1,])) {
    
    meanH0[ik] <- median(as.numeric(dstartTot[which(xYear>=1976&xYear<=2005),ik]),na.rm=T)
    meanH1[ik] <- median(as.numeric(dstartTot[which(xYear>=2021&xYear<=2050),ik]),na.rm=T)
    meanH2[ik] <- median(as.numeric(dstartTot[which(xYear>=2041&xYear<=2070),ik]),na.rm=T)
    meanH3[ik] <- median(as.numeric(dstartTot[which(xYear>=2070&xYear<=2098),ik]),na.rm=T)
    
  }
  
  xStart <- rbind(xStart,rbind(c(all_chain_dirs[ii],"H0",round(meanH0,3)),
                               c(all_chain_dirs[ii],"H1",round(meanH1,3)),
                               c(all_chain_dirs[ii],"H2",round(meanH2,3)),
                               c(all_chain_dirs[ii],"H3",round(meanH3,3))))
  
  
  #####
  
  xMonth <- as.integer(month(as.Date(dataInterm[,1])))
  dataInterm<- dataInterm[which(xMonth>6&xMonth<11),]
  
  xYear <- as.integer(year(as.Date(dataInterm[,1])))
  
  meanH0 <- rep(0,length(dataInterm[1,]))
  meanH1 <- rep(0,length(dataInterm[1,]))
  meanH2 <- rep(0,length(dataInterm[1,]))
  meanH3 <- rep(0,length(dataInterm[1,]))
  
  for (ik in 3:length(dataInterm[1,])) {
    
    meanH0[ik] <- mean(dataInterm[which(xYear>=1976&xYear<=2005),ik],na.rm=T)
    meanH1[ik] <- mean(dataInterm[which(xYear>=2021&xYear<=2050),ik],na.rm=T)
    meanH2[ik] <- mean(dataInterm[which(xYear>=2041&xYear<=2070),ik],na.rm=T)
    meanH3[ik] <- mean(dataInterm[which(xYear>=2070&xYear<=2099),ik],na.rm=T)
    
  }
  
  x <- rbind(x,rbind(c(all_chain_dirs[ii],"H0",meanH0[3:length(dataInterm[1,])]),
                     c(all_chain_dirs[ii],"H1",meanH1[3:length(dataInterm[1,])]),
                     c(all_chain_dirs[ii],"H2",meanH2[3:length(dataInterm[1,])]),
                     c(all_chain_dirs[ii],"H3",meanH3[3:length(dataInterm[1,])])))
}

# setwd("C:\\Users\\esauquet\\Desktop\\Explore2\\Intermittence\\Tab_ChroniquesProba_LearnBrut_ByHer\\FDC_Projections\\ORCHIDEE_20231128")
setwd("/home/tjaouen/Documents/Output/ChangementClimatique2019/Test/TestEric20240329/")

write.table(x,
            paste0("resul.csv"),sep=";",
            quote=TRUE,row.names=F,
            col.names=c("GCM-RCM-BC","Horizon",colnames(dataInterm)[3:length(dataInterm[1,])]))

write.table(xND,
            paste0("resulND.csv"),sep=";",
            quote=TRUE,row.names=F,
            col.names=c("GCM-RCM-BC","Horizon",colnames(dataInterm)[3:length(dataInterm[1,])]))


write.table(xEnd,
            paste0("resulEnd.csv"),sep=";",
            quote=TRUE,row.names=F,
            col.names=c("GCM-RCM-BC","Horizon",colnames(dataInterm)[3:length(dataInterm[1,])]))


write.table(xStart,
            paste0("resulStart.csv"),sep=";",
            quote=TRUE,row.names=F,
            col.names=c("GCM-RCM-BC","Horizon",colnames(dataInterm)[3:length(dataInterm[1,])]))



# tab_start_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/Test/TestEric20240329_save/resulStart.csv", sep =";", dec = ".", header = T)
# min(tab_start_$X57[which(tab_start_$Horizon=="H2")]+1) # 157.5 -> 6 ou 7/06 au lieu de 6/06
# median(tab_start_$X57[which(tab_start_$Horizon=="H2")]) # 200.5 -> 19 ou 20/07 au lieu de 18/07
# max(tab_start_$X57[which(tab_start_$Horizon=="H2")]) # 227 -> 15/08 au lieu de 14/08
# 
# as.Date(187, origin = paste0(2041, "-01-01"), format = "%Y-%j")
# 
# as.Date(min(tab_start_$X57[which(tab_start_$Horizon=="H2")]+1), origin = paste0(2023, "-01-01"), format = "%Y-%j")
# as.Date(median(tab_start_$X57[which(tab_start_$Horizon=="H2")]+1), origin = paste0(2023, "-01-01"), format = "%Y-%j")
# as.Date(max(tab_start_$X57[which(tab_start_$Horizon=="H2")]+1), origin = paste0(2023, "-01-01"), format = "%Y-%j")
# 
# min(tab_start_$X13[which(tab_start_$Horizon=="H2")]) # 143.5 -> 23 ou 24/05 au lieu de 23/05
# median(tab_start_$X13[which(tab_start_$Horizon=="H2")]) # 163 -> 12/06 au lieu de 11/06
# max(tab_start_$X13[which(tab_start_$Horizon=="H2")]) # 185 -> 4/07 au lieu de 3/07
# 
# min(tab_start_$X81[which(tab_start_$Horizon=="H2")]) # 165.5 -> 14ou15/06 au lieu de 14/06
# median(tab_start_$X81[which(tab_start_$Horizon=="H2")]) # 187 -> 6/07 au lieu de 5/07
# max(tab_start_$X81[which(tab_start_$Horizon=="H2")]) # 203 -> 22/07 au lieu de 21/07
# 
# min(tab_start_$X105[which(tab_start_$Horizon=="H2")]) # 118 -> 28/04 au lieu de 27/04
# median(tab_start_$X105[which(tab_start_$Horizon=="H2")]) # 164 -> 13/06 au lieu de 12/06
# max(tab_start_$X105[which(tab_start_$Horizon=="H2")]) # 176.5 -> 25 ou 26/06 au lieu de 24/06

