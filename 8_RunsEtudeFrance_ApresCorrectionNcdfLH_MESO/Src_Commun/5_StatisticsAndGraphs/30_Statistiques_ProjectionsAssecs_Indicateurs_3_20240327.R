# print("GRSD - 8_Chroniques_ProjectionsAssecs_19752004_7local_20240229.R")
# source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_GRSD/PathsProgram/PathProgram_1_20230206.R")
# source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_GRSD/1_Parameters_MESO/0_SimulationParameters_AvecCC_2_20230227_MESO.R")
# source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_Commun/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")
source("/home/tjaouen/Documents/Input/FondsCartes/LHcolors/color.R")

### Libraries ###
suppressMessages(library(doParallel))
suppressMessages(library(tidyverse))
suppressMessages(library(svglite))
suppressMessages(library(ggplot2))
suppressMessages(library(strex))
suppressMessages(library(latex2exp))
suppressMessages(library(lubridate))
suppressMessages(library(readxl))

### Parameters ###
folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_apprentissage_ = nom_apprentissage_param_
nom_validation_ = nom_validation_param_
annees_validModels_ = annees_validModels_param_
nom_GCM_ = nom_GCM_param_
breaks_NSE_ = breaks_NSE_param
folder_input_ = folder_input_param_
# HER_ = HER_param_
HER_ <- c("2", "3", "5", "12", "13", "14", "17", "21", "22", "24", "25", "27", "28", "34", "35", "36",
          "38", "40", "41", "43", "44", "50", "51", "52", "53", "55", "56", "57", "58", "59", "61", 
          "62", "63", "64", "65", "66", "67", "68", "70", "71", "73", "74", "75", "76", "77", "78",
          "79", "81", "84", "85", "86", "87", "91", "93", "94", "97", "98", "99", "101", "103", "104",
          "105", "106", "107", "108", "112", "113", "117", "118", "120", "31033039", "37054", "69096",
          "89092", "49090")

# date_intervalle_ = c("1976-01-01","2005-12-31")
date_intervalle_ = c("2041-01-01","2070-12-31")
# date_intervalle_ = c("2070-01-01","2099-12-31")
pattern_rcp_ = str_before_last(str_after_last(nom_categorieSimu_,"_"),"/")
pattern_SafranHistRcp_ = "Historical|rcp"
correctionBiais_ = "ADAMONT"

# nom_categorieSimu_ = "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/"
# nom_categorieSimu_ = "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/"
# nom_categorieSimu_ = "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/"
# nom_categorieSimu_ = "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/"
# nom_categorieSimu_ = "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/"
nom_categorieSimu_ = "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/"
# nom_categorieSimu_ = "J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/"
# nom_categorieSimu_ = "J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/"
# nom_categorieSimu_ = "J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/"
# nom_categorieSimu_ = "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/"
# nom_categorieSimu_ = "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/"
# nom_categorieSimu_ = "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/"
# nom_categorieSimu_ = "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/"
# nom_categorieSimu_ = "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/"
# nom_categorieSimu_ = "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/"

nFiles_to_use = length(HER_)

### Description HER ###
descriptionHER_ = read_excel(paste0(folder_HER_DataDescription_,"../HER2officielles/DescriptionHER2_3_20240313.xlsx"))
indicateurs_ <- data.frame(HER = HER_,
                           
                           propAssecMoyenneJuilletOct_ModeleMin_ = NA,
                           propAssecMoyenneJuilletOct_ModeleMedian_ = NA,
                           propAssecMoyenneJuilletOct_ModeleMax_ = NA,
                           
                           nbMoyenJoursParAnSup10pct_ModeleMin_ = NA,
                           nbMoyenJoursParAnSup10pct_ModeleMedian_ = NA,
                           nbMoyenJoursParAnSup10pct_ModeleMax_ = NA,
                           
                           initDate_min_ = NA,
                           initDate_median_ = NA,
                           initDate_max_ = NA,
                           finishDate_min_ = NA,
                           finishDate_median_ = NA,
                           finishDate_max_ = NA)

for (HER_h_ in HER_){
  
  print(HER_h_)
  
  tab_allModels_ <- read.table(paste0(folder_input_,"Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/",
                                      ifelse(obsSim_param_=="",nom_GCM_param_,
                                             paste0("FDC_",obsSim_param_,
                                                    ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                    ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                                      "/Tab_ChroniquesProba_LearnBrut_HER",HER_h_,".txt"),
                               # "/Tab_ChroniquesProba_LearnBrut_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,".txt"),
                               sep = ";", dec = ".", header = T)
  tab_allModels_ <- tab_allModels_[,grepl("Date|Type|ADAMONT|Jour_annee",colnames(tab_allModels_))]
  
  ### Choix du forcage climatique et de l'intervalle de dates ###
  # tab_allModels_Safran_ <- tab_allModels_[which(tab_allModels_$Type == "Safran"),]
  tab_allModels_ <- tab_allModels_[which(grepl(pattern_SafranHistRcp_,tab_allModels_$Type)),]
  tab_allModels_ <- tab_allModels_[which(tab_allModels_$Date >= date_intervalle_[1] & tab_allModels_$Date <= date_intervalle_[2]),]
  
  ### MEDIANE ASSECS JUILLET - OCTOBRE ###
  tab_allModels_Proba_ <- tab_allModels_[which(month(tab_allModels_$Date) >= 7 & month(tab_allModels_$Date) <= 10),]
  tab_allModels_Proba_ <- tab_allModels_Proba_[, !colnames(tab_allModels_Proba_) %in% c("Type", "Jour_annee")]

  indicateurs_$propAssecMoyenneJuilletOct_ModeleMin_[which(indicateurs_$HER == HER_h_)] <- round(min(colMeans(tab_allModels_Proba_[2:ncol(tab_allModels_Proba_)], na.rm = T)))
  indicateurs_$propAssecMoyenneJuilletOct_ModeleMedian_[which(indicateurs_$HER == HER_h_)] <- round(median(colMeans(tab_allModels_Proba_[2:ncol(tab_allModels_Proba_)], na.rm = T)))
  indicateurs_$propAssecMoyenneJuilletOct_ModeleMax_[which(indicateurs_$HER == HER_h_)] <- round(max(colMeans(tab_allModels_Proba_[2:ncol(tab_allModels_Proba_)], na.rm = T)))
  
  ### NOMBRE ANNUEL DE JOURS AVEC UNE PROPORTION D'ASSEC SUPERIEURE A 10% ###
  nbJours_list <- c()
  
  for (col in 3:(ncol(tab_allModels_)-1)) {
    
    # print(col)
    
    # Filtrer les lignes avec une probabilité supérieure à 10 dans la colonne actuelle
    subset_data_year <- data.frame(Date = subset(tab_allModels_$Date, tab_allModels_[, col] > 0))
    list_years <- unique(year(subset_data_year$Date))
    subset_data <- data.frame(Date = subset(tab_allModels_$Date, tab_allModels_[, col] > 10))
    
    # Extraire l'année de chaque date
    subset_data$Year <- year(subset_data$Date)
    
    # Trouver le nombre de jours pour chaque année
    nb_dates <- aggregate(Date ~ Year, subset_data, length)
    # Ajouter annees manquantes dans table de sortie
    if (length(list_years[which(!(list_years %in% subset_data$Year))]) > 0){
      # nb_dates <- rbind(nb_dates,data.frame(Year = list_years[which(!(list_years %in% subset_data$Year))],
      #                                       Date = NA))
      nb_dates <- rbind(nb_dates,data.frame(Year = list_years[which(!(list_years %in% subset_data$Year))],
                                            Date = 0))
    }
    nb_dates <- nb_dates[order(nb_dates$Year),]
    colnames(nb_dates) <- c("Year",colnames(tab_allModels_)[col])
    
    if (length(nbJours_list) == 0){
      nbJours_list = as.data.frame(nb_dates)
    }else{
      nbJours_list = merge(nbJours_list,nb_dates, by = "Year", all.x = T, all.y = T)
    }
    
  }
  nbJours_list_mean_ <- lapply(nbJours_list[,2:ncol(nbJours_list)], function(x) mean(x,na.rm=T))
  indicateurs_$nbMoyenJoursParAnSup10pct_ModeleMin_[which(indicateurs_$HER == HER_h_)] <- round(min(unlist(nbJours_list_mean_)))
  indicateurs_$nbMoyenJoursParAnSup10pct_ModeleMedian_[which(indicateurs_$HER == HER_h_)] <- round(median(unlist(nbJours_list_mean_)))
  indicateurs_$nbMoyenJoursParAnSup10pct_ModeleMax_[which(indicateurs_$HER == HER_h_)] <- round(max(unlist(nbJours_list_mean_)))

  
  ### JOURS LIMITES ###
  # Selection de la plage de donnees et du forcage climatique #
  tab_allModels_JoursLimites_ <- tab_allModels_[which(month(tab_allModels_$Date) >= 4),]
  
  # Init tables #
  initDate_list <- c()
  finishDate_list <- c()
  
  # Boucler sur chaque colonne de probabilité
  for (col in 3:(ncol(tab_allModels_JoursLimites_)-1)) {
    
    # print(col)
    
    # Filtrer les lignes avec une probabilité supérieure à 10 dans la colonne actuelle
    subset_data_year <- data.frame(Date = subset(tab_allModels_JoursLimites_$Date, tab_allModels_JoursLimites_[, col] > 0))
    list_years <- unique(year(subset_data_year$Date))
    
    subset_data <- data.frame(Date = subset(tab_allModels_JoursLimites_$Date, tab_allModels_JoursLimites_[, col] > 10))
    
    # Extraire l'année de chaque date
    subset_data$Year <- year(subset_data$Date)
    
    # print("ok0.1")
    
    # Trouver la date minimale pour chaque année
    min_dates <- aggregate(Date ~ Year, subset_data, min)
    min_dates$Date <- format(as.Date(min_dates$Date),"%m-%d")
    # print("ok0.2")
    min_dates$Date <- format(as.Date(paste0("2020-", min_dates$Date)), "%Y-%m-%d")
    
    # Ajouter annees manquantes dans table de sortie
    if (length(list_years[which(!(list_years %in% subset_data$Year))]) > 0){
      min_dates <- rbind(min_dates,data.frame(Year = list_years[which(!(list_years %in% subset_data$Year))],
                                              Date = NA))
    }
    # print("ok0.3")
    min_dates <- min_dates[order(min_dates$Year),]
    # print("ok0.4")
    colnames(min_dates) <- c("Year",colnames(tab_allModels_JoursLimites_)[col])
    # print("ok0.5")
    if (length(initDate_list) == 0){
      initDate_list = as.data.frame(min_dates)
    }else{
      initDate_list = merge(initDate_list,min_dates, by = "Year", all.x = T, all.y = T)
    }
    
    # print("ok1")
    
    # Trouver la date maximale pour chaque année
    max_dates <- aggregate(Date ~ Year, subset_data, max)
    max_dates$Date <- format(as.Date(max_dates$Date),"%m-%d")
    max_dates$Date <- format(as.Date(paste0("2020-", max_dates$Date)), "%Y-%m-%d")
    
    # Ajouter annees manquantes dans table de sortie
    if (length(list_years[which(!(list_years %in% subset_data$Year))]) > 0){
      max_dates <- rbind(max_dates,data.frame(Year = list_years[which(!(list_years %in% subset_data$Year))],
                                              Date = NA))
    }
    max_dates <- max_dates[order(max_dates$Year),]
    colnames(max_dates) <- c("Year",colnames(tab_allModels_JoursLimites_)[col])
    
    if (length(finishDate_list) == 0){
      finishDate_list = as.data.frame(max_dates)
    }else{
      finishDate_list = merge(finishDate_list,max_dates, by = "Year", all.x = T, all.y = T)
    }
  }
  
  # liste <- c("01-05", "02-10", "03-15", "04-20", "05-25")
  
  # Convertir les dates au format "mois-jour" en dates complètes avec une année arbitraire (2022)
  # formatted_dates <- as.Date(paste0("2022-", liste), format = "%Y-%m-%d")
  
  # initDate_list <- as.Date(paste0("2022-", initDate_list), format = "%Y-%m-%d")
  # medianinitDate_list <- median(initDate_list)
  # initDate_list <- format(initDate_list, "%m-%d")
  
  # initDate_list[, 2:3] <- lapply(initDate_list[, 2:3], as.Date)
  # colMeans(initDate_list[,2:ncol(initDate_list)], na.rm = T)
  # colMeans(initDate_list[,2:3], na.rm = T)
  
  # mean(initDate_list[,2], na.rm = T)
  
  # initDate_list_mean_ <- lapply(initDate_list[,2:ncol(initDate_list)], function(x) mean(as.Date(x),na.rm=T))
  initDate_list_median_ <- lapply(initDate_list[,2:ncol(initDate_list)], function(x) median(as.Date(x),na.rm=T))
  indicateurs_$initDate_min_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(min(unlist(initDate_list_median_)), origin = "1970-01-01"), "%m-%d")
  indicateurs_$initDate_median_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(median(unlist(initDate_list_median_)), origin = "1970-01-01"), "%m-%d")
  indicateurs_$initDate_max_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(max(unlist(initDate_list_median_)), origin = "1970-01-01"), "%m-%d")

  # finishDate_list_mean_ <- lapply(finishDate_list[,2:ncol(finishDate_list)], function(x) mean(as.Date(x),na.rm=T))
  finishDate_list_median_ <- lapply(finishDate_list[,2:ncol(finishDate_list)], function(x) median(as.Date(x),na.rm=T))
  indicateurs_$finishDate_min_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(min(unlist(finishDate_list_median_)), origin = "1970-01-01"), "%m-%d")
  indicateurs_$finishDate_median_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(median(unlist(finishDate_list_median_)), origin = "1970-01-01"), "%m-%d")
  indicateurs_$finishDate_max_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(max(unlist(finishDate_list_median_)), origin = "1970-01-01"), "%m-%d")

  
  # initDate_list[2:ncol(initDate_list)] <- lapply(initDate_list[2:ncol(initDate_list)], function(x) as.Date(x, origin = "1970-01-01"))
  # finishDate_list[2:ncol(finishDate_list)] <- lapply(finishDate_list[2:ncol(finishDate_list)], function(x) as.Date(x, origin = "1970-01-01"))
  # nbJours_list_melt <- nbJours_list %>%
  #   pivot_longer(cols = -c(Year), names_to = "Variable", values_to = "Value")
  
  # indicateurs_$initDate_min_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(min(unlist(initDate_list[2:ncol(initDate_list)]), na.rm = T), origin = "1970-01-01"), "%m-%d")
  # indicateurs_$initDate_median_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(median(unlist(initDate_list[2:ncol(initDate_list)]), na.rm = T), origin = "1970-01-01"), "%m-%d")
  # indicateurs_$initDate_max_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(max(unlist(initDate_list[2:ncol(initDate_list)]), na.rm = T), origin = "1970-01-01"), "%m-%d")
  # indicateurs_$finishDate_min_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(min(unlist(finishDate_list[2:ncol(finishDate_list)]), na.rm = T), origin = "1970-01-01"), "%m-%d")
  # indicateurs_$finishDate_median_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(median(unlist(finishDate_list[2:ncol(finishDate_list)]), na.rm = T), origin = "1970-01-01"), "%m-%d")
  # indicateurs_$finishDate_max_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(max(unlist(finishDate_list[2:ncol(finishDate_list)]), na.rm = T), origin = "1970-01-01"), "%m-%d")
  # indicateurs_$finishDate_median_[which(indicateurs_$HER == HER_h_)] <- median(as.matrix(finishDate_list[2:ncol(finishDate_list)]), na.rm = T) # Au format mois-jour
  
  write.table(indicateurs_,paste0(folder_input_,"Tab_Indicateurs/",
                                  ifelse(obsSim_param_=="",nom_GCM_param_,
                                         paste0("FDC_",obsSim_param_,
                                                ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                                  "/Tab_Indicateurs_",
                                  paste0(unique(correctionBiais_), collapse = ""),"_",
                                  year(date_intervalle_[1]),year(date_intervalle_[2]),"_",
                                  paste0(unique(tab_allModels_JoursLimites_$Type), collapse = ""),".txt"),
              sep = ";", dec = ".", row.names = F)
  
}


indicateurs_





# df <- data.frame(Date = as.Date(c("2022-01-01", "2022-02-01", "2023-01-01", "2023-02-01")),
#                  Prob1 = c(0.1, 0.2, 0.3, 0.4),
#                  Prob2 = c(0.2, 0.3, 0.4, 0.5),
#                  Prob3 = c(0.3, 0.4, 0.5, 0.6),
#                  Prob4 = c(0.4, 0.5, 0.6, 0.7))
# 
# # Ajout de l'année dans une nouvelle colonne
# df$Year <- format(df$Date, "%Y")
# 
# # Calcul de la moyenne des probabilités par année
# means_by_year <- aggregate(. ~ Year, data = df[, -1], FUN = mean)
# 
# # Affichage du résultat
# print(means_by_year)
