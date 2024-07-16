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

HER_eliminees_J2000 <- c("10", "21", "22", "24", "27", "34", "35", "36", "57", "59", "61", "65", "67", "68",
                         "77", "78", "93", "94", "103", "108", "118", "0", "31033039", "69096",
                         "66", "64", "117", "112", "56", "62", "38", "40", "105", "17", "25", "107",
                         "55", "12", "53")



pattern_rcp_ = str_before_last(str_after_last(nom_categorieSimu_,"_"),"/")
pattern_SafranHistRcp_ = "Historical|rcp"
correctionBiais_ = "ADAMONT"

seuilAssec_ = 20


# nom_categorieSimu_ = "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/"
# nom_categorieSimu_ = "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/"
# nom_categorieSimu_ = "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/"
# nom_categorieSimu_ = "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/"
# nom_categorieSimu_ = "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/"
# nom_categorieSimu_ = "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/"
# nom_categorieSimu_ = "J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/"
# nom_categorieSimu_ = "J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/"
# nom_categorieSimu_ = "J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/"
# nom_categorieSimu_ = "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/"
# nom_categorieSimu_ = "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/"
# nom_categorieSimu_ = "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/"
# nom_categorieSimu_ = "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/"
# nom_categorieSimu_ = "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/"
# nom_categorieSimu_ = "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/"

nom_categorieSimu_list_ = c("CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/",
                            "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/",
                            "J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            "J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            "J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/",
                            "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/")

for (nom_categorieSimu_ in nom_categorieSimu_list_){
  
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
  
  if (str_before_first(nom_categorieSimu_,"_") == "J2000"){
    HER_ <- HER_[which(!(HER_ %in% HER_eliminees_J2000))]
  }
  
  for (HER_h_ in HER_){ # [1:4]
    
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
    pattern_SafranHistRcp_Read_ <- paste0(unique(tab_allModels_$Type), collapse = "")
    tab_allModels_ <- tab_allModels_[, !colnames(tab_allModels_) %in% c("Type", "Jour_annee")]
    # tab_allModels_ <- tab_allModels_[which(tab_allModels_$Date >= date_intervalle_[1] & tab_allModels_$Date <= date_intervalle_[2]),]
    
    
    if (!dir.exists(paste0(folder_input_,"Tab_Indicateurs/",
                           ifelse(obsSim_param_=="",nom_GCM_param_,
                                  paste0("FDC_",obsSim_param_,
                                         ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                         ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),"/"))){
      dir.create(paste0(folder_input_,"Tab_Indicateurs/",
                        ifelse(obsSim_param_=="",nom_GCM_param_,
                               paste0("FDC_",obsSim_param_,
                                      ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                      ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),"/"))
    }
    
    ### MEDIANE ASSECS JUILLET - OCTOBRE ###
    tab_allModels_Proba_ <- tab_allModels_[which(month(tab_allModels_$Date) >= 7 & month(tab_allModels_$Date) <= 10),]
    tab_allModels_Proba_$Year <- year(tab_allModels_Proba_$Date)

    write.table(aggregate(.~Year, tab_allModels_Proba_[,c(2:(ncol(tab_allModels_Proba_)))], mean, na.rm = T),
                paste0(folder_input_,"Tab_Indicateurs/",
                       ifelse(obsSim_param_=="",nom_GCM_param_,
                              paste0("FDC_",obsSim_param_,
                                     ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                     ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                       "/Tab_Indicateurs_ProbaMeanJuilOct_HER",
                       HER_h_,"_",
                       paste0(unique(correctionBiais_), collapse = ""),"_",
                       # min(year(tab_allModels_Proba_$Date)),max(year(tab_allModels_Proba_$Date)),"_",
                       # year(date_intervalle_[1]),year(date_intervalle_[2]),"_",
                       pattern_SafranHistRcp_Read_,".txt"),
                sep = ";", dec = ".", row.names = F)
    
    # indicateurs_$propAssecMoyenneJuilletOct_ModeleMin_[which(indicateurs_$HER == HER_h_)] <- round(min(colMeans(tab_allModels_Proba_[2:ncol(tab_allModels_Proba_)], na.rm = T)))
    # indicateurs_$propAssecMoyenneJuilletOct_ModeleMedian_[which(indicateurs_$HER == HER_h_)] <- round(median(colMeans(tab_allModels_Proba_[2:ncol(tab_allModels_Proba_)], na.rm = T)))
    # indicateurs_$propAssecMoyenneJuilletOct_ModeleMax_[which(indicateurs_$HER == HER_h_)] <- round(max(colMeans(tab_allModels_Proba_[2:ncol(tab_allModels_Proba_)], na.rm = T)))
    
    ### NOMBRE ANNUEL DE JOURS AVEC UNE PROPORTION D'ASSEC SUPERIEURE A 10% ###
    tab_allModels_nbJours_ <- tab_allModels_
    # tab_allModels_nbJours_[2:(ncol(tab_allModels_nbJours_)-1)] <- tab_allModels_nbJours_[2:(ncol(tab_allModels_nbJours_)-1)] > 10
    tab_allModels_nbJours_[2:(ncol(tab_allModels_nbJours_))] <- as.numeric(tab_allModels_nbJours_[2:(ncol(tab_allModels_nbJours_))] > seuilAssec_)
    tab_allModels_nbJours_$Year <- year(tab_allModels_nbJours_$Date)
    # tab_allModels_nbJours_ <- aggregate(.~Year)
    write.table(aggregate(.~Year, tab_allModels_nbJours_[,c(2:(ncol(tab_allModels_nbJours_)))], sum, na.rm = T),
                paste0(folder_input_,"Tab_Indicateurs/",
                       ifelse(obsSim_param_=="",nom_GCM_param_,
                              paste0("FDC_",obsSim_param_,
                                     ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                     ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                       "/Tab_Indicateurs_NbJoursSup",seuilAssec_,"_HER",
                       HER_h_,"_",
                       paste0(unique(correctionBiais_), collapse = ""),"_",
                       # min(year(tab_allModels_nbJours_$Date)),max(year(tab_allModels_nbJours_$Date)),"_",
                       # year(date_intervalle_[1]),year(date_intervalle_[2]),"_",
                       pattern_SafranHistRcp_Read_,".txt"),
                sep = ";", dec = ".", row.names = F)
    
    
    ### JOURS LIMITES ###
    # Selection de la plage de donnees et du forcage climatique #
    if (HER_h_ == 12){
      tab_allModels_JoursLimites_avril_ <- tab_allModels_[which(month(tab_allModels_$Date) >= 5),]
    }else{
      tab_allModels_JoursLimites_avril_ <- tab_allModels_[which(month(tab_allModels_$Date) >= 4),]
    }
    
    # Init tables #
    initDate_list <- c()
    finishDate_list <- c()
    
    # Boucler sur chaque colonne de probabilité
    for (col in 2:(ncol(tab_allModels_JoursLimites_avril_))) {
      
      # print(col)
      
      # Filtrer les lignes avec une probabilité supérieure à 10 dans la colonne actuelle
      subset_data_year <- data.frame(Date = subset(tab_allModels_JoursLimites_avril_$Date, tab_allModels_JoursLimites_avril_[, col] > 0))
      list_years <- unique(year(subset_data_year$Date))
      
      subset_data <- data.frame(Date = subset(tab_allModels_JoursLimites_avril_$Date, tab_allModels_JoursLimites_avril_[, col] > seuilAssec_))
      
      # Extraire l'année de chaque date
      subset_data$Year <- year(subset_data$Date)
      
      # print("ok0.1")
      
      # Trouver la date minimale pour chaque année
      if (nrow(subset_data) > 0){
        min_dates <- aggregate(Date ~ Year, subset_data, min)
        min_dates$Date <- format(as.Date(min_dates$Date),"%m-%d")
        # print("ok0.2")
        min_dates$Date <- format(as.Date(paste0("2020-", min_dates$Date)), "%Y-%m-%d")
      }else{
        min_dates <- NA
      }
      
      # Ajouter annees manquantes dans table de sortie
      if (length(list_years[which(!(list_years %in% subset_data$Year))]) > 0){
        min_dates <- rbind(min_dates,data.frame(Year = list_years[which(!(list_years %in% subset_data$Year))],
                                                Date = NA))
      }
      # print("ok0.3")
      min_dates <- min_dates[order(min_dates$Year),]
      # print("ok0.4")
      colnames(min_dates) <- c("Year",colnames(tab_allModels_JoursLimites_avril_)[col])
      # print("ok0.5")
      if (length(initDate_list) == 0){
        initDate_list = as.data.frame(min_dates)
      }else{
        initDate_list = merge(initDate_list,min_dates, by = "Year", all.x = T, all.y = T)
      }
      
      # print("ok1")
      
      # Trouver la date maximale pour chaque année
      if (nrow(subset_data) > 0){
        max_dates <- aggregate(Date ~ Year, subset_data, max)
        # print(max_dates)
        max_dates$AnneeSuivante = 0
        
        for (i in 1:nrow(max_dates)){
          if (format(as.Date(max_dates$Date[i]), "%m-%d") == "12-31"){
            tab_annee_suivante_ <- tab_allModels_nbJours_[which(year(tab_allModels_nbJours_$Date) == (year(max_dates$Date[i])+1)),]
            rle_result <- rle(tab_annee_suivante_[,col])
            # Trouver la position de la première itération de 5 valeurs 1 consécutives dans la série originale
            position <- which(rle_result$lengths >= 15 & rle_result$values == 0) # 15 jours consecutif sans assec a plus de 10%
            # Si une telle position est trouvée, ajustez-la pour obtenir la position dans la série originale
            if (length(position) > 0) {
              first_position <- sum(rle_result$lengths[1:(position[1] - 1)])
              max_dates$Date[i] <- tab_annee_suivante_$Date[first_position]
              max_dates$AnneeSuivante[i] = 1
            }
          }
        }
        
        max_dates$Date <- format(as.Date(max_dates$Date),"%m-%d")
        max_dates$Date <- ifelse(max_dates$AnneeSuivante == 0,
                                 format(as.Date(paste0("2020-", max_dates$Date)), "%Y-%m-%d"),
                                 format(as.Date(paste0("2021-", max_dates$Date)), "%Y-%m-%d"))
        max_dates <- max_dates[,!grepl("AnneeSuivante",colnames(max_dates))]
        # for (i in 1:nrow(max_dates)){
        #   if (max_dates$AnneeSuivante[i] == 1){
        #     max_dates$Date <- format(as.Date(paste0("2020-", max_dates$Date)), "%Y-%m-%d")
        #   }else{
        #     max_dates$Date <- format(as.Date(paste0("2021-", max_dates$Date)), "%Y-%m-%d")
        #   }
        # }
      }else{
        max_dates <- NA
      }
      
      # Ajouter annees manquantes dans table de sortie
      if (length(list_years[which(!(list_years %in% subset_data$Year))]) > 0){
        max_dates <- rbind(max_dates,data.frame(Year = list_years[which(!(list_years %in% subset_data$Year))],
                                                Date = NA))
      }
      max_dates <- max_dates[order(max_dates$Year),]
      colnames(max_dates) <- c("Year",colnames(tab_allModels_JoursLimites_avril_)[col])
      
      if (length(finishDate_list) == 0){
        finishDate_list = as.data.frame(max_dates)
      }else{
        finishDate_list = merge(finishDate_list,max_dates, by = "Year", all.x = T, all.y = T)
      }
    }
    
    write.table(initDate_list,
                paste0(folder_input_,"Tab_Indicateurs/",
                       ifelse(obsSim_param_=="",nom_GCM_param_,
                              paste0("FDC_",obsSim_param_,
                                     ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                     ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                       "/Tab_Indicateurs_InitDate_Seuil",seuilAssec_,"_HER",
                       HER_h_,"_",
                       paste0(unique(correctionBiais_), collapse = ""),"_",
                       pattern_SafranHistRcp_Read_,".txt"),
                sep = ";", dec = ".", row.names = F)
    
    write.table(finishDate_list,
                paste0(folder_input_,"Tab_Indicateurs/",
                       ifelse(obsSim_param_=="",nom_GCM_param_,
                              paste0("FDC_",obsSim_param_,
                                     ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                     ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                       "/Tab_Indicateurs_FinishDate_Seuil",seuilAssec_,"_HER",
                       HER_h_,"_",
                       paste0(unique(correctionBiais_), collapse = ""),"_",
                       pattern_SafranHistRcp_Read_,".txt"),
                sep = ";", dec = ".", row.names = F)
  }
}

