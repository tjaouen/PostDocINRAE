#-------------------------------------------------------------------------------
# Calcul les frequences de non depassement pour les stations HYDRO
# Bottet Quentin - Irstea - 10/09/2019 - Version 1
#-------------------------------------------------------------------------------

### Librairies ###
library(doParallel)
library(lubridate)
library(hydroTSM)
library(rgdal)
library(strex)

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Option0SafranCompletSeul.R")

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

### Run ###
cl <- makePSOCKcluster(detectCores()/2-1)
registerDoParallel(cores=cl)

### Folders ###
liste_folders_ = list.files(paste0(folder_input_,
                                   "FlowDurationCurves/",
                                   ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                                   nom_categorieSimu_), full.names = T)
# liste_folders_ = liste_folders_[c(1,3:5,7:length(liste_folders_))]
# liste_folders_ = liste_folders_[c(24,28:length(liste_folders_))]
# liste_folders_ = liste_folders_[12:23]
# liste_folders_ = liste_folders_[24:length(liste_folders_)]
# ifelse(nom_categorieSimu_=="","",paste0(nom_categorieSimu_,"/")),
# ifelse(nom_GCM_=="","",nom_GCM_)), pattern = ".txt|.Rdata", full.names = T)

output <- foreach(folder_ = liste_folders_) %dopar% { #, errorhandling='pass'
  
  liste_fichiers_ = list.files(folder_, pattern = ".txt|.Rdata", full.names = T)
  
  # for (i in liste_fichiers_[1:299]){
  # for (i in liste_fichiers_[300:length(liste_fichiers_)]){
  for (i in liste_fichiers_){
    
    fdc_ <- read.table(i, sep=";", header=T)
    
    fdc_$Date <- as.Date(as.character(fdc_$Date), format = "%Y%m%d")
    
    type_ = str_after_last(str_before_last(str_before_last(nom_categorieSimu_,"/"),"/"),"_")
    if (type_ %in% c("historical","safran")){
      fdc_$Type = paste0(toupper(substring(type_, 1, 1)), substring(type_, 2))
    }else{
      fdc_$Type = type_
    }
    # write.table(fdc_, paste0(folder_input_,
    #                          "FlowDurationCurves/",
    #                          ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
    #                          ifelse(nom_categorieSimu_=="","",paste0(nom_categorieSimu_,"/")),
    #                          ifelse(nom_GCM_=="","",nom_GCM_),"/",
    #                          basename(i)), sep=";", row.name=F, quote=F)
    
    data_saf_ <- fdc_[which(fdc_$Type == "Safran"),]
    data_hist_ <- fdc_[which(fdc_$Type == "Historical"),]
    data_rcp_ <- fdc_[which(grepl("rcp",fdc_$Type)),]
    
    if ((!all(diff(as.numeric(data_saf_$Date)) == 1)) | (!all(diff(as.numeric(data_hist_$Date)) == 1)) | (!all(diff(as.numeric(data_rcp_$Date)) == 1))){
      stop("Les dates ne sont pas successives dans un des fichiers FDC.")
    }
    
    data_saf_$Moyenne_6jours <- rollapply(data_saf_$FreqNonDep, width = 7, FUN = mean, align = "right", fill = NA)
    data_hist_$Moyenne_6jours <- rollapply(data_hist_$FreqNonDep, width = 7, FUN = mean, align = "right", fill = NA)
    data_rcp_$Moyenne_6jours <- rollapply(data_rcp_$FreqNonDep, width = 7, FUN = mean, align = "right", fill = NA)
    
    fdc_ <- rbind(data_saf_,
                  data_hist_,
                  data_rcp_)
    
    if (!(dir.exists(gsub("FlowDurationCurves/","FlowDurationCurves_meanJm6Jj/",str_before_last(i,"/"))))){
      dir.create(gsub("FlowDurationCurves/","FlowDurationCurves_meanJm6Jj/",str_before_last(i,"/")))
    }
    
    colnames(fdc_)[which(colnames(fdc_) == "Debit")] = "Qm3s1"
    
    write.table(fdc_, gsub("FlowDurationCurves/","FlowDurationCurves_meanJm6Jj/",i), sep=";", row.name=F, quote=F)
    
  }
}

# Arreter le cluster doParallel
stopCluster(cl)

