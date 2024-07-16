### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

### Libraries ###
library(ncdf4) # package for netcdf manipulation
library(strex)
library(hydroTSM)

### Parameters ###
folder_input_ = folder_input_param_
folder_input_DD_ = folder_input_DD_param_
folder_input_PC_ = folder_input_PC_param_

### Fichier de reference de la liste des stations ###

# CTRIP
pattern_ = "CTRIP"
# 1   2   3   4   5   8 
# 875  35   7   4   2   2 => 875+35+7+4+2+2 = 925 fichiers

# GRSD
# pattern_ = "GRSD"
# 1   2   3   7 
# 967  11   4   1 => 967+11+4+1 = 983 fichiers

# J2000
# pattern_ = "J2000"
# 1   2   3   4   5   6   7   8   9  10  19  21 
# 374  39  15   8   8   5   2   7   1   2   1   1  => 374+39+15+8+8+5+2+7+1+2+1+1 = 463 fichiers

# ORCH
# pattern_ = "ORCHIDEE"
# 1   2   3   4 
# 954  19   4   1 => 954+19+4+1 = 978 fichiers

# SMASH
# pattern_ = "SMASH"
# 1   2   3   4 
# 968  15   2   1 => 968+15+2+1 = 986 fichiers


# Fichier points de simulation selectionnes
# fichier_SelectionPointsSimulation_ <- paste0(folder_input_,"StationsSelectionnees/SelectionCsv/SelectionCsv_26_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_20231201/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_",pattern_,"_29_20231202.csv")
fichier_SelectionPointsSimulation_ <- paste0(folder_input_PC_,"StationsSelectionnees/SelectionCsv/SelectionCsv_26_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_20231201/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_",pattern_,"_29_20231203.csv")

tab_SelectionPointsSimulation_ <- read.table(fichier_SelectionPointsSimulation_, sep = ";", dec = ".", header = T)
if (ncol(tab_SelectionPointsSimulation_) == 1){
  tab_SelectionPointsSimulation_ <- read.table(fichier_SelectionPointsSimulation_, sep = ",", dec = ".", header = T, quote = "")
}
dim(tab_SelectionPointsSimulation_) # 1008

length(which(tab_SelectionPointsSimulation_$Code10_ChoixDefinitifPointSimu %in% tab_SelectionPointsSimulation_$Code10_ChoixDefinitifPointSimu[duplicated(tab_SelectionPointsSimulation_$Code10_ChoixDefinitifPointSimu)]))
# J2000 : 738 / 364 doublons OK
# CTRIP : 1008 / 133 doublons OK
# GRSD : 1008 / 41 doublons OK
# ORCHIDEE : 1008 / 54 doublons OK
# SMASH : 1008 / 40 doublons OK

### Choix modele ###
tab_SelectionPointsSimulation_model_ = tab_SelectionPointsSimulation_

### Parameters Safran ###
List_netcdf_ = list.files(paste0(folder_input_DD_, "Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_CorrLocPointsLH_20231123_Ncdf/Safran_CorrigeLH_20231128/"),
                          full.names = T)
Txt_folder_ = paste0(folder_input_DD_, "Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_CorrLocPointsLH_20231123_FormatTxt/Safran_CorrigeLH_20231128/")
List_netcdf_ = List_netcdf_[grepl(pattern_, List_netcdf_)]


### Parameters Projections ###
# List_netcdf_ = list.files(paste0(folder_input_DD_, "Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_Ncdf/J2000_20231124"),  # J2000
#                           full.names = T, recursive = T, include.dirs = F)

# List_netcdf_ = list.files(paste0(folder_input_DD_, "Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_Ncdf/CTRIP_20231124/"), # CTRIP
#                           full.names = T)
# 
# List_netcdf_ = list.files(paste0(folder_input_DD_, "Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_Ncdf/GRSD_20231124/"), # GRSD
#                           full.names = T)
# 
# List_netcdf_ = list.files(paste0(folder_input_DD_, "Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_Ncdf/ORCHIDEE_20231124/"), # ORCHIDEE
#                           full.names = T)
# 
# List_netcdf_ = list.files(paste0(folder_input_DD_, "Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_Ncdf/SMASH_20231124/"), # SMASH
#                           full.names = T)
# Txt_folder_ = paste0(folder_input_DD_, "Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/ChroniquesBrutes_")

### Output ###
for (Netcdf_file_ in List_netcdf_){
  
  motifs_dates <- str_extract_all(str_after_last(Netcdf_file_,"/"), "\\d{8}")
  
  foldername_ = paste0(Txt_folder_,str_after_last(str_before_last(Netcdf_file_, "/"),"/"),
                       # "_",
                       # motifs_dates[[1]][1],"to",
                       # motifs_dates[[1]][2],"/",
                       strsplit(basename(Netcdf_file_), ".", fixed = TRUE)[[1]][1],"/")
  
  if (!dir.exists(str_before_last(str_before_last(foldername_,"/"),"/"))){
    dir.create(str_before_last(str_before_last(foldername_,"/"),"/"))
  }
  
  if (!dir.exists(foldername_)){
    dir.create(foldername_)
  }
  
  nc <- nc_open(Netcdf_file_)
  
  ### Extract variables ###
  netcdf_model_code <- ncvar_get(nc, "code") #length(netcdf_model_code)
  netcdf_model_codeType <- ncvar_get(nc, "code_type") #length(netcdf_model_codeType)
  netcdf_model_name <- ncvar_get(nc, "name")
  netcdf_model_topologicalSurface <- ncvar_get(nc, "topologicalSurface") #length(netcdf_CTRIP_variable_area) #535
  netcdf_model_debit <- ncvar_get(nc, "debit")
  netcdf_model_L93_X <- ncvar_get(nc, "L93_X")
  netcdf_model_L93_Y <- ncvar_get(nc, "L93_Y")
  netcdf_model_time <- as.Date(ncvar_get(nc,"time"), origin = "1950-01-01") #1976-01-01 - 2020-12-31
  
  netcdf_model_code[duplicated(netcdf_model_code)]
  # J2000 0 OK
  # GRSD "---" seulement, OK
  # ORCHIDEE  "---" seulement, OK
  
  ### Comparaison ###
  tab_SelectionPointsSimulation_model_$Code10_ChoixDefinitifPointSimu[which(tab_SelectionPointsSimulation_model_$Code10_ChoixDefinitifPointSimu %in% netcdf_model_code)]
  tab_SelectionPointsSimulation_model_$Code10_ChoixDefinitifPointSimu[which(!(tab_SelectionPointsSimulation_model_$Code10_ChoixDefinitifPointSimu %in% netcdf_model_code))]
  # J2000 OK
  # CTRIP EN COURS
  # GRSD OK
  # ORCHIDEE OK
  # SMASH OK
  
  ### Table des points de simulation selectionnes ###
  tab_debit = c()
  for (s in 1:dim(tab_SelectionPointsSimulation_model_)[1]){
    
    if (length(which(netcdf_model_code == tab_SelectionPointsSimulation_model_$Code10_ChoixDefinitifPointSimu[s])) > 1){
      stop("Erreur : Presence de doublons dans le netcdf")
    }else{
      indice_ <- which(netcdf_model_code == tab_SelectionPointsSimulation_model_$Code10_ChoixDefinitifPointSimu[s])
    }
    
    if (length(tab_debit) == 0){
      tab_debit <- netcdf_model_debit[indice_,]
    }else{
      tab_debit <- rbind(tab_debit,
                         netcdf_model_debit[indice_,])
    }
  }
  
  dim(tab_debit)
  rownames(tab_debit) <- tab_SelectionPointsSimulation_model_$Code10_ChoixDefinitifPointSimu
  colnames(tab_debit) <- as.Date(netcdf_model_time, origin = "1950-01-01")
  tab_date <- as.Date(netcdf_model_time, origin = "1950-01-01")
  tab_debit[1:5,1:5]
  which(is.na(tab_debit), arr.ind = TRUE)
  # J2000 331 Pas de donnees manquantes OK
  # GRSD 937 Pas de donnees manquantes OK
  # ORCHIDEE 874 Pas de donnees manquantes OK
  
  ### Calcul FDC par point de simulation - Base sur la periode 1976.08.01 - 2022.12.31 ###
  for (t in 1:nrow(tab_debit)){
    
    stationName_ <- rownames(tab_debit)[t]
    flow = data.frame(tab_debit[t,])
    
    if (length(which(is.na(flow))) < 1){
      
      colnames(flow) <- c("Qm3s1") # Debit en M3.S-1.
      flow$Date <- as.Date(netcdf_model_time, origin = "1950-01-01")
      
      if (length(which(is.na(flow$Qm3s1) | is.character(flow$Qm3s1) | (flow$Qm3s1 < 0))) > 0){
        stop(paste0("Error in the netcdf file on line ",t))
      }
      
      write.table(data.frame(Date = flow$Date,
                             Qm3s1 = flow$Qm3s1),
                  paste0(foldername_,
                         stationName_,".txt"),
                  sep = ";", dec = ".",
                  row.name = F,
                  quote = F)
      
    }
  }
}

