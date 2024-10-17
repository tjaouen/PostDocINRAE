rm(list=ls())
library(stringr)
library(ggplot2)

#-------------------------------------------------------------------------------
# Changement climatique
# S?lection des stations HYDRO
# Bottet Quentin - Irstea - 06/09/2019 - Version 1
#-------------------------------------------------------------------------------

#Entr?e
dir.in = "C:/GRAssec/"
dir.out = "C:/eric/CHANGEMENT CLIM 2019 (BOTTET)/Changement Clim/eric/"

#-------------------------------------------------------------------------------

# bassin versant de plus de 90% en France + KGE sur racine de d?bit > 0.60
# sur la p?riode 1958-2018 + donn?es observ?es disponibles sur 2012-2018

Stations = read.csv2(paste0("C:/eric/CHANGEMENT CLIM 2019 (BOTTET)/Changement Clim/ClasseurHER_874Station_2.csv"),sep=",")
KGE_sqrt <- c()

# S?lection

# KGE sur racine de d?bit > 0.60 sur la p?riode 1958-2018
setwd(paste0("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/Changement Clim/Autre/HYDRO/Donnees/"))
for(i in 1:length(list.files(pattern = "\\.txt$"))){
  print(i)
  Station = read.table(paste0(list.files(pattern = "\\.txt$")[i]),header = T)
  Stations[which(Stations$Code == str_sub(list.files(pattern = "\\.txt$")[i],1,-9)),c("ObsPost2012")] = sum(ifelse(!is.na(Station[which(as.Date(Station$date)>=as.Date("2012-05-01")),c("Qobs")]),1,0))
  Station = Station[which(!(is.na(Station$Qsim)|is.na(Station$Qobs))),]
  Station = Station[which(as.Date(Station$date) >= as.Date("1958-01-01")),]
  Station = Station[which(as.Date(Station$date) < as.Date("2019-01-01")),]
  Station$Qobs = sqrt(Station$Qobs)
  Station$Qsim = sqrt(Station$Qsim)
  r = cor(Station$Qobs,Station$Qsim)
  beta = mean(Station$Qsim)/mean(Station$Qobs)
  alpha = mean(Station$Qobs)/mean(Station$Qsim)*sd(Station$Qsim)/sd(Station$Qobs)
  KGE_sqrt <- cbind(KGE_sqrt,1-sqrt((1-r)**2+(1-beta)**2+(1-alpha)**2))
  Stations[which(Stations$Code == str_sub(list.files(pattern = "\\.txt$")[i],1,-9)),c("KGE_Sim")] = 1 - sqrt((1-r)**2+(1-alpha)**2+(1-beta)**2)
}

Hypso <- read.table(file=paste("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/GR_Thirel/listeGR.txt", sep=""),fill=TRUE, 
                    stringsAsFactors = FALSE, skip=1)
surface <- rep(0,length(Stations[,1]))

for(i in 1:length(Stations[,1])){
  iStation <- which(Hypso[,1] == as.character(Stations$Code[i]))
  if (length(iStation>0)) {
    #surface[i] <- Hypso[iStation,6]
    surface[i] <- Hypso[iStation,4]
  }
}

# Stations$A est la fraction hors France
# stations < 2000 km2 sinon influenc?es
for(iDisp in c(-1,1,3,5)){
  for(seuilKGE in (1:9)/10){
    Selection = Stations[which(Stations$A<1/3 # Retirer les stations au 2/3 hors de France
                               & Stations$ObsPost2012 > 365*iDisp
                               & surface< 2000
                               & Stations$KGE_Sim > seuilKGE),] # KGE sur racine de d?bit > 0.60 sur la p?riode 1958-2018
    
    #setwd(paste0(dir.in,"Simul1958-2018_OUDIN_CAL_Cemaneige_WX/"))
    #file.copy(list.files(pattern = "\\.txt$")[which(str_sub(list.files(pattern = "\\.txt$"),1,-9) %in% Selection$Code)],paste(dir.out,"HYDRO/Donnees/",sep=""))
    
    write.table(Selection,paste("/home/tjaouen/Documents/Output/ChangementClimatique2019/Test/Stations_HYDRO_KGESUp",seuilKGE,"0_DispSup",iDisp,".csv",sep=""),sep=";",quote=FALSE,row.names=FALSE,col.names=TRUE)
  }
}

setwd(dir.out)
liste <- list.files(pattern="Stations_HYDRO_KGESUp")

synthes <- c()

for (il in (liste)) {
  compt_loc <- rep(0,22)
  compt_weight <- rep(0,25)
  hydro = read.table(paste(dir.out,"/",il,sep=""),sep=";",header=T)
  for (i in 1:22){
    compt_loc[i] <- length(which(hydro[,27]==i))
    compt_weight[i] <- length(which(hydro[,4+i]>0))
  }
  compt_weight[23] <- sum(compt_weight[1:22])
  compt_weight[24] <- median(hydro[,29])
  compt_weight[25] <- min(hydro[,29])
  
  synthes <- rbind(synthes,t(c(il,compt_loc,compt_weight)))  
}

liste <- list.files(pattern="Stations_HYDRO_1270.csv")

for (il in (liste)) {
  compt_loc <- rep(0,22)
  compt_weight <- rep(0,25)
  hydro = read.table(paste(dir.out,"/",il,sep=""),sep=";",header=T)
  for (i in 1:22){
    compt_loc[i] <- length(which(hydro[,27]==i))
    compt_weight[i] <- length(which(hydro[,4+i]>0))
  }
  compt_weight[23] <- sum(compt_weight[1:22])
  
  synthes <- rbind(synthes,t(c(il,compt_loc,compt_weight)))  
}

write.table(synthes,paste(dir.out,"/synthese.csv",sep=""),sep=";",quote=FALSE,row.names=FALSE,col.names=TRUE)
