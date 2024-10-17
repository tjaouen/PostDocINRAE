rm(list=ls(all=TRUE))

library(zoo)

# Entr?e
dir.in = "C:/eric/CHANGEMENT CLIM 2019 (BOTTET)/Changement Clim/eric/"
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

statPST <- matrix(0,length(liste.GCM),23)
statMI <- matrix(0,length(liste.GCM),23)
statFIN <- matrix(0,length(liste.GCM),23)

for(inum in 1:length(liste.GCM)){
  hydro = read.table("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/Changement Clim/eric/OLD/CC/bcc-csm1-1_rcp26_r1Assecs_FDC_SIM_568_stations_hydro_pondere.csv",sep=";",header=T)
  #hydro = read.table("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/Changement Clim/eric/bcc-csm1-1_rcp26_r1Assecs_FDC_SIM_568_stations_hydro_pondere.csv",sep=";",header=T)
  #hydro = read.table(paste(dir.in,liste.GCM[inum],"Assecs_FDC_SIM_568_stations_hydro_pondere.csv",sep=""),sep=";",header=T)
  
  iPST <- c(1:21184)
  hydroPST <- hydro[iPST,]
  iMI <- c(21185:40543)
  hydroMI <- hydro[iMI,]
  iFIN <- c(40544:59902)
  hydroFIN <- hydro[iFIN,]
  PST <- (as.Date(as.Date("1960-08-01"):(as.Date("2018-07-31"))))
  MI <- (as.Date(as.Date("1960-08-01"):(as.Date("2013-07-31"))))
  FIN <- (as.Date(as.Date("1960-08-01"):(as.Date("2013-07-31"))))
  
  imPST <- as.numeric(substr(as.character(
    (as.Date(as.Date("1960-08-01"):(as.Date("2018-07-31"))))),6,7))
  imFUT <- as.numeric(substr(as.character(
    (as.Date(as.Date("1960-08-01"):(as.Date("2013-07-31"))))),6,7))
  iONDEPST <- which(imPST>4 & imPST<11)
  iONDEFUT <- which(imFUT>4 & imFUT<11)
  
  statPST[inum,1] <- liste.GCM[inum]
  statMI[inum,1] <- liste.GCM[inum]
  statFIN[inum,1] <- liste.GCM[inum]
  for(j in 2:23){
    print(paste0("HER1 : ",j))
    statPST[inum,j] <- mean(hydroPST[iONDEPST,(j-1)]) 
    statMI[inum,j] <- mean(hydroMI[iONDEFUT,(j-1)]) 
    statFIN[inum,j] <- mean(hydroFIN[iONDEFUT,(j-1)]) 
  }
  
}

write.table(statPST, paste0(dir.out,"statistique/","PSTstat.csv"),
            sep=";", row.name=F, quote=F)
write.table(statMI, paste0(dir.out,"statistique/","MIstat.csv"),
            sep=";", row.name=F, quote=F)
write.table(statFIN, paste0(dir.out,"statistique/","FINstat.csv"),
            sep=";", row.name=F, quote=F)

write.table(rbind(apply(statPST[,2:length(statPST[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(statMI[,2:length(statPST[1,])],2,function(x){mean(as.numeric(x))}),
                  apply(statFIN[,2:length(statPST[1,])],2,function(x){mean(as.numeric(x))})),
            paste0(dir.out,"statistique/","statHER.csv"),
            sep=";", row.name=F, quote=F)
