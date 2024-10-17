rm(list=ls(all=TRUE))

library(ggplot2)
library(stringr)
library(gridExtra)
library(grid)
library(dplyr)
library(scales)
library(zoo)

library(tidyverse)
library(hrbrthemes)
library(viridis)
library(plotly)

# Faire un graph des assecs continu, on va chercher les donn?es de simulations

source("C:/eric/CHANGEMENT CLIM 2019 (BOTTET)/Changement Clim/8_CC_ASSECS_OBS_SIM_OK.R") 
# Assecs : Donne les r?gressions pour les couples HER2 x RH

# Entr?e
dir.in = "C:/eric/CHANGEMENT CLIM 2019 (BOTTET)/Changement Clim/eric/"
dir.out = "C:/eric/CHANGEMENT CLIM 2019 (BOTTET)/Changement Clim/eric/"
dir.out.GCM <- c("CSIRO-Mk3-6-0_rcp26_r1","CSIRO-Mk3-6-0_rcp85_r1","GFDL-ESM2G_rcp26_r1","GFDL-ESM2G_rcp85_r1","MIROC-ESM_rcp26_r1","MIROC-ESM_rcp85_r1","bcc-csm1-1_rcp26_r1","bcc-csm1-1_rcp85_r1","GFDL-ESM2M_rcp26_r1","GFDL-ESM2M_rcp85_r1","HadGEM2-ES_rcp26_r1","HadGEM2-ES_rcp85_r1","IPSL-CM5A-LR_rcp26_r1","IPSL-CM5A-LR_rcp85_r1","MIROC5_rcp26_r1","MIROC5_rcp85_r1","MRI-CGCM3_rcp26_r1","MRI-CGCM3_rcp85_r1","CCSM4_rcp26_r1","CCSM4_rcp85_r1","IPSL-CM5A-MR_rcp26_r1","IPSL-CM5A-MR_rcp85_r1","MIROC-ESM-CHEM_rcp26_r1","MIROC-ESM-CHEM_rcp85_r1","MPI-ESM-LR_rcp26_r1","MPI-ESM-LR_rcp85_r1")

#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# S?lectionner les stations HYDRO et ADES du territoire s?lectionn? (HER2 x RH)
# Moyenner les fr?quences de non d?passement sur le territoire (caract?riser les incertitudes : ?carts ? la moyenne + nombre de donn?es)
# Appliquer la r?gression aux fr?quences de non d?passement pour obtenir la chronique continue des % d'assecs
#-------------------------------------------------------------------------------

#~hydro = read.table(paste("/home/tjaouen/Documents/Input/HYDRO/GR_Thirel_20230216/CorrespondanceHydroHer/Liste_874StationsHYDRO_HER1_2.csv",sep=""),sep=",")
#~hydro = read.table(paste("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/Changement Clim/eric/OLD/Stations_HYDRO_568.csv",sep=""),sep=";")
#hydro = read.table(paste("/home/tjaouen/Documents/Input/HYDRO/GR_Thirel_20230216/CorrespondanceHydroHer/Liste_874StationsHYDRO_HER1_2.csv",sep=""),sep=",")
hydro = read.table(paste("/home/tjaouen/Documents/Input/HYDRO/GR_Thirel_20230216/StationsSelectionnees/SelectionCsv/SelectionCsv_3_Essai568stations_2012_2018_20230224/Stations_HYDRO_KGESUp0.60_DispSup-1.csv",sep=""),sep=";")


#hydro = read.table(paste(dir.out,"Stations_HYDRO_1728.csv",sep=""),sep=";")
hydro2 = hydro[-1,c(1,5:27)]
colnames(hydro2) = c("Code","E1","E2","E3","E4","E5","E6","E7","E8","E9","E10","E11","E12","E13","E14","E15","E16","E17","E18","E19","E20","E21","ER","HER1")
hydro = hydro[-1,c(1,2,3,27)]
colnames(hydro) = c("Code","X","Y","HER1")
hydro$HER1 = as.numeric(hydro$HER1)

output = as.data.frame(setNames(replicate(1,numeric(0), simplify = F),c("Date") ))
Out = NULL

#for(inum in 1:length(dir.out.GCM)){

for(j in 1:22){
  print(paste0("HER1 : ",j))
  #  Selection_hydro = as.vector(hydro[which(hydro$HER1 == j),c("Code")])
  Selection_hydro = hydro[which(as.numeric(as.vector(hydro2[,(j+1)]))>0),c("Code")]
  Weight_hydro <- as.numeric(as.vector(hydro2[which(as.numeric(as.vector(hydro2[,(j+1)]))>0),(j+1)]))
  
  # HYDRO
  flows <- as.character(as.Date(as.Date("2012-01-01"):as.Date("2018-12-31")))
  flows = cbind((flows),rep(NA,length(flows)))
  colnames(flows) = c("Date",paste0("flow_NA"))
  
  weightFDC <- c()
  iFDC <- 0
  for(i in Selection_hydro[1:length(Selection_hydro)]){
    print(c(i,length(Selection_hydro)))
    iFDC <- iFDC+1
    
    flow = read.table(paste0("/home/tjaouen/Documents/Input/HYDRO/GR_Thirel_20230216/FrequencesNonDepassement/FDC_Sim_3_Essai568stations_2012_2018_20230224/FDC_",paste0(i,"_Sim.txt"),sep=""),sep=";",fill=T,colClasses = "character",quote = "",header=T)
    
    #~flow = read.table(paste0(dir.in,"HYDRO/FDC OBS/FDC_",paste0(i,"_Sim.txt"),sep=""),sep=";",fill=T,colClasses = "character",quote = "",header=T)
    #flow = read.table(paste0(dir.in,"HYDRO/FDC SIM/FDC_",i,"_Sim.txt"),sep=";",fill=T,colClasses = "character",quote = "",header=T)
    #flow = read.table(paste0(dir.in,"HYDRO/FDC 1728/FDC_",i,"_qj_hydro2.txt"),sep=";",fill=T,colClasses = "character",quote = "",header=T)
    #flow = read.table(paste0(dir.in,"HYDRO/FDC FUT/",dir.out.GCM[inum],"/FDC_",i,"_Sim.txt"),sep=";",fill=T,colClasses = "character",quote = "",header=T)
    if (length(flow[,1])>(365*3)) {
      weightFDC <- rbind(weightFDC,Weight_hydro[iFDC]) 
      flow = flow[,1:2]
      colnames(flow) = c("Date",paste0("flow_",i))
      flows = merge(flows,flow, by = "Date",all = T)
    }
  }
  #-------------------------------------------------------------------------------
  
  # FDC
  FDC = flows[,c(1,3:length(flows[1,]))]
  n = ncol(FDC)
  
  FDC[,2:ncol(FDC)] = mapply(FDC[,2:ncol(FDC)], FUN = as.numeric)
  
  #~dir.Nash <- "C:/eric/CHANGEMENT CLIM 2019 (BOTTET)/Changement Clim/eric/Nash/"
  
  #~write.table(FDC, paste0(dir.out,"HER",j,"_568_OBS.csv"), sep=";", row.name=F, quote=F)
  #~fileAssecs <- "_2012-2018_valid_logit_OBS_568.csv"
  #write.table(FDC, paste0(dir.out,"HER",j,"_568_SIM.csv"), sep=";", row.name=F, quote=F)
  #fileAssecs <- "_2012-2018_valid_logit_SIM_568.csv"
  #write.table(FDC, paste0(dir.out,"HER",j,"_1728_OBS.csv"), sep=";", row.name=F, quote=F)
  #fileAssecs <- "_2012-2018_valid_logit_OBS_1728.csv"
  #write.table(FDC, paste0(dir.out,dir.out.GCM[inum],"_HER",j,"_568_OBS.csv"), sep=";", row.name=F, quote=F)
  #fileAssecs <- paste0(dir.out.GCM[inum],"_2012-2018_valid_logit.csv")
  
  # Assecs <- read.table(paste(dir.Nash,fileAssecs,sep=""),sep=";",header=T)
  
  Assecs <- read.table("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/Changement Clim/eric/Nash/Matrice_SIM_2012_2018__KGESUp0.60_DispSup-1_weig_valid_logit.csv",sep=";",header=T)
  
  
  Reg = Assecs[which(Assecs$HER == j),c("Inter_logit","Slope_logit")]
  
  FDC$Mean = apply(FDC[,2:ncol(FDC)],1,function(x){weighted.mean(x[!is.na(x)],weightFDC[which(x>=0)])})
  FDC$Nb_stations = apply(FDC[,2:(ncol(FDC)-1)],1,function(x){ncol(FDC) - 2 - sum(is.na(x))})
  FDC$Ecart_type = apply(FDC[,2:(ncol(FDC)-2)],1,function(x){sd(x[!is.na(x)])})
  #-------------------------------------------------------------------------------
  
  # Transposition en % Assecs
  A = lapply(FDC[,n+1],function(x){(exp(Reg[2]*x+Reg[1])/(1+exp(Reg[2]*x+Reg[1])))*100})
  FDC$P_Assec = unlist(A)
  
  Out$Date = as.Date(FDC$Date)
  Out$P_Assec = FDC$P_Assec
  Out = as.data.frame(Out)
  #-------------------------------------------------------------------------------
  output = merge(output,Out, by = "Date",all = T)
}
colnames(output) = c("Date","H1","H2","H3","H4","H5","H6","H7","H8","H9","H10","H11","H12","H13","H14","H15","H16","H17","H18","H19","H20","H21","H22")

write.table(output, paste0(dir.out,"Assecs_FDC_OBS_568_stations_hydro_pondere.csv"), sep=";", row.name=F, quote=F)
#write.table(output, paste0(dir.out,"Assecs_FDC_SIM_568_stations_hydro_pondere.csv"), sep=";", row.name=F, quote=F)
#write.table(output, paste0(dir.out,"Assecs_FDC_OBS_1728_stations_hydro_pondere.csv"), sep=";", row.name=F, quote=F)
#write.table(output, paste0(dir.out,dir.out.GCM[inum],"/Assecs_FDC_SIM_568_stations_hydro_pondere.csv"), sep=";", row.name=F, quote=F)

#}
