#-------------------------------------------------------------------------------
# Bottet Quentin - Irstea - 14/06/2019 - Version 1
# Etablir une table des assecs | HER | RH | Date | % observes | % simules | 
#-------------------------------------------------------------------------------

### Libraries ###
library(strex)
library(rgdal)

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/3_RunsTristan_20230407/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
#source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/3_RunsTristan_20230407/2_Run/7_Func_Relation_AvecCC_3_20230412.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/3_RunsTristan_20230407/2_Run/7_Func_Relation_AvecCC_4_20230414.R")

### Study data ###
folder_input_ = folder_input_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nom_GCM_ = nom_GCM_param_
nom_selectStations_ = nom_selectStations_param_
HER_ = c(56)
HER_variable_ = "HER2"

obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
annees_learn_ = c(2012:2018)
#annees_learn_ = c(2012:2022)

nomSim_ = "5_PresentMesures_HERh_TsKGE_CorrectionPonderations_2012_2022_20230413"
nom_selectStations_ = "5_PresentMesures_HERh_TsKGE_CorrectionPonderations_2012_2022_20230413"

### Run ###
liste <- c(list.files(paste0(folder_output_,"1_MatricesInputModeles_ParHERDates/",nomSim_), pattern="MatInputModel", full.names = T))
NSE <- c()
colNSE <- c()

for (il in liste) {
  
  #liste = read.table(paste0(dir.in,"Classif_Assec_ONDE_HYDRO_PIEZO_HER2_group_new_RH_2019.csv"), header = T, sep = ";", row.names = NULL, quote="")
  onde = read.table(il, header = T, sep = ";", row.names = NULL, quote="")
  if (dim(onde)[1] == 1){
    onde = read.table(il, header = T, sep = ",", row.names = NULL, quote="")
  }
  onde = onde[which((!is.na(onde[,c("Freq_j")])) & !is.na(onde[,c("Freq_j.5.1")])),]
  liste_Her=sort(unique(onde[,1]))
  
  ### Calcul des diff?rents crit?res de NASH (Sortie : NASH en validation)
  # Sortie : | HER | RH | Date | %NoF_obs | %NoF_sim |
  regr = "logit"
  Assecs = FUNC_CAL_VAL(1,onde,liste_Her,regr)
  write.table(round(Assecs,3), paste0(folder_output_,"2_ResultatsModeles_ParHer/",nomSim_,"/ModelResults_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_logit_kge.csv"), sep=";", row.name=F, quote=F) #Pourquoi s'appelle validation ?
  vecTemp <- rep(NA,length(HER_))
  for(i in HER_){
    if(length(which(Assecs[,1]==i))>0) {
      vecTemp[i] <- round(Assecs[which(Assecs[,1]==i),4],3) }
  }
  NSE <- cbind(NSE, c(vecTemp,
                      paste0(str_before_nth(str_after_nth(basename(il), "\\_", 2), "\\_", 1),"-",str_before_nth(str_after_nth(basename(il), "\\_", 3), "\\_", 1)),
                      str_before_nth(str_after_nth(basename(il), "\\_", 4), "\\_", 1),
                      str_before_nth(str_after_nth(basename(il), "\\_", 5), "\\_", 1),
                      str_before_nth(str_after_nth(basename(il), "\\_", 6), "\\_", 1),
                      str_before_last(str_after_nth(basename(il), "\\_", 8),"\\."),
                      "LR"))
  colNSE <- c(colNSE,
              paste0(str_before_nth(str_after_nth(basename(il), "\\_", 4), "\\_", 1),
                     str_before_nth(str_after_nth(basename(il), "\\_", 5), "\\_", 1),
                     str_before_nth(str_after_nth(basename(il), "\\_", 6), "\\_", 1),
                     str_before_last(str_after_nth(basename(il), "\\_", 8),"\\.")))
  
  # NSE <- cbind(NSE, c(vecTemp,substr(il,9,11),substr(il,24,33),substr(il,60,60),"LR"))
  # colNSE <- c(colNSE,paste0(substr(il,9,11),substr(il,23,43),substr(il,59,63),"_logit"))
  
  regr = "log"
  Assecs = FUNC_CAL_VAL(1,onde,liste_Her,regr)
  write.table(round(Assecs,3),paste0(folder_output_,"2_ResultatsModeles_ParHer/",nomSim_,"/ModelResults_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_log_kge.csv"),sep=";", row.name=F, quote=F)
  vecTemp <- rep(NA,length(HER_))
  for(i in HER_){
    if(length(which(Assecs[,1]==i))>0) {
      vecTemp[i] <- round(Assecs[which(Assecs[,1]==i),7],3) }
  }
  NSE <- cbind(NSE, c(vecTemp,
                      paste0(str_before_nth(str_after_nth(basename(il), "\\_", 2), "\\_", 1),"-",str_before_nth(str_after_nth(basename(il), "\\_", 3), "\\_", 1)),
                      str_before_nth(str_after_nth(basename(il), "\\_", 4), "\\_", 1),
                      str_before_nth(str_after_nth(basename(il), "\\_", 5), "\\_", 1),
                      str_before_nth(str_after_nth(basename(il), "\\_", 6), "\\_", 1),
                      str_before_last(str_after_nth(basename(il), "\\_", 8),"\\."),
                      "TLLR"))
  colNSE <- c(colNSE,
              paste0(str_before_nth(str_after_nth(basename(il), "\\_", 4), "\\_", 1),
                     str_before_nth(str_after_nth(basename(il), "\\_", 5), "\\_", 1),
                     str_before_nth(str_after_nth(basename(il), "\\_", 6), "\\_", 1),
                     str_before_last(str_after_nth(basename(il), "\\_", 8),"\\.")))
  
  # NSE <- cbind(NSE, c(vecTemp,substr(il,9,11),substr(il,24,33),substr(il,60,60),"TLLR"))
  # colNSE <- c(colNSE,paste0(substr(il,9,11),substr(il,23,43),substr(il,59,63),"_log"))
  
  #-------------------------------------------------------------------------------
}
colnames(NSE) <- colNSE
write.table(NSE,paste0(folder_output_,"2_ResultatsModeles_ParHer/",nomSim_,"/KGE_HER_logit_log_kge.csv"),sep=";", row.name=F, quote=F)


# 
# 
# 
# #liste = read.table(paste0(dir.in,"Classif_Assec_ONDE_HYDRO_PIEZO_HER2_group_new_RH_2019.csv"), header = T, sep = ";", row.names = NULL, quote="")
# 
# print("QUEL FICHIER POUR FAIRE FONCTIONNER CE BOUT DE CODE ?")
# # onde = read.table(paste0(outputDir_matricesHERdates_,"Thirel_Sim_20230220/","Matrice_sim_2012_2018_XXX_stations_Hydro_WEIGHT.csv"), header = T, sep = ";", row.names = NULL, quote="")
# # onde = onde[which((!is.na(onde[,c("Freq_j")])) & !is.na(onde[,c("Freq_j.5.1")])),]
# # liste_Her=sort(unique(onde[,1]))
# 
# ### Calcul des differents crit?res de NASH (Sortie : NASH en validation)
# #-------------------------------------------------------------------------------
# 
# # Sortie : | HER | RH | Date | %NoF_obs | %NoF_sim |
# regr = "logit"
# Assecs = FUNC_CAL_VAL(1,onde,liste_Her,regr)
# write.table(round(Assecs,3),paste0(outputDir_modelesAssec_,"Thirel_Sim_20230220/","_2012-2018_valid_logit_SIM_XXX_kge.csv"),sep=";", row.name=F, quote=F)
# #-------------------------------------------------------------------------------
# 
# #liste = read.table(paste0(dir.in,"Classif_Assec_ONDE_HYDRO_PIEZO_HER2_group_new_RH_2019.csv"), header = T, sep = ";", row.names = NULL, quote="")
# onde = read.table(paste0(outputDir_matricesHERdates_,"Thirel_Sim_20230220/","Matrice_OBS_2012_2018_1270_stations_Hydro_loc.csv"), header = T, sep = ";", row.names = NULL, quote="")
# onde = onde[which((!is.na(onde[,c("Freq_j")])) & !is.na(onde[,c("Freq_j.5.1")])),]
# liste_Her=sort(unique(onde[,1]))
# 
# ### Calcul des diff?rents crit?res de NASH (Sortie : NASH en validation)
# #-------------------------------------------------------------------------------
# 
# # Sortie : | HER | RH | Date | %NoF_obs | %NoF_sim |
# regr = "logit"
# Assecs = FUNC_CAL_VAL(1,onde,liste_Her,regr)
# write.table(round(Assecs,3),paste0(outputDir_modelesAssec_,"Thirel_Sim_20230220/","_2012-2018_valid_logit_OBS_1270_loc_kge.csv"),sep=";", row.name=F, quote=F)
# 
# regr = "log"
# Assecs = FUNC_CAL_VAL(1,onde,liste_Her,regr)
# write.table(round(Assecs,3),paste0(outputDir_modelesAssec_,"Thirel_Sim_20230220/","_2012-2018_valid_log_OBS_1270_loc_kge.csv"),sep=";", row.name=F, quote=F)
# 
# #-------------------------------------------------------------------------------
# 
# #liste = read.table(paste0(dir.in,"Classif_Assec_ONDE_HYDRO_PIEZO_HER2_group_new_RH_2019.csv"), header = T, sep = ";", row.names = NULL, quote="")
# onde = read.table(paste0(outputDir_matricesHERdates_,"Thirel_Sim_20230220/","Matrice_OBS_2012_2018_1270_stations_Hydro_weight.csv"), header = T, sep = ";", row.names = NULL, quote="")
# onde = onde[which((!is.na(onde[,c("Freq_j")])) & !is.na(onde[,c("Freq_j.5.1")])),]
# liste_Her=sort(unique(onde[,1]))
# 
# ### Calcul des diff?rents crit?res de NASH (Sortie : NASH en validation)
# #-------------------------------------------------------------------------------
# 
# # Sortie : | HER | RH | Date | %NoF_obs | %NoF_sim |
# regr = "logit"
# Assecs = FUNC_CAL_VAL(1,onde,liste_Her,regr)
# write.table(round(Assecs,3),paste0(outputDir_modelesAssec_,"Thirel_Sim_20230220/","_2012-2018_valid_logit_OBS_1270_weight_kge.csv"),sep=";", row.name=F, quote=F)
# 
# regr = "log"
# Assecs = FUNC_CAL_VAL(1,onde,liste_Her,regr)
# write.table(round(Assecs,3),paste0(outputDir_modelesAssec_,"Thirel_Sim_20230220/","_2012-2018_valid_log_OBS_1270_weight_kge.csv"),sep=";", row.name=F, quote=F)
# 
# #-------------------------------------------------------------------------------
# 
# 
# dir.in = "C:/eric/CHANGEMENT CLIM 2019 (BOTTET)/Changement Clim/eric/"
# dir.in.GCM <- c("CSIRO-Mk3-6-0_rcp26_r1","CSIRO-Mk3-6-0_rcp85_r1","GFDL-ESM2G_rcp26_r1",
#                 "GFDL-ESM2G_rcp85_r1","MIROC-ESM_rcp26_r1","MIROC-ESM_rcp85_r1",
#                 "bcc-csm1-1_rcp26_r1","bcc-csm1-1_rcp85_r1","GFDL-ESM2M_rcp26_r1",
#                 "GFDL-ESM2M_rcp85_r1","HadGEM2-ES_rcp26_r1","HadGEM2-ES_rcp85_r1",
#                 "IPSL-CM5A-LR_rcp26_r1","IPSL-CM5A-LR_rcp85_r1","MIROC5_rcp26_r1",
#                 "MIROC5_rcp85_r1","MRI-CGCM3_rcp26_r1","MRI-CGCM3_rcp85_r1",
#                 "CCSM4_rcp26_r1","CCSM4_rcp85_r1","IPSL-CM5A-MR_rcp26_r1",
#                 "IPSL-CM5A-MR_rcp85_r1","MIROC-ESM-CHEM_rcp26_r1","MIROC-ESM-CHEM_rcp85_r1",
#                 "MPI-ESM-LR_rcp26_r1","MPI-ESM-LR_rcp85_r1")
# 
# for (inum in 1:length(dir.in.GCM)){
#   
#   onde = read.table(paste0(dir.in,dir.in.GCM[inum],"_Matrice_KGESUp0.60_DispSup-1.csv"), header = T, sep = ";", row.names = NULL, quote="")
#   onde = onde[which((!is.na(onde[,c("Freq_j")])) & !is.na(onde[,c("Freq_j.5.1")])),]
#   liste_Her=sort(unique(onde[,1]))
#   
#   ### Calcul des diff?rents crit?res de NASH (Sortie : NASH en validation)
#   #-------------------------------------------------------------------------------
#   
#   # Sortie : | HER | RH | Date | %NoF_obs | %NoF_sim |
#   regr = "logit"
#   Assecs = FUNC_CAL_VAL(1,onde,liste_Her,regr)
#   write.table(round(Assecs,3),paste0(outputDir_modelesAssec_,"Thirel_Sim_20230220/",dir.in.GCM[inum],"_Matrice_KGESUp0.60_DispSup-1_logit_kge.csv"),sep=";", row.name=F, quote=F)
#   #-------------------------------------------------------------------------------
#   
# }
# 
# 
# ### Pour n'utiliser qu'un seul fichier ###
# # selection finale cf. finaldataset
# 
# #il <- "Matrice_SIM_2012_2018__KGESUp0.60_DispSup-1_stations_Hydro_weight.csv"
# il <- "Matrice_SIM_2012_2018_KGESUp0.20_DispSup-1_stations_Hydro_weight.csv"
# onde = read.table(paste0(outputDir_matricesHERdates_,"Thirel_Sim_20230220/",il), header = T, sep = ";", row.names = NULL, quote="")
# onde = onde[which((!is.na(onde[,c("Freq_j")])) & !is.na(onde[,c("Freq_j.5.1")])),]
# liste_Her=sort(unique(onde[,1]))
# 
# ### Calcul des diff?rents crit?res de NASH (Sortie : NASH en validation)
# #-------------------------------------------------------------------------------
# 
# # Sortie : | HER | RH | Date | %NoF_obs | %NoF_sim |
# regr = "logit"
# Assecs = FUNC_CAL_VAL(1,onde,liste_Her,regr)
# write.table(round(Assecs,3),paste0(outputDir_modelesAssec_,"Thirel_Sim_20230220/",str_replace(basename(il),".csv",""),"_valid_logit_kge.csv"),sep=";", row.name=F, quote=F)
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# string <- "ab..cd..de..fg..h"
# str_before_nth(str_after_nth(string, "\\.\\.", 2), "\\.\\.", 1)
# str_before_nth(string, "e", 1)
# str_before_nth(string, "\\.", -3)
# str_before_nth(string, ".", -3)
# str_before_nth(rep(string, 2), fixed("."), -3)
# 









