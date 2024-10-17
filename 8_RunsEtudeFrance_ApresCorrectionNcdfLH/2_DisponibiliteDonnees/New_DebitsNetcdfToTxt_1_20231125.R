### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

### Libraries ###
library(ncdf4) # package for netcdf manipulation
library(strex)
library(hydroTSM)

### Fichier de reference de la liste des stations ###
fichier_SelectionPointsSimulation_ <- paste0(folder_input_,"StationsSelectionnees/SelectionCsv/SelectionCsv_24_ObservesReanalyseSafran_CorrectionNetcdfLH_20231125/Stations_HYDRO_AvecCorrespondanceShp_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_13_20231126.csv")
tab_SelectionPointsSimulation_ <- read.table(fichier_SelectionPointsSimulation_, sep = ";", dec = ".", header = T)
if (ncol(tab_SelectionPointsSimulation_) == 1){
  tab_SelectionPointsSimulation_ <- read.table(fichier_SelectionPointsSimulation_, sep = ",", dec = ".", header = T, quote = "")
}
dim(tab_SelectionPointsSimulation_) # 1008

tab_SelectionPointsSimulation_CTRIP_ = tab_SelectionPointsSimulation_[which(tab_SelectionPointsSimulation_$CTRIP_ChoixDefinitifPointSimu == 1),]
tab_SelectionPointsSimulation_GRSD_ = tab_SelectionPointsSimulation_[which(tab_SelectionPointsSimulation_$GRSD_ChoixDefinitifPointSimu == 1),]
tab_SelectionPointsSimulation_J2000_ = tab_SelectionPointsSimulation_[which(tab_SelectionPointsSimulation_$J2000_ChoixDefinitifPointSimu == 1),]
tab_SelectionPointsSimulation_ORCHIDEE_ = tab_SelectionPointsSimulation_[which(tab_SelectionPointsSimulation_$ORCHID_ChoixDefinitifPointSimu == 1),]
tab_SelectionPointsSimulation_SMASH_ = tab_SelectionPointsSimulation_[which(tab_SelectionPointsSimulation_$SMASH_ChoixDefinitifPointSimu == 1),]
dim(tab_SelectionPointsSimulation_J2000_)
dim(tab_SelectionPointsSimulation_CTRIP_)
dim(tab_SelectionPointsSimulation_GRSD_)
dim(tab_SelectionPointsSimulation_ORCHIDEE_)
dim(tab_SelectionPointsSimulation_SMASH_)
tab_SelectionPointsSimulation_J2000_$Code10[duplicated(tab_SelectionPointsSimulation_J2000_$Code10)]
tab_SelectionPointsSimulation_CTRIP_$Code10[duplicated(tab_SelectionPointsSimulation_CTRIP_$Code10)]
tab_SelectionPointsSimulation_GRSD_$Code10[duplicated(tab_SelectionPointsSimulation_GRSD_$Code10)]
tab_SelectionPointsSimulation_ORCHIDEE_$Code10[duplicated(tab_SelectionPointsSimulation_ORCHIDEE_$Code10)]
tab_SelectionPointsSimulation_SMASH_$Code10[duplicated(tab_SelectionPointsSimulation_SMASH_$Code10)]
# J2000 : 331
# CTRIP : 779
# GRSD : 937
# ORCHIDEE : 874
# SMASH : 965

#J2000 2023.10.03 : 330 OK, 2023.09 : 343
#SIM2 2023.10.05 : 190 OK, 2023.09 : 200
#ORCHIDEE 2023.10.05 : 874 OK
#GRSD 2023.10.10 : 966 OK

# tab_SelectionPointsSimulation_model_ = tab_SelectionPointsSimulation_J2000_
# tab_SelectionPointsSimulation_model_ = tab_SelectionPointsSimulation_CTRIP_
# tab_SelectionPointsSimulation_model_ = tab_SelectionPointsSimulation_GRSD_
tab_SelectionPointsSimulation_model_ = tab_SelectionPointsSimulation_ORCHIDEE_
# tab_SelectionPointsSimulation_model_ = tab_SelectionPointsSimulation_SMASH_

### Parameters ###
folder_input_ = folder_input_param_
Safran_netcdf_ = list.files(paste0(folder_input_, "Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_DebitsParModelesHydro_Ncdf"),
                            full.names = T)
# Safran_netcdf_file_ = Safran_netcdf_[grepl("J2000", Safran_netcdf_)] # J2000
# Safran_netcdf_file_ = Safran_netcdf_[grepl("CTRIP", Safran_netcdf_)] # CTRIP
# Safran_netcdf_file_ = Safran_netcdf_[grepl("GRSD", Safran_netcdf_)] # GRSD
Safran_netcdf_file_ = Safran_netcdf_[grepl("ORCHIDEE", Safran_netcdf_)] # ORCHIDEE
# Safran_netcdf_file_ = Safran_netcdf_[grepl("SMASH", Safran_netcdf_)] # SMASH
Safran_txt_ = paste0(folder_input_, "Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_DebitsParModelesHydro_FormatTxt/")
foldername_ = paste0(Safran_txt_,strsplit(basename(Safran_netcdf_file_), ".", fixed = TRUE)[[1]][1],"/")

if (!dir.exists(foldername_)){
  dir.create(foldername_)
}

nc <- nc_open(Safran_netcdf_file_)

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
# for (t in 1:1){
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
                paste0(folder_input_,
                       "Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_DebitsParModelesHydro_FormatTxt/",
                       strsplit(basename(Safran_netcdf_file_), ".", fixed = TRUE)[[1]][1],"/",
                       stationName_,".txt"),
                sep = ";", dec = ".",
                row.name = F,
                quote = F)
    
    # fdcurve <- fdc(as.numeric((flow[, "Qm3s1"])),plot=F,lQ.thr=0.95,hQ.thr=0.2,ylab="Q [m3/s]")
    
    # Creation d'un matrice avec date/debit/debit spe/% de depassement du debit -> Correction ? Creation d'un matrice avec date/frequence de non depassement/debit
    # debExtract = as.data.frame(cbind(Date = format(as.Date(flow[, "Date"]),"%Y%m%d"), FreqNonDep = 1-fdcurve, Debit_l_s = flow[, "Qm3s1"]))
    
    # write.table(debExtract,
    #             paste0(folder_input_,
    #                    "FlowDurationCurves/",
    #                    presFut_,"/",
    #                    ifelse(obsSim_=="","",paste0("FDC_",obsSim_)),"/",
    #                    "DebitsComplets_DebitsParModelesHydro_FichierComplet/",
    #                    foldername_,
    #                    "/FDC_",stationName_,".txt"), sep=";", row.name=F, quote=F)
  }
}


### Calcul FDC par point de simulation - Base sur la periode 2012.01.01 - 2022.12.31 ###
# for (t in 1:1){
# for (t in 1:nrow(tab_debit)){
#   
#   stationName_ <- rownames(tab_debit)[t]
#   flow = data.frame(tab_debit[t,])
#   
#   if (length(which(is.na(flow))) < 100){
#     
#     colnames(flow) <- c("Qm3s1")
#     flow$Date <- as.Date(netcdf_model_time, origin = "1950-01-01")
#     
#     # Selection de la date
#     # flow <- flow[which((as.Date(flow$Date, format = "%Y-%m-%d") >= as.Date("2012-01-01", format = "%Y-%m-%d")) & (as.Date(flow$Date, format = "%Y-%m-%d") <= as.Date("2022-12-31", format = "%Y-%m-%d"))),]
#     flow <- flow[which((as.Date(flow$Date, format = "%Y-%m-%d") >= as.Date(FDC_dateBorneMin_, format = "%Y-%m-%d")) & (as.Date(flow$Date, format = "%Y-%m-%d") <= as.Date(FDC_dateBorneMax_, format = "%Y-%m-%d"))),]
#     dim(flow)
#     
#     if (length(which(is.na(flow$Qm3s1) | is.character(flow$Qm3s1) | (flow$Qm3s1 < 0))) > 0){
#       stop(paste0("Error in the netcdf file on line ",t))
#     }
#     
#     fdcurve <- fdc(as.numeric((flow[, "Qm3s1"])),plot=F,lQ.thr=0.95,hQ.thr=0.2,ylab="Q [m3/s]")
#     
#     # Creation d'un matrice avec date/debit/debit spe/% de depassement du debit -> Correction ? Creation d'un matrice avec date/frequence de non depassement/debit
#     debExtract = as.data.frame(cbind(Date = format(as.Date(flow[, "Date"]),"%Y%m%d"), FreqNonDep = 1-fdcurve, Debit_l_s = flow[, "Qm3s1"]))
#     
#     write.table(debExtract, 
#                 paste0(folder_input_,
#                        "FlowDurationCurves/",
#                        presFut_,"/",
#                        ifelse(obsSim_=="","",paste0("FDC_",obsSim_)),"/",
#                        ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),"/",
#                        foldername_,
#                        "/FDC_",stationName_,".txt"), sep=";", row.name=F, quote=F)
#   }
# }

