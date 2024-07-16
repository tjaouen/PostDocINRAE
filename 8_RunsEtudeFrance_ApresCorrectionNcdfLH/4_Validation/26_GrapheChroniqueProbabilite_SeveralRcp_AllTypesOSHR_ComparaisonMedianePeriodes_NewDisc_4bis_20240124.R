source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
library(lubridate)
library(ggplot2)
library(ggrepel)
library(strex)
library(dplyr)

### Colors ###
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

col_mod_Obs__Data_Obs_ = col_mod_Obs__Data_Obs_param_
col_mod_SafSeul__Data_Saf_ = col_mod_SafSeul__Data_Saf_param_
col_mod_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_ = col_mod_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_param_
col_mod_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019_ = col_mod_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019_param_
col_mod_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019_ = col_mod_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019_param_
col_mod_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_ = col_mod_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_param_
col_mod_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019_ = col_mod_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019_param_
col_mod_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019_ = col_mod_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019_param_
col_mod_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019_ = col_mod_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019_param_
col_mod_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019_ =col_mod_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019_param_

### Observe ###
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunGraphe_Obs.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")
# chroniqueFDCbyHERweighted_obs_ = read.table(paste0(folder_input_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
# # chroniqueFDCbyHERweighted_obs_ = read.table(paste0(folder_input_DD_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
#                                                    ifelse(obsSim_param_=="",nom_GCM_param_,
#                                                           paste0("FDC_",obsSim_param_,
#                                                                  ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
#                                                                  ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),"/",
#                                                                  ifelse(nom_categorieSimu_param_=="","",paste0("Mod_",str_after_first(nom_categorieSimu_param_,"/"))),"/",
#                                                                  ifelse(nom_GCM_param_=="","",paste0("Mod_",nom_GCM_param_)))),
#                                                    "/Tab_ChroniquesProba_LearnBrut_ByHer.txt"), sep=";", header = T)
# colnames(chroniqueFDCbyHERweighted_obs_)[!colnames(chroniqueFDCbyHERweighted_obs_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_obs_)[!colnames(chroniqueFDCbyHERweighted_obs_) %in% c("Date", "Type")])


# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run3.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run4.R")

source_files_ = c("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R",
                  "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R",
                  "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run3.R",
                  "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run4.R")


for (source_ in source_files_[4]){
  source(source_)
  
  HER_ = HER_param_
  folder_output_ = folder_output_param_
  nomSim_ = nomSim_param_
  obsSim_ = obsSim_param_
  nom_categorieSimu_ = nom_categorieSimu_param_
  nom_GCM_ = nom_GCM_param_
  nom_apprentissage_ = nom_apprentissage_param_
  folder_input_ = folder_input_param_
  nom_FDCfolder_ = nom_FDCfolder_param_
  
  date_min_past = "1976-01-01"
  date_max_past = "2005-12-31"
  # date_min_ = "2012-01-01"
  # date_max_ = "2019-12-31"
  date_min_fut = "2070-01-01"
  date_max_fut = "2100-12-31"
  
  data.frame(type = c("Obs","Safran","Hist","rcp85"),
             data_min = c(date_min_past))
  
  
  ### Table input ONDE ###
  files_input_ <- list.files(paste0(folder_output_,
                                    "1_MatricesInputModeles_ParHERDates/",
                                    nomSim_,
                                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))), pattern = "MatInputModel_CampOndeExcl_ByHERDates_",
                             full.names = T)
  tab_input_ <- read.table(files_input_, sep = ";", dec = ".", header = T)
  tab_input_$Mois <- month(as.Date(tab_input_$Date))
  
  ### Table Output ###
  files_output_ <- list.files(paste0(folder_output_,
                                     "2_ResultatsModeles_ParHer/",
                                     nomSim_,
                                     ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                     ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                     "/ApprentissageGlobalModelesBruts/"), pattern = "logit",
                              full.names = T)
  tab_output_ <- read.table(files_output_, sep = ";", dec = ".", header = T)
  
  
  ### Projections ###
  list_HM_saf_hist_rcp85_ = list.files(paste0(folder_input_DD_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                              ifelse(obsSim_=="",nom_GCM_,
                                                     paste0("FDC_",obsSim_,
                                                            ifelse(nom_FDCfolder_=="","",paste0("_",nom_FDCfolder_)),"/",
                                                            ifelse(nom_categorieSimu_=="","",str_before_first(nom_categorieSimu_,"/")),"/Mod_ChroniquesCombinees_saf_hist_rcp85/"))), recursive = T, full.names = T)
  list_HM_saf_rcp85_ = list.files(paste0(folder_input_DD_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                         ifelse(obsSim_=="",nom_GCM_,
                                                paste0("FDC_",obsSim_,
                                                       ifelse(nom_FDCfolder_=="","",paste0("_",nom_FDCfolder_)),"/",
                                                       ifelse(nom_categorieSimu_=="","",str_before_first(nom_categorieSimu_,"/")),"/Mod_ChroniquesCombinees_saf_rcp85/"))), recursive = T, full.names = T)
  
  
  list_modelsRL_ = c(list_HM_saf_hist_rcp85_, list_HM_saf_rcp85_)
  dat_modelsRL_ = data.frame(liste_fichiers = list_modelsRL_,
                             model = c("Mod_CERFACS_ALADIN63_saf_hist_rcp85",
                                       "Mod_ECEARTH_HadREM3_saf_hist_rcp85",
                                       "Mod_HadGEM2_CCLM4_saf_hist_rcp85",
                                       "Mod_HadGEM2_ALADIN63_saf_hist_rcp85",
                                       "Mod_CERFACS_ALADIN63_saf_rcp85",
                                       "Mod_ECEARTH_HadREM3_saf_rcp85",
                                       "Mod_HadGEM2_CCLM4_saf_rcp85",
                                       "Mod_HadGEM2_ALADIN63_saf_rcp85"),
                             names_ = c("Mod_CERFACS_ALADIN63_saf_hist_rcp85__Data_CERFACS_ALADIN63",
                                        "Mod_ECEARTH_HadREM3_saf_hist_rcp85__Data_ECEARTH_HadREM3",
                                        "Mod_HadGEM2_CCLM4_saf_hist_rcp85__Data_HadGEM2_CCLM4",
                                        "Mod_HadGEM2_ALADIN63_saf_hist_rcp85__Data_HadGEM2_ALADIN63",
                                        "Mod_CERFACS_ALADIN63_saf_rcp85__Data_CERFACS_ALADIN63",
                                        "Mod_ECEARTH_HadREM3_saf_rcp85__Data_ECEARTH_HadREM3",
                                        "Mod_HadGEM2_CCLM4_saf_rcp85__Data_HadGEM2_CCLM4",
                                        "Mod_HadGEM2_ALADIN63_saf_rcp85__Data_HadGEM2_ALADIN63"))#,
  # colors_ = c(col_mod_Obs__Data_Obs_,
  #             col_mod_SafSeul__Data_Saf_,
  #             col_mod_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_,
  #             col_mod_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019_,
  #             col_mod_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019_,
  #             col_mod_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_,
  #             col_mod_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019_,
  #             col_mod_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019_,
  #             col_mod_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019_,
  #             col_mod_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019_))
  
  # ind_ = 1
  # tab_ = read.table(dat_modelsRL_$liste_fichiers[ind_], sep=";", header = T)
  
  model_ = dat_modelsRL_$liste_fichiers[which(grepl(str_after_first(nom_categorieSimu_,"/"), dat_modelsRL_$liste_fichiers) &
                                                grepl(nom_GCM_, dat_modelsRL_$liste_fichiers))]
  tab_ = read.table(model_, sep=";", header = T)
  colnames(tab_) <- sub("^X", "", colnames(tab_))
  
  tab_saf_19752005 = tab_[which(tab_$Type == "Safran" & tab_$Date >= date_min_past & tab_$Date <= date_max_past),]
  tab_hist_19752005 = tab_[which(tab_$Type == "Historical" & tab_$Date >= date_min_past & tab_$Date <= date_max_past),]
  tab_rcp_20702100 = tab_[which(tab_$Type == "rcp85" & tab_$Date >= date_min_fut & tab_$Date <= date_max_fut),]
  
  # tab_rcp26_20702100 = read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/GRSD_20231128/ChroniquesBrutes_rcp26/ModA_FaFa/debit_France_CNRM-CERFACS-CNRM-CM5_rcp26_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/Tab_ChroniquesProba_LearnBrut_ByHer.txt",sep =";", dec=".", header = T)
  # tab_rcp26_20702100 = read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/GRSD_20231128/ChroniquesBrutes_rcp26/ModB_ChSc/debit_France_ICHEC-EC-EARTH_rcp26_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/Tab_ChroniquesProba_LearnBrut_ByHer.txt",sep =";", dec=".", header = T)
  # colnames(tab_rcp26_20702100) <- sub("^X", "", colnames(tab_rcp26_20702100))
  # tab_rcp26_20702100 = tab_rcp26_20702100[which(tab_rcp26_20702100$Type == "rcp26" & tab_rcp26_20702100$Date >= date_min_fut & tab_rcp26_20702100$Date <= date_max_fut),]
  tab_rcp26_20702100 = NULL
  
  # tab_rcp45_20702100 = read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/GRSD_20231128/ChroniquesBrutes_rcp45/ModA_FaFa/debit_France_CNRM-CERFACS-CNRM-CM5_rcp45_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/Tab_ChroniquesProba_LearnBrut_ByHer.txt",sep =";", dec=".", header = T)
  # tab_rcp45_20702100 = read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/GRSD_20231128/ChroniquesBrutes_rcp45/ModD_ChHm/debit_France_MOHC-HadGEM2-ES_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731/Tab_ChroniquesProba_LearnBrut_ByHer.txt",sep =";", dec=".", header = T)
  # colnames(tab_rcp45_20702100) <- sub("^X", "", colnames(tab_rcp45_20702100))
  # tab_rcp45_20702100 = tab_rcp45_20702100[which(tab_rcp45_20702100$Type == "rcp45" & tab_rcp45_20702100$Date >= date_min_fut & tab_rcp45_20702100$Date <= date_max_fut),]
  tab_rcp45_20702100 = NULL
  
  
  ### Attention, tab_input va de 2012 à 2022
  
  # tab_obs_ = chroniqueFDCbyHERweighted_obs_[which(chroniqueFDCbyHERweighted_obs_$Type == "Observes" 
  #                                                 & chroniqueFDCbyHERweighted_obs_$Date >= min(tab_saf_19752005$Date)
  #                                                 & chroniqueFDCbyHERweighted_obs_$Date <= max(tab_saf_19752005$Date)),]
  
  
  
  ### Delimiter chroniques ###
  for (HER_h_ in HER_){
    
    print(HER_h_)
    # HER_h_ = 59
    # HER_h_ = 40
    
    # if (HER_h_ %in% colnames(chroniqueFDCbyHERweighted_saf_)){
    if (HER_h_ %in% colnames(tab_)){
      
      tab_input_h_ = tab_input_[which(tab_input_$HER2 == HER_h_),]  ### Attention, tab_input va de 2012 à 2022
      # tab_input_h_[,c('Date','X._Assec')]
      
      # Calculer la moyenne pour chaque mois
      moyennes_mois <- tab_input_h_ %>%
        group_by(Mois) %>%
        summarise(Moyenne_X_Assec = mean(X._Assec),
                  Median_X_Assec = median(X._Assec))
      moyennes_mois$Date = as.Date(paste0("2022-",moyennes_mois$Mois,"-25"))
      all_dates = tab_input_h_
      all_dates$Date_2022 = as.Date(format(as.Date(all_dates$Date), "2022-%m-%d"))
      
      chro_saf_19752005 <- tab_saf_19752005[,c("Date",as.character(HER_h_))]
      chro_hist_19752005 <- tab_hist_19752005[,c("Date",as.character(HER_h_))]
      chro_rcp_20702100 <- tab_rcp_20702100[,c("Date",as.character(HER_h_))]
      
      colnames(chro_saf_19752005) = c("Date","Proba")
      colnames(chro_hist_19752005) = c("Date","Proba")
      colnames(chro_rcp_20702100) = c("Date","Proba")
      
      chro_saf_19752005$Date <- as.Date(chro_saf_19752005$Date)
      chro_saf_19752005$Jour_annee <- format(chro_saf_19752005$Date, format = "%m-%d")
      proba_saf_19752005 <- chro_saf_19752005 %>%
        group_by(Jour_annee) %>%
        summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                  Proba_median = median(Proba, na.rm = TRUE),
                  Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                  Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
      
      chro_hist_19752005$Date <- as.Date(chro_hist_19752005$Date)
      chro_hist_19752005$Jour_annee <- format(chro_hist_19752005$Date, format = "%m-%d")
      proba_hist_19752005 <- chro_hist_19752005 %>%
        group_by(Jour_annee) %>%
        summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                  Proba_median = median(Proba, na.rm = TRUE),
                  Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                  Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
      
      chro_rcp_20702100$Date <- as.Date(chro_rcp_20702100$Date)
      chro_rcp_20702100$Jour_annee <- format(chro_rcp_20702100$Date, format = "%m-%d")
      proba_rcp_20702100 <- chro_rcp_20702100 %>%
        group_by(Jour_annee) %>%
        summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                  Proba_median = median(Proba, na.rm = TRUE),
                  Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                  Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
      
      # Ajouter une colonne "Période" à chaque table
      proba_saf_19752005$Periode <- paste0("Safran_19702005")
      proba_hist_19752005$Periode <- paste0("Hist_19702005")
      proba_rcp_20702100$Periode <- paste0("Rcp85_20702100")
      # proba_saf_19752005$Periode <- paste0(dat_modelsRL_$model[ind_],"__Data_Safran_19702005")
      # proba_hist_19752005$Periode <- paste0(dat_modelsRL_$model[ind_],"__Data_Hist_19702005")
      # proba_rcp_20702100$Periode <- paste0(dat_modelsRL_$model[ind_],"__Data_Rcp_20702100")
      
      # Fusionner les trois tables en une seule
      combined_data <- rbind(proba_saf_19752005,
                             proba_hist_19752005,
                             proba_rcp_20702100)
      
      if (!is.null(tab_rcp26_20702100)){
        chro_rcp26_20702100 <- tab_rcp26_20702100[,c("Date",as.character(HER_h_))]
        colnames(chro_rcp26_20702100) = c("Date","Proba")
        chro_rcp26_20702100$Date <- as.Date(chro_rcp26_20702100$Date)
        chro_rcp26_20702100$Jour_annee <- format(chro_rcp26_20702100$Date, format = "%m-%d")
        proba_rcp26_20702100 <- chro_rcp26_20702100 %>%
          group_by(Jour_annee) %>%
          summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                    Proba_median = median(Proba, na.rm = TRUE),
                    Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                    Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
        proba_rcp26_20702100$Periode <- paste0("Rcp26_20702100")
        combined_data <- rbind(combined_data,
                               proba_rcp26_20702100)
      }
      if (!is.null(tab_rcp45_20702100)){
        chro_rcp45_20702100 <- tab_rcp45_20702100[,c("Date",as.character(HER_h_))]
        colnames(chro_rcp45_20702100) = c("Date","Proba")
        chro_rcp45_20702100$Date <- as.Date(chro_rcp45_20702100$Date)
        chro_rcp45_20702100$Jour_annee <- format(chro_rcp45_20702100$Date, format = "%m-%d")
        proba_rcp45_20702100 <- chro_rcp45_20702100 %>%
          group_by(Jour_annee) %>%
          summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                    Proba_median = median(Proba, na.rm = TRUE),
                    Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                    Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
        proba_rcp45_20702100$Periode <- paste0("Rcp45_20702100")
        combined_data <- rbind(combined_data,
                               proba_rcp45_20702100)
      }
      

      
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
      
      # Création du graphique avec deux facettes : une pour tous les jours et une autre pour le premier jour de chaque mois
      # x11()
      
      # custom_colors <- c("Safran 1976 à 2005" = "#3182bd",
      #                    "RCP85 1976 à 2005" = "#fc9272",
      #                    "RCP85 2071 à 2100" = "#de2d26",
      #                    "Observé 2012 à 2022" = "#31a354")
      # 
      # custom_colors <- c("Mod_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_19702005" = "#2b8cbe",
      #                    "Mod_CERFACS_ALADIN63_saf_hist_rcp85__Data_Hist_19702005" = "#f1eef6",
      #                    "Mod_CERFACS_ALADIN63_saf_hist_rcp85__Data_Rcp_20702100" = "#cb181d")
      # desired_order <- c(paste0(dat_modelsRL_$model[ind_],"__Data_Safran_19702005"),
      #                    paste0(dat_modelsRL_$model[ind_],"__Data_Hist_19702005"),
      #                    paste0(dat_modelsRL_$model[ind_],"__Data_Rcp_20702100"))
      
      combined_data <- combined_data %>%
        group_by(Periode) %>%
        mutate(ProbaLissee = (lag(Proba_median, 2) + lag(Proba_median, 1) + Proba_median + lead(Proba_median, 1) + lead(Proba_median, 2)) / 5)
      
      # Filtrer les données pour obtenir uniquement le premier jour de chaque mois
      first_days <- combined_data %>% filter(Jour == 1)
      
      custom_colors <- c("Safran_19702005" = "#084594",
                         "Hist_19702005" = "#238443",
                         "Rcp85_20702100" = "#990000")
      desired_order <- c("Safran_19702005",
                         "Hist_19702005",
                         "Rcp85_20702100")
      labels_ <- c(paste0("Safran ",year(min(tab_saf_19752005$Date)),"/",year(max(tab_saf_19752005$Date))),
                   paste0("Historical ",year(min(tab_hist_19752005$Date)),"/",year(max(tab_hist_19752005$Date))),
                   paste0("RCP 8.5 ",year(min(tab_rcp_20702100$Date)),"/",year(max(tab_rcp_20702100$Date))))
      
      # custom_colors <- c("Safran_19702005" = "#084594",
      #                    "Hist_19702005" = "#238443",
      #                    "Rcp85_20702100" = "#990000",
      #                    "Rcp45_20702100" = "#ef6548")
      # desired_order <- c("Safran_19702005",
      #                    "Hist_19702005",
      #                    "Rcp85_20702100",
      #                    "Rcp45_20702100")
      # labels_ <- c(paste0("Safran ",year(min(tab_saf_19752005$Date)),"/",year(max(tab_saf_19752005$Date))),
      #              paste0("Historical ",year(min(tab_hist_19752005$Date)),"/",year(max(tab_hist_19752005$Date))),
      #              paste0("RCP 8.5 ",year(min(tab_rcp_20702100$Date)),"/",year(max(tab_rcp_20702100$Date))),
      #              paste0("RCP 4.5 ",year(min(tab_rcp45_20702100$Date)),"/",year(max(tab_rcp45_20702100$Date))))
      
      # custom_colors <- c("Safran_19702005" = "#084594",
      #                    "Hist_19702005" = "#238443",
      #                    "Rcp85_20702100" = "#990000",
      #                    "Rcp26_20702100" = "#fdd49e")
      # desired_order <- c("Safran_19702005",
      #                    "Hist_19702005",
      #                    "Rcp85_20702100",
      #                    "Rcp26_20702100")
      # labels_ <- c(paste0("Safran ",year(min(tab_saf_19752005$Date)),"/",year(max(tab_saf_19752005$Date))),
      #              paste0("Historical ",year(min(tab_hist_19752005$Date)),"/",year(max(tab_hist_19752005$Date))),
      #              paste0("RCP 8.5 ",year(min(tab_rcp_20702100$Date)),"/",year(max(tab_rcp_20702100$Date))),
      #              paste0("RCP 2.6 ",year(min(tab_rcp26_20702100$Date)),"/",year(max(tab_rcp26_20702100$Date))))
      
      # custom_colors <- c("Safran_19702005" = "#084594",
      #                    "Hist_19702005" = "#238443",
      #                    "Rcp85_20702100" = "#990000",
      #                    "Rcp45_20702100" = "#ef6548",
      #                    "Rcp26_20702100" = "#fdd49e")
      # desired_order <- c("Safran_19702005",
      #                    "Hist_19702005",
      #                    "Rcp85_20702100",
      #                    "Rcp45_20702100",
      #                    "Rcp26_20702100")
      # labels_ <- c(paste0("Safran ",year(min(tab_saf_19752005$Date)),"/",year(max(tab_saf_19752005$Date))),
      #              paste0("Historical ",year(min(tab_hist_19752005$Date)),"/",year(max(tab_hist_19752005$Date))),
      #              paste0("RCP 8.5 ",year(min(tab_rcp_20702100$Date)),"/",year(max(tab_rcp_20702100$Date))),
      #              paste0("RCP 4.5 ",year(min(tab_rcp45_20702100$Date)),"/",year(max(tab_rcp45_20702100$Date))),
      #              paste0("RCP 2.6 ",year(min(tab_rcp26_20702100$Date)),"/",year(max(tab_rcp26_20702100$Date))))
      
      # desired_order <- c(paste0(dat_modelsRL_$model[ind_],"__Data_Safran_19702005"),
      #                    paste0(dat_modelsRL_$model[ind_],"__Data_Hist_19702005"),
      #                    paste0(dat_modelsRL_$model[ind_],"__Data_Rcp_20702100"))
      combined_data$Periode <- factor(combined_data$Periode, levels = desired_order)
      
      p <- ggplot() +
        
        geom_line(data = combined_data, aes(x = Jour_annee, y = ProbaLissee, color = Periode, group = Periode), size = 0.8) +
        # geom_line(data = combined_data, aes(x = Jour_annee, y = ProbaLissee, color = Periode, group = Periode), size = 0.3) +
        # geom_line(data = combined_data, aes(x = Jour_annee, y = Proba_median, color = Periode, group = Periode), size = 0.3) +
        # geom_line(data = combined_data, aes(x = Jour_annee, y = Proba_median, color = Periode, group = Periode), size = 1.5) +
        
        # geom_line(data = combined_data, aes(x = Jour_annee, y = Proba_moyen, color = Periode, group = Periode), size = 1.5) +
        # geom_point(data = combined_data_min_max_, aes(x = Date, y = Proba_Q5, color = Periode, group = Periode), size = 2, shape = 3) +
        # geom_point(data = combined_data_min_max_, aes(x = Date, y = Proba_Q95, color = Periode, group = Periode), size = 2, shape = 3) +
        
        scale_color_manual(values = custom_colors,
                           labels = labels_) +  # Utilisation de la palette de couleurs personnalisée
        
        geom_point(data = first_days, aes(x = Jour_annee, y = ProbaLissee, color = Periode, group = Periode), size = 0, alpha = 0) +
        # geom_point(data = first_days, aes(x = Jour_annee, y = Proba_moyen, color = Periode, group = Periode), size = 0) +
        # scale_x_date(date_breaks = "1 month", date_labels = "%d-%b") +
        scale_x_date(date_breaks = "1 month", date_labels = "%b") +
        
        geom_point(data = moyennes_mois, aes(x = Date, y = Median_X_Assec), color = "#252525", size = 3, shape = 16) +
        # geom_point(data = moyennes_mois, aes(x = Date, y = Moyenne_X_Assec), color = "#252525", size = 3, shape = 16) +
        geom_point(data = tab_input_h_min_max_, aes(x = Date, y = Min_X_Assec), color = "#969696", size = 3, shape = 16) +
        geom_point(data = tab_input_h_min_max_, aes(x = Date, y = Max_X_Assec), color = "#969696", size = 3, shape = 16) +
        # geom_point(data = all_dates, aes(x = Date_2022, y = X._Assec), color = "blue", size = 3, shape = 16) +
        # geom_text_repel(data = all_dates, aes(label = format(as.Date(Date), "%m-%Y"), x = Date_2022, y = X._Assec), vjust = -1, hjust = 0, size = 3) +
        
        # ylim(0,50) +
        ylim(0,max(max(na.omit(combined_data$Proba_median)),max(na.omit(tab_input_h_min_max_$Max_X_Assec)))*1.05)+
        theme_minimal(base_size = 14) +
        theme(strip.text.x = element_blank(),
              strip.background = element_blank(),
              axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
        guides(color = guide_legend(override.aes = list(lwd=2.5))) +
        labs(x = "Date", y = "Drying probability (%)", color = "Data", title = paste0("Hydrological model: ",str_before_first(nom_categorieSimu_,"_"),
                                                                                      "\nFDC concatenation: ", str_before_first(str_after_first(nom_categorieSimu_,"/"),"/"),
                                                                                      "\nModel: ",nom_GCM_,
                                                                                      "\nHER ",HER_h_))
      # p
      
      if (!dir.exists(paste0(folder_output_,
                             "19_GrapheChroniqueProbabilite_OneModel_AllTypesOSHR_ComparaisonMedianePeriodes/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                             ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))))){
        dir.create(paste0(folder_output_,
                          "19_GrapheChroniqueProbabilite_OneModel_AllTypesOSHR_ComparaisonMedianePeriodes/",
                          nomSim_,
                          ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                          ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))))
      }
      if (!dir.exists(paste0(folder_output_,
                             "19_GrapheChroniqueProbabilite_OneModel_AllTypesOSHR_ComparaisonMedianePeriodes/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                             ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                             ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_))))){
        dir.create(paste0(folder_output_,
                          "19_GrapheChroniqueProbabilite_OneModel_AllTypesOSHR_ComparaisonMedianePeriodes/",
                          nomSim_,
                          ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                          ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                          ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_))))
      }
      
      
      output_name_ <- paste0(folder_output_,
                             "19_GrapheChroniqueProbabilite_OneModel_AllTypesOSHR_ComparaisonMedianePeriodes/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                             # ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                             ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                             ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_)),
                             "/ChroniquesProbaPerONDE_HER",HER_h_,"_logit.pdf")
      
      pdf(output_name_,
          width = 12)
      print(p)
      dev.off()
      
      saveRDS(p, file = paste0(str_before_first(output_name_, ".pdf"),".rds"))
      
    }
  }
  
  
  
  # Une HER Nord, ouest, sud ouest, sud est, alpes, est
  #Courbes avec d'autres indicateurs, courbes enveloppe, 
  
  # Recoupement HER : quantifier le temps
  
  # Voir le pourcentage de bassins versants sur lesquels approximation a partir des stations HYDRO d'origine
  
}