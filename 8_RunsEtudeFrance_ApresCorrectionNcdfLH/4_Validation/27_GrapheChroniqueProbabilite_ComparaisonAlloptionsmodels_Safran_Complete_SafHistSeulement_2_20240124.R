source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")

library(lubridate)
library(ggplot2)
library(ggrepel)
library(strex)
library(dplyr)


date_min_ = "2012-01-01"
# date_max_ = "2019-12-31"
date_max_ = "2022-12-31"
type_ = c("Safran")

### Colors ###
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

col_mod_Obs__Data_Obs_ = col_mod_Obs__Data_Obs_param_
col_mod_SafSeul__Data_Saf_ = col_mod_SafSeul__Data_Saf_param_
col_mod_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_ = col_mod_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_param_
col_mod_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019_ = col_mod_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019_param_
col_mod_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019_ = col_mod_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019_param_
col_mod_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_ = col_mod_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_param_
# col_mod_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019_ = col_mod_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019_param_
# col_mod_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019_ = col_mod_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019_param_
# col_mod_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019_ = col_mod_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019_param_
# col_mod_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019_ =col_mod_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019_param_

### Observe ###
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunGraphe_Obs.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")
chroniqueFDCbyHERweighted_obs_ = read.table(paste0(folder_input_DD_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                                   ifelse(obsSim_param_=="",nom_GCM_param_,
                                                          paste0("FDC_",obsSim_param_,
                                                                 ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                                 # ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),"/",
                                                                 paste0("Mod_",nom_categorieSimu_param_))),
                                                                 # ifelse(nom_categorieSimu_param_=="","",paste0("Mod_",str_after_first(nom_categorieSimu_param_,"/"))),"/",
                                                                 # ifelse(nom_GCM_param_=="","",paste0("Mod_",nom_GCM_param_)))),
                                                   "/Tab_ChroniquesProba_LearnBrut_ByHer.txt"), sep=";", header = T)
colnames(chroniqueFDCbyHERweighted_obs_)[!colnames(chroniqueFDCbyHERweighted_obs_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_obs_)[!colnames(chroniqueFDCbyHERweighted_obs_) %in% c("Date", "Type")])

tab_res_obs_ = read.table(list.files(paste0(folder_output_param_,
                                            "2_ResultatsModeles_ParHer/",
                                            nomSim_param_,
                                            ifelse(nom_categorieSimu_param_=="","",paste0("/",nom_categorieSimu_param_)),
                                            ifelse(nom_GCM_param_=="","",paste0("/",nom_GCM_param_)),
                                            ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_))),
                                     # ifelse(nom_validation_param_=="","",paste0("/",nom_validation_param_))),
                                     pattern = "logit", full.names = T),
                          dec = ".", sep = ";", header = T)

### Table input ONDE ###
files_input_ <- list.files(paste0(folder_output_param_,
                                  "1_MatricesInputModeles_ParHERDates/",
                                  nomSim_param_,
                                  ifelse(nom_categorieSimu_param_=="","",paste0("/",nom_categorieSimu_param_)),
                                  ifelse(nom_GCM_param_=="","",paste0("/",nom_GCM_param_))), pattern = "MatInputModel_CampOndeExcl_ByHERDates_",
                           full.names = T)
tab_input_ <- read.table(files_input_, sep = ";", dec = ".", header = T)
tab_input_$Mois <- month(as.Date(tab_input_$Date))

### Table Output ###
files_output_ <- list.files(paste0(folder_output_param_,
                                   "2_ResultatsModeles_ParHer/",
                                   nomSim_param_,
                                   ifelse(nom_categorieSimu_param_=="","",paste0("/",nom_categorieSimu_param_)),
                                   ifelse(nom_GCM_param_=="","",paste0("/",nom_GCM_param_)),
                                   "/ApprentissageGlobalModelesBruts/"), pattern = "logit",
                            full.names = T)
tab_output_ <- read.table(files_output_, sep = ";", dec = ".", header = T)


### Projections ###
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R") # OK avec un seul run
HER_ = HER_param_
folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_GCM_ = nom_GCM_param_

list_HM_saf_hist_rcp85_ = list.files(paste0(folder_input_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                            ifelse(obsSim_param_=="",nom_GCM_param_,
                                                   paste0("FDC_",obsSim_param_,
                                                          ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                          ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),"/Mod_ChroniquesCombinees_saf_hist_rcp85/"))), recursive = T, full.names = T)
tab_CERFACS_ALADIN63_saf_hist_rcp85_ = read.table(list_HM_saf_hist_rcp85_[1], sep=";", header = T)
colnames(tab_CERFACS_ALADIN63_saf_hist_rcp85_) <- sub("^X", "", colnames(tab_CERFACS_ALADIN63_saf_hist_rcp85_))
tab_ECearth_HadREM3_saf_hist_rcp85_ = read.table(list_HM_saf_hist_rcp85_[2], sep=";", header = T )
colnames(tab_ECearth_HadREM3_saf_hist_rcp85_) <- sub("^X", "", colnames(tab_ECearth_HadREM3_saf_hist_rcp85_))
tab_HadGEM2_CCLM4_saf_hist_rcp85_ = read.table(list_HM_saf_hist_rcp85_[3], sep=";", header = T )
colnames(tab_HadGEM2_CCLM4_saf_hist_rcp85_) <- sub("^X", "", colnames(tab_HadGEM2_CCLM4_saf_hist_rcp85_))
tab_HadGEM2_ALADIN63_saf_hist_rcp85_ = read.table(list_HM_saf_hist_rcp85_[4], sep=";", header = T )
colnames(tab_HadGEM2_ALADIN63_saf_hist_rcp85_) <- sub("^X", "", colnames(tab_HadGEM2_ALADIN63_saf_hist_rcp85_))

# list_HM_saf_rcp85_ = list.files(paste0(folder_input_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
#                                        ifelse(obsSim_param_=="",nom_GCM_param_,
#                                               paste0("FDC_",obsSim_param_,
#                                                      ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
#                                                      ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),"/Mod_ChroniquesCombinees_saf_rcp85/"))), recursive = T, full.names = T)
# tab_CERFACS_ALADIN63_saf_rcp85_ = read.table(list_HM_saf_rcp85_[1], sep=";", header = T )
# colnames(tab_CERFACS_ALADIN63_saf_rcp85_) <- sub("^X", "", colnames(tab_CERFACS_ALADIN63_saf_rcp85_))
# tab_ECearth_HadREM3_saf_rcp85_ = read.table(list_HM_saf_rcp85_[2], sep=";", header = T )
# colnames(tab_ECearth_HadREM3_saf_rcp85_) <- sub("^X", "", colnames(tab_ECearth_HadREM3_saf_rcp85_))
# tab_HadGEM2_CCLM4_saf_rcp85_ = read.table(list_HM_saf_rcp85_[3], sep=";", header = T )
# colnames(tab_HadGEM2_CCLM4_saf_rcp85_) <- sub("^X", "", colnames(tab_HadGEM2_CCLM4_saf_rcp85_))
# tab_HadGEM2_ALADIN63_saf_rcp85_ = read.table(list_HM_saf_rcp85_[4], sep=";", header = T )
# colnames(tab_HadGEM2_ALADIN63_saf_rcp85_) <- sub("^X", "", colnames(tab_HadGEM2_ALADIN63_saf_rcp85_))


### Results KGE ###
files_results_ <- list.files(paste0(folder_output_,
                                    "2_ResultatsModeles_ParHer/",
                                    nomSim_,
                                    ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_, "/")))),
                             pattern = "logit", recursive = T, full.names = T)
tab_res_CERFACS_ALADIN63_saf_hist_rcp85_ = read.table(files_results_[grepl("saf_hist_.*CERFACS.*ALADIN",files_results_)], sep = ";", dec = ".", header = T)
tab_res_ECearth_HadREM3_saf_hist_rcp85_ = read.table(files_results_[grepl("saf_hist_.*EC-EARTH.*HadREM3",files_results_)], sep = ";", dec = ".", header = T)
tab_res_HadGEM2_CCLM4_saf_hist_rcp85_ = read.table(files_results_[grepl("saf_hist_.*HadGEM2.*CCLM4",files_results_)], sep = ";", dec = ".", header = T)
tab_res_HadGEM2_ALADIN63_saf_hist_rcp85_ = read.table(files_results_[grepl("saf_hist_.*HadGEM2.*ALADIN",files_results_)], sep = ";", dec = ".", header = T)
# tab_res_CERFACS_ALADIN63_saf_rcp85_ = read.table(files_results_[grepl("saf_rcp85.*CERFACS.*ALADIN",files_results_)], sep = ";", dec = ".", header = T)
# tab_res_ECearth_HadREM3_saf_rcp85_ = read.table(files_results_[grepl("saf_rcp85.*EC-EARTH.*HadREM3",files_results_)], sep = ";", dec = ".", header = T)
# tab_res_HadGEM2_CCLM4_saf_rcp85_ = read.table(files_results_[grepl("saf_rcp85.*HadGEM2.*CCLM4",files_results_)], sep = ";", dec = ".", header = T)
# tab_res_HadGEM2_ALADIN63_saf_rcp85_ = read.table(files_results_[grepl("saf_rcp85.*HadGEM2.*ALADIN",files_results_)], sep = ";", dec = ".", header = T)
# tab_res_saf_ = read.table(files_results_[grepl("SafranSeulCplt",files_results_)], sep = ";", dec = ".", header = T)

### Modele Safran seul ###
tab_saf_ = read.table(paste0(folder_input_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                             ifelse(obsSim_param_=="",nom_GCM_param_,
                                    paste0("FDC_",obsSim_param_,
                                           ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                           ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),
                                           "/Mod_ChroniquesSafranSeulCplt/Tab_ChroniquesProba_LearnBrut_ByHer.txt"))), sep=";", header = T )
colnames(tab_saf_) <- sub("^X", "", colnames(tab_saf_))


### Selection de la plage etudiee et du type de courbes ###
tab_saf_Safran20122019 = tab_saf_[which(tab_saf_$Type %in% type_ & tab_saf_$Date >= date_min_ & tab_saf_$Date <= date_max_),]

tab_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019 = tab_CERFACS_ALADIN63_saf_hist_rcp85_[which(tab_CERFACS_ALADIN63_saf_hist_rcp85_$Type %in% type_ & tab_CERFACS_ALADIN63_saf_hist_rcp85_$Date >= min(tab_saf_Safran20122019$Date) & tab_CERFACS_ALADIN63_saf_hist_rcp85_$Date <= max(tab_saf_Safran20122019$Date)),]
tab_ECearth_HadREM3_saf_hist_rcp85_Safran20122019 = tab_ECearth_HadREM3_saf_hist_rcp85_[which(tab_ECearth_HadREM3_saf_hist_rcp85_$Type %in% type_ & tab_ECearth_HadREM3_saf_hist_rcp85_$Date >= min(tab_saf_Safran20122019$Date) & tab_ECearth_HadREM3_saf_hist_rcp85_$Date <= max(tab_saf_Safran20122019$Date)),]
tab_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019 = tab_HadGEM2_CCLM4_saf_hist_rcp85_[which(tab_HadGEM2_CCLM4_saf_hist_rcp85_$Type %in% type_ & tab_HadGEM2_CCLM4_saf_hist_rcp85_$Date >= min(tab_saf_Safran20122019$Date) & tab_HadGEM2_CCLM4_saf_hist_rcp85_$Date <= max(tab_saf_Safran20122019$Date)),]
tab_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019 = tab_HadGEM2_ALADIN63_saf_hist_rcp85_[which(tab_HadGEM2_ALADIN63_saf_hist_rcp85_$Type %in% type_ & tab_HadGEM2_ALADIN63_saf_hist_rcp85_$Date >= min(tab_saf_Safran20122019$Date) & tab_HadGEM2_ALADIN63_saf_hist_rcp85_$Date <= max(tab_saf_Safran20122019$Date)),]
# tab_CERFACS_ALADIN63_saf_rcp85_Safran20122019 = tab_CERFACS_ALADIN63_saf_rcp85_[which(tab_CERFACS_ALADIN63_saf_rcp85_$Type %in% type_ & tab_CERFACS_ALADIN63_saf_rcp85_$Date >= min(tab_saf_Safran20122019$Date) & tab_CERFACS_ALADIN63_saf_rcp85_$Date <= max(tab_saf_Safran20122019$Date)),]
# tab_ECearth_HadREM3_saf_rcp85_Safran20122019 = tab_ECearth_HadREM3_saf_rcp85_[which(tab_ECearth_HadREM3_saf_rcp85_$Type %in% type_ & tab_ECearth_HadREM3_saf_rcp85_$Date >= min(tab_saf_Safran20122019$Date) & tab_ECearth_HadREM3_saf_rcp85_$Date <= max(tab_saf_Safran20122019$Date)),]
# tab_HadGEM2_CCLM4_saf_rcp85_Safran20122019 = tab_HadGEM2_CCLM4_saf_rcp85_[which(tab_HadGEM2_CCLM4_saf_rcp85_$Type %in% type_ & tab_HadGEM2_CCLM4_saf_rcp85_$Date >= min(tab_saf_Safran20122019$Date) & tab_HadGEM2_CCLM4_saf_rcp85_$Date <= max(tab_saf_Safran20122019$Date)),]
# tab_HadGEM2_ALADIN63_saf_rcp85_Safran20122019 = tab_HadGEM2_ALADIN63_saf_rcp85_[which(tab_HadGEM2_ALADIN63_saf_rcp85_$Type %in% type_ & tab_HadGEM2_ALADIN63_saf_rcp85_$Date >= min(tab_saf_Safran20122019$Date) & tab_HadGEM2_ALADIN63_saf_rcp85_$Date <= max(tab_saf_Safran20122019$Date)),]

# tab_chroniqueFDCbyHERweighted_obs_Safran20122019 = chroniqueFDCbyHERweighted_obs_[which(chroniqueFDCbyHERweighted_obs_$Type == "Observes" & chroniqueFDCbyHERweighted_obs_$Date >= min(tab_saf_Safran20122019$Date) & chroniqueFDCbyHERweighted_obs_$Date <= max(tab_saf_Safran20122019$Date)),]


### Delimiter chroniques ###
for (HER_h_ in HER_){
  
  print(HER_h_)
  # HER_h_ = 59
  # HER_h_ = 40
  
  # if (HER_h_ %in% colnames(chroniqueFDCbyHERweighted_saf_)){
  if (HER_h_ %in% colnames(tab_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019)){
    
    tab_input_h_ = tab_input_[which(tab_input_$HER2 == HER_h_ & tab_input_$Date >= min(tab_saf_Safran20122019$Date) & tab_input_$Date <= max(tab_saf_Safran20122019$Date)),]
    # tab_input_h_[,c('Date','X._Assec')]
    
    # Calculer la moyenne pour chaque mois
    # moyennes_mois <- tab_input_h_ %>%
    #   group_by(Mois) %>%
    #   summarise(Moyenne_X_Assec = mean(X._Assec),
    #             Median_X_Assec = median(X._Assec))
    # moyennes_mois$Date = as.Date(paste0("2022-",moyennes_mois$Mois,"-25"))
    # all_dates = tab_input_h_
    # all_dates$Date_2022 = as.Date(format(as.Date(all_dates$Date), "2022-%m-%d"))
    
    # chro_chroniqueFDCbyHERweighted_obs_ <- tab_chroniqueFDCbyHERweighted_obs_Safran20122019[,c("Date",as.character(HER_h_))]
    
    # chro_saf_Safran20122019 <- tab_saf_Safran20122019[,c("Date",as.character(HER_h_))]
    
    chro_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019 <- tab_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    chro_ECearth_HadREM3_saf_hist_rcp85_Safran20122019 <- tab_ECearth_HadREM3_saf_hist_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    chro_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019 <- tab_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    chro_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019 <- tab_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    
    # chro_CERFACS_ALADIN63_saf_rcp85_Safran20122019 <- tab_CERFACS_ALADIN63_saf_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    # chro_ECearth_HadREM3_saf_rcp85_Safran20122019 <- tab_ECearth_HadREM3_saf_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    # chro_HadGEM2_CCLM4_saf_rcp85_Safran20122019 <- tab_HadGEM2_CCLM4_saf_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    # chro_HadGEM2_ALADIN63_saf_rcp85_Safran20122019 <- tab_HadGEM2_ALADIN63_saf_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    
    # colnames(chro_chroniqueFDCbyHERweighted_obs_) = c("Date","Proba")
    # colnames(chro_saf_Safran20122019) = c("Date","Proba")
    colnames(chro_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019) = c("Date","Proba")
    colnames(chro_ECearth_HadREM3_saf_hist_rcp85_Safran20122019) = c("Date","Proba")
    colnames(chro_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019) = c("Date","Proba")
    colnames(chro_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019) = c("Date","Proba")
    # colnames(chro_CERFACS_ALADIN63_saf_rcp85_Safran20122019) = c("Date","Proba")
    # colnames(chro_ECearth_HadREM3_saf_rcp85_Safran20122019) = c("Date","Proba")
    # colnames(chro_HadGEM2_CCLM4_saf_rcp85_Safran20122019) = c("Date","Proba")
    # colnames(chro_HadGEM2_ALADIN63_saf_rcp85_Safran20122019) = c("Date","Proba")
    
    # proba_chroniqueFDCbyHERweighted_obs_ <- chro_chroniqueFDCbyHERweighted_obs_
    # proba_saf_Safran20122019 <- chro_saf_Safran20122019
    proba_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019 <- chro_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019
    proba_ECearth_HadREM3_saf_hist_rcp85_Safran20122019 <- chro_ECearth_HadREM3_saf_hist_rcp85_Safran20122019
    proba_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019 <- chro_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019
    proba_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019 <- chro_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019
    # proba_CERFACS_ALADIN63_saf_rcp85_Safran20122019 <- chro_CERFACS_ALADIN63_saf_rcp85_Safran20122019
    # proba_ECearth_HadREM3_saf_rcp85_Safran20122019 <- chro_ECearth_HadREM3_saf_rcp85_Safran20122019
    # proba_HadGEM2_CCLM4_saf_rcp85_Safran20122019 <- chro_HadGEM2_CCLM4_saf_rcp85_Safran20122019
    # proba_HadGEM2_ALADIN63_saf_rcp85_Safran20122019 <- chro_HadGEM2_ALADIN63_saf_rcp85_Safran20122019
    
    # Ajouter une colonne "Période" à chaque table
    # proba_chroniqueFDCbyHERweighted_obs_$Periode <- "Model_Observed__Data_Observed_20122019"
    # proba_saf_Safran20122019$Periode <- "Model_SafranSeul__Data_Safran_20122019"
    proba_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019$Periode <- "Model_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019"
    proba_ECearth_HadREM3_saf_hist_rcp85_Safran20122019$Periode <- "Model_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019"
    proba_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019$Periode <- "Model_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019"
    proba_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019$Periode <- "Model_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019"
    # proba_CERFACS_ALADIN63_saf_rcp85_Safran20122019$Periode <- "Model_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019"
    # proba_ECearth_HadREM3_saf_rcp85_Safran20122019$Periode <- "Model_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019"
    # proba_HadGEM2_CCLM4_saf_rcp85_Safran20122019$Periode <- "Model_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019"
    # proba_HadGEM2_ALADIN63_saf_rcp85_Safran20122019$Periode <- "Model_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019"
    
    
    # Fusionner les trois tables en une seule
    combined_data <- rbind(# proba_chroniqueFDCbyHERweighted_obs_,
                           # proba_saf_Safran20122019,
                           proba_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019,
                           proba_ECearth_HadREM3_saf_hist_rcp85_Safran20122019,
                           proba_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019,
                           proba_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019)#,
                           # proba_CERFACS_ALADIN63_saf_rcp85_Safran20122019,
                           # proba_ECearth_HadREM3_saf_rcp85_Safran20122019,
                           # proba_HadGEM2_CCLM4_saf_rcp85_Safran20122019,
                           # proba_HadGEM2_ALADIN63_saf_rcp85_Safran20122019)
    
    
    combined_data[which(is.na(combined_data$Proba_moyen)),]
    # Remplacer les valeurs manquantes par des zéros
    # combined_data[is.na(combined_data)] <- 0
    
    # Filtrer les données pour obtenir uniquement le premier jour de chaque mois
    combined_data$Jour <- as.numeric(format(as.Date(combined_data$Date), "%d"))
    
    combined_data <- combined_data %>%
      group_by(Periode) %>%
      mutate(ProbaLissee = (lag(Proba, 2) + lag(Proba, 1) + Proba + lead(Proba, 1) + lead(Proba, 2)) / 5)
    
    first_days <- combined_data %>% filter(Jour == 1)
    
    # Création du graphique avec deux facettes : une pour tous les jours et une autre pour le premier jour de chaque mois
    # x11()
    
    custom_colors <- c(# "Model_Observed__Data_Observed_20122019" = col_mod_Obs__Data_Obs_,
                       # "Model_SafranSeul__Data_Safran_20122019" = col_mod_SafSeul__Data_Saf_,
                       "Model_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019" = col_mod_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_,
                       "Model_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019" = col_mod_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019_,
                       "Model_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019" = col_mod_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019_,
                       "Model_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019" = col_mod_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_)#,
                       # "Model_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019" = col_mod_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019_,
                       # "Model_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019" = col_mod_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019_,
                       # "Model_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019" = col_mod_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019_,
                       # "Model_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019" = col_mod_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019_)
    
    desired_order <- c(# "Model_Observed__Data_Observed_20122019",
                       # "Model_SafranSeul__Data_Safran_20122019",
                       "Model_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019",
                       "Model_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019",
                       "Model_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019",
                       "Model_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019")#,
                       # "Model_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019",
                       # "Model_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019",
                       # "Model_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019",
                       # "Model_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019")
    labels_ <- c(#paste0("Model: Observed - Data: Observed - ",year(min(tab_chroniqueFDCbyHERweighted_obs_Safran20122019$Date)),"/",year(max(tab_chroniqueFDCbyHERweighted_obs_Safran20122019$Date))," - KGE: ", tab_res_obs_$KGE_logit_Learn[which(tab_res_obs_$HER == HER_h_)]),
                 #paste0("Model: Safran seul - Data: Safran - ",year(min(tab_saf_Safran20122019$Date)),"/",year(max(tab_saf_Safran20122019$Date))," - KGE: ", tab_res_saf_$KGE_logit_Learn[which(tab_res_saf_$HER == HER_h_)]),
                 paste0("Model: CERFACS_ALADIN63_saf_hist_rcp85 - Data: Safran - ",year(min(tab_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019$Date)),"/",year(max(tab_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019$Date))," - KGE: ", tab_res_CERFACS_ALADIN63_saf_hist_rcp85_$KGE_logit_Learn[which(tab_res_CERFACS_ALADIN63_saf_hist_rcp85_$HER == HER_h_)]),
                 paste0("Model: ECearth_HadREM3_saf_hist_rcp85 - Data: Safran - ",year(min(tab_ECearth_HadREM3_saf_hist_rcp85_Safran20122019$Date)),"/",year(max(tab_ECearth_HadREM3_saf_hist_rcp85_Safran20122019$Date))," - KGE: ", tab_res_ECearth_HadREM3_saf_hist_rcp85_$KGE_logit_Learn[which(tab_res_ECearth_HadREM3_saf_hist_rcp85_$HER == HER_h_)]),
                 paste0("Model: HadGEM2_CCLM4_saf_hist_rcp85 - Data: Safran - ",year(min(tab_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019$Date)),"/",year(max(tab_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019$Date))," - KGE: ", tab_res_HadGEM2_CCLM4_saf_hist_rcp85_$KGE_logit_Learn[which(tab_res_HadGEM2_CCLM4_saf_hist_rcp85_$HER == HER_h_)]),
                 paste0("Model: HadGEM2_ALADIN63_saf_hist_rcp85 - Data: Safran - ",year(min(tab_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019$Date)),"/",year(max(tab_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019$Date))," - KGE: ", tab_res_HadGEM2_ALADIN63_saf_hist_rcp85_$KGE_logit_Learn[which(tab_res_HadGEM2_ALADIN63_saf_hist_rcp85_$HER == HER_h_)]))#,
                 # paste0("Model: CERFACS_ALADIN63_saf_rcp85 - Data: Safran - ",year(min(tab_CERFACS_ALADIN63_saf_rcp85_Safran20122019$Date)),"/",year(max(tab_CERFACS_ALADIN63_saf_rcp85_Safran20122019$Date))," - KGE: ", tab_res_CERFACS_ALADIN63_saf_rcp85_$KGE_logit_Learn[which(tab_res_CERFACS_ALADIN63_saf_rcp85_$HER == HER_h_)]),
                 # paste0("Model: ECearth_HadREM3_saf_rcp85 - Data: Safran - ",year(min(tab_ECearth_HadREM3_saf_rcp85_Safran20122019$Date)),"/",year(max(tab_ECearth_HadREM3_saf_rcp85_Safran20122019$Date))," - KGE: ", tab_res_ECearth_HadREM3_saf_rcp85_$KGE_logit_Learn[which(tab_res_ECearth_HadREM3_saf_rcp85_$HER == HER_h_)]),
                 # paste0("Model: HadGEM2_CCLM4_saf_rcp85 - Data: Safran - ",year(min(tab_HadGEM2_CCLM4_saf_rcp85_Safran20122019$Date)),"/",year(max(tab_HadGEM2_CCLM4_saf_rcp85_Safran20122019$Date))," - KGE: ", tab_res_HadGEM2_CCLM4_saf_rcp85_$KGE_logit_Learn[which(tab_res_HadGEM2_CCLM4_saf_rcp85_$HER == HER_h_)]),
                 # paste0("Model: HadGEM2_ALADIN63_saf_rcp85 - Data: Safran - ",year(min(tab_HadGEM2_ALADIN63_saf_rcp85_Safran20122019$Date)),"/",year(max(tab_HadGEM2_ALADIN63_saf_rcp85_Safran20122019$Date))," - KGE: ", tab_res_HadGEM2_ALADIN63_saf_rcp85_$KGE_logit_Learn[which(tab_res_HadGEM2_ALADIN63_saf_rcp85_$HER == HER_h_)]))
    combined_data$Periode <- factor(combined_data$Periode, levels = desired_order)
    
    
    combined_data$Date <- as.Date(combined_data$Date, format = "%Y-%m-%d")
    first_days$Date <- as.Date(first_days$Date, format = "%Y-%m-%d")
    tab_input_h_$Date <- as.Date(tab_input_h_$Date, format = "%Y-%m-%d")
    
    p <- ggplot() +
      
      # geom_smooth(data = combined_data, aes(x = Date, y = Proba, color = Periode, group = Periode), size = 1, method = "loess", span = 0.0001) +  # Ajouter la courbe lissée
      geom_line(data = combined_data, aes(x = Date, y = ProbaLissee, color = Periode, group = Periode), size = 0.3) +
      # geom_line(data = combined_data, aes(x = Date, y = Proba, color = Periode, group = Periode), size = 0.3) +
      scale_color_manual(values = custom_colors,
                         labels = labels_) +  # Utilisation de la palette de couleurs personnalisée
      
      geom_point(data = first_days, aes(x = Date, y = ProbaLissee, color = Periode, group = Periode), size = 0, alpha = 0) +
      # geom_point(data = first_days, aes(x = Date, y = Proba, color = Periode, group = Periode), size = 0) +
      scale_x_date(date_breaks = "1 month", date_labels = "%b-%Y") +
      
      geom_point(data = tab_input_h_, aes(x = Date, y = X._Assec), color = "#252525", size = 3, shape = 16) +
      ylim(0,max(na.omit(combined_data$Proba))*1.05) +
      theme_minimal() +
      theme(strip.text.x = element_blank(),
            strip.background = element_blank(),
            axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
            legend.position = "bottom",
            legend.box = "horizontal",
            legend.direction = "horizontal") +
      guides(color = guide_legend(ncol = 2, override.aes = list(lwd=2.5))) +
      # guides(color = guide_legend(legend.position = "bottom",  # Position de la légende
      #                             legend.box = "horizontal",   # Disposition horizontale (en deux colonnes)
      #                             legend.direction = "horizontal",  # Direction horizontale
      #                             ncol = 2, byrow = TRUE))+
      labs(x = "Date", y = "Drying probability (%)", color = "Data", title = paste0("Hydrological model: ",str_before_first(nom_categorieSimu_,"_"),
                                                                                    "\nHER ",HER_h_))
    # labs(x = "Date", y = "Drying probability (%)", color = "Période", title = paste0("HER ",HER_h_))
    # x11()
    # p
    
    if (!dir.exists(paste0(folder_output_,
                           "20_GrapheChroniqueProbabilite_ComparaisonAlloptionsmodels_Safran_SafHistSeul_Complete/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/")))))){
      # ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))))){
      dir.create(paste0(folder_output_,
                        "20_GrapheChroniqueProbabilite_ComparaisonAlloptionsmodels_Safran_SafHistSeul_Complete/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/")))))
      # ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))))
    }
    if (!dir.exists(paste0(folder_output_,
                           "20_GrapheChroniqueProbabilite_ComparaisonAlloptionsmodels_Safran_SafHistSeul_Complete/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                           # ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                           ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_))))){
      dir.create(paste0(folder_output_,
                        "20_GrapheChroniqueProbabilite_ComparaisonAlloptionsmodels_Safran_SafHistSeul_Complete/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                        # ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                        ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_))))
    }
    
    
    output_name_ <- paste0(folder_output_,
                           "20_GrapheChroniqueProbabilite_ComparaisonAlloptionsmodels_Safran_SafHistSeul_Complete/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                           # ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                           ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_)),
                           "/ChroProba_CompAlloptionsmodels_Safran_Complete_HER",HER_h_,"_logit.pdf")
    
    pdf(output_name_,
        width = 18)
    print(p)
    dev.off()
    
    png(paste0(output_name_,".png"),
        width = 1600, #height = 750,
        units = "px", pointsize = 12)
    print(p)
    dev.off()
    
    saveRDS(p, file = paste0(str_before_first(output_name_, ".pdf"),".rds"))
    
  }
}

