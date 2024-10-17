#-------------------------------------------------------------------------------
# Calcul les frequences de non depassement pour les stations HYDRO
# Bottet Quentin - Irstea - 10/09/2019 - Version 1
#-------------------------------------------------------------------------------

### Librairies ###
library(hydroTSM)
library(rgdal)
library(lubridate)

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunGraphe_Obs.R")

### Study data ###
folder_input_ = folder_input_param_
# presFut_ = presFut_param_
obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
nom_GCM_ = nom_GCM_param_
date_variable_name_ = "Date"
FDC_dateBorneMin_ = FDC_dateBorneMin_param_
FDC_dateBorneMax_ = FDC_dateBorneMax_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_selectStations_ = nom_selectStations_param_
folder_input_DD_ = folder_input_DD_param_


liste = list.files(paste0(folder_input_PC_,
                          "FlowDurationCurves/",
                          ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                          ifelse(nom_categorieSimu_=="","",paste0(nom_categorieSimu_,"/")),
                          ifelse(nom_GCM_=="","",nom_GCM_)), pattern = ".txt|.Rdata", full.names = T)


liste_station <- list.files(paste0(folder_input_PC_,
                                   "StationsSelectionnees/SelectionCsv/",
                                   nom_selectStations_,"/"),pattern="Stations_HYDRO", full.names = T)
liste_station <- read.table(liste_station, sep = ";", dec = ".", header = T)
           

for(i in liste){
  
  if (str_before_first(str_after_first(basename(i),"FDC_"),"_") %in% liste_station$Code_short){
    
    ### ATTENTION VERIFIER NOMS DOSSIER A PARTIR DE LA
    
    print(basename(i))
    
    fdc_ <- read.table(paste0(folder_input_PC_,
                              "FlowDurationCurves/",
                              ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                              ifelse(nom_categorieSimu_=="","",paste0(nom_categorieSimu_,"/")),
                              ifelse(nom_GCM_=="","",nom_GCM_),"/",
                              basename(i)), sep=";", header=T)
    
    fdc_$Date <- as.Date(as.character(fdc_$Date), format = "%Y%m%d")
    if (!all(diff(as.numeric(fdc_$Date)) == 1)){
      stop("Les dates ne sont pas successives dans un des fichiers FDC.")
    }
    
    # data_saf_ <- fdc_[which(fdc_$Type == "Safran"),]
    # data_hist_ <- fdc_[which(fdc_$Type == "Historical"),]
    # data_rcp_ <- fdc_[which(grepl("rcp",fdc_$Type)),]
    # if ((!all(diff(as.numeric(data_saf_$Date)) == 1)) | (!all(diff(as.numeric(data_hist_$Date)) == 1)) | (!all(diff(as.numeric(data_rcp_$Date)) == 1))){
    #   stop("Les dates ne sont pas successives dans un des fichiers FDC.")
    # }
    
    fdc_$Moyenne_6jours <- rollapply(fdc_$FreqNonDep, width = 7, FUN = mean, align = "right", fill = NA)
    
    # data_hist_$Moyenne_6jours <- rollapply(data_hist_$FreqNonDep, width = 7, FUN = mean, align = "right", fill = NA)
    # data_rcp_$Moyenne_6jours <- rollapply(data_rcp_$FreqNonDep, width = 7, FUN = mean, align = "right", fill = NA)
    # fdc_ <- rbind(data_saf_,
    #               data_hist_,
    #               data_rcp_)
    
    if (!(dir.exists(paste0(folder_input_DD_,
                            "FlowDurationCurves_meanJm6Jj/",
                            ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                            ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                            ifelse(nom_GCM_=="","",nom_GCM_),"/")))){
      dir.create(paste0(folder_input_DD_,
                        "FlowDurationCurves_meanJm6Jj/",
                        ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                        ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                        ifelse(nom_GCM_=="","",nom_GCM_),"/"))
    }
    
    fdc_$Type = "Observes"
    
    write.table(fdc_, paste0(folder_input_DD_,
                             "FlowDurationCurves_meanJm6Jj/",
                             ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                             ifelse(nom_categorieSimu_=="","",paste0(nom_categorieSimu_,"/")),
                             ifelse(nom_GCM_=="","",nom_GCM_),"/",
                             basename(i)), sep=";", row.name=F, quote=F)
    
  }
}
