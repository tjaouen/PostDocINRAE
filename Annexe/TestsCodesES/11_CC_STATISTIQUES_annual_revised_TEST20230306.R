#rm(list=ls(all=TRUE))

library(zoo)
library(hydroTSM)
library(roll)
library(extRemes)
library(lubridate)

# Entr?e
dir.in = "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/Changement Clim/eric/"
dir.out = "C:/eric/CHANGEMENT CLIM 2019 (BOTTET)/Changement Clim/eric/"
# liste.GCM <- c("CSIRO-Mk3-6-0_rcp26_r1","CSIRO-Mk3-6-0_rcp85_r1",
#                "GFDL-ESM2G_rcp26_r1","GFDL-ESM2G_rcp85_r1",
#                "MIROC-ESM_rcp26_r1","MIROC-ESM_rcp85_r1",
#                "bcc-csm1-1_rcp26_r1","bcc-csm1-1_rcp85_r1",
#                "GFDL-ESM2M_rcp26_r1","GFDL-ESM2M_rcp85_r1",
#                "HadGEM2-ES_rcp26_r1","HadGEM2-ES_rcp85_r1",
#                "IPSL-CM5A-LR_rcp26_r1","IPSL-CM5A-LR_rcp85_r1",
#                "MIROC5_rcp26_r1","MIROC5_rcp85_r1",
#                "MRI-CGCM3_rcp26_r1","MRI-CGCM3_rcp85_r1", 
#                "CCSM4_rcp26_r1","CCSM4_rcp85_r1",
#                "IPSL-CM5A-MR_rcp26_r1","IPSL-CM5A-MR_rcp85_r1",
#                "MIROC-ESM-CHEM_rcp26_r1","MIROC-ESM-CHEM_rcp85_r1",
#                "MPI-ESM-LR_rcp26_r1","MPI-ESM-LR_rcp85_r1")
liste.GCM <- c("bcc-csm1-1_rcp26_r1")
#-------------------------------------------------------------------------------

meanPST <- matrix(0,length(liste.GCM),23)
meanMI <- matrix(0,length(liste.GCM),23)
meanFIN <- matrix(0,length(liste.GCM),23)

sdPST <- matrix(0,length(liste.GCM),23)
sdMI <- matrix(0,length(liste.GCM),23)
sdFIN <- matrix(0,length(liste.GCM),23)
z05T5PST <- matrix(0,length(liste.GCM),23)
z05T5MI <- matrix(0,length(liste.GCM),23)
z05T5FIN <- matrix(0,length(liste.GCM),23)
z10T5PST <- matrix(0,length(liste.GCM),23)
z10T5MI <- matrix(0,length(liste.GCM),23)
z10T5FIN <- matrix(0,length(liste.GCM),23)
z20T5PST <- matrix(0,length(liste.GCM),23)
z20T5MI <- matrix(0,length(liste.GCM),23)
z20T5FIN <- matrix(0,length(liste.GCM),23)

deb10PST <- matrix(0,length(liste.GCM),23)
deb10MI <- matrix(0,length(liste.GCM),23)
deb10FIN <- matrix(0,length(liste.GCM),23)
fin10PST <- matrix(0,length(liste.GCM),23)
fin10MI <- matrix(0,length(liste.GCM),23)
fin10FIN <- matrix(0,length(liste.GCM),23)

for(inum in 1:length(liste.GCM)){
  hydro = read.table(paste(dir.in,liste.GCM[inum],"Assecs_KGESUp0.60_DispSup-1_logit.csv",sep=""),sep=";",header=T)
  
  iPST <- c(1:21184)
  hydroPST <- hydro[iPST,]
  iMI <- c(21185:(40543-1))
  hydroMI <- hydro[iMI,]
  iFIN <- c(40544:(59902-1))
  hydroFIN <- hydro[iFIN,]
  # les simulations commencent bien le 01-08 mais pour la gestion des ann?es hydro commen?ant
  # le 1er avril on d?cale de deux mois !!! concordance nombre de jour dans les tableaux 
  # length imFUT = length iFIN = length iMI = length(colonne(hydroFIN,hydroMI))
  PST <- (as.Date(as.Date("1960-05-01"):(as.Date("2018-04-30")))) # attention 1er avril = 1er janvier
  MI <-  (as.Date(as.Date("1960-05-01"):(as.Date("2013-04-30"))))
  FIN <- (as.Date(as.Date("1960-05-01"):(as.Date("2013-04-30"))))
  
  imPST <- as.numeric(substr(as.character(
    (as.Date(as.Date("1960-05-01"):(as.Date("2018-04-30"))))),6,7))
  imFUT <- as.numeric(substr(as.character(
    (as.Date(as.Date("1960-05-01"):(as.Date("2013-04-30"))))),6,7))
  iONDEPST <- which(imPST>2 & imPST<9) # ajustement on veut JUIN (6) - NOMVEMBRE (11)
  iONDEFUT <- which(imFUT>2 & imFUT<9)
  
  meanPST[inum,1] <- liste.GCM[inum]
  meanMI[inum,1] <- liste.GCM[inum]
  meanFIN[inum,1] <- liste.GCM[inum]
  sdPST[inum,1] <- liste.GCM[inum]
  sdMI[inum,1] <- liste.GCM[inum]
  sdFIN[inum,1] <- liste.GCM[inum]
  z05T5PST[inum,1] <- liste.GCM[inum]
  z05T5MI[inum,1] <- liste.GCM[inum]
  z05T5FIN[inum,1] <- liste.GCM[inum]
  z10T5PST[inum,1] <- liste.GCM[inum]
  z10T5MI[inum,1] <- liste.GCM[inum]
  z10T5FIN[inum,1] <- liste.GCM[inum]
  z20T5PST[inum,1] <- liste.GCM[inum]
  z20T5MI[inum,1] <- liste.GCM[inum]
  z20T5FIN[inum,1] <- liste.GCM[inum]
  deb10PST[inum,1] <- liste.GCM[inum]
  deb10MI[inum,1] <- liste.GCM[inum]
  deb10FIN[inum,1] <- liste.GCM[inum]
  fin10PST[inum,1] <- liste.GCM[inum]
  fin10MI[inum,1] <- liste.GCM[inum]
  fin10FIN[inum,1] <- liste.GCM[inum]
  
  temp <- c()
  for(j in 2:23){
    print(paste0("HER1 : ",(j-1)))
    z <- daily2annual(zoo(hydroPST[iONDEPST,(j-1)],PST),mean)
    meanPST[inum,j] <- mean(z[2:(length(z)-1)]) 
    sdPST[inum,j] <- sd(z[2:(length(z)-1)]) 
    
    z <- daily2annual(zoo(hydroMI[iONDEFUT,(j-1)],MI),mean)
    meanMI[inum,j] <- mean(z[2:(length(z)-1)]) 
    sdMI[inum,j] <- sd(z[2:(length(z)-1)]) 
    
    z <- daily2annual(zoo(hydroFIN[iONDEFUT,(j-1)],FIN),mean)
    meanFIN[inum,j] <- mean(z[2:(length(z)-1)]) 
    sdFIN[inum,j] <- sd(z[2:(length(z)-1)]) 
    
    z05PST <-daily2annual(roll_min(zoo(hydroPST[,(j-1)],PST),5),max)
    fit <- (fevd(sort(as.vector(z05PST[2:(length(z05PST)-1)])), type = "GEV",method ="Lmoments"))
    z05T5PST[inum,j] <- as.vector(return.level(fit,c(5)))[1]
    
    z10PST <-daily2annual(roll_min(zoo(hydroPST[,(j-1)],PST),10),max) 
    fit <- (fevd(sort(as.vector(z10PST[2:(length(z10PST)-1)])), type = "GEV",method ="Lmoments"))
    z10T5PST[inum,j] <- as.vector(return.level(fit,c(5)))[1]
    
    z20PST <-daily2annual(roll_min(zoo(hydroPST[,(j-1)],PST),20),max) 
    fit <- (fevd(sort(as.vector(z20PST[2:(length(z20PST)-1)])), type = "GEV",method ="Lmoments"))
    z20T5PST[inum,j] <- as.vector(return.level(fit,c(5)))[1]
    
    z05MI <-daily2annual(roll_min(zoo(hydroMI[,(j-1)],MI),5),max) 
    fit <- (fevd(sort(as.vector(z05MI[2:(length(z05MI)-1)])), type = "GEV",method ="Lmoments"))
    z05T5MI[inum,j] <- as.vector(return.level(fit,c(5)))[1]
    
    z10MI <-daily2annual(roll_min(zoo(hydroMI[,(j-1)],MI),10),max) 
    fit <- (fevd(sort(as.vector(z10MI[2:(length(z10MI)-1)])), type = "GEV",method ="Lmoments"))
    z10T5MI[inum,j] <- as.vector(return.level(fit,c(5)))[1]
    
    z20MI <-daily2annual(roll_min(zoo(hydroMI[,(j-1)],MI),20),max) 
    fit <- (fevd(sort(as.vector(z20MI[2:(length(z20MI)-1)])), type = "GEV",method ="Lmoments"))
    z20T5MI[inum,j] <- as.vector(return.level(fit,c(5)))[1]
    
    z05FIN <-daily2annual(roll_min(zoo(hydroFIN[,(j-1)],FIN),5),max) 
    fit <- (fevd(sort(as.vector(z05FIN[2:(length(z05FIN)-1)])), type = "GEV",method ="Lmoments"))
    z05T5FIN[inum,j] <- as.vector(return.level(fit,c(5)))[1]
    
    z10FIN <-daily2annual(roll_min(zoo(hydroFIN[,(j-1)],FIN),10),max) 
    fit <- (fevd(sort(as.vector(z10FIN[2:(length(z10FIN)-1)])), type = "GEV",method ="Lmoments"))
    z10T5FIN[inum,j] <- as.vector(return.level(fit,c(5)))[1]
    
    z20FIN <-daily2annual(roll_min(zoo(hydroFIN[,(j-1)],PST),20),max) 
    fit <- (fevd(sort(as.vector(z20FIN[2:(length(z20FIN)-1)])), type = "GEV",method ="Lmoments"))
    z20T5FIN[inum,j] <- as.vector(return.level(fit,c(5)))[1]
    
    dJul <- rep(NA,length(hydroPST[,(j-1)]))
    iDate <- which(hydroPST[,(j-1)]>10 & year(zoo(hydroPST[,(j-1)],PST))>1960 & year(zoo(hydroPST[,(j-1)],PST))<2018)
    dJul <- (time(zoo(hydroPST[,(j-1)],PST))-
               as.Date(paste(year(zoo(hydroPST[,(j-1)],PST)),"-01-01",sep=""))+1)[iDate]
    start <- daily2annual(zoo(dJul,PST[iDate]),min)+91 # ajustement / d?but au 1er avril
    end <- daily2annual(zoo(dJul,PST[iDate]),max)+91 # ajustement / d?but au 1er avril
    deb10PST[inum,j] <- median(start,na.rm=T)
    fin10PST[inum,j] <- median(end,na.rm=T)
    
    dJul <- rep(NA,length(hydroMI[,(j-1)]))
    iDate <- which(hydroMI[,(j-1)]>10 & year(zoo(hydroMI[,(j-1)],MI))>1960 & year(zoo(hydroMI[,(j-1)],MI))<2013)
    dJul <- (time(zoo(hydroMI[,(j-1)],MI))-
               as.Date(paste(year(zoo(hydroMI[,(j-1)],MI)),"-01-01",sep=""))+1)[iDate]
    start <- daily2annual(zoo(dJul,MI[iDate]),min)+91 # ajustement / d?but au 1er avril
    end <- daily2annual(zoo(dJul,MI[iDate]),max)+91 # ajustement / d?but au 1er avril
    deb10MI[inum,j] <- median(start,na.rm=T)
    fin10MI[inum,j] <- median(end,na.rm=T)
    
    dJul <- rep(999,length(hydroFIN[,(j-1)]))
    iDate <- which(hydroFIN[,(j-1)]>10 & year(zoo(hydroFIN[,(j-1)],FIN))>1960 & year(zoo(hydroFIN[,(j-1)],FIN))<2013)
    dJul <- (time(zoo(hydroFIN[,(j-1)],FIN))-
               as.Date(paste(year(zoo(hydroFIN[,(j-1)],FIN)),"-01-01",sep=""))+1)[iDate]
    start <- daily2annual(zoo(dJul,FIN[iDate]),min)+91 # ajustement / d?but au 1er avril
    end <- daily2annual(zoo(dJul,FIN[iDate]),max)+91 # ajustement / d?but au 1er avril
    deb10FIN[inum,j] <- median(start,na.rm=T)
    fin10FIN[inum,j] <- median(end,na.rm=T)
  }
}

write.table(meanPST, paste0(dir.out,"statistique_revised/","PSTmeanJJASON.csv"),
            sep=";", row.name=F, quote=F)
write.table(meanMI, paste0(dir.out,"statistique_revised/","MImeanJJASON.csv"),
            sep=";", row.name=F, quote=F)
write.table(meanFIN, paste0(dir.out,"statistique_revised/","FINmeanJJASON.csv"),
            sep=";", row.name=F, quote=F)

write.table(sdPST, paste0(dir.out,"statistique_revised/","PSTsdJJASON.csv"),
            sep=";", row.name=F, quote=F)
write.table(sdMI, paste0(dir.out,"statistique_revised/","MIsdJJASON.csv"),
            sep=";", row.name=F, quote=F)
write.table(sdFIN, paste0(dir.out,"statistique_revised/","FINsdJJASON.csv"),
            sep=";", row.name=F, quote=F)

write.table(z05T5PST, paste0(dir.out,"statistique_revised/","z05T5PST.csv"),
            sep=";", row.name=F, quote=F)
write.table(z05T5MI, paste0(dir.out,"statistique_revised/","z05T5MI.csv"),
            sep=";", row.name=F, quote=F)
write.table(z05T5FIN, paste0(dir.out,"statistique_revised/","z05T5FIN.csv"),
            sep=";", row.name=F, quote=F)

write.table(z10T5PST, paste0(dir.out,"statistique_revised/","z10T5PST.csv"),
            sep=";", row.name=F, quote=F)
write.table(z10T5MI, paste0(dir.out,"statistique_revised/","z10T5MI.csv"),
            sep=";", row.name=F, quote=F)
write.table(z10T5FIN, paste0(dir.out,"statistique_revised/","z10T5FIN.csv"),
            sep=";", row.name=F, quote=F)

write.table(z20T5PST, paste0(dir.out,"statistique_revised/","z20T5PST.csv"),
            sep=";", row.name=F, quote=F)
write.table(z20T5MI, paste0(dir.out,"statistique_revised/","z20T5MI.csv"),
            sep=";", row.name=F, quote=F)
write.table(z20T5FIN, paste0(dir.out,"statistique_revised/","z20T5FIN.csv"),
            sep=";", row.name=F, quote=F)

write.table(deb10PST, paste0(dir.out,"statistique_revised/","deb10PST.csv"),
            sep=";", row.name=F, quote=F)
write.table(deb10MI, paste0(dir.out,"statistique_revised/","deb10MI.csv"),
            sep=";", row.name=F, quote=F)
write.table(deb10FIN, paste0(dir.out,"statistique_revised/","deb10FIN.csv"),
            sep=";", row.name=F, quote=F)

write.table(fin10PST, paste0(dir.out,"statistique_revised/","fin10PST.csv"),
            sep=";", row.name=F, quote=F)
write.table(fin10MI, paste0(dir.out,"statistique_revised/","fin10MI.csv"),
            sep=";", row.name=F, quote=F)
write.table(fin10FIN, paste0(dir.out,"statistique_revised/","fin10FIN.csv"),
            sep=";", row.name=F, quote=F)

write.table(rbind(apply(meanPST[,2:length(meanPST[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(meanMI[,2:length(meanMI[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(meanFIN[,2:length(meanFIN[1,])],2,function(x){mean(as.numeric(x))})),
            paste0(dir.out,"statistique_revised/","statHER_meanJJASON.csv"),
            sep=";", row.name=F, quote=F)

# moyenne des sd !!!!
write.table(rbind(apply(sdPST[,2:length(sdPST[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(sdMI[,2:length(sdMI[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(sdFIN[,2:length(sdFIN[1,])],2,function(x){mean(as.numeric(x))})),
            paste0(dir.out,"statistique_revised/","statHER_sdJJASON.csv"),
            sep=";", row.name=F, quote=F)

# sd de la moyenne
write.table(rbind(apply(meanPST[,2:length(meanPST[1,])],2,function(x){sd(as.numeric(x))}),
                  apply(meanMI[,2:length(meanMI[1,])],2,function(x){sd(as.numeric(x))}),
                  apply(meanFIN[,2:length(meanFIN[1,])],2,function(x){sd(as.numeric(x))})),
            paste0(dir.out,"statistique_revised/","statHER_sdmeanJJASON.csv"),
            sep=";", row.name=F, quote=F)



write.table(rbind(apply(z05T5PST[,2:length(z05T5PST[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(z05T5MI[,2:length(z05T5MI[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(z05T5FIN[,2:length(z05T5FIN[1,])],2,function(x){mean(as.numeric(x))})),
            paste0(dir.out,"statistique_revised/","statHER_z05T5.csv"),
            sep=";", row.name=F, quote=F)

write.table(rbind(apply(z10T5PST[,2:length(z10T5PST[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(z10T5MI[,2:length(z10T5MI[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(z10T5FIN[,2:length(z10T5FIN[1,])],2,function(x){mean(as.numeric(x))})),
            paste0(dir.out,"statistique_revised/","statHER_z10T5.csv"),
            sep=";", row.name=F, quote=F)

write.table(rbind(apply(z20T5PST[,2:length(z20T5PST[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(z20T5MI[,2:length(z20T5MI[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(z20T5FIN[,2:length(z20T5FIN[1,])],2,function(x){mean(as.numeric(x))})),
            paste0(dir.out,"statistique_revised/","statHER_z20T5.csv"),
            sep=";", row.name=F, quote=F)

write.table(rbind(apply(deb10PST[,2:length(deb10PST[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(deb10MI[,2:length(deb10MI[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(deb10FIN[,2:length(deb10FIN[1,])],2,function(x){mean(as.numeric(x))})),
            paste0(dir.out,"statistique_revised/","statHER_deb10.csv"),
            sep=";", row.name=F, quote=F)

write.table(rbind(apply(fin10PST[,2:length(fin10PST[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(fin10MI[,2:length(fin10MI[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(fin10FIN[,2:length(fin10FIN[1,])],2,function(x){mean(as.numeric(x))})),
            paste0(dir.out,"statistique_revised/","statHER_fin10.csv"),
            sep=";", row.name=F, quote=F)
