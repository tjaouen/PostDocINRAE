#-------------------------------------------------------------------------------
# Bottet Quentin - Irstea - 14/06/2019 - Version 1
# Etablir une table des assecs | HER | RH | Date | % observes | % simules | 
#-------------------------------------------------------------------------------

### Libraries ###

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

### Libraries ###
library(ncdf4) # package for netcdf manipulation
library(hydroTSM)
library(strex)

### Folder ###
folder_input_ = folder_input_param_
folder_input_DebitsObsReanalyseSafran_ <- paste0(folder_input_param_, "Debits/DebitsObservesReanalyseSafran/DebitsComplets_DebitsParModelesHydro/")
presFut_ = presFut_param_
obsSim_ = obsSim_param_
nom_FDCfolder_ = nom_FDCfolder_param_

### Fichier de reference de la liste des stations ###
fichier_SelectionPointsSimulation_ <- paste0(folder_input_,"StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/Stations_HYDRO_AvecCorrespondanceShp_VersionCorresDistanceBruteExp2_8_20230803.csv")
tab_SelectionPointsSimulation_ <- read.table(fichier_SelectionPointsSimulation_, sep = ";", dec = ".", header = T)
tab_SelectionPointsSimulation_$Code10_ChoixDefinitifPointSimu

tab_SelectionPointsSimulation_J2000_ = tab_SelectionPointsSimulation_[which(tab_SelectionPointsSimulation_$J2000_ChoixDefinitifPointSimu == 1),]
dim(tab_SelectionPointsSimulation_J2000_) #343

### CNRM-CM5_historical - rcp26_r1i1p1_CNRM - ALADIN63_v2 _ ADAMONT - J2000 - 2006/01/01-2100/12/31 ###
filename_ = "debit_Rhone-Loire_SAFRAN-France-2022_INRAE-J2000_day_19760801-20221231.nc"
foldername_ = strsplit(filename_, ".", fixed = TRUE)[[1]][1]
netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_ = paste0(folder_input_DebitsObsReanalyseSafran_,filename_)
nc <- nc_open(netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_)


### Extract variables ###
netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_code <- ncvar_get(nc, "code") #length(netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_code)
netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_codeType <- ncvar_get(nc, "code_type") #length(netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_codeType)
netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_topologicalSurface <- ncvar_get(nc, "topologicalSurface") #length(netcdf_CTRIP_variable_area) #535
netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_debit <- ncvar_get(nc, "debit")
netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_L93_X_model <- ncvar_get(nc, "L93_X_model")
netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_L93_Y_model <- ncvar_get(nc, "L93_Y_model")
netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_L93_X <- ncvar_get(nc, "L93_X")
netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_L93_Y <- ncvar_get(nc, "L93_Y")
netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_time <- as.Date(ncvar_get(nc,"time"), origin = "1950-01-01") #1976-08-01 - 2022-12-31

tab_SelectionPointsSimulation_J2000_$Code10_ChoixDefinitifPointSimu %in% netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_code
tab_SelectionPointsSimulation_J2000_[which(!(tab_SelectionPointsSimulation_J2000_$Code10_ChoixDefinitifPointSimu %in% netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_code)),]

### Tailles ###
dim(tab_SelectionPointsSimulation_J2000_) #343
length(netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_code) #1291
length(tab_SelectionPointsSimulation_J2000_$Code10_ChoixDefinitifPointSimu) #343
dim(netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_debit[which(netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_code %in% tab_SelectionPointsSimulation_J2000_$Code10_ChoixDefinitifPointSimu),])

table(tab_SelectionPointsSimulation_J2000_$Code10_ChoixDefinitifPointSimu %in% netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_code)
table(netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_code %in% tab_SelectionPointsSimulation_J2000_$Code10_ChoixDefinitifPointSimu)
#343-317 = 26 doublons qu'on ne prend pas avec cette methode

### Table des points de simulation selectionnes ###
tab_debit = c()
for (s in 1:dim(tab_SelectionPointsSimulation_J2000_)[1]){
  
  if (length(tab_debit) == 0){
    tab_debit <- netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_debit[which(netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_code == tab_SelectionPointsSimulation_J2000_$Code10_ChoixDefinitifPointSimu[s]),]
  }else{
    tab_debit <- rbind(tab_debit,netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_debit[which(netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_code == tab_SelectionPointsSimulation_J2000_$Code10_ChoixDefinitifPointSimu[s]),])
  }
}
rownames(tab_debit) <- tab_SelectionPointsSimulation_J2000_$Code10_ChoixDefinitifPointSimu
colnames(tab_debit) <- as.character(as.Date(netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_time, origin = "1950-01-01"))
tab_date <- as.Date(netcdf_CNRM_CM5_rcp26_r1i1p1_ALADIN63v2_ADAMONT_J2000_time, origin = "1950-01-01")
tab_debit[1:5,1:5]
which(is.na(tab_debit), arr.ind = TRUE) # Pas de donnees manquantes


### Ouverture des fichiers de debits projetes ###
# nom_GCM_ = "debit_Rhone-Loire_ICHEC-EC-EARTH_historical-rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v1_ADAMONT-France_INRAE-J2000_day_20060101-21001231"
# nom_GCM_ = "debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_historical-rcp85_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_20060101-21001231"
# nom_GCM_ = "debit_Rhone-Loire_MOHC-HadGEM2-ES_historical-rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_ADAMONT-France_INRAE-J2000_day_20060101-20991231"
nom_GCM_ = "debit_Rhone-Loire_MOHC-HadGEM2-ES_historical-rcp85_r1i1p1_CNRM-ALADIN63_v1_ADAMONT-France_INRAE-J2000_day_20060101-20991231"

list_debitsProjetes_ <- list.files(paste0(folder_input_,"/Debits/DebitsProjections/NetcdfMerged_FormatTxt/",nom_GCM_), pattern = ".txt|.Rdata", full.names = T)

for (f in list_debitsProjetes_){
  df_safran_ <- data.frame(Date = colnames(tab_debit), Qm3s1 = tab_debit[which(rownames(tab_debit) == str_before_first(basename(f),".txt"))[1],]) # Garder le [1] en cas de doublon, sinon cree une grande matrice
  df_safran_ <- df_safran_[which(df_safran_$Date < "2023-01-01"),] # Garde les donnees de debit Safran jusqu'a 2022 -> A CONTROLER SI OK
  
  print(paste0("Date max trouvee sur Safran : ", max(df_safran_$Date)))
  
  df_proj_ <- read.table(f, sep = ";", dec = ".", header = T)
  df_proj_ <- df_proj_[which(df_proj_$Date > max(df_safran_$Date)),] # Utilise les donnees projetees ensuite, a partir de la date max trouvee
  
  
  df_merge_ <- rbind(df_safran_, df_proj_)
  write.table(df_merge_, paste0(folder_input_,"/Debits/DebitsObservesReanalyseSafranJusqua2022_ProjectionsEnsuite/DebitsComplets_DebitsParModelesHydro_NetcdfMerged/",nom_GCM_,"/",basename(f)), sep = ";", dec = ".", row.names = F, quote = F)
}





