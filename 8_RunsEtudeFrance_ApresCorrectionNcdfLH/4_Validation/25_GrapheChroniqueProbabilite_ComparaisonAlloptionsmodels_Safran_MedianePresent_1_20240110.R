source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")

library(lubridate)
library(ggplot2)
library(ggrepel)
library(strex)
library(dplyr)


date_min_ = "2012-01-01"
date_max_ = "2019-12-31"
type_ = c("Safran")
  
### Observe ###
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunGraphe_Obs.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")
chroniqueFDCbyHERweighted_obs_ = read.table(paste0(folder_input_DD_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                                   ifelse(obsSim_param_=="",nom_GCM_param_,
                                                          paste0("FDC_",obsSim_param_,
                                                                 ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                                 ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),"/",
                                                                 ifelse(nom_categorieSimu_param_=="","",paste0("Mod_",str_after_first(nom_categorieSimu_param_,"/"))),"/",
                                                                 ifelse(nom_GCM_param_=="","",paste0("Mod_",nom_GCM_param_)))),
                                                   "/Tab_ChroniquesProba_LearnBrut_ByHer.txt"), sep=";", header = T)
colnames(chroniqueFDCbyHERweighted_obs_)[!colnames(chroniqueFDCbyHERweighted_obs_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_obs_)[!colnames(chroniqueFDCbyHERweighted_obs_) %in% c("Date", "Type")])

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
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

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

list_HM_saf_rcp85_ = list.files(paste0(folder_input_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                       ifelse(obsSim_param_=="",nom_GCM_param_,
                                              paste0("FDC_",obsSim_param_,
                                                     ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                     ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),"/Mod_ChroniquesCombinees_saf_rcp85/"))), recursive = T, full.names = T)
tab_CERFACS_ALADIN63_saf_rcp85_ = read.table(list_HM_saf_rcp85_[1], sep=";", header = T )
colnames(tab_CERFACS_ALADIN63_saf_rcp85_) <- sub("^X", "", colnames(tab_CERFACS_ALADIN63_saf_rcp85_))
tab_ECearth_HadREM3_saf_rcp85_ = read.table(list_HM_saf_rcp85_[2], sep=";", header = T )
colnames(tab_ECearth_HadREM3_saf_rcp85_) <- sub("^X", "", colnames(tab_ECearth_HadREM3_saf_rcp85_))
tab_HadGEM2_CCLM4_saf_rcp85_ = read.table(list_HM_saf_rcp85_[3], sep=";", header = T )
colnames(tab_HadGEM2_CCLM4_saf_rcp85_) <- sub("^X", "", colnames(tab_HadGEM2_CCLM4_saf_rcp85_))
tab_HadGEM2_ALADIN63_saf_rcp85_ = read.table(list_HM_saf_rcp85_[4], sep=";", header = T )
colnames(tab_HadGEM2_ALADIN63_saf_rcp85_) <- sub("^X", "", colnames(tab_HadGEM2_ALADIN63_saf_rcp85_))

### Modele Safran seul ###
tab_saf_ = read.table(paste0(folder_input_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                             ifelse(obsSim_param_=="",nom_GCM_param_,
                                    paste0("FDC_",obsSim_param_,
                                           ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                           ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),
                                           "/Mod_ChroniquesSafranSeulCplt/Tab_ChroniquesProba_LearnBrut_ByHer.txt"))), sep=";", header = T )
colnames(tab_saf_) <- sub("^X", "", colnames(tab_saf_))


### Selection de la plage etudiee et du type de courbes ###
tab_chroniqueFDCbyHERweighted_obs_Safran20122019 = chroniqueFDCbyHERweighted_obs_[which(chroniqueFDCbyHERweighted_obs_$Type == "Observes" & chroniqueFDCbyHERweighted_obs_$Date >= date_min_ & chroniqueFDCbyHERweighted_obs_$Date <= date_max_),]
tab_saf_Safran20122019 = tab_saf_[which(tab_saf_$Type %in% type_ & tab_saf_$Date >= date_min_ & tab_saf_$Date <= date_max_),]
tab_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019 = tab_CERFACS_ALADIN63_saf_hist_rcp85_[which(tab_CERFACS_ALADIN63_saf_hist_rcp85_$Type %in% type_ & tab_CERFACS_ALADIN63_saf_hist_rcp85_$Date >= date_min_ & tab_CERFACS_ALADIN63_saf_hist_rcp85_$Date <= date_max_),]
tab_ECearth_HadREM3_saf_hist_rcp85_Safran20122019 = tab_ECearth_HadREM3_saf_hist_rcp85_[which(tab_ECearth_HadREM3_saf_hist_rcp85_$Type %in% type_ & tab_ECearth_HadREM3_saf_hist_rcp85_$Date >= date_min_ & tab_ECearth_HadREM3_saf_hist_rcp85_$Date <= date_max_),]
tab_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019 = tab_HadGEM2_CCLM4_saf_hist_rcp85_[which(tab_HadGEM2_CCLM4_saf_hist_rcp85_$Type %in% type_ & tab_HadGEM2_CCLM4_saf_hist_rcp85_$Date >= date_min_ & tab_HadGEM2_CCLM4_saf_hist_rcp85_$Date <= date_max_),]
tab_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019 = tab_HadGEM2_ALADIN63_saf_hist_rcp85_[which(tab_HadGEM2_ALADIN63_saf_hist_rcp85_$Type %in% type_ & tab_HadGEM2_ALADIN63_saf_hist_rcp85_$Date >= date_min_ & tab_HadGEM2_ALADIN63_saf_hist_rcp85_$Date <= date_max_),]
tab_CERFACS_ALADIN63_saf_rcp85_Safran20122019 = tab_CERFACS_ALADIN63_saf_rcp85_[which(tab_CERFACS_ALADIN63_saf_rcp85_$Type %in% type_ & tab_CERFACS_ALADIN63_saf_rcp85_$Date >= date_min_ & tab_CERFACS_ALADIN63_saf_rcp85_$Date <= date_max_),]
tab_ECearth_HadREM3_saf_rcp85_Safran20122019 = tab_ECearth_HadREM3_saf_rcp85_[which(tab_ECearth_HadREM3_saf_rcp85_$Type %in% type_ & tab_ECearth_HadREM3_saf_rcp85_$Date >= date_min_ & tab_ECearth_HadREM3_saf_rcp85_$Date <= date_max_),]
tab_HadGEM2_CCLM4_saf_rcp85_Safran20122019 = tab_HadGEM2_CCLM4_saf_rcp85_[which(tab_HadGEM2_CCLM4_saf_rcp85_$Type %in% type_ & tab_HadGEM2_CCLM4_saf_rcp85_$Date >= date_min_ & tab_HadGEM2_CCLM4_saf_rcp85_$Date <= date_max_),]
tab_HadGEM2_ALADIN63_saf_rcp85_Safran20122019 = tab_HadGEM2_ALADIN63_saf_rcp85_[which(tab_HadGEM2_ALADIN63_saf_rcp85_$Type %in% type_ & tab_HadGEM2_ALADIN63_saf_rcp85_$Date >= date_min_ & tab_HadGEM2_ALADIN63_saf_rcp85_$Date <= date_max_),]


### Delimiter chroniques ###
for (HER_h_ in HER_){
  
  print(HER_h_)
  # HER_h_ = 59
  # HER_h_ = 40
  
  # if (HER_h_ %in% colnames(chroniqueFDCbyHERweighted_saf_)){
  if (HER_h_ %in% colnames(tab_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019)){
    
    tab_input_h_ = tab_input_[which(tab_input_$HER2 == HER_h_),]
    # tab_input_h_[,c('Date','X._Assec')]
    
    # Calculer la moyenne pour chaque mois
    moyennes_mois <- tab_input_h_ %>%
      group_by(Mois) %>%
      summarise(Moyenne_X_Assec = mean(X._Assec),
                Median_X_Assec = median(X._Assec))
    moyennes_mois$Date = as.Date(paste0("2022-",moyennes_mois$Mois,"-25"))
    all_dates = tab_input_h_
    all_dates$Date_2022 = as.Date(format(as.Date(all_dates$Date), "2022-%m-%d"))
    
    chro_chroniqueFDCbyHERweighted_obs_ <- tab_chroniqueFDCbyHERweighted_obs_Safran20122019[,c("Date",as.character(HER_h_))]
    
    chro_saf_Safran20122019 <- tab_saf_Safran20122019[,c("Date",as.character(HER_h_))]

    chro_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019 <- tab_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    chro_ECearth_HadREM3_saf_hist_rcp85_Safran20122019 <- tab_ECearth_HadREM3_saf_hist_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    chro_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019 <- tab_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    chro_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019 <- tab_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    
    chro_CERFACS_ALADIN63_saf_rcp85_Safran20122019 <- tab_CERFACS_ALADIN63_saf_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    chro_ECearth_HadREM3_saf_rcp85_Safran20122019 <- tab_ECearth_HadREM3_saf_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    chro_HadGEM2_CCLM4_saf_rcp85_Safran20122019 <- tab_HadGEM2_CCLM4_saf_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    chro_HadGEM2_ALADIN63_saf_rcp85_Safran20122019 <- tab_HadGEM2_ALADIN63_saf_rcp85_Safran20122019[,c("Date",as.character(HER_h_))]
    
    colnames(chro_chroniqueFDCbyHERweighted_obs_) = c("Date","Proba")
    colnames(chro_saf_Safran20122019) = c("Date","Proba")
    colnames(chro_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019) = c("Date","Proba")
    colnames(chro_ECearth_HadREM3_saf_hist_rcp85_Safran20122019) = c("Date","Proba")
    colnames(chro_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019) = c("Date","Proba")
    colnames(chro_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019) = c("Date","Proba")
    colnames(chro_CERFACS_ALADIN63_saf_rcp85_Safran20122019) = c("Date","Proba")
    colnames(chro_ECearth_HadREM3_saf_rcp85_Safran20122019) = c("Date","Proba")
    colnames(chro_HadGEM2_CCLM4_saf_rcp85_Safran20122019) = c("Date","Proba")
    colnames(chro_HadGEM2_ALADIN63_saf_rcp85_Safran20122019) = c("Date","Proba")
    
    chro_chroniqueFDCbyHERweighted_obs_$Date <- as.Date(chro_chroniqueFDCbyHERweighted_obs_$Date)
    chro_chroniqueFDCbyHERweighted_obs_$Jour_annee <- format(chro_chroniqueFDCbyHERweighted_obs_$Date, format = "%m-%d")
    proba_chroniqueFDCbyHERweighted_obs_ <- chro_chroniqueFDCbyHERweighted_obs_ %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_median = median(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    chro_saf_Safran20122019$Date <- as.Date(chro_saf_Safran20122019$Date)
    chro_saf_Safran20122019$Jour_annee <- format(chro_saf_Safran20122019$Date, format = "%m-%d")
    proba_saf_Safran20122019 <- chro_saf_Safran20122019 %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_median = median(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))

    chro_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019$Date <- as.Date(chro_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019$Date)
    chro_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019$Jour_annee <- format(chro_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019$Date, format = "%m-%d")
    proba_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019 <- chro_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019 %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_median = median(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    chro_ECearth_HadREM3_saf_hist_rcp85_Safran20122019$Date <- as.Date(chro_ECearth_HadREM3_saf_hist_rcp85_Safran20122019$Date)
    chro_ECearth_HadREM3_saf_hist_rcp85_Safran20122019$Jour_annee <- format(chro_ECearth_HadREM3_saf_hist_rcp85_Safran20122019$Date, format = "%m-%d")
    proba_ECearth_HadREM3_saf_hist_rcp85_Safran20122019 <- chro_ECearth_HadREM3_saf_hist_rcp85_Safran20122019 %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_median = median(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    chro_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019$Date <- as.Date(chro_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019$Date)
    chro_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019$Jour_annee <- format(chro_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019$Date, format = "%m-%d")
    proba_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019 <- chro_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019 %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_median = median(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    chro_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019$Date <- as.Date(chro_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019$Date)
    chro_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019$Jour_annee <- format(chro_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019$Date, format = "%m-%d")
    proba_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019 <- chro_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019 %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_median = median(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    chro_CERFACS_ALADIN63_saf_rcp85_Safran20122019$Date <- as.Date(chro_CERFACS_ALADIN63_saf_rcp85_Safran20122019$Date)
    chro_CERFACS_ALADIN63_saf_rcp85_Safran20122019$Jour_annee <- format(chro_CERFACS_ALADIN63_saf_rcp85_Safran20122019$Date, format = "%m-%d")
    proba_CERFACS_ALADIN63_saf_rcp85_Safran20122019 <- chro_CERFACS_ALADIN63_saf_rcp85_Safran20122019 %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_median = median(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    chro_ECearth_HadREM3_saf_rcp85_Safran20122019$Date <- as.Date(chro_ECearth_HadREM3_saf_rcp85_Safran20122019$Date)
    chro_ECearth_HadREM3_saf_rcp85_Safran20122019$Jour_annee <- format(chro_ECearth_HadREM3_saf_rcp85_Safran20122019$Date, format = "%m-%d")
    proba_ECearth_HadREM3_saf_rcp85_Safran20122019 <- chro_ECearth_HadREM3_saf_rcp85_Safran20122019 %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_median = median(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    chro_HadGEM2_CCLM4_saf_rcp85_Safran20122019$Date <- as.Date(chro_HadGEM2_CCLM4_saf_rcp85_Safran20122019$Date)
    chro_HadGEM2_CCLM4_saf_rcp85_Safran20122019$Jour_annee <- format(chro_HadGEM2_CCLM4_saf_rcp85_Safran20122019$Date, format = "%m-%d")
    proba_HadGEM2_CCLM4_saf_rcp85_Safran20122019 <- chro_HadGEM2_CCLM4_saf_rcp85_Safran20122019 %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_median = median(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    chro_HadGEM2_ALADIN63_saf_rcp85_Safran20122019$Date <- as.Date(chro_HadGEM2_ALADIN63_saf_rcp85_Safran20122019$Date)
    chro_HadGEM2_ALADIN63_saf_rcp85_Safran20122019$Jour_annee <- format(chro_HadGEM2_ALADIN63_saf_rcp85_Safran20122019$Date, format = "%m-%d")
    proba_HadGEM2_ALADIN63_saf_rcp85_Safran20122019 <- chro_HadGEM2_ALADIN63_saf_rcp85_Safran20122019 %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_median = median(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    

    
    # Ajouter une colonne "Période" à chaque table
    proba_chroniqueFDCbyHERweighted_obs_$Periode <- "Model_Observed__Data_Observed_20122019"
    proba_saf_Safran20122019$Periode <- "Model_SafranSeul__Data_Safran_20122019"
    proba_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019$Periode <- "Model_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019"
    proba_ECearth_HadREM3_saf_hist_rcp85_Safran20122019$Periode <- "Model_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019"
    proba_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019$Periode <- "Model_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019"
    proba_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019$Periode <- "Model_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019"
    proba_CERFACS_ALADIN63_saf_rcp85_Safran20122019$Periode <- "Model_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019"
    proba_ECearth_HadREM3_saf_rcp85_Safran20122019$Periode <- "Model_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019"
    proba_HadGEM2_CCLM4_saf_rcp85_Safran20122019$Periode <- "Model_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019"
    proba_HadGEM2_ALADIN63_saf_rcp85_Safran20122019$Periode <- "Model_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019"
    

    # Fusionner les trois tables en une seule
    combined_data <- rbind(proba_chroniqueFDCbyHERweighted_obs_,
                           proba_saf_Safran20122019,
                           proba_CERFACS_ALADIN63_saf_hist_rcp85_Safran20122019,
                           proba_ECearth_HadREM3_saf_hist_rcp85_Safran20122019,
                           proba_HadGEM2_CCLM4_saf_hist_rcp85_Safran20122019,
                           proba_HadGEM2_ALADIN63_saf_hist_rcp85_Safran20122019,
                           proba_CERFACS_ALADIN63_saf_rcp85_Safran20122019,
                           proba_ECearth_HadREM3_saf_rcp85_Safran20122019,
                           proba_HadGEM2_CCLM4_saf_rcp85_Safran20122019,
                           proba_HadGEM2_ALADIN63_saf_rcp85_Safran20122019)
    
    
    combined_data[which(is.na(combined_data$Proba_moyen)),]
    # Remplacer les valeurs manquantes par des zéros
    # combined_data[is.na(combined_data)] <- 0
    
    combined_data_min_max_ <- combined_data[which(combined_data$Jour_annee %in% c("05-25","06-25","07-25","08-25","09-25")),]
    combined_data_min_max_$Date <- as.Date(paste0("2022-",combined_data_min_max_$Jour_annee))
    tab_input_h_[,c("HER2","Date","Mois","X._Assec")]
    tab_input_h_min_max_ <- tab_input_h_ %>%
      group_by(Mois) %>%
      summarize(Max_X_Assec = max(X._Assec),
                Min_X_Assec = min(X._Assec))
    tab_input_h_min_max_$Date = as.Date(paste0("2022-",tab_input_h_min_max_$Mois,"-25"))
    
    # # Créer une colonne pour le mois
    # combined_data <- combined_data %>%
    #   mutate(Mois = format(Jour_annee, "%m"))
    
    # Supposons que "combined_data" est votre jeu de données avec une colonne "Jour_annee" au format "MM-DD" et une colonne "Debit_moyen"
    
    # Convertir Jour_annee au format de date en ajoutant une année fixe (par exemple, 2022)
    combined_data$Jour_annee <- as.Date(paste0("2022-", combined_data$Jour_annee), format = "%Y-%m-%d")
    
    # Création d'une colonne pour extraire le jour de chaque date
    combined_data$Jour <- as.numeric(format(combined_data$Jour_annee, "%d"))
    
    # Filtrer les données pour obtenir uniquement le premier jour de chaque mois
    first_days <- combined_data %>% filter(Jour == 1)
    
    # Création du graphique avec deux facettes : une pour tous les jours et une autre pour le premier jour de chaque mois
    # x11()
    
    # custom_colors <- c("Safran 1976 à 2005" = "#3182bd",
    #                    "RCP85 1976 à 2005" = "#fc9272",
    #                    "RCP85 2071 à 2100" = "#de2d26",
    #                    "Observé 2012 à 2022" = "#31a354")
    
    custom_colors <- c("Model_Observed__Data_Observed_20122019" = "#2ca25f",
                       "Model_SafranSeul__Data_Safran_20122019" = "#2b8cbe",
                       "Model_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019" = "#f1eef6",
                       "Model_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019" = "#c994c7",
                       "Model_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019" = "#e7298a",
                       "Model_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019" = "#ce1256",
                       "Model_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019" = "#fee5d9",
                       "Model_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019" = "#fc9272",
                       "Model_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019" = "#fb6a4a",
                       "Model_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019" = "#cb181d")
    desired_order <- c("Model_Observed__Data_Observed_20122019",
                       "Model_SafranSeul__Data_Safran_20122019",
                       "Model_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019",
                       "Model_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019",
                       "Model_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019",
                       "Model_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019",
                       "Model_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019",
                       "Model_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019",
                       "Model_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019",
                       "Model_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019")
    combined_data$Periode <- factor(combined_data$Periode, levels = desired_order)
    
    p <- ggplot() +
      
      geom_line(data = combined_data, aes(x = Jour_annee, y = Proba_median, color = Periode, group = Periode), size = 0.3) +
      # geom_line(data = combined_data, aes(x = Jour_annee, y = Proba_median, color = Periode, group = Periode), size = 1.5) +
      
      # geom_line(data = combined_data, aes(x = Jour_annee, y = Proba_moyen, color = Periode, group = Periode), size = 1.5) +
      # geom_point(data = combined_data_min_max_, aes(x = Date, y = Proba_Q5, color = Periode, group = Periode), size = 2, shape = 3) +
      # geom_point(data = combined_data_min_max_, aes(x = Date, y = Proba_Q95, color = Periode, group = Periode), size = 2, shape = 3) +
      
      scale_color_manual(values = custom_colors) +  # Utilisation de la palette de couleurs personnalisée
      
      geom_point(data = first_days, aes(x = Jour_annee, y = Proba_moyen, color = Periode, group = Periode), size = 0) +
      # scale_x_date(date_breaks = "1 month", date_labels = "%d-%b") +
      scale_x_date(date_breaks = "1 month", date_labels = "%b") +
      
      geom_point(data = moyennes_mois, aes(x = Date, y = Median_X_Assec), color = "#252525", size = 3, shape = 16) +
      # geom_point(data = moyennes_mois, aes(x = Date, y = Moyenne_X_Assec), color = "#252525", size = 3, shape = 16) +
      geom_point(data = tab_input_h_min_max_, aes(x = Date, y = Min_X_Assec), color = "#969696", size = 3, shape = 16) +
      geom_point(data = tab_input_h_min_max_, aes(x = Date, y = Max_X_Assec), color = "#969696", size = 3, shape = 16) +
      # geom_point(data = all_dates, aes(x = Date_2022, y = X._Assec), color = "blue", size = 3, shape = 16) +
      # geom_text_repel(data = all_dates, aes(label = format(as.Date(Date), "%m-%Y"), x = Date_2022, y = X._Assec), vjust = -1, hjust = 0, size = 3) +
      
      # ylim(0,50) +
      ylim(0,30) +
      theme_minimal() +
      theme(strip.text.x = element_blank(),
            strip.background = element_blank(),
            axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
      labs(x = "Date", y = "Probabilité d'assec", color = "Période", title = paste0("HER ",HER_h_, " - KGE = ",tab_output_$KGE_logit_Learn[which(tab_output_$HER == HER_h_)]))
    # p
    
    if (!dir.exists(paste0(folder_output_,
                           "17_ChroniquesProbabilitesPeriodeONDE_MedianePeriode/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))))){
      dir.create(paste0(folder_output_,
                        "17_ChroniquesProbabilitesPeriodeONDE_MedianePeriode/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))))
    }
    if (!dir.exists(paste0(folder_output_,
                           "17_ChroniquesProbabilitesPeriodeONDE_MedianePeriode/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                           ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_))))){
      dir.create(paste0(folder_output_,
                        "17_ChroniquesProbabilitesPeriodeONDE_MedianePeriode/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                        ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_))))
    }
    
    
    output_name_ <- paste0(folder_output_,
                           "17_ChroniquesProbabilitesPeriodeONDE_MedianePeriode/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                           ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_)),
                           "/ChroniquesProbaPerONDE_HER",HER_h_,"_logit.pdf")
    
    pdf(output_name_,
        width = 8)
    print(p)
    dev.off()
    
    saveRDS(p, file = paste0(str_before_first(output_name_, ".pdf"),".rds"))
    
  }
}



# Une HER Nord, ouest, sud ouest, sud est, alpes, est
#Courbes avec d'autres indicateurs, courbes enveloppe, 

# Recoupement HER : quantifier le temps

# Voir le pourcentage de bassins versants sur lesquels approximation a partir des stations HYDRO d'origine
