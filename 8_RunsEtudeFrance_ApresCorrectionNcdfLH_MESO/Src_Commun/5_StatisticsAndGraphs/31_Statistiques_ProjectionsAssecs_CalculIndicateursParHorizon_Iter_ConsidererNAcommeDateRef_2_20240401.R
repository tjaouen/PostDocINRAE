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
HER_ = HER_param_
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

nom_categorieSimu_list_ = c(
  # "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/",
  #                           "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/",
  #                           "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/",
  #                           "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/",
  #                           "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/",
  #                           "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/",
  #                           "J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/",
  #                           "J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/",
  #                           "J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/")#,
                            # "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            # "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            # "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/")

# date_intervalle_ = c("1976-01-01","2005-12-31")
# date_intervalle_ = c("2041-01-01","2070-12-31")
# date_intervalle_ = c("2070-01-01","2099-12-31")

for (date_intervalle_ in list(c("1976-01-01","2005-12-31"),
                              c("2041-01-01","2070-12-31"),
                              c("2070-01-01","2099-12-31"))){
  
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
    
    HER_ <- c("2", "3", "5", "12", "13", "14", "17", "21", "22", "24", "25", "27", "28", "34", "35", "36",
              "38", "40", "41", "43", "44", "50", "51", "52", "53", "55", "56", "57", "58", "59", "61", 
              "62", "63", "64", "65", "66", "67", "68", "70", "71", "73", "74", "75", "76", "77", "78",
              "79", "81", "84", "85", "86", "87", "91", "93", "94", "97", "98", "99", "101", "103", "104",
              "105", "106", "107", "108", "112", "113", "117", "118", "120", "31033039", "37054", "69096",
              "89092", "49090")
    
    if (str_before_first(nom_categorieSimu_,"_") == "J2000"){
      HER_ <- HER_[which(!(HER_ %in% HER_eliminees_J2000))]
    }
    
    for (HER_h_ in HER_){
      
      print(HER_h_)
      
      ### Mean proba ###
      tab_ProbaMeanJuilOct_HER_ <- read.table(paste0(folder_input_,"Tab_Indicateurs/",
                                                     ifelse(obsSim_param_=="",nom_GCM_param_,
                                                            paste0("FDC_",obsSim_param_,
                                                                   ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                                   ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                                                     "/Tab_Indicateurs_ProbaMeanJuilOct_HER",
                                                     HER_h_,"_",
                                                     paste0(unique(correctionBiais_), collapse = ""),"_",
                                                     # min(year(tab_allModels_Proba_$Date)),max(year(tab_allModels_Proba_$Date)),"_",
                                                     # year(date_intervalle_[1]),year(date_intervalle_[2]),"_",
                                                     "Historical",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),".txt"),
                                              sep = ";", dec = ".", header = T)
      # tab_ProbaMeanJuilOct_HER_ <- tab_ProbaMeanJuilOct_HER_[which(tab_ProbaMeanJuilOct_HER_$Year >= year(date_intervalle_[1]) & tab_ProbaMeanJuilOct_HER_$Year <= year(date_intervalle_[2])),]
      means_ <- colMeans(tab_ProbaMeanJuilOct_HER_[which(tab_ProbaMeanJuilOct_HER_$Year >= min(year(date_intervalle_)) &
                                                           tab_ProbaMeanJuilOct_HER_$Year <= max(year(date_intervalle_))),c(2:ncol(tab_ProbaMeanJuilOct_HER_))])
      indicateurs_$propAssecMoyenneJuilletOct_ModeleMin_[which(indicateurs_$HER == HER_h_)] <- round(min(means_, na.rm = T))
      indicateurs_$propAssecMoyenneJuilletOct_ModeleMedian_[which(indicateurs_$HER == HER_h_)] <- round(median(means_, na.rm = T))
      indicateurs_$propAssecMoyenneJuilletOct_ModeleMax_[which(indicateurs_$HER == HER_h_)] <- round(max(means_, na.rm = T))
      
      
      ### Nombre de jours ###
      tab_nbJours_HER_ <- read.table(paste0(folder_input_,"Tab_Indicateurs/",
                                            ifelse(obsSim_param_=="",nom_GCM_param_,
                                                   paste0("FDC_",obsSim_param_,
                                                          ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                          ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                                            "/Tab_Indicateurs_NbJoursSup",seuilAssec_,"_HER",
                                            HER_h_,"_",
                                            paste0(unique(correctionBiais_), collapse = ""),"_",
                                            # min(year(tab_allModels_nbJours_$Date)),max(year(tab_allModels_nbJours_$Date)),"_",
                                            # year(date_intervalle_[1]),year(date_intervalle_[2]),"_",
                                            "Historical",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),".txt"),
                                     sep = ";", dec = ".", header = T)
      
      means_ <- colMeans(tab_nbJours_HER_[which(tab_nbJours_HER_$Year >= min(year(date_intervalle_)) &
                                                  tab_nbJours_HER_$Year <= max(year(date_intervalle_))),c(2:ncol(tab_nbJours_HER_))])
      indicateurs_[[paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMin_")]][which(indicateurs_$HER == HER_h_)] <- round(min(unlist(means_)))
      indicateurs_[[paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMedian_")]][which(indicateurs_$HER == HER_h_)] <- round(median(unlist(means_)))
      indicateurs_[[paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMax_")]][which(indicateurs_$HER == HER_h_)] <- round(max(unlist(means_)))
      
      
      
      write.table(indicateurs_,paste0(folder_input_,"Tab_Indicateurs/",
                                      ifelse(obsSim_param_=="",nom_GCM_param_,
                                             paste0("FDC_",obsSim_param_,
                                                    ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                    ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                                      "/Tab_Indicateurs_",
                                      paste0(unique(correctionBiais_), collapse = ""),"_",
                                      year(date_intervalle_[1]),year(date_intervalle_[2]),"_",
                                      "Historical",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),".txt"),
                  sep = ";", dec = ".", row.names = F)
      
      
      ### Date debut assec ###
      tab_initDate_HER_ <- read.table(paste0(folder_input_,"Tab_Indicateurs/",
                                             ifelse(obsSim_param_=="",nom_GCM_param_,
                                                    paste0("FDC_",obsSim_param_,
                                                           ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                           ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                                             "/Tab_Indicateurs_InitDate_Seuil",seuilAssec_,"_HER",
                                             HER_h_,"_",
                                             paste0(unique(correctionBiais_), collapse = ""),"_",
                                             # min(year(tab_allModels_nbJours_$Date)),max(year(tab_allModels_nbJours_$Date)),"_",
                                             # year(date_intervalle_[1]),year(date_intervalle_[2]),"_",
                                             "Historical",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),".txt"),
                                      sep = ";", dec = ".", header = T)
      
      initDate_list_median_ <- lapply(tab_initDate_HER_[which(tab_initDate_HER_$Year >= min(year(date_intervalle_)) &
                                                                tab_initDate_HER_$Year <= max(year(date_intervalle_))),2:ncol(tab_initDate_HER_)], function(x) median(as.Date(x),na.rm=T))
      indicateurs_$initDate_min_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(min(unlist(initDate_list_median_), na.rm = T), origin = "1970-01-01"), "%Y-%m-%d")
      indicateurs_$initDate_median_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(median(unlist(initDate_list_median_), na.rm = T), origin = "1970-01-01"), "%Y-%m-%d")
      indicateurs_$initDate_max_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(max(unlist(initDate_list_median_), na.rm = T), origin = "1970-01-01"), "%Y-%m-%d")
      # indicateurs_$initDate_min_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(min(unlist(initDate_list_median_)), origin = "1970-01-01"), "%Y-%m-%d")
      # indicateurs_$initDate_median_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(median(unlist(initDate_list_median_)), origin = "1970-01-01"), "%Y-%m-%d")
      # indicateurs_$initDate_max_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(max(unlist(initDate_list_median_)), origin = "1970-01-01"), "%Y-%m-%d")
      
      tab_finishDate_HER_ <- read.table(paste0(folder_input_,"Tab_Indicateurs/",
                                               ifelse(obsSim_param_=="",nom_GCM_param_,
                                                      paste0("FDC_",obsSim_param_,
                                                             ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                             ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                                               "/Tab_Indicateurs_FinishDate_Seuil",seuilAssec_,"_HER",
                                               HER_h_,"_",
                                               paste0(unique(correctionBiais_), collapse = ""),"_",
                                               # min(year(tab_allModels_nbJours_$Date)),max(year(tab_allModels_nbJours_$Date)),"_",
                                               # year(date_intervalle_[1]),year(date_intervalle_[2]),"_",
                                               "Historical",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),".txt"),
                                        sep = ";", dec = ".", header = T)
      
      finishDate_list_median_ <- lapply(tab_finishDate_HER_[which(tab_finishDate_HER_$Year >= min(year(date_intervalle_)) &
                                                                    tab_finishDate_HER_$Year <= max(year(date_intervalle_))),2:ncol(tab_finishDate_HER_)], function(x) median(as.Date(x),na.rm=T))
      indicateurs_$finishDate_min_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(min(unlist(finishDate_list_median_), na.rm = T), origin = "1970-01-01"), "%Y-%m-%d")
      indicateurs_$finishDate_median_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(median(unlist(finishDate_list_median_), na.rm = T), origin = "1970-01-01"), "%Y-%m-%d")
      indicateurs_$finishDate_max_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(max(unlist(finishDate_list_median_), na.rm = T), origin = "1970-01-01"), "%Y-%m-%d")
      # indicateurs_$finishDate_min_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(min(unlist(finishDate_list_median_)), origin = "1970-01-01"), "%Y-%m-%d")
      # indicateurs_$finishDate_median_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(median(unlist(finishDate_list_median_)), origin = "1970-01-01"), "%Y-%m-%d")
      # indicateurs_$finishDate_max_[which(indicateurs_$HER == HER_h_)] <- format(as.Date(max(unlist(finishDate_list_median_)), origin = "1970-01-01"), "%Y-%m-%d")
      
      
      write.table(indicateurs_,paste0(folder_input_,"Tab_Indicateurs/",
                                      ifelse(obsSim_param_=="",nom_GCM_param_,
                                             paste0("FDC_",obsSim_param_,
                                                    ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                    ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                                      "/Tab_Indicateurs_",
                                      paste0(unique(correctionBiais_), collapse = ""),"_",
                                      year(date_intervalle_[1]),year(date_intervalle_[2]),"_",
                                      "Historical",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),".txt"),
                  sep = ";", dec = ".", row.names = F)
    }
  }
}


